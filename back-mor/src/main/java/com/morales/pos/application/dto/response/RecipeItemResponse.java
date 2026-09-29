package com.morales.pos.application.dto.response;

import com.morales.pos.domain.entity.RecipeItem;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RecipeItemResponse {

    private Long id;
    private Long ingredientProductId;
    private String ingredientProductName;
    private String ingredientUnit;
    private BigDecimal quantity;
    private BigDecimal wastePercent;
    private Integer sortOrder;

    public static RecipeItemResponse fromEntity(RecipeItem item) {
        return RecipeItemResponse.builder()
                .id(item.getId())
                .ingredientProductId(item.getIngredient().getId())
                .ingredientProductName(item.getIngredient().getName())
                .ingredientUnit(item.getIngredient().getUnit())
                .quantity(item.getQuantity())
                .wastePercent(item.getWastePercent())
                .sortOrder(item.getSortOrder())
                .build();
    }
}
