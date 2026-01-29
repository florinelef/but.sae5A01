package fr.but3.sae_web.controllers;

import java.time.LocalDate;
import java.time.Month;
import java.time.format.TextStyle;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import fr.but3.sae_web.config.AppProperties;
import jakarta.servlet.http.HttpSession;

@Controller
public class Planning {

    @Autowired
    private AppProperties appProperties;

    @RequestMapping({"/", "planning"})
    public String landing(Model model, @RequestParam(value="month", required=false) String month,
                            @RequestParam(value="year", required=false) String year,
                            HttpSession session) {

        // date par défaut
        LocalDate currentDate = LocalDate.now();
        Month viewMonth = currentDate.getMonth();
        int viewYear = currentDate.getYear();
        
        // Vérification du mois
        if (month != null) {
            try {
                int monthInt = Integer.parseInt(month);
                if (monthInt >= 1 && monthInt <= 12) {
                    viewMonth = Month.of(monthInt);
                }
            }
            catch(NumberFormatException e) {
                // on laisse le mois courant
            }
        }
        // Vérification de l'année
        if (year != null) {
            try {
                int yearInt = Integer.parseInt(year);
                viewYear = yearInt;
            }
            catch(NumberFormatException e) {
                // on laisse l'année courante
            }
        }

        // Affichage de la date
        String monthDisplay = viewMonth.getDisplayName(TextStyle.FULL, Locale.FRANCE);
        LocalDate firstOfMonth = LocalDate.of(viewYear, viewMonth, 1);
        int dayOfFirstOfMonth = firstOfMonth.getDayOfWeek().getValue();
        int lenghtOfMonth = firstOfMonth.lengthOfMonth();

        // Calcul du mois précédent
        LocalDate previousMonthDate = firstOfMonth.minusMonths(1);
        Month previousMonth = previousMonthDate.getMonth();
        int previousYear = previousMonthDate.getYear();
        String previousMonthDisplay = previousMonth.getDisplayName(TextStyle.FULL, Locale.FRANCE);
        
        // Calcul du mois suivant
        LocalDate nextMonthDate = firstOfMonth.plusMonths(1);
        Month nextMonth = nextMonthDate.getMonth();
        int nextYear = nextMonthDate.getYear();
        
        String nextMonthDisplay = nextMonth.getDisplayName(TextStyle.FULL, Locale.FRANCE);
        
        // i18n displayssss :)
        if(session.getAttribute("lang") != null) {
            switch ((String)session.getAttribute("lang")) {
                case "en":
                    monthDisplay = viewMonth.getDisplayName(TextStyle.FULL, Locale.ENGLISH);
                    previousMonthDisplay = previousMonth.getDisplayName(TextStyle.FULL, Locale.ENGLISH);
                    nextMonthDisplay = nextMonth.getDisplayName(TextStyle.FULL, Locale.ENGLISH);
                    break;
                case "es":
                    monthDisplay = viewMonth.getDisplayName(TextStyle.FULL, new Locale ( "es" , "ES" ));
                    previousMonthDisplay = previousMonth.getDisplayName(TextStyle.FULL, new Locale ( "es" , "ES" ));
                    nextMonthDisplay = nextMonth.getDisplayName(TextStyle.FULL, new Locale ( "es" , "ES" ));
                    break;
            }
        }
        String monthString = monthDisplay.substring(0, 1).toUpperCase() + monthDisplay.substring(1);
        String previousMonthString = previousMonthDisplay.substring(0,1).toUpperCase() + previousMonthDisplay.substring(1);
        String nextMonthString = nextMonthDisplay.substring(0,1).toUpperCase() + nextMonthDisplay.substring(1);
        


        String role = "user";
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !(auth instanceof AnonymousAuthenticationToken)) {
            for (GrantedAuthority ga : auth.getAuthorities()) {
                String authority = ga.getAuthority();
                if ("ROLE_ADMIN".equals(authority) || "ADMIN".equals(authority)) {
                    role = "admin";
                    break;
                }
            }
        }
        model.addAttribute("role", role);

        // ajout de la date 
        model.addAttribute("monthString", monthString);
        model.addAttribute("viewMonth", viewMonth.getValue());
        model.addAttribute("viewYear", viewYear);
        model.addAttribute("dayOfFirstOfMonth", dayOfFirstOfMonth);
        model.addAttribute("lengthOfMonth", lenghtOfMonth);
        model.addAttribute("currentDate", currentDate);

        // ajout précédent/suivant
        model.addAttribute("previousMonth", previousMonth.getValue());
        model.addAttribute("nextMonth", nextMonth.getValue());
        model.addAttribute("previousMonthString", previousMonthString);
        model.addAttribute("nextMonthString", nextMonthString);
        model.addAttribute("previousYear", previousYear);
        model.addAttribute("nextYear", nextYear);

        //ajout info config
        model.addAttribute("appTitle", appProperties.getTitle());
        model.addAttribute("appFavicon", appProperties.getFaviconPath());
        model.addAttribute("appOpenDays", appProperties.getOpenDays());
        return "planning";
    }
}
