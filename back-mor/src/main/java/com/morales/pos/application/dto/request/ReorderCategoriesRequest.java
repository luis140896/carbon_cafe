package com.morales.pos.application.dto.request;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReorderCategoriesRequest {

    @NotEmpty(message = "La lista de categorías no puede estar vacía")
    private List<@NotNull(message = "El id de la categoría no puede ser nulo") Long> categoryIds;
}
