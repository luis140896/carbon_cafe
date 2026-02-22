package com.morales.pos.domain.repository;

import com.morales.pos.domain.entity.Notification;
import com.morales.pos.domain.enums.NotificationType;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Long> {

    @Query(value = "SELECT * FROM notifications n WHERE n.is_read = false " +
           "AND n.target_roles @> CAST(:role AS jsonb) " +
           "ORDER BY n.created_at DESC", nativeQuery = true)
    List<Notification> findUnreadByRole(@Param("role") String role);

    @Query(value = "SELECT COUNT(*) FROM notifications n WHERE n.is_read = false " +
           "AND n.target_roles @> CAST(:role AS jsonb)", nativeQuery = true)
    Long countUnreadByRole(@Param("role") String role);

    @Query(value = "SELECT * FROM notifications n WHERE n.target_roles @> CAST(:role AS jsonb) " +
           "ORDER BY n.created_at DESC",
           countQuery = "SELECT COUNT(*) FROM notifications n WHERE n.target_roles @> CAST(:role AS jsonb)",
           nativeQuery = true)
    Page<Notification> findByRole(@Param("role") String role, Pageable pageable);

    @Modifying
    @Query(value = "UPDATE notifications SET is_read = true, read_at = :now WHERE is_read = false " +
           "AND target_roles @> CAST(:role AS jsonb)", nativeQuery = true)
    int markAllAsReadByRole(@Param("role") String role, @Param("now") LocalDateTime now);

    boolean existsByTypeAndReferenceIdAndIsReadFalse(NotificationType type, Long referenceId);

    @Modifying
    @Query("DELETE FROM Notification n WHERE n.createdAt < :before AND n.isRead = true")
    int deleteOldReadNotifications(@Param("before") LocalDateTime before);
}
