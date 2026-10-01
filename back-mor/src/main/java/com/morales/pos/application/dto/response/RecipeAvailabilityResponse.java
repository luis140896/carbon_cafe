package com.morales.pos.application.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * Disponibilidad calculada de un producto preparado segun el stock
 * de sus ingredientes (o de su propio stock si no tiene receta activa).
 *
 * producibleQty = min(stock_insumo / consumo_por_lote) * yieldQty
 *   - null  -> sin datos de stock (ningun ingrediente controla inventario)
 *   - 0     -> agotado (al menos un ingrediente sin stock)
 *
 * source:
 *   - "RECIPE"        -> calculado a partir de los ingredientes
 *   - "PRODUCT_STOCK" -> receta inactiva/sin items: el POS descuenta el stock
 *                      propio del producto (mismo fallback que StockDeductionService)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RecipeAvailabilityResponse {

    private Long recipeId;
    private Long productId;
    private String productName;
    private String productUnit;
    private BigDecimal yieldQty;
    private Boolean isActive;
    private BigDecimal producibleQty;
    private String limitingIngredient;
    private String source;
}
