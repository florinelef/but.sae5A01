package fr.but3.sae_web.models;

import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.Getter;
import lombok.Setter;

@Entity
public class Bookings {
    @EmbeddedId
    @Getter @Setter
    private BookingId id;

    @Getter @Setter
    @ManyToOne
    @JoinColumn(name = "idSlot", referencedColumnName = "id_slot", insertable = false, updatable = false)
    private Slots slot;
}

