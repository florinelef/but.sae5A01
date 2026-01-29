package fr.but3.sae_web.models;

import java.io.Serializable;

import jakarta.persistence.Embeddable;

@Embeddable
public class AuthorityID implements Serializable {
    @SuppressWarnings("unused")
    private String login;
    @SuppressWarnings("unused")
    private String authority;

    public AuthorityID() {}

    public AuthorityID (String login, String authority) {
        this.login = login;
        this.authority = authority;
    }
}
