package fr.but3.sae_web.api;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import fr.but3.sae_web.models.Bookings;
import fr.but3.sae_web.models.BookingsRepository;

@RestController
@RequestMapping(value= "/myappointments", 
                produces = {MediaType.APPLICATION_XML_VALUE,
                            MediaType.APPLICATION_JSON_VALUE
                }
)
public class APIAppointments {
    @Autowired
    private BookingsRepository bookingsRepository;

    @GetMapping("/{login}")
    public List<Bookings> getBookingsOfName(@PathVariable String login) {
        List<Bookings> bookings = bookingsRepository.findUpcomingBookingsForUser(login, LocalDate.now(), LocalTime.now());
        return bookings;
    }
}
