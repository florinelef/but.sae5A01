package fr.but3.sae_web.models;

import java.time.LocalDate;
import java.time.LocalTime;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "slots")
public class Slots {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_slot")
    private Integer idSlot;
    
    @Column(name = "day_start")
    private LocalDate dayStart;
    
    @Column(name = "time_start")
    private LocalTime timeStart;
    
    @Column(name = "time_end")
    private LocalTime timeEnd;
}