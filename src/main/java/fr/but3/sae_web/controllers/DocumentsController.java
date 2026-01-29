package fr.but3.sae_web.controllers;

import java.io.File;
import java.io.IOException;
import java.security.Principal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import fr.but3.sae_web.config.AppProperties;
import fr.but3.sae_web.models.BookingId;
import fr.but3.sae_web.models.Bookings;
import fr.but3.sae_web.models.BookingsRepository;
import fr.but3.sae_web.models.Documents;
import fr.but3.sae_web.models.DocumentsRepository;
import fr.but3.sae_web.models.Users;
import fr.but3.sae_web.models.UsersRepository;
import lombok.extern.slf4j.Slf4j;


@Controller
@Slf4j
public class DocumentsController {

    @Autowired
    private BookingsRepository bookingsRepository;
    
    @Autowired
    private DocumentsRepository documentsRepository;

    @Autowired
    private AppProperties appProperties;

    @Autowired
    private UsersRepository usersRepository;

    @GetMapping("/documents")
    public String displayDocuments(
            @RequestParam("login") String login,
            @RequestParam("idSlot") Integer idSlot,
            @RequestParam("lastPage") String lastPage,
            Model model,
            Principal principal) {

        Users user = usersRepository.findByLogin(principal.getName());
        model.addAttribute("role", VerifyUser.verify(user));

        BookingId bookingId = new BookingId();
        bookingId.setLogin(login);
        bookingId.setIdSlot(idSlot);

        Optional<Bookings> bookingOpt = bookingsRepository.findById(bookingId);

        if (bookingOpt.isEmpty()) {
            model.addAttribute("errorMessage", "Réservation introuvable.");
            return "redirect:/compte"; 
        }
        Bookings booking = bookingOpt.get(); 

        List<Documents> documents = documentsRepository.findByLoginAndIdSlot(login, idSlot); 

        model.addAttribute("booking", booking);
        model.addAttribute("documents", documents);
        model.addAttribute("idSlot", idSlot);

        model.addAttribute("lastPage", lastPage);

        //ajout info config
        model.addAttribute("appTitle", appProperties.getTitle());
        model.addAttribute("appFavicon", appProperties.getFaviconPath());
        model.addAttribute("appOpenDays", appProperties.getOpenDays());

        return "documents";
    }

    @PostMapping("/documents/upload")
    public String uploadDocuments(Model model,
            @RequestParam("file") MultipartFile file,
            @RequestParam("idSlot") Integer idSlot,
            @RequestParam("login") String login,
            RedirectAttributes redirectAttributes,
            Principal principal) {


        if (file.isEmpty()) {
            return "redirect:/documents?login=" + login + "&idSlot=" + idSlot;
        }
        
        // --- 2. Définition des chemins d'upload ---
        String projectRootPath = new File(".").getAbsolutePath();
        String targetUploadPath = projectRootPath.substring(0, projectRootPath.length() - 1) 
                                + File.separator + "target" + File.separator + "documents";

        try {
            // Création du répertoire cible si inexistant
            File uploadDir = new File(targetUploadPath);
            if (!uploadDir.exists()) {
                if (!uploadDir.mkdirs()) {
                    log.error("ÉCHEC : Impossible de créer le dossier cible 'target/uploads'.");
                    redirectAttributes.addFlashAttribute("errorMessage", "Erreur serveur : répertoire d'upload non accessible.");
                    return "redirect:/compte"; 
                }
            }

            // --- 3. Création du nom de fichier unique ---
            String originalFileName = file.getOriginalFilename();
            // Utiliser un UUID est souvent plus sûr que l'heure/date, mais en gardant votre format :
            String fileExtension = "";
            int dotIndex = originalFileName.lastIndexOf('.');
            if (dotIndex > 0) {
                fileExtension = originalFileName.substring(dotIndex);
            }
            
            String baseName = originalFileName.substring(0, dotIndex > 0 ? dotIndex : originalFileName.length());
            String uniqueName = login + "-" + idSlot + "-" + baseName.replaceAll("\\s+", "_")
                              + "-" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("HHmmss")) + fileExtension;
            
            File targetFile = new File(uploadDir, uniqueName); 
            
            // --- 4. Sauvegarde physique du fichier ---
            file.transferTo(targetFile);

            // --- 5. Enregistrement en base de données (Documents) ---
            Documents document = new Documents();
            document.setLogin(login);
            document.setIdSlot(idSlot);
            // Le chemin web doit correspondre au ResourceHandler configuré dans WebConfig
            document.setDocPath("/documents/" + uniqueName); 
            
            documentsRepository.save(document);
            
            log.info("Document sauvegardé et entrée DB créée : " + targetFile.getAbsolutePath());
            redirectAttributes.addFlashAttribute("successMessage", "Document téléversé avec succès.");
            
        } catch (IOException e) {
            log.error("Erreur lors de l'enregistrement du fichier.", e);
            redirectAttributes.addFlashAttribute("errorMessage", "Erreur lors de l'enregistrement du fichier sur le serveur.");
        } catch (Exception e) {
             log.error("Erreur lors de la sauvegarde en DB.", e);
             redirectAttributes.addFlashAttribute("errorMessage", "Erreur lors de la sauvegarde des informations du document.");
        }

        // --- 6. Redirection vers la page des documents du booking concerné ---
        return "redirect:/documents?login=" + login + "&idSlot=" + idSlot + "&lastPage=compte";
    }

    @PostMapping("/documents/delete")
    public String deleteDocuments(Principal principal, @RequestParam("idDoc") Integer idDoc, @RequestParam("idSlot") Integer idSlot) {                
        String login = principal.getName();

        documentsRepository.deleteById(idDoc);

        return "redirect:/documents?login=" + login + "&idSlot=" + idSlot;
    }
}

