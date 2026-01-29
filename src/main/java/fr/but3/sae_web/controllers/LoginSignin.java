package fr.but3.sae_web.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import fr.but3.sae_web.config.AppProperties;
import fr.but3.sae_web.config.MailSenderService;
import fr.but3.sae_web.models.Authorities;
import fr.but3.sae_web.models.AuthoritiesRepository;
import fr.but3.sae_web.models.AuthorityID;
import fr.but3.sae_web.models.Users;
import fr.but3.sae_web.models.UsersRepository;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;

@Controller
public class LoginSignin {

    @Autowired
    private UsersRepository usersRepository;

    @Autowired
    private AppProperties appProperties;

    @Autowired
    private MailSenderService mailSenderService;

    @Autowired
    private PasswordEncoder passwordEncoder;


    @Autowired
    private AuthoritiesRepository authoritiesRepository;

    @RequestMapping("login")
    public String loginPage(Model model, @RequestParam(value = "lang", required = false, defaultValue = "fr") String lang) {
        model.addAttribute("appTitle", appProperties.getTitle());
        model.addAttribute("appFavicon", appProperties.getFaviconPath());
        model.addAttribute("appLogo", appProperties.getLogoPath());
        model.addAttribute("lang", lang);
        return "login";
    }

    @RequestMapping("signin")
    public String signinPage(Model model, @RequestParam(value = "lang", required = false, defaultValue = "fr") String lang) {
        model.addAttribute("appTitle", appProperties.getTitle());
        model.addAttribute("appFavicon", appProperties.getFaviconPath());
        model.addAttribute("appLogo", appProperties.getLogoPath());
        model.addAttribute("lang", lang);
        return "signin";
    }

    
    @PostMapping("/check_signin")
    public String checkSignIn(Model model,
                            @Valid @ModelAttribute Users user,
                            BindingResult result,
                            HttpServletRequest request,
                            RedirectAttributes redirectAttributes
                        ) {
        if (result.hasErrors()) {
            List<ObjectError> errors = result.getAllErrors();
            redirectAttributes.addFlashAttribute("message", errors);
            return "redirect:signin";
        }

        if (usersRepository.findByLogin(user.getLogin()) == null) {
            String encodedPassword = passwordEncoder.encode(user.getPassword());
            user.setPassword(encodedPassword);
            user.setEnabled(true);
            usersRepository.save(user);

            Authorities auth = new Authorities();
            AuthorityID authId = new AuthorityID(user.getLogin(), "USER");
            auth.setId(authId);
                
            authoritiesRepository.save(auth);

            mailSenderService.sendMail(user.getEmail(), "confirmation de la création de votre compte", "Bienvenue " + user.getFirstname() + ",\n\nVotre compte à bien été créé !");

            return "redirect:planning";
        }
        else {
            redirectAttributes.addFlashAttribute("message", "L'utilisateur existe déjà");
            return "redirect:signin";
        }
    }

    @PostMapping("/log_out")
    public String logOut(HttpServletRequest request) {
        request.getSession().invalidate();
        return "redirect:login";
    }
}
