package fr.but3.sae_web.models;

import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Entity
@Data
public class Authorities {
    @EmbeddedId
    @Getter @Setter
    private AuthorityID id;
}