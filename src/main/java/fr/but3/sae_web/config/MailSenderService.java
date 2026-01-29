package fr.but3.sae_web.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class MailSenderService {

    @Autowired
    private JavaMailSender sender;

    @Autowired
    private AppProperties props;
    
    public void sendMail(String to, String subject, String text){
        try {
            MimeMessage message = sender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message);

            helper.setFrom(props.getSpringMailUsername() + "@univ-lille.fr");
            helper.setTo(to);
            helper.setSubject(props.getTitle() + " : " + subject);
            helper.setText(text, false);

            sender.send(message);
        } catch (MessagingException e) {
            log.error(e.getMessage());
        }
    }
}
