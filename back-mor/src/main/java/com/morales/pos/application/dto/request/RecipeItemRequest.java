package com.morales.pos.application.dto.request;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RecipeItemRequest {

    private Long id;

    @NotNull(message = "El ingrediente es requerido")
    private Long ingredientProductId;

    @NotNull(message = "La cantidad es requerida")
    @DecimalMin(value = "0.0001", message = "La cantidad debe ser mayor a 0")
    @Digits(integer = 18, fraction = 6, message = "Cantidad inválida")
    private BigDecimal quantity;

    @DecimalMin(value = "0.0", message = "El porcentaje de merma no puede ser negativo")
    @Digits(integer = 5, fraction = 2, message = "Porcentaje de merma inválido")
    private BigDecimal wastePercent;

    private Integer sortOrder;
}
