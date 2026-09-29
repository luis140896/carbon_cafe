package com.morales.pos.application.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SaveRecipeRequest {

    @NotNull(message = "El producto preparado es requerido")
    private Long productId;

    @NotNull(message = "El rendimiento es requerido")
    @DecimalMin(value = "0.0001", message = "El rendimiento debe ser mayor a 0")
    @Digits(integer = 12, fraction = 2, message = "Rendimiento inválido")
    private BigDecimal yieldQty;

    @NotEmpty(message = "La receta debe tener al menos un ingrediente")
    @Valid
    private List<RecipeItemRequest> items;
}
