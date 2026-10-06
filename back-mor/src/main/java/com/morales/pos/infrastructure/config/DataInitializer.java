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
        // No se modifica la contraseña del admin existente para evitar una puerta trasera
        // en producción. El seed inicial se carga por Flyway en V2.
    }
}
