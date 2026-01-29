package fr.but3.sae_web.config;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

public class DateParser {

    /**
     * Formate un LocalDate au format dd-MM-yyyy
     * @param date LocalDate à formater
     * @return String formatée, vide si date est null
     */
    public static String formatDate(LocalDate date, String lang) {
        if (date == null) return "";
        Locale locale;
        String pattern = "d MMMM yyyy";
        switch (lang) {
            case "en":
                locale = Locale.ENGLISH;
                pattern = "MMMM d yyyy";
                break;
            case "es":
                locale = new Locale("es", "ES");
                break;
            default:
                locale = Locale.FRENCH;
        }

        DateTimeFormatter formatter =
                DateTimeFormatter.ofPattern(pattern, locale);

        return date.format(formatter);
    }
}

