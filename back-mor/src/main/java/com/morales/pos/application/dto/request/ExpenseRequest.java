package com.morales.pos.application.dto.request;

import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Request único para crear y actualizar gastos.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ExpenseRequest {

    @NotNull(message = "La fecha del gasto es requerida")
    private LocalDate expenseDate;

    @NotBlank(message = "La descripción es requerida")
    @Size(max = 255, message = "La descripción no puede exceder 255 caracteres")
    private String description;

    @NotBlank(message = "La categoría es requerida")
    @Size(max = 50, message = "La categoría no puede exceder 50 caracteres")
    private String category;

    @NotNull(message = "El monto es requerido")
    @DecimalMin(value = "0.01", message = "El monto debe ser mayor a 0")
    private BigDecimal amount;

    @Size(max = 50, message = "El método de pago no puede exceder 50 caracteres")
    private String paymentMethod;

    @Size(max = 2000, message = "Las notas no pueden exceder 2000 caracteres")
    private String notes;
}
