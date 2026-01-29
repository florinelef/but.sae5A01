package fr.but3.sae_web.api;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import fr.but3.sae_web.models.Bookings;
import fr.but3.sae_web.models.BookingsRepository;
import fr.but3.sae_web.models.Slots;
import fr.but3.sae_web.models.SlotsRepository;

@RestController
@RequestMapping(value= "/todayslist",
                produces= {MediaType.APPLICATION_XML_VALUE,
                            MediaType.APPLICATION_JSON_VALUE
                }
)
public class APITodaysList {
    @Autowired
    private BookingsRepository bookingsRepository;

    @Autowired
    private SlotsRepository slotsRepository;

    @GetMapping("/{date}")
    public List<Bookings> getBookingsOfDate (@PathVariable String date) {
        List<Slots> slots = slotsRepository.findByDay(LocalDate.parse(date));
        List<Bookings> bookings = new ArrayList<>();
        for (Slots slot : slots) {
            bookings.addAll(bookingsRepository.findAllById_IdSlot(slot.getIdSlot()));
        }
        return bookings;
    }
}
