package fr.but3.sae_web.models;

import jakarta.persistence.Embeddable;
import java.io.Serializable;
import lombok.Getter;
import lombok.Setter;
import lombok.EqualsAndHashCode;

@Embeddable
@Getter @Setter @EqualsAndHashCode
public class BookingId implements Serializable {
    private int idSlot;
    private String login;
}
