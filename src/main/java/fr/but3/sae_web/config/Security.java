package fr.but3.sae_web.config;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.security.servlet.PathRequest;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.JdbcUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

import jakarta.servlet.DispatcherType;

@Configuration
public class Security {
    @Autowired
    DataSource dataSource;

    @Autowired
    AppProperties appProperties;

    @Bean
    public SecurityFilterChain mesautorisations(HttpSecurity http) throws Exception {
        return http
        .authorizeHttpRequests(authorize -> authorize
            .dispatcherTypeMatchers(DispatcherType.FORWARD,DispatcherType.ERROR).permitAll()
            .requestMatchers("/login").permitAll()
            .requestMatchers("/check_login").permitAll()
            .requestMatchers("/signin").permitAll()
            .requestMatchers("/check_signin").permitAll()
            .requestMatchers("/*/*.png").permitAll()
            .requestMatchers("/*/*.jpg").permitAll()
            .requestMatchers("/*/*.ico").permitAll()
            .requestMatchers("/*.css").permitAll()
            .requestMatchers("/*.js").permitAll()
            .requestMatchers(PathRequest.toH2Console()).permitAll()
            .anyRequest().authenticated()
        )
        .formLogin(form -> form
            .loginPage("/login")
            .loginProcessingUrl("/check_login")
            .usernameParameter("login")
            .passwordParameter("password")
            .defaultSuccessUrl("/", true)
            .permitAll()
        )
        .httpBasic(Customizer.withDefaults())
        .logout(logout -> logout
            .logoutUrl("/logout")
            .logoutSuccessUrl("/login")
            .invalidateHttpSession(true)
            .deleteCookies("JSESSIONID", "remember-me")
            .permitAll()
        )
        .rememberMe(configurer -> 
            configurer.rememberMeParameter("remember-me").rememberMeCookieName("remember-me").useSecureCookie(true)
        )
        .csrf(csrf -> csrf
            .ignoringRequestMatchers(PathRequest.toH2Console()) )
            .headers(headers -> headers.frameOptions(frameOptions -> frameOptions.sameOrigin())
        )
        .build();
    }
    
    @Bean
    public JdbcUserDetailsManager users() {
        String usersByUsernameQuery = "select login as username, password, enabled from users where login = ?";
        String authsByUserQuery = "select login as username, authority from authorities where login = ?";

        JdbcUserDetailsManager users = new JdbcUserDetailsManager(dataSource);
        users.setUsersByUsernameQuery(usersByUsernameQuery);
        users.setAuthoritiesByUsernameQuery(authsByUserQuery);

        return users;
    }
    
    @Bean
    public PasswordEncoder encoder() {
        return new BCryptPasswordEncoder();
    }
}
