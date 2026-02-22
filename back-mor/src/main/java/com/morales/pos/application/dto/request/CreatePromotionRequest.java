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
public class CreatePromotionRequest {

    @NotBlank(message = "El nombre es requerido")
    @Size(max = 100, message = "El nombre no puede exceder 100 caracteres")
    private String name;

    @Size(max = 500, message = "La descripción no puede exceder 500 caracteres")
    private String description;

    @NotNull(message = "El porcentaje de descuento es requerido")
    @DecimalMin(value = "0.01", message = "El descuento debe ser mayor a 0")
    @DecimalMax(value = "100.00", message = "El descuento no puede exceder 100%")
    private BigDecimal discountPercent;

    @NotNull(message = "El tipo de programación es requerido")
    private ScheduleType scheduleType;

    private String daysOfWeek; // JSON array for WEEKLY type

    private LocalDate startDate; // Required for SPECIFIC_DATE

    private LocalDate endDate; // Required for SPECIFIC_DATE

    @Builder.Default
    private Boolean isActive = true;

    @Builder.Default
    private Boolean applyToAllProducts = true;

    @Min(value = 0, message = "La prioridad no puede ser negativa")
    @Builder.Default
    private Integer priority = 0;
}
