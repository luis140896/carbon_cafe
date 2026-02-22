package com.morales.pos.application.dto.response;

import com.morales.pos.domain.entity.Promotion;
import com.morales.pos.domain.enums.ScheduleType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PromotionResponse {

    private Long id;
    private String name;
    private String description;
    private BigDecimal discountPercent;
    private ScheduleType scheduleType;
    private String daysOfWeek;
    private LocalDate startDate;
    private LocalDate endDate;
    private Boolean isActive;
    private Boolean applyToAllProducts;
    private Integer priority;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static PromotionResponse fromEntity(Promotion promotion) {
        return PromotionResponse.builder()
                .id(promotion.getId())
                .name(promotion.getName())
                .description(promotion.getDescription())
                .discountPercent(promotion.getDiscountPercent())
                .scheduleType(promotion.getScheduleType())
                .daysOfWeek(promotion.getDaysOfWeek())
                .startDate(promotion.getStartDate())
                .endDate(promotion.getEndDate())
                .isActive(promotion.getIsActive())
                .applyToAllProducts(promotion.getApplyToAllProducts())
                .priority(promotion.getPriority())
                .createdAt(promotion.getCreatedAt())
                .updatedAt(promotion.getUpdatedAt())
                .build();
    }
}
