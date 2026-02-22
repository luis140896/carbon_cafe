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
public class CreateCustomerRequest {

    @Size(max = 10, message = "El tipo de documento no puede exceder 10 caracteres")
    @Builder.Default
    private String documentType = "CC";

    @Size(max = 20, message = "El número de documento no puede exceder 20 caracteres")
    private String documentNumber;

    @NotBlank(message = "El nombre completo es requerido")
    @Size(max = 200, message = "El nombre no puede exceder 200 caracteres")
    private String fullName;

    @Email(message = "El email debe tener un formato válido")
    @Size(max = 100, message = "El email no puede exceder 100 caracteres")
    private String email;

    @Size(max = 50, message = "El teléfono no puede exceder 50 caracteres")
    private String phone;

    @Size(max = 500, message = "La dirección no puede exceder 500 caracteres")
    private String address;

    @Size(max = 100, message = "La ciudad no puede exceder 100 caracteres")
    private String city;

    @Size(max = 1000, message = "Las notas no pueden exceder 1000 caracteres")
    private String notes;

    @DecimalMin(value = "0.0", inclusive = true, message = "El límite de crédito no puede ser negativo")
    @Digits(integer = 10, fraction = 2, message = "Formato de monto inválido")
    @Builder.Default
    private BigDecimal creditLimit = BigDecimal.ZERO;

    @Builder.Default
    private Boolean isActive = true;
}
