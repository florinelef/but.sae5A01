package fr.but3.sae_web.models;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Getter;
import lombok.Setter;

@Entity
public class Documents {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Getter @Setter
    @Column(name = "id_doc")
    private Integer idDoc;

    @Getter @Setter
    @Column(name = "doc_path")
    private String docPath;

    @Getter @Setter
    @Column(name = "id_slot")
    private Integer idSlot;

    @Getter @Setter
    @Column(name = "login")
    private String login;
}

