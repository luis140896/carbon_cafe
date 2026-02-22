package com.morales.pos.application.dto.request;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateTableRequest {

    @NotNull(message = "El número de mesa es requerido")
    @Min(value = 1, message = "El número de mesa debe ser mayor a 0")
    private Integer tableNumber;

    private String name;

    @Min(value = 1, message = "La capacidad debe ser al menos 1")
    @Builder.Default
    private Integer capacity = 4;

    private String zone;

    private Integer displayOrder;
}
