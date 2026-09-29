package com.morales.pos.application.dto.response;

import com.morales.pos.domain.entity.Recipe;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RecipeResponse {

    private Long id;
    private Long productId;
    private String productName;
    private BigDecimal yieldQty;
    private Boolean isActive;
    private List<RecipeItemResponse> items;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static RecipeResponse fromEntity(Recipe recipe) {
        return RecipeResponse.builder()
                .id(recipe.getId())
                .productId(recipe.getProduct().getId())
                .productName(recipe.getProduct().getName())
                .yieldQty(recipe.getYieldQty())
                .isActive(recipe.getIsActive())
                .items(recipe.getItems() != null
                        ? recipe.getItems().stream().map(RecipeItemResponse::fromEntity).collect(Collectors.toList())
                        : List.of())
                .createdAt(recipe.getCreatedAt())
                .updatedAt(recipe.getUpdatedAt())
                .build();
    }
}
