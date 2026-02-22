package com.morales.pos.application.dto.response;

import com.morales.pos.domain.entity.Product;
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
public class ProductResponse {

    private Long id;
    private String code;
    private String barcode;
    private String name;
    private String description;
    private Long categoryId;
    private String categoryName;
    private String imageUrl;
    private BigDecimal costPrice;
    private BigDecimal salePrice;
    private String unit;
    private BigDecimal taxRate;
    private Boolean isActive;
    private BigDecimal profitMargin;
    
    // Inventory info
    private BigDecimal stockQuantity;
    private BigDecimal minStock;
    private BigDecimal maxStock;
    private String location;
    private Boolean lowStock;
    private Boolean outOfStock;
    
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static ProductResponse fromEntity(Product product) {
        ProductResponseBuilder builder = ProductResponse.builder()
                .id(product.getId())
                .code(product.getCode())
                .barcode(product.getBarcode())
                .name(product.getName())
                .description(product.getDescription())
                .imageUrl(product.getImageUrl())
                .costPrice(product.getCostPrice())
                .salePrice(product.getSalePrice())
                .unit(product.getUnit())
                .taxRate(product.getTaxRate())
                .isActive(product.getIsActive())
                .profitMargin(product.getProfitMargin())
                .createdAt(product.getCreatedAt())
                .updatedAt(product.getUpdatedAt());

        if (product.getCategory() != null) {
            builder.categoryId(product.getCategory().getId())
                   .categoryName(product.getCategory().getName());
        }

        if (product.getInventory() != null) {
            builder.stockQuantity(product.getInventory().getQuantity())
                   .minStock(product.getInventory().getMinStock())
                   .maxStock(product.getInventory().getMaxStock())
                   .location(product.getInventory().getLocation())
                   .lowStock(product.getInventory().isLowStock())
                   .outOfStock(product.getInventory().isOutOfStock());
        }

        return builder.build();
    }
}
