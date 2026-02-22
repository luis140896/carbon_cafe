package com.morales.pos.application.service;

import com.morales.pos.application.dto.response.NotificationResponse;
import com.morales.pos.domain.entity.Notification;
import com.morales.pos.domain.entity.TableSession;
import com.morales.pos.domain.entity.User;
import com.morales.pos.domain.enums.NotificationSeverity;
import com.morales.pos.domain.enums.NotificationType;
import com.morales.pos.domain.repository.NotificationRepository;
import com.morales.pos.domain.repository.TableSessionRepository;
import com.morales.pos.domain.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class NotificationService {

    private final NotificationRepository notificationRepository;
    private final TableSessionRepository tableSessionRepository;
    private final UserRepository userRepository;

    // ==================== QUERIES ====================

    @Transactional(readOnly = true)
    public List<NotificationResponse> getUnreadByRole(String role) {
        String jsonRole = toJsonArray(role);
        return notificationRepository.findUnreadByRole(jsonRole).stream()
                .map(NotificationResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public Long countUnreadByRole(String role) {
        return notificationRepository.countUnreadByRole(toJsonArray(role));
    }

    @Transactional(readOnly = true)
    public Page<NotificationResponse> getAllByRole(String role, Pageable pageable) {
        return notificationRepository.findByRole(toJsonArray(role), pageable)
                .map(NotificationResponse::fromEntity);
    }

    // ==================== ACTIONS ====================

    @Transactional
    public void markAsRead(Long notificationId, User user) {
        Notification notification = notificationRepository.findById(notificationId)
                .orElseThrow(() -> new RuntimeException("Notificación no encontrada"));
        notification.setIsRead(true);
        notification.setReadBy(user);
        notification.setReadAt(LocalDateTime.now());
        notificationRepository.save(notification);
    }

    @Transactional
    public int markAllAsRead(String role) {
        return notificationRepository.markAllAsReadByRole(toJsonArray(role), LocalDateTime.now());
    }

    private String toJsonArray(String role) {
        return "[\"" + role + "\"]";
    }

    // ==================== CREATE NOTIFICATIONS ====================

    @Transactional
    public Notification createNotification(NotificationType type, String title, String message,
                                           NotificationSeverity severity, List<String> targetRoles,
                                           String referenceType, Long referenceId) {
        // Avoid duplicate unread notifications for the same reference
        if (referenceId != null && notificationRepository.existsByTypeAndReferenceIdAndIsReadFalse(type, referenceId)) {
            return null;
        }

        Notification notification = Notification.builder()
                .type(type)
                .title(title)
                .message(message)
                .severity(severity)
                .targetRoles(targetRoles)
                .referenceType(referenceType)
                .referenceId(referenceId)
                .build();

        Notification saved = notificationRepository.save(notification);
        log.debug("Notificación creada: {} - {}", type, title);
        return saved;
    }

    public void notifyVoidAttempt(String invoiceNumber, String userName) {
        createNotification(
                NotificationType.VOID_ATTEMPT,
                "Anulación de factura",
                String.format("El usuario %s anuló la factura %s", userName, invoiceNumber),
                NotificationSeverity.CRITICAL,
                List.of("ADMIN", "SUPERVISOR"),
                "INVOICE",
                null
        );
    }

    public void notifyLowStock(String productName, Long productId, int currentStock, int minStock) {
        createNotification(
                NotificationType.LOW_STOCK,
                "Stock bajo: " + productName,
                String.format("El producto %s tiene %d unidades (mínimo: %d)", productName, currentStock, minStock),
                NotificationSeverity.WARNING,
                List.of("ADMIN", "INVENTARIO"),
                "PRODUCT",
                productId
        );
    }

    public void notifyOutOfStock(String productName, Long productId) {
        createNotification(
                NotificationType.OUT_OF_STOCK,
                "Sin stock: " + productName,
                String.format("El producto %s se ha agotado", productName),
                NotificationSeverity.ERROR,
                List.of("ADMIN", "INVENTARIO", "CAJERO"),
                "PRODUCT",
                productId
        );
    }

    // ==================== SCHEDULED CHECKS ====================

    @Scheduled(fixedRate = 300000) // Every 5 minutes
    @Transactional
    public void checkLongOpenTables() {
        LocalDateTime threshold = LocalDateTime.now().minus(40, ChronoUnit.MINUTES);
        List<TableSession> longSessions = tableSessionRepository.findLongOpenSessions(threshold);

        for (TableSession session : longSessions) {
            createNotification(
                    NotificationType.TABLE_LONG_OPEN,
                    "Mesa #" + session.getRestaurantTable().getTableNumber() + " abierta mucho tiempo",
                    String.format("La mesa #%d lleva abierta desde %s (%d minutos)",
                            session.getRestaurantTable().getTableNumber(),
                            session.getOpenedAt().toLocalTime(),
                            ChronoUnit.MINUTES.between(session.getOpenedAt(), LocalDateTime.now())),
                    NotificationSeverity.WARNING,
                    List.of("ADMIN", "SUPERVISOR", "MESERO"),
                    "TABLE",
                    session.getRestaurantTable().getId()
            );
        }
    }

    @Scheduled(fixedRate = 300000) // Every 5 minutes
    @Transactional
    public void checkIdleTables() {
        LocalDateTime threshold = LocalDateTime.now().minus(15, ChronoUnit.MINUTES);
        List<TableSession> idleSessions = tableSessionRepository.findIdleSessions(threshold);

        for (TableSession session : idleSessions) {
            createNotification(
                    NotificationType.TABLE_IDLE,
                    "Mesa #" + session.getRestaurantTable().getTableNumber() + " sin actividad",
                    String.format("La mesa #%d no ha tenido movimientos en los últimos 15 minutos",
                            session.getRestaurantTable().getTableNumber()),
                    NotificationSeverity.INFO,
                    List.of("ADMIN", "SUPERVISOR"),
                    "TABLE",
                    session.getRestaurantTable().getId()
            );
        }
    }

    // Cleanup old read notifications (older than 30 days)
    @Scheduled(cron = "0 0 3 * * ?") // Every day at 3 AM
    @Transactional
    public void cleanupOldNotifications() {
        LocalDateTime before = LocalDateTime.now().minusDays(30);
        int deleted = notificationRepository.deleteOldReadNotifications(before);
        if (deleted > 0) {
            log.info("Limpieza de notificaciones: {} eliminadas", deleted);
        }
    }
}
