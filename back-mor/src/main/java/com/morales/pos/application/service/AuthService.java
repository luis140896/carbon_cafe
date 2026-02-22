package com.morales.pos.application.service;

import com.morales.pos.application.dto.request.LoginRequest;
import com.morales.pos.application.dto.response.AuthResponse;
import com.morales.pos.domain.entity.User;
import com.morales.pos.domain.repository.UserRepository;
import com.morales.pos.infrastructure.security.jwt.CustomUserDetails;
import com.morales.pos.infrastructure.security.jwt.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
@Slf4j
public class AuthService {

    private final AuthenticationManager authenticationManager;
    private final JwtTokenProvider jwtTokenProvider;
    private final UserRepository userRepository;

    @Transactional
    public AuthResponse login(LoginRequest request) {
        User user = userRepository.findByUsernameWithRole(request.getUsername())
                .orElseThrow(() -> new BadCredentialsException("Credenciales inválidas"));

        // Verificar si la cuenta está bloqueada
        if (user.isAccountLocked()) {
            throw new LockedException("Cuenta bloqueada. Intente nuevamente más tarde.");
        }

        try {
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            request.getUsername(),
                            request.getPassword()
                    )
            );

            // Login exitoso - resetear intentos fallidos
            user.resetFailedAttempts();
            user.setLastLogin(LocalDateTime.now());
            userRepository.save(user);

            // Generar tokens
            String accessToken = jwtTokenProvider.generateAccessToken(authentication);
            String refreshToken = jwtTokenProvider.generateRefreshToken(request.getUsername());

            CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();

            return AuthResponse.builder()
                    .accessToken(accessToken)
                    .refreshToken(refreshToken)
                    .tokenType("Bearer")
                    .expiresIn(jwtTokenProvider.getAccessTokenExpiration() / 1000)
                    .user(AuthResponse.UserInfo.builder()
                            .id(userDetails.getId())
                            .username(userDetails.getUsername())
                            .email(userDetails.getEmail())
                            .fullName(userDetails.getFullName())
                            .role(user.getRole().getName())
                            .permissions(user.getRole().getPermissions())
                            .build())
                    .build();

        } catch (AuthenticationException e) {
            // Incrementar intentos fallidos
            user.incrementFailedAttempts();
            userRepository.save(user);
            
            log.warn("Intento de login fallido para usuario: {}", request.getUsername());
            throw new BadCredentialsException("Credenciales inválidas");
        }
    }

    @Transactional
    public AuthResponse refreshToken(String refreshToken) {
        if (!jwtTokenProvider.validateToken(refreshToken)) {
            throw new BadCredentialsException("Refresh token inválido o expirado");
        }

        String username = jwtTokenProvider.getUsernameFromToken(refreshToken);
        User user = userRepository.findByUsernameWithRole(username)
                .orElseThrow(() -> new BadCredentialsException("Usuario no encontrado"));

        if (!user.getIsActive()) {
            throw new BadCredentialsException("Usuario inactivo");
        }

        // Crear autenticación para generar nuevo access token
        CustomUserDetails userDetails = new CustomUserDetails(user);
        Authentication authentication = new UsernamePasswordAuthenticationToken(
                userDetails, null, userDetails.getAuthorities()
        );

        String newAccessToken = jwtTokenProvider.generateAccessToken(authentication);
        String newRefreshToken = jwtTokenProvider.generateRefreshToken(username);

        return AuthResponse.builder()
                .accessToken(newAccessToken)
                .refreshToken(newRefreshToken)
                .tokenType("Bearer")
                .expiresIn(jwtTokenProvider.getAccessTokenExpiration() / 1000)
                .user(AuthResponse.UserInfo.builder()
                        .id(user.getId())
                        .username(user.getUsername())
                        .email(user.getEmail())
                        .fullName(user.getFullName())
                        .role(user.getRole().getName())
                        .permissions(user.getRole().getPermissions())
                        .build())
                .build();
    }
}
