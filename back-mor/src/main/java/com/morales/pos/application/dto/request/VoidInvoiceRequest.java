package com.morales.pos.application.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VoidInvoiceRequest {

    @NotBlank(message = "El motivo de anulación es requerido")
    @Size(max = 500, message = "El motivo no puede exceder 500 caracteres")
    private String reason;
}
