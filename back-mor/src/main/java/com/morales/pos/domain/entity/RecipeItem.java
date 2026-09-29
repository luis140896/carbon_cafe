package com.morales.pos.domain.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;

/**
 * Linea de receta: un ingrediente y la cantidad que consume el producto preparado.
 * La cantidad se expresa en la unidad propia del ingrediente (ej. gramos, ml, unidades).
 */
@Entity
@Table(name = "recipe_items")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RecipeItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "recipe_id", nullable = false)
    private Recipe recipe;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ingredient_product_id", nullable = false)
    private Product ingredient;

    @Column(name = "quantity", precision = 18, scale = 6, nullable = false)
    private BigDecimal quantity;

    @Column(name = "waste_percent", precision = 5, scale = 2, nullable = false)
    @Builder.Default
    private BigDecimal wastePercent = BigDecimal.ZERO;

    @Column(name = "sort_order")
    @Builder.Default
    private Integer sortOrder = 0;
}
