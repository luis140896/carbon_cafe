package com.morales.pos.application.service;

import com.morales.pos.domain.entity.Inventory;
import com.morales.pos.domain.entity.Product;
import com.morales.pos.domain.entity.Recipe;
import com.morales.pos.domain.entity.RecipeItem;
import com.morales.pos.domain.entity.User;
import com.morales.pos.domain.enums.ProductType;
import com.morales.pos.domain.repository.InventoryRepository;
import com.morales.pos.domain.repository.ProductRepository;
import com.morales.pos.domain.repository.RecipeRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Resuelve el descuento de inventario al vender.
 *
 * Reglas:
 *  - Producto DIRECTO / INSUMO  -> descuenta su propio stock 1:1.
 *  - Producto PREPARADO con receta activa -> descuenta cada ingrediente segun la receta:
 *        consumo = cantidad_receta * (1 + merma%) / rendimiento * cantidad_vendida
 *  - Producto PREPARADO sin receta -> fallback: se comporta como DIRECTO (descuenta su propio stock).
 *
 * El consumo se agrega por producto/ingrediente para generar un unico movimiento por venta.
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class StockDeductionService {

    private final ProductRepository productRepository;
    private final RecipeRepository recipeRepository;
    private final InventoryRepository inventoryRepository;
    private final InventoryService inventoryService;

    /** Linea de venta minima requerida para calcular el consumo. */
    public record SaleLine(Long productId, BigDecimal quantity) {}

    /**
     * Calcula la cantidad total requerida por producto/ingrediente expandiendo recetas.
     * @return mapa productId(o ingredientId) -> cantidad requerida
     */
    @Transactional(readOnly = true)
    public Map<Long, BigDecimal> computeRequired(List<SaleLine> lines) {
        Map<Long, BigDecimal> required = new LinkedHashMap<>();

        for (SaleLine line : lines) {
            Product product = productRepository.findById(line.productId())
                    .orElseThrow(() -> new EntityNotFoundException("Producto no encontrado: " + line.productId()));

            if (product.getProductType() == ProductType.PREPARADO) {
                Recipe recipe = recipeRepository.findByProductIdWithItems(product.getId()).orElse(null);
                if (recipe != null && Boolean.TRUE.equals(recipe.getIsActive())
                        && recipe.getItems() != null && !recipe.getItems().isEmpty()) {

                    BigDecimal yield = recipe.getYieldQty() != null
                            && recipe.getYieldQty().compareTo(BigDecimal.ZERO) > 0
                            ? recipe.getYieldQty() : BigDecimal.ONE;

                    for (RecipeItem item : recipe.getItems()) {
                        BigDecimal wasteFactor = BigDecimal.ONE.add(
                                (item.getWastePercent() != null ? item.getWastePercent() : BigDecimal.ZERO)
                                        .divide(BigDecimal.valueOf(100)));
                        BigDecimal consumption = item.getQuantity()
                                .multiply(wasteFactor)
                                .multiply(line.quantity())
                                .divide(yield, 6, RoundingMode.HALF_UP);
                        required.merge(item.getIngredient().getId(), consumption, BigDecimal::add);
                    }
                    continue; // ingredientes ya contabilizados
                }
                log.warn("Producto PREPARADO id={} sin receta activa; se descuenta su propio stock (fallback)",
                        product.getId());
            }

            // DIRECTO / INSUMO / PREPARADO sin receta
            required.merge(product.getId(), line.quantity(), BigDecimal::add);
        }

        return required;
    }

    /**
     * Verifica que haya stock suficiente para todo el mapa de requeridos.
     * Productos sin registro de inventario se ignoran (no controlan stock).
     * @throws IllegalArgumentException si algun item no tiene stock suficiente.
     */
    @Transactional(readOnly = true)
    public void validate(Map<Long, BigDecimal> required) {
        for (Map.Entry<Long, BigDecimal> entry : required.entrySet()) {
            Inventory inventory = inventoryRepository.findByProductId(entry.getKey()).orElse(null);
            if (inventory == null) {
                continue; // producto que no controla inventario
            }
            if (inventory.getQuantity().compareTo(entry.getValue()) < 0) {
                Product product = productRepository.findById(entry.getKey())
                        .orElseThrow(() -> new EntityNotFoundException("Producto no encontrado"));
                throw new IllegalArgumentException(String.format(
                        "Stock insuficiente para %s. Disponible: %s, Requerido: %s",
                        product.getName(), inventory.getQuantity(), entry.getValue()));
            }
        }
    }

    /** Descuenta el mapa de requeridos generando movimientos de inventario. */
    @Transactional
    public void deduct(Map<Long, BigDecimal> required, String reason, User user) {
        for (Map.Entry<Long, BigDecimal> entry : required.entrySet()) {
            if (entry.getValue().compareTo(BigDecimal.ZERO) <= 0) continue;
            if (inventoryRepository.findByProductId(entry.getKey()).isPresent()) {
                inventoryService.removeStock(entry.getKey(), entry.getValue(), reason, user);
            }
        }
    }

    /** Restaura (reintegra) stock por venta anulada / item eliminado de mesa. */
    @Transactional
    public void restore(List<SaleLine> lines, String reason, User user) {
        Map<Long, BigDecimal> required = computeRequired(lines);
        for (Map.Entry<Long, BigDecimal> entry : required.entrySet()) {
            if (entry.getValue().compareTo(BigDecimal.ZERO) <= 0) continue;
            if (inventoryRepository.findByProductId(entry.getKey()).isPresent()) {
                inventoryService.addStock(entry.getKey(), entry.getValue(), reason, user);
            }
        }
    }

    /** Atajo: valida y descuenta para un conjunto de lineas de venta. */
    @Transactional
    public void validateAndDeduct(List<SaleLine> lines, String reason, User user) {
        Map<Long, BigDecimal> required = computeRequired(lines);
        validate(required);
        deduct(required, reason, user);
    }
}
