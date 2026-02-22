package com.morales.pos.application.dto.request;

import jakarta.validation.constraints.Min;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UpdateTableRequest {

    @Min(value = 1, message = "El número de mesa debe ser mayor a 0")
    private Integer tableNumber;

    private String name;

    @Min(value = 1, message = "La capacidad debe ser al menos 1")
    private Integer capacity;

    private String zone;

    private Integer displayOrder;

    private Boolean isActive;
}
