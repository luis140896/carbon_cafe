package com.morales.pos.presentation.controller;

import com.morales.pos.application.dto.response.ApiResponse;
import com.morales.pos.application.dto.response.NotificationResponse;
import com.morales.pos.application.service.NotificationService;
import com.morales.pos.domain.entity.User;
import com.morales.pos.domain.repository.UserRepository;
import com.morales.pos.infrastructure.security.jwt.CustomUserDetails;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;
    private final UserRepository userRepository;

    @GetMapping
    public ResponseEntity<ApiResponse<Page<NotificationResponse>>> findAll(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @PageableDefault(size = 20) Pageable pageable) {
        String role = extractRole(userDetails);
        return ResponseEntity.ok(ApiResponse.success(notificationService.getAllByRole(role, pageable)));
    }

    @GetMapping("/unread")
    public ResponseEntity<ApiResponse<Map<String, Long>>> countUnread(
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        String role = extractRole(userDetails);
        Long count = notificationService.countUnreadByRole(role);
        return ResponseEntity.ok(ApiResponse.success(Map.of("count", count)));
    }

    @GetMapping("/unread/list")
    public ResponseEntity<ApiResponse<List<NotificationResponse>>> getUnread(
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        String role = extractRole(userDetails);
        return ResponseEntity.ok(ApiResponse.success(notificationService.getUnreadByRole(role)));
    }

    @PutMapping("/{id}/read")
    public ResponseEntity<ApiResponse<Void>> markAsRead(
            @PathVariable Long id,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        User user = userRepository.findById(userDetails.getId())
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
        notificationService.markAsRead(id, user);
        return ResponseEntity.ok(ApiResponse.success(null, "Notificación marcada como leída"));
    }

    @PutMapping("/read-all")
    public ResponseEntity<ApiResponse<Map<String, Integer>>> markAllAsRead(
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        String role = extractRole(userDetails);
        int count = notificationService.markAllAsRead(role);
        return ResponseEntity.ok(ApiResponse.success(
                Map.of("marked", count), "Todas las notificaciones marcadas como leídas"));
    }

    private String extractRole(CustomUserDetails userDetails) {
        return userDetails.getAuthorities().stream()
                .findFirst()
                .map(a -> a.getAuthority().replace("ROLE_", ""))
                .orElse("CAJERO");
    }
}
