package fr.but3.sae_web.controllers;

import java.security.Principal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import fr.but3.sae_web.config.AppProperties;
import fr.but3.sae_web.config.DateParser;
import fr.but3.sae_web.config.MailSenderService;
import fr.but3.sae_web.models.BookingId;
import fr.but3.sae_web.models.Bookings;
import fr.but3.sae_web.models.BookingsRepository;
import fr.but3.sae_web.models.CancelledDays;
import fr.but3.sae_web.models.CancelledSlots;
import fr.but3.sae_web.models.SlotVirtual;
import fr.but3.sae_web.models.Slots;
import fr.but3.sae_web.models.SlotsRepository;
import fr.but3.sae_web.models.Users;
import fr.but3.sae_web.models.UsersRepository;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class DayPlanning {
    @Autowired
    private SlotsRepository slotsRepository;

    @Autowired
    private BookingsRepository bookingsRepository;

    @Autowired
    private AppProperties appProperties;

    @Autowired
    private MailSenderService mailSenderService;

    @Autowired
    private UsersRepository usersRepository;

    @RequestMapping("/day_planning")
    public String day_planning(Model model, 
                                @RequestParam(value="date", required=true) String date,
                                HttpServletRequest request,
                                Principal principal,
                                HttpSession session) {
        LocalDate localdate = LocalDate.parse(date);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("d MMMM yyyy", Locale.FRENCH);
        
        if (session.getAttribute("lang") != null) {
            switch ((String) session.getAttribute("lang")) {
                case "en" : 
                    formatter = DateTimeFormatter.ofPattern("d MMMM yyyy", Locale.ENGLISH);
                    break;
                case "es" :
                    formatter = DateTimeFormatter.ofPattern("d MMMM yyyy", new Locale("es", "ES"));
                    break;
            }
        }
        String formattedDate = formatter.format(localdate);

        if (!appProperties.getOpenDays().contains(localdate.getDayOfWeek())) {
            model.addAttribute("closed", true);
        }
        else {
            List<SlotVirtual> mergedSlots = new ArrayList<>();
            if (!CancelledDays.cancelled_days.contains(localdate)) {
                List<SlotVirtual> virtualSlots = new ArrayList<>();
                LocalTime startTime = appProperties.getStartTime();
                LocalTime endTime = appProperties.getEndTime();
                int duration = appProperties.getDuration();

                // on ajoute un nouveau slot virtuel de X durée tant que ça rentre dans les horaires des paramètres
                LocalTime currentTime = startTime;
                while (currentTime.plusMinutes(duration).isBefore(endTime) 
                    || currentTime.plusMinutes(duration).equals(endTime)) {
                        LocalTime slotEnd = currentTime.plusMinutes(duration);
                        SlotVirtual vSlot = new SlotVirtual(localdate, currentTime, slotEnd);
                        if (!CancelledSlots.cancelled_slots.contains(vSlot)) { // On vérifie que le créneau n'a pas été annulé
                            virtualSlots.add(vSlot);
                        }
                        currentTime = slotEnd;
                    }

                List<Slots> realSlots = slotsRepository.findByDay(localdate);

                // On indexe les slots réels avec l'heure de début
                Map<LocalTime, Slots> slotMap = new HashMap<>();
                for (Slots slot : realSlots) {
                    slotMap.put(slot.getTimeStart(), slot);
                }

                for (SlotVirtual virtual : virtualSlots) {
                    LocalTime key = virtual.getTimeStart();

                    // on vérifie si le slot réel existe
                    if (slotMap.containsKey(key)) {
                        Slots realSlot = slotMap.get(key);
                        int nbBookings = slotsRepository.getNumberOfReservation(realSlot.getIdSlot());
                        Double pct = slotsRepository.getCapacityPercentage(appProperties.getCapacity(), realSlot.getIdSlot());
                        if (pct == null) pct = 0.0;

                        mergedSlots.add(new SlotVirtual(realSlot, nbBookings, pct));
                    }
                    else {
                        mergedSlots.add(virtual);
                    }
                }
            }

            // ajout créneaux et capacité
            model.addAttribute("slots", mergedSlots);
            model.addAttribute("capacity", appProperties.getCapacity());
            model.addAttribute("closed", false);
        }

        //ajout info date actuelle et heure
        if(localdate.isBefore(LocalDate.now())){
            model.addAttribute("pastDay", true);
        } else {
            model.addAttribute("pastDay", false);
        }

        if(localdate.equals(LocalDate.now())){
            model.addAttribute("today", true);
        } else {
            model.addAttribute("today", false);
        }

        model.addAttribute("timeHour", LocalTime.now());

        // ajout infos utilisateur
        Users user = usersRepository.findByLogin(principal.getName());
        
        model.addAttribute("login", principal.getName());
        model.addAttribute("role", VerifyUser.verify(user));


        //ajout slots réservés de user
        List<String> userSlots = new ArrayList<>();
        for(Bookings b : bookingsRepository.findUpcomingBookingsForUser(principal.getName(), LocalDate.now(), LocalTime.now())){
            userSlots.add(b.getSlot().getIdSlot().toString());
        }
        model.addAttribute("userSlots", userSlots);

        LocalDate previousDate = localdate.minusDays(1);
        LocalDate nextDate = localdate.plusDays(1);

        // ajout dates
        model.addAttribute("date", date.toString());
        model.addAttribute("previousDate", previousDate.toString());
        model.addAttribute("nextDate", nextDate.toString());
        model.addAttribute("formattedDate", formattedDate);

        // ajout info config
        model.addAttribute("appTitle", appProperties.getTitle());
        model.addAttribute("appFavicon", appProperties.getFaviconPath());

        return "day_planning";
    }

    @PostMapping("/insert_booking")
    public String insertBooking(
            @RequestParam(value = "id_slot", required = false) Integer idSlot,
            @RequestParam("login") String login,
            @RequestParam("date") String date,
            @RequestParam("time_start") String timeStart,
            @RequestParam("time_end") String timeEnd,
            RedirectAttributes redirectAttributes,
            HttpSession session) {

        Slots slot;

        if (idSlot == null) {
            slot = new Slots();
            slot.setDayStart(LocalDate.parse(date));
            slot.setTimeStart(LocalTime.parse(timeStart));
            slot.setTimeEnd(LocalTime.parse(timeEnd));
            slot = slotsRepository.save(slot);
        } else {
            slot = slotsRepository.findById(idSlot).orElse(null);
            if (slot == null) {
                redirectAttributes.addFlashAttribute("message", "Créneau introuvable");
                return "redirect:/day_planning?date=" + date;
            }
        }

        if (slotsRepository.getNumberOfReservation(slot.getIdSlot()) >= appProperties.getCapacity()) {
            redirectAttributes.addFlashAttribute("message", "Réservation impossible, capacité pleine");
            return "redirect:/day_planning?date=" + date;
        }

        BookingId bookingId = new BookingId();
        bookingId.setIdSlot(slot.getIdSlot());
        bookingId.setLogin(login);

        Bookings booking = new Bookings();
        booking.setId(bookingId);

        bookingsRepository.save(booking);
        
        String lang = (String) session.getAttribute("lang");
        lang = lang == null ? "fr" : lang;
        
        String message = "Réservation validée !";
        switch (lang) {
            case "en" -> message = "Booking successful !";
            case "es" -> message = "Reserva validada !";
        }

        redirectAttributes.addFlashAttribute("message", message);

        mailSenderService.sendMail(usersRepository.findById(login).get().getEmail(), "réservation confirmée", "Vous avez pris une réservation pour le " + DateParser.formatDate(slot.getDayStart(), lang) + " de " + slot.getTimeStart() + " à " + slot.getTimeEnd() + ".");
        return "redirect:/day_planning?date=" + date;
    }

}
