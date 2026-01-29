package fr.but3.sae_web.models;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import jakarta.transaction.Transactional;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

@Repository
public interface SlotsRepository extends CrudRepository<Slots, Integer> {

       // Récupérer les slots d'un jour donnés
       @Query("SELECT s FROM Slots s " +
            "WHERE s.dayStart = :date " +
            "ORDER BY s.dayStart")
       List<Slots> findByDay(@Param("date") LocalDate date);

       // Pourcentage d'occupation d'un slot
       @Query("SELECT FUNCTION('ROUND', (COUNT(b.id.login) * 100.0 / :capacity), 2) " +
           "FROM Bookings b " +
           "WHERE b.id.idSlot = :id")
       Double getCapacityPercentage(@Param("capacity") int capacity, @Param("id") int idSlot);

       // Nombre de réservations pour un slot
       @Query("SELECT COUNT(b.id.login) " +
           "FROM Bookings b " +
           "WHERE b.id.idSlot = :id")
       int getNumberOfReservation(@Param("id") int idSlot);

       // Trouver un slot selon date et horaire
       @Query(   "SELECT s FROM Slots s " +
              "WHERE s.dayStart = :date " +
              "AND s.timeStart = :timeStart AND s.timeEnd = :timeEnd")
       Optional<Slots> findByDateAndTime(@Param("date") LocalDate date,
                                   @Param("timeStart") LocalTime timeStart,
                                   @Param("timeEnd") LocalTime timeEnd);

       @Transactional
       @Modifying
       @Query("DELETE FROM Slots s " +
              "WHERE s.dayStart = :date ")
       void deleteSlotsOfDay(@Param("date") LocalDate date);

}
