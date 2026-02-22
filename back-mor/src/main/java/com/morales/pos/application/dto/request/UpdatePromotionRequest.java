package com.morales.pos.application.dto.request;

import com.morales.pos.domain.enums.ScheduleType;
import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UpdatePromotionRequest {

    @Size(max = 100, message = "El nombre no puede exceder 100 caracteres")
    private String name;

    @Size(max = 500, message = "La descripción no puede exceder 500 caracteres")
    private String description;

    @DecimalMin(value = "0.01", message = "El descuento debe ser mayor a 0")
    @DecimalMax(value = "100.00", message = "El descuento no puede exceder 100%")
    private BigDecimal discountPercent;

    private ScheduleType scheduleType;

    private String daysOfWeek;

    private LocalDate startDate;

    private LocalDate endDate;

    private Boolean isActive;

    private Boolean applyToAllProducts;

    @Min(value = 0, message = "La prioridad no puede ser negativa")
    private Integer priority;
}
