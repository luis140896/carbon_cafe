package com.morales.pos.application.dto.request;

import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UpdateProductRequest {

    @Size(max = 50, message = "El código no puede exceder 50 caracteres")
    private String code;

    @Size(max = 50, message = "El código de barras no puede exceder 50 caracteres")
    private String barcode;

    @Size(max = 200, message = "El nombre no puede exceder 200 caracteres")
    private String name;

    @Size(max = 1000, message = "La descripción no puede exceder 1000 caracteres")
    private String description;

    private Long categoryId;

    private String imageUrl;

    @DecimalMin(value = "0.0", inclusive = true, message = "El precio de costo no puede ser negativo")
    @Digits(integer = 10, fraction = 2, message = "Formato de precio inválido")
    private BigDecimal costPrice;

    @DecimalMin(value = "0.01", inclusive = true, message = "El precio de venta debe ser mayor a 0")
    @Digits(integer = 10, fraction = 2, message = "Formato de precio inválido")
    private BigDecimal salePrice;

    @Size(max = 20, message = "La unidad no puede exceder 20 caracteres")
    private String unit;

    @DecimalMin(value = "0.0", inclusive = true, message = "La tasa de impuesto no puede ser negativa")
    @DecimalMax(value = "100.0", inclusive = true, message = "La tasa de impuesto no puede exceder 100%")
    private BigDecimal taxRate;

    private Boolean isActive;
}
