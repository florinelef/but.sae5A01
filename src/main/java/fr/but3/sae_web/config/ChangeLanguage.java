package fr.but3.sae_web.config;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;

@Controller
public class ChangeLanguage {
    @GetMapping("/changeLanguage")
    public String changeLanguage(@RequestParam("lang") String lang, @RequestParam("origin") String origin, HttpSession session){
        session.setAttribute("lang", lang);
        
        return "redirect:/" + origin;
    }
}
