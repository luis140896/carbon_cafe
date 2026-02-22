package com.morales.pos.application.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.DecimalMin;
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
public class AddTableItemsRequest {

    @NotEmpty(message = "Debe incluir al menos un producto")
    @Valid
    private List<TableItemRequest> items;

    @Builder.Default
    private Boolean priority = false;

    private String priorityReason;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class TableItemRequest {

        @NotNull(message = "El ID del producto es requerido")
        private Long productId;

        @NotNull(message = "La cantidad es requerida")
        @DecimalMin(value = "0.01", inclusive = true, message = "La cantidad debe ser mayor a 0")
        private BigDecimal quantity;

        @NotNull(message = "El precio unitario es requerido")
        @DecimalMin(value = "0.0", inclusive = true, message = "El precio no puede ser negativo")
        private BigDecimal unitPrice;

        @DecimalMin(value = "0.0", inclusive = true, message = "El descuento no puede ser negativo")
        @Builder.Default
        private BigDecimal discountAmount = BigDecimal.ZERO;

        private String notes;
    }
}
