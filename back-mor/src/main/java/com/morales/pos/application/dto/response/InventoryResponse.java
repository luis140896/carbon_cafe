package com.morales.pos.application.dto.response;

import com.morales.pos.domain.entity.Inventory;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class InventoryResponse {

    private Long id;
    private Long productId;
    private String productCode;
    private String productName;
    private BigDecimal quantity;
    private BigDecimal minStock;
    private BigDecimal maxStock;
    private String location;
    private LocalDateTime lastRestockDate;
    private Boolean lowStock;
    private Boolean outOfStock;
    private LocalDateTime updatedAt;

    public static InventoryResponse fromEntity(Inventory inventory) {
        InventoryResponseBuilder builder = InventoryResponse.builder()
                .id(inventory.getId())
                .quantity(inventory.getQuantity())
                .minStock(inventory.getMinStock())
                .maxStock(inventory.getMaxStock())
                .location(inventory.getLocation())
                .lastRestockDate(inventory.getLastRestockDate())
                .lowStock(inventory.isLowStock())
                .outOfStock(inventory.isOutOfStock())
                .updatedAt(inventory.getUpdatedAt());

        if (inventory.getProduct() != null) {
            builder.productId(inventory.getProduct().getId())
                   .productCode(inventory.getProduct().getCode())
                   .productName(inventory.getProduct().getName());
        }

        return builder.build();
    }
}
