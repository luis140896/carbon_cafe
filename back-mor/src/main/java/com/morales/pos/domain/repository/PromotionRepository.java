package com.morales.pos.domain.repository;

import com.morales.pos.domain.entity.Promotion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface PromotionRepository extends JpaRepository<Promotion, Long> {

    List<Promotion> findByIsActiveTrue();

    @Query("SELECT p FROM Promotion p WHERE p.isActive = true " +
           "AND (p.scheduleType = 'DAILY' " +
           "OR (p.scheduleType = 'WEEKLY' AND p.daysOfWeek LIKE CONCAT('%', :dayOfWeek, '%')) " +
           "OR (p.scheduleType = 'SPECIFIC_DATE' AND :today BETWEEN p.startDate AND p.endDate)) " +
           "ORDER BY p.priority DESC")
    List<Promotion> findActivePromotionsForToday(@Param("today") LocalDate today, @Param("dayOfWeek") String dayOfWeek);

    Optional<Promotion> findFirstByIsActiveTrueOrderByPriorityDesc();
}
