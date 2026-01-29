package fr.but3.sae_web.models;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
public interface BookingsRepository extends CrudRepository<Bookings, BookingId> {
    @Query("SELECT b FROM Bookings b INNER JOIN Slots s ON b.id.idSlot = s.idSlot " +
            "WHERE b.id.login = :login " +
            "AND (s.dayStart > :startDay " +
            "OR (s.dayStart = :startDay AND s.timeStart > :startTime)) " +
            "ORDER BY s.dayStart, s.timeStart")
    List<Bookings> findUpcomingBookingsForUser(@Param("login") String login,
                                            @Param("startDay") LocalDate startDay,
                                            @Param("startTime") LocalTime startTime);

    // Les créneaux dont l'heure de début est inférieure à l'heure actuelle sont considérés comme passés
    @Query("SELECT b FROM Bookings b INNER JOIN Slots s ON b.id.idSlot = s.idSlot " +
        "WHERE b.id.login = :login " +
        "AND (s.dayStart < :startDay " +
        "OR (s.dayStart = :startDay AND s.timeStart < :endTime)) " +
        "ORDER BY s.dayStart DESC, s.timeStart")
    List<Bookings> findPastBookingsForUser(@Param("login") String login,
                                            @Param("startDay") LocalDate startDay,
                                            @Param("endTime") LocalTime endTime);

    List<Bookings> findAllById_IdSlot(Integer idSlot);

    @Transactional
    void deleteAllById_IdSlot(Integer idSlot);
}
