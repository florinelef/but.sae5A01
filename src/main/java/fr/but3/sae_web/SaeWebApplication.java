package fr.but3.sae_web;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletComponentScan;

@SpringBootApplication
@ServletComponentScan
public class SaeWebApplication {

	public static void main(String[] args) {
		SpringApplication.run(SaeWebApplication.class, args);
	}
}
