package com.morales.pos.domain.repository;

import com.morales.pos.domain.entity.TableSession;
import com.morales.pos.domain.enums.TableSessionStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface TableSessionRepository extends JpaRepository<TableSession, Long> {

    @Query("SELECT ts FROM TableSession ts " +
           "LEFT JOIN FETCH ts.invoice i " +
           "LEFT JOIN FETCH i.details " +
           "LEFT JOIN FETCH ts.restaurantTable " +
           "LEFT JOIN FETCH ts.openedBy " +
           "WHERE ts.restaurantTable.id = :tableId AND ts.status = :status")
    Optional<TableSession> findByTableIdAndStatus(
            @Param("tableId") Long tableId,
            @Param("status") TableSessionStatus status);

    default Optional<TableSession> findActiveByTableId(Long tableId) {
        return findByTableIdAndStatus(tableId, TableSessionStatus.ABIERTA);
    }

    @Query("SELECT ts FROM TableSession ts " +
           "LEFT JOIN FETCH ts.restaurantTable " +
           "LEFT JOIN FETCH ts.openedBy " +
           "LEFT JOIN FETCH ts.invoice " +
           "WHERE ts.status = :status " +
           "ORDER BY ts.openedAt ASC")
    List<TableSession> findByStatus(@Param("status") TableSessionStatus status);

    default List<TableSession> findAllActive() {
        return findByStatus(TableSessionStatus.ABIERTA);
    }

    @Query("SELECT ts FROM TableSession ts " +
           "LEFT JOIN FETCH ts.restaurantTable " +
           "LEFT JOIN FETCH ts.openedBy " +
           "WHERE ts.status = 'ABIERTA' AND ts.openedAt < :threshold")
    List<TableSession> findLongOpenSessions(@Param("threshold") LocalDateTime threshold);

    @Query("SELECT ts FROM TableSession ts " +
           "LEFT JOIN FETCH ts.invoice i " +
           "WHERE ts.status = 'ABIERTA' AND i.updatedAt < :threshold")
    List<TableSession> findIdleSessions(@Param("threshold") LocalDateTime threshold);

    boolean existsByRestaurantTableIdAndStatus(Long tableId, TableSessionStatus status);

    @Query("SELECT ts FROM TableSession ts " +
           "LEFT JOIN FETCH ts.restaurantTable " +
           "LEFT JOIN FETCH ts.openedBy " +
           "LEFT JOIN FETCH ts.closedBy " +
           "WHERE ts.closedAt BETWEEN :start AND :end " +
           "ORDER BY ts.closedAt DESC")
    List<TableSession> findClosedBetween(
            @Param("start") LocalDateTime start,
            @Param("end") LocalDateTime end);
}
