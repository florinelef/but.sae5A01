package fr.but3.sae_web.controllers;

import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;

import fr.but3.sae_web.models.Users;

public class VerifyUser {
    public static String verify(Users user){
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
        return role;
    }
}
