package com.morales.pos.presentation.controller;

import com.morales.pos.application.dto.request.LoginRequest;
import com.morales.pos.application.dto.response.ApiResponse;
import com.morales.pos.application.dto.response.AuthResponse;
import com.morales.pos.application.service.AuthService;
import com.morales.pos.infrastructure.security.jwt.CustomUserDetails;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
@Tag(name = "Autenticación", description = "Endpoints de autenticación y manejo de sesiones")
public class AuthController {

    private final AuthService authService;

    @PostMapping("/login")
    @Operation(summary = "Iniciar sesión", description = "Autentica un usuario y devuelve tokens JWT")
    public ResponseEntity<ApiResponse<AuthResponse>> login(@Valid @RequestBody LoginRequest request) {
        AuthResponse response = authService.login(request);
        return ResponseEntity.ok(ApiResponse.success(response, "Login exitoso"));
    }

    @PostMapping("/refresh")
    @Operation(summary = "Refrescar token", description = "Genera un nuevo access token usando el refresh token")
    public ResponseEntity<ApiResponse<AuthResponse>> refreshToken(@RequestBody Map<String, String> request) {
        String refreshToken = request.get("refreshToken");
        AuthResponse response = authService.refreshToken(refreshToken);
        return ResponseEntity.ok(ApiResponse.success(response, "Token actualizado"));
    }

    @PostMapping("/logout")
    @Operation(summary = "Cerrar sesión", description = "Invalida el refresh token de la sesión del usuario")
    public ResponseEntity<ApiResponse<Void>> logout(
            Authentication authentication,
            @RequestBody(required = false) Map<String, String> request) {
        CustomUserDetails userDetails = authentication != null ? (CustomUserDetails) authentication.getPrincipal() : null;
        String refreshToken = request != null ? request.get("refreshToken") : null;
        authService.logout(userDetails != null ? userDetails.getUser() : null, refreshToken);
        return ResponseEntity.ok(ApiResponse.success(null, "Sesión cerrada exitosamente"));
    }
}
