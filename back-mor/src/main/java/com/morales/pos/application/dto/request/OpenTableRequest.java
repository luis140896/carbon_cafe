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
public class OpenTableRequest {

    @Min(value = 1, message = "El número de comensales debe ser al menos 1")
    @Builder.Default
    private Integer guestCount = 1;

    private Long customerId;

    private String notes;
}
