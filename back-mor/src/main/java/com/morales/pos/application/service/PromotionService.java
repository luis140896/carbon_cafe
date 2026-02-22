package com.morales.pos.application.service;

import com.morales.pos.application.dto.request.CreatePromotionRequest;
import com.morales.pos.application.dto.request.UpdatePromotionRequest;
import com.morales.pos.domain.entity.Promotion;
import com.morales.pos.domain.enums.ScheduleType;
import com.morales.pos.domain.repository.PromotionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class PromotionService {

    private final PromotionRepository promotionRepository;

    @Transactional(readOnly = true)
    public List<Promotion> getAllPromotions() {
        return promotionRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Optional<Promotion> getPromotionById(Long id) {
        return promotionRepository.findById(id);
    }

    @Transactional(readOnly = true)
    public List<Promotion> getActivePromotions() {
        return promotionRepository.findByIsActiveTrue();
    }

    /**
     * Get active promotion for today based on schedule
     */
    @Transactional(readOnly = true)
    public Optional<Promotion> getActivePromotionForToday() {
        LocalDate today = LocalDate.now();
        DayOfWeek dayOfWeek = today.getDayOfWeek();
        String dayString = String.valueOf(dayOfWeek.getValue()); // 1=Mon, 7=Sun

        List<Promotion> promotions = promotionRepository.findActivePromotionsForToday(today, dayString);
        
        return promotions.isEmpty() ? Optional.empty() : Optional.of(promotions.get(0));
    }

    @Transactional
    public Promotion createPromotion(CreatePromotionRequest request) {
        validatePromotionDates(request.getScheduleType(), request.getStartDate(), request.getEndDate());

        Promotion promotion = Promotion.builder()
                .name(request.getName())
                .description(request.getDescription())
                .discountPercent(request.getDiscountPercent())
                .scheduleType(request.getScheduleType())
                .daysOfWeek(request.getDaysOfWeek())
                .startDate(request.getStartDate())
                .endDate(request.getEndDate())
                .isActive(request.getIsActive())
                .applyToAllProducts(request.getApplyToAllProducts())
                .priority(request.getPriority())
                .build();

        return promotionRepository.save(promotion);
    }

    @Transactional
    public Promotion updatePromotion(Long id, UpdatePromotionRequest request) {
        Promotion promotion = promotionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Promoción no encontrada"));

        if (request.getName() != null) {
            promotion.setName(request.getName());
        }
        if (request.getDescription() != null) {
            promotion.setDescription(request.getDescription());
        }
        if (request.getDiscountPercent() != null) {
            promotion.setDiscountPercent(request.getDiscountPercent());
        }
        if (request.getScheduleType() != null) {
            promotion.setScheduleType(request.getScheduleType());
        }
        if (request.getDaysOfWeek() != null) {
            promotion.setDaysOfWeek(request.getDaysOfWeek());
        }
        if (request.getStartDate() != null) {
            promotion.setStartDate(request.getStartDate());
        }
        if (request.getEndDate() != null) {
            promotion.setEndDate(request.getEndDate());
        }
        if (request.getIsActive() != null) {
            promotion.setIsActive(request.getIsActive());
        }
        if (request.getApplyToAllProducts() != null) {
            promotion.setApplyToAllProducts(request.getApplyToAllProducts());
        }
        if (request.getPriority() != null) {
            promotion.setPriority(request.getPriority());
        }

        validatePromotionDates(promotion.getScheduleType(), promotion.getStartDate(), promotion.getEndDate());

        return promotionRepository.save(promotion);
    }

    @Transactional
    public void deletePromotion(Long id) {
        Promotion promotion = promotionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Promoción no encontrada"));
        promotionRepository.delete(promotion);
    }

    @Transactional
    public Promotion togglePromotionStatus(Long id) {
        Promotion promotion = promotionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Promoción no encontrada"));
        promotion.setIsActive(!promotion.getIsActive());
        return promotionRepository.save(promotion);
    }

    private void validatePromotionDates(ScheduleType scheduleType, LocalDate startDate, LocalDate endDate) {
        if (scheduleType == ScheduleType.SPECIFIC_DATE) {
            if (startDate == null || endDate == null) {
                throw new IllegalArgumentException("Las fechas de inicio y fin son requeridas para promociones de tipo SPECIFIC_DATE");
            }
            if (endDate.isBefore(startDate)) {
                throw new IllegalArgumentException("La fecha de fin no puede ser anterior a la fecha de inicio");
            }
        }
    }
}
