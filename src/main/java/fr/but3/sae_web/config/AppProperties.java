package fr.but3.sae_web.config;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class AppProperties {

    @Value("${app.title}")
    private String title;

    @Value("${app.logo.path}")
    private String logoPath;

    @Value("${app.favicon.path}")
    private String faviconPath;

    @Value("${app.slot.capacity}")
    private int capacity;

    @Value("${app.open_days}")
    private List<DayOfWeek> openDays;

    @Value("${app.slot.duration}")
    private int duration;

    @Value("${app.day.start_time}")
    private LocalTime startTime;

    @Value("${app.day.end_time}")
    private LocalTime endTime;

    @Value("${spring.mail.username}")
    private String springMailUsername;

    public String getSpringMailUsername(){
        return springMailUsername;
    }

    public String getTitle() {
        return title;
    }

    public String getLogoPath() {
        return logoPath;
    }

    public String getFaviconPath() {
        return faviconPath;
    }

    public int getCapacity() {
        return capacity;
    }

    public int getDuration() {
        return duration;
    }

    public List<DayOfWeek> getOpenDays() {
        return openDays;
    }

    public LocalTime getStartTime() {
        return startTime;
    }

    public LocalTime getEndTime() {
        return endTime;
    }
}