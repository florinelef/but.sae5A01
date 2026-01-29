package fr.but3.sae_web.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    
    private static final String UPLOAD_DIR = "./target/uploads";
    private static final String DOC_DIR = "./target/documents";

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + new java.io.File(UPLOAD_DIR).getAbsolutePath() + "/");
        
        registry.addResourceHandler("/documents/**")
                .addResourceLocations("file:" + new java.io.File(DOC_DIR).getAbsolutePath() + "/");

        WebMvcConfigurer.super.addResourceHandlers(registry);
    }
}
