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

import fr.but3.sae_web.config.AppProperties;
import fr.but3.sae_web.config.DateParser;
import fr.but3.sae_web.config.MailSenderService;
import fr.but3.sae_web.models.Bookings;
import fr.but3.sae_web.models.BookingsRepository;
import fr.but3.sae_web.models.CancelledDays;
import fr.but3.sae_web.models.CancelledSlots;
import fr.but3.sae_web.models.SlotVirtual;
import fr.but3.sae_web.models.Slots;
import fr.but3.sae_web.models.SlotsRepository;
import fr.but3.sae_web.models.Users;
import fr.but3.sae_web.models.UsersRepository;
import jakarta.servlet.http.HttpSession;

@Controller
public class PanelAdmin {

    @Autowired
    private AppProperties appProperties;

    @Autowired
    private SlotsRepository slotsRepository;

    @Autowired
    private UsersRepository usersRepository;

    @Autowired
    private BookingsRepository bookingsRepository;

    @Autowired
    private MailSenderService mailSenderService;

    @RequestMapping("panel_admin")
    public String adminView(Principal principal, 
                            Model model, 
                            @RequestParam(value = "date", defaultValue = "today") String date,
                            HttpSession session) {
        
        if(!VerifyUser.verify(usersRepository.findByLogin(principal.getName())).equals("admin")){
            return "forbidden";
        }

        //ajout info config
        model.addAttribute("appTitle", appProperties.getTitle());
        model.addAttribute("appFavicon", appProperties.getFaviconPath());
        
        // access controlled by @PreAuthorize

        if(date.equals("today")){
            date = LocalDate.now().toString();
        }

        LocalDate localdate = LocalDate.parse(date);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("d MMMM yyyy", Locale.FRANCE);
        
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
            List<SlotVirtual> virtualSlots = new ArrayList<>();
            LocalTime startTime = appProperties.getStartTime();
            LocalTime endTime = appProperties.getEndTime();
            int duration = appProperties.getDuration();

            // on ajoute un nouveau slot virtuel de X durée tant que ça rentre dans les horaires des paramètres
            LocalTime currentTime = startTime;
            while (currentTime.plusMinutes(duration).isBefore(endTime) 
                || currentTime.plusMinutes(duration).equals(endTime)) {
                    LocalTime slotEnd = currentTime.plusMinutes(duration);
                    virtualSlots.add(new SlotVirtual(localdate, currentTime, slotEnd));
                    currentTime = slotEnd;
                }

            List<Slots> realSlots = slotsRepository.findByDay(localdate);

            // On indexe les slots réels avec l'heure de début
            Map<LocalTime, Slots> slotMap = new HashMap<>();
            for (Slots slot : realSlots) {
                slotMap.put(slot.getTimeStart(), slot);
            }

            List<SlotVirtual> mergedSlots = new ArrayList<>();
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

            // ajout créneaux et capacité
            model.addAttribute("slots", mergedSlots);
            model.addAttribute("capacity", appProperties.getCapacity());
            model.addAttribute("closed", false);
        }

        if(localdate.isBefore(LocalDate.now())){
            model.addAttribute("pastDay", true);
        } else {
            model.addAttribute("pastDay", false);
        }

        // ajout dates
        model.addAttribute("date", date.toString());
        model.addAttribute("previousDate", localdate.minusDays(1).toString());
        model.addAttribute("nextDate", localdate.plusDays(1).toString());
        model.addAttribute("formattedDate", formattedDate);
        
        return "panel_admin";
    }

    @PostMapping("/delete_slot")
    public String deleteSlot(Principal principal, 
                            @RequestParam(value = "id_slot", required = true) Integer idSlot, 
                            @RequestParam(value="date") String date,
                            HttpSession session) {

        if(!VerifyUser.verify(usersRepository.findByLogin(principal.getName())).equals("admin")){
            return "redirect:/forbidden";
        }

        String lang = (String) session.getAttribute("lang");
        lang = lang == null ? "fr" : lang;

        Slots slot = slotsRepository.findById(idSlot).orElse(null);
        if (slot != null) {
            this.informUserForDeletingPerSlot(slot, lang);
            SlotVirtual vSlot = new SlotVirtual(LocalDate.parse(date), slot.getTimeStart(), slot.getTimeEnd());
            CancelledSlots.cancelled_slots.add(vSlot);
        }
        bookingsRepository.deleteAllById_IdSlot(idSlot);
        slotsRepository.deleteById(idSlot);

        return "redirect:/panel_admin?date=" + date;
    }

    @PostMapping("/cancel_day")
    public String cancelDay(Principal principal, @RequestParam(value = "cancelled_day", required = true) String cancelledDay, HttpSession session) {
        if(!VerifyUser.verify(usersRepository.findByLogin(principal.getName())).equals("admin")){
                    return "redirect:/forbidden";
        }

        LocalDate date = LocalDate.parse(cancelledDay);

        String lang = (String) session.getAttribute("lang");
        lang = lang == null ? "fr" : lang;

        // Supprime les vrais slots
        List<Slots> toDelete = slotsRepository.findByDay(date);
        for (Slots slot : toDelete) {
            this.informUserForDeletingPerSlot(slot, lang);

            SlotVirtual vSlot = new SlotVirtual(date, slot.getTimeStart(), slot.getTimeEnd());
            CancelledSlots.cancelled_slots.add(vSlot);
        }

        slotsRepository.deleteSlotsOfDay(date);

        CancelledDays.cancelled_days.add(date);

        return "redirect:/panel_admin?date=" + date;
    }

    @PostMapping("/consult_users")
    public String consultUsers(Model model, 
                            Principal principal, 
                            HttpSession session,
                            @RequestParam(value = "id_slot", required = true) int idSlot){

        if(!VerifyUser.verify(usersRepository.findByLogin(principal.getName())).equals("admin")){
            return "redirect:/forbidden";
        }

        //recup users
        List<Bookings> bookings = bookingsRepository.findAllById_IdSlot(idSlot);
        List<String> logins = bookings.stream()
                              .map(b -> b.getId().getLogin())
                              .toList();      
        List<Users> userList = usersRepository.findAllByLoginIn(logins);

        
        Slots slot = slotsRepository.findById(idSlot).orElse(null);
        
        // ajout infos page
        model.addAttribute("lastPage", "consult_users");

        //ajout liste users
        model.addAttribute("users", userList);

        //ajout config
        model.addAttribute("appTitle", appProperties.getTitle());
        model.addAttribute("appFavicon", appProperties.getFaviconPath());
        
        //infos slot
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("d MMMM yyyy", Locale.FRANCE);
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
        model.addAttribute("date", slot.getDayStart());
        model.addAttribute("formattedDate", formatter.format(slot.getDayStart()));
        model.addAttribute("formattedTimeStart", slot.getTimeStart().toString());
        model.addAttribute("formattedTimeEnd", slot.getTimeEnd().toString());
        model.addAttribute("idSlot", idSlot);

        return "registered_users";
    }

    private void informUserForDeletingPerSlot(Slots slot, String lang){
        List<Bookings> bookings = bookingsRepository.findAllById_IdSlot(slot.getIdSlot());
        List<String> logins = bookings.stream()
                            .map(b -> b.getId().getLogin())
                            .toList();      
        List<Users> userToInform = usersRepository.findAllByLoginIn(logins);

        for(Users user : userToInform){
            mailSenderService.sendMail(user.getEmail(), "Réservation supprimée", "Bonjour " + user.getFirstname() + " " + user.getLastname() + ",\n\nVotre réservation du " + DateParser.formatDate(slot.getDayStart(), lang) + " a été annulée.");
        }
    }
}
