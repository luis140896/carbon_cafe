package com.morales.pos.domain.repository;

import com.morales.pos.domain.entity.InventoryMovement;
import com.morales.pos.domain.enums.MovementType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface InventoryMovementRepository extends JpaRepository<InventoryMovement, Long> {

    List<InventoryMovement> findByProductIdOrderByCreatedAtDesc(Long productId);

    List<InventoryMovement> findByCreatedAtBetweenOrderByCreatedAtDesc(LocalDateTime start, LocalDateTime end);

    List<InventoryMovement> findByMovementTypeOrderByCreatedAtDesc(MovementType movementType);

    @Query("SELECT m FROM InventoryMovement m WHERE m.user.id = :userId ORDER BY m.createdAt DESC")
    List<InventoryMovement> findByUserIdOrderByCreatedAtDesc(@Param("userId") Long userId);

    @Query("SELECT m FROM InventoryMovement m WHERE m.product.id = :productId AND m.createdAt BETWEEN :start AND :end ORDER BY m.createdAt DESC")
    List<InventoryMovement> findByProductIdAndDateRange(
            @Param("productId") Long productId,
            @Param("start") LocalDateTime start,
            @Param("end") LocalDateTime end);
}
