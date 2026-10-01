package com.morales.pos.application.service;

import com.morales.pos.application.dto.request.RecipeItemRequest;
import com.morales.pos.application.dto.request.SaveRecipeRequest;
import com.morales.pos.application.dto.response.RecipeResponse;
import com.morales.pos.domain.entity.Product;
import com.morales.pos.domain.entity.Recipe;
import com.morales.pos.domain.entity.RecipeItem;
import com.morales.pos.domain.enums.ProductType;
import com.morales.pos.domain.repository.ProductRepository;
import com.morales.pos.domain.repository.RecipeRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class RecipeService {

    private final RecipeRepository recipeRepository;
    private final ProductRepository productRepository;

    @Transactional(readOnly = true)
    public List<RecipeResponse> findAll() {
        return recipeRepository.findAllWithProduct().stream()
                .sorted(Comparator.comparing(r -> r.getProduct().getName(),
                        String.CASE_INSENSITIVE_ORDER))
                .map(RecipeResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public RecipeResponse findByProductId(Long productId) {
        return recipeRepository.findByProductIdWithItems(productId)
                .map(RecipeResponse::fromEntity)
                .orElseThrow(() -> new EntityNotFoundException("Receta no encontrada para el producto: " + productId));
    }

    @Transactional
    public RecipeResponse save(SaveRecipeRequest request) {
        Product product = productRepository.findById(request.getProductId())
                .orElseThrow(() -> new EntityNotFoundException("Producto no encontrado: " + request.getProductId()));

        if (product.getProductType() != ProductType.PREPARADO) {
            product.setProductType(ProductType.PREPARADO);
        }

        Recipe recipe = recipeRepository.findByProductId(product.getId()).orElse(null);
        if (recipe == null) {
            recipe = Recipe.builder()
                    .product(product)
                    .yieldQty(request.getYieldQty())
                    .isActive(true)
                    .items(new ArrayList<>())
                    .build();
        } else {
            recipe.setYieldQty(request.getYieldQty());
            recipe.setIsActive(true);
            recipe.getItems().clear();
            // Flush para que los DELETE de huérfanos se ejecuten antes de los INSERT,
            // evitando violar uq_recipe_ingredient con el mismo (recipe_id, ingredient)
            recipeRepository.flush();
        }

        Set<Long> seenIngredients = new HashSet<>();
        for (RecipeItemRequest itemReq : request.getItems()) {
            if (itemReq.getIngredientProductId().equals(product.getId())) {
                throw new IllegalArgumentException("Un producto no puede ser ingrediente de si mismo");
            }
            if (!seenIngredients.add(itemReq.getIngredientProductId())) {
                throw new IllegalArgumentException("Ingrediente duplicado en la receta: " + itemReq.getIngredientProductId());
            }
            Product ingredient = productRepository.findById(itemReq.getIngredientProductId())
                    .orElseThrow(() -> new EntityNotFoundException("Ingrediente no encontrado: " + itemReq.getIngredientProductId()));

            RecipeItem item = RecipeItem.builder()
                    .recipe(recipe)
                    .ingredient(ingredient)
                    .quantity(itemReq.getQuantity())
                    .wastePercent(itemReq.getWastePercent() != null ? itemReq.getWastePercent() : java.math.BigDecimal.ZERO)
                    .sortOrder(itemReq.getSortOrder() != null ? itemReq.getSortOrder() : 0)
                    .build();
            recipe.getItems().add(item);
        }

        recipe.getItems().sort(Comparator.comparing(RecipeItem::getSortOrder,
                Comparator.nullsFirst(Integer::compareTo)));

        Recipe saved = recipeRepository.save(recipe);
        return RecipeResponse.fromEntity(saved);
    }

    @Transactional
    public void deleteByProductId(Long productId) {
        Recipe recipe = recipeRepository.findByProductId(productId)
                .orElseThrow(() -> new EntityNotFoundException("Receta no encontrada para el producto: " + productId));
        recipe.setIsActive(false);
        recipeRepository.save(recipe);
    }
}
