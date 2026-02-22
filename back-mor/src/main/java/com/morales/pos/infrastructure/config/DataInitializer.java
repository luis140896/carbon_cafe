package com.morales.pos.infrastructure.config;

import com.morales.pos.domain.entity.User;
import com.morales.pos.domain.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Slf4j
public class DataInitializer implements CommandLineRunner {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        // Actualizar contraseña del admin si existe
        userRepository.findByUsername("admin").ifPresent(user -> {
            String newHash = passwordEncoder.encode("admin123");
            user.setPasswordHash(newHash);
            userRepository.save(user);
            log.info("Contraseña del usuario admin actualizada correctamente");
        });
    }
}
