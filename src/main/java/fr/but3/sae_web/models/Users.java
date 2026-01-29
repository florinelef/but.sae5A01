package fr.but3.sae_web.models;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Entity
@Data
public class Users {
    @Id
    @NotNull(message = "Login manquant")
    private String login;
    @NotNull(message = "Nom manquant")
    private String lastname;
    @NotNull(message = "Prénom manquant")
    private String firstname;
    @NotNull(message = "Mail manquant")
    private String email;
    @NotNull(message = "Mot de passe manquant")
    private String password;
    private String img_path;
    private boolean enabled;
}
