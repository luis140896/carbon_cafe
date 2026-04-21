package com.morales.pos.application.dto.request;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PayTableRequest {

    @NotBlank(message = "El método de pago es requerido")
    private String paymentMethod;

    @NotNull(message = "El monto recibido es requerido")
    @DecimalMin(value = "0.0", inclusive = true, message = "El monto recibido no puede ser negativo")
    private BigDecimal amountReceived;

    @DecimalMin(value = "0.0", inclusive = true, message = "El descuento no puede ser negativo")
    private BigDecimal discountPercent = BigDecimal.ZERO;

    @DecimalMin(value = "0.0", inclusive = true, message = "El cargo por servicio no puede ser negativo")
    private BigDecimal serviceChargePercent = BigDecimal.ZERO;

    @DecimalMin(value = "0.0", inclusive = true, message = "El cargo por servicio no puede ser negativo")
    private BigDecimal serviceChargeAmount = BigDecimal.ZERO;

    @DecimalMin(value = "0.0", inclusive = true, message = "El cargo por domicilio no puede ser negativo")
    private BigDecimal deliveryChargeAmount = BigDecimal.ZERO;

    @DecimalMin(value = "0.0", inclusive = true, message = "El monto en efectivo no puede ser negativo")
    private BigDecimal cashAmount = BigDecimal.ZERO;

    @DecimalMin(value = "0.0", inclusive = true, message = "El monto en transferencia no puede ser negativo")
    private BigDecimal transferAmount = BigDecimal.ZERO;

    private String notes;
}
