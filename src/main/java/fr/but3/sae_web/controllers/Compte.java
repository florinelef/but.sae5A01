package fr.but3.sae_web.controllers;

import java.io.File;
import java.io.IOException;
import java.security.Principal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import fr.but3.sae_web.config.AppProperties;
import fr.but3.sae_web.config.DateParser;
import fr.but3.sae_web.config.MailSenderService;
import fr.but3.sae_web.models.BookingId;
import fr.but3.sae_web.models.Bookings;
import fr.but3.sae_web.models.BookingsRepository;
import fr.but3.sae_web.models.Slots;
import fr.but3.sae_web.models.SlotsRepository;
import fr.but3.sae_web.models.Users;
import fr.but3.sae_web.models.UsersRepository;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class Compte {

    @Autowired
    private AppProperties appProperties;

    @Autowired
    private UsersRepository usersRepository;

    @Autowired
    private BookingsRepository bookingsRepository;

    @Autowired
    private SlotsRepository slotsRepository;

    @Autowired
    private MailSenderService mailSenderService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @RequestMapping("compte")
    public String compte(@RequestParam(value = "limit", defaultValue = "5") int limit,
                        Principal principal,
                        Model model) {    
        Users user = usersRepository.findByLogin(principal.getName());
        
        LocalDate localDate = LocalDate.now();
        LocalTime localTime = LocalTime.now();
        List<Bookings> bookings = bookingsRepository.findUpcomingBookingsForUser(user.getLogin(), localDate, localTime);
        List<Bookings> pastBookings = bookingsRepository.findPastBookingsForUser(user.getLogin(), localDate, localTime);

        // ajout infos utilisateur
        model.addAttribute("principal", principal);
        model.addAttribute("role", VerifyUser.verify(user));

        model.addAttribute("user", user);
        model.addAttribute("bookings", bookings);
        model.addAttribute("pastBookings", pastBookings);

        //ajout info config
        model.addAttribute("appTitle", appProperties.getTitle());
        model.addAttribute("appFavicon", appProperties.getFaviconPath());
        model.addAttribute("appOpenDays", appProperties.getOpenDays());
        model.addAttribute("limit", limit);
        return "compte";
    }

    @PostMapping("update_user")
    public String updateUser(@RequestParam("login") String login,
                            @RequestParam("password") String password,
                            @RequestParam("firstname") String firstname,
                            @RequestParam("lastname") String lastname,
                            @RequestParam("email") String email,
                            Principal principal,
                            Model model) {
        Users user = usersRepository.findByLogin(login);

        if (!password.equals("")) {
            user.setPassword(passwordEncoder.encode(password));
        }
        
        user.setFirstname(firstname);
        user.setLastname(lastname);
        user.setEmail(email);
        usersRepository.save(user);


        mailSenderService.sendMail(user.getEmail(), "modification de votre compte", "Vous venez d'effectuer des modifications sur votre compte.");
        return "redirect:/compte";
    }

    @PostMapping("update_user/upload")
    public String updateUserImage(Principal principal, @RequestParam("file") MultipartFile file){
        String login = principal.getName();

        String projectRootPath = new File(".").getAbsolutePath();
        
        String targetUploadPath = projectRootPath.substring(0, projectRootPath.length() - 1) 
                                + File.separator + "target" + File.separator + "uploads";

        if (!file.isEmpty()) { 
            try {

                File uploadDir = new File(targetUploadPath);

                if (!uploadDir.exists()) {
                    boolean created = uploadDir.mkdirs();
                    if (created) {
                        log.info("Dossier créé avec succès: " + uploadDir.getAbsolutePath());
                    } else {
                        log.error("ÉCHEC : Impossible de créer le dossier cible 'target/uploads'.");
                        return "redirect:/compte?error=upload_dir_creation_failed"; 
                    }
                }

                String fileName = file.getOriginalFilename(); 

                String uniqueFileName = login + "-" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HH-mm")) + "-" + fileName; 
                
                File targetFile = new File(uploadDir, uniqueFileName); 
                
                file.transferTo(targetFile);
                
                Users user = usersRepository.findByLogin(login);
                user.setImg_path("/uploads/" + uniqueFileName); 
                usersRepository.save(user);
                
                mailSenderService.sendMail(user.getEmail(), "modification de votre compte", "Vous venez de changer votre photo de profil.");
                log.info("Fichier sauvegardé dans : " + targetFile.getAbsolutePath());
                
            } catch (IOException e) {
                log.error("Erreur lors de l'enregistrement du fichier.", e);
                e.printStackTrace();
            }
        }
        

        return "redirect:/compte";
    }

    @PostMapping("cancel_booking")
    public String cancelBooking(@RequestParam("idSlot") int idSlot,
                                @RequestParam("login") String login,
                                Model model,
                                HttpServletRequest request, 
                                HttpSession session) {
        BookingId id = new BookingId();
        id.setIdSlot(idSlot);
        id.setLogin(login);
        bookingsRepository.deleteById(id);

        String lang = (String) session.getAttribute("lang");
        lang = lang == null ? "fr" : lang;

        Slots slot = slotsRepository.findById(idSlot).get();
        mailSenderService.sendMail(usersRepository.findById(login).get().getEmail(), "réservation annulée", "Vous venez d'annuler votre réservation du " + DateParser.formatDate(slot.getDayStart(), lang) + " de " + slot.getTimeStart() + " à " + slot.getTimeEnd() + ".");

        if (slotsRepository.getNumberOfReservation(idSlot) == 0) {
            slotsRepository.deleteById(idSlot);
        }
        return "redirect:compte";
    }
}
