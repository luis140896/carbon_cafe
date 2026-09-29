package com.morales.pos.domain.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Cabecera de receta (Bill of Materials) asociada a un producto PREPARADO.
 * Define cuantas porciones rinde (yieldQty) y sus ingredientes (items).
 */
@Entity
@Table(name = "recipes")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Recipe {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", unique = true, nullable = false)
    private Product product;

    @Column(name = "yield_qty", precision = 12, scale = 2, nullable = false)
    @Builder.Default
    private BigDecimal yieldQty = BigDecimal.ONE;

    @Column(name = "is_active", nullable = false)
    @Builder.Default
    private Boolean isActive = true;

    @OneToMany(mappedBy = "recipe", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @Builder.Default
    private List<RecipeItem> items = new ArrayList<>();

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    public void prePersist() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}
