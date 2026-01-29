package fr.but3.sae_web.models;

import java.time.LocalDate;
import java.time.LocalTime;

import lombok.Getter;
import lombok.Setter;

public class SlotVirtual {
    @Getter @Setter private Integer idSlot; // null si virtuel
    @Getter @Setter private LocalDate day;
    @Getter @Setter private LocalTime timeStart;
    @Getter @Setter private LocalTime timeEnd;
    @Getter @Setter private boolean isVirtual; // true si non encore créé en base
    @Getter @Setter private int reservationCount;
    @Getter @Setter private double capacityPercentage;

    public SlotVirtual(LocalDate day, LocalTime start, LocalTime end) {
        this.day = day;
        this.timeStart = start;
        this.timeEnd = end;
        this.isVirtual = true;
        this.reservationCount = 0;
        this.capacityPercentage = 0.0;
    }

    public SlotVirtual(Slots slot, int reservationCount, double percentage) {
        this.idSlot = slot.getIdSlot();
        this.day = slot.getDayStart();
        this.timeStart = slot.getTimeStart();
        this.timeEnd = slot.getTimeEnd();
        this.isVirtual = false;
        this.reservationCount = reservationCount;
        this.capacityPercentage = percentage;
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((day == null) ? 0 : day.hashCode());
        result = prime * result + ((timeStart == null) ? 0 : timeStart.hashCode());
        result = prime * result + ((timeEnd == null) ? 0 : timeEnd.hashCode());
        return result;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        SlotVirtual other = (SlotVirtual) obj;
        if (day == null) {
            if (other.day != null)
                return false;
        } else if (!day.equals(other.day))
            return false;
        if (timeStart == null) {
            if (other.timeStart != null)
                return false;
        } else if (!timeStart.equals(other.timeStart))
            return false;
        if (timeEnd == null) {
            if (other.timeEnd != null)
                return false;
        } else if (!timeEnd.equals(other.timeEnd))
            return false;
        return true;
    }


    
}