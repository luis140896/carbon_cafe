package com.morales.pos.application.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
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
public class CreateSaleRequest {

    private Long customerId;

    @NotBlank(message = "El método de pago es requerido")
    private String paymentMethod;

    @DecimalMin(value = "0.0", inclusive = true, message = "El descuento no puede ser negativo")
    @DecimalMax(value = "100.0", inclusive = true, message = "El descuento no puede exceder 100%")
    @Builder.Default
    private BigDecimal discountPercent = BigDecimal.ZERO;

    @DecimalMin(value = "0.0", inclusive = true, message = "El cargo por servicio no puede ser negativo")
    @DecimalMax(value = "100.0", inclusive = true, message = "El cargo por servicio no puede exceder 100%")
    @Builder.Default
    private BigDecimal serviceChargePercent = BigDecimal.ZERO;

    @NotNull(message = "El monto recibido es requerido")
    @DecimalMin(value = "0.0", inclusive = true, message = "El monto recibido no puede ser negativo")
    private BigDecimal amountReceived;

    @DecimalMin(value = "0.0", inclusive = true, message = "El cargo por domicilio no puede ser negativo")
    @Builder.Default
    private BigDecimal deliveryChargeAmount = BigDecimal.ZERO;

    @Size(max = 500, message = "Las notas no pueden exceder 500 caracteres")
    private String notes;

    @NotEmpty(message = "Debe incluir al menos un producto")
    @Valid
    private List<SaleDetailRequest> details;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class SaleDetailRequest {

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
