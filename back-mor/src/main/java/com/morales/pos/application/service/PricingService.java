package com.morales.pos.application.service;

import com.morales.pos.domain.entity.Product;
import com.morales.pos.domain.entity.Promotion;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class PricingService {

    private final PromotionService promotionService;

    /**
     * Resuelve el precio de venta final de un producto aplicando la promoción activa del día
     * cuando corresponde. Si no hay promoción activa o no aplica al producto, retorna el
     * precio de catálogo.
     *
     * Nota: actualmente las promociones del modelo aplican a todos los productos
     * (applyToAllProducts). En el futuro se puede extender a productos/categorías específicas.
     */
    @Transactional(readOnly = true)
    public BigDecimal resolveSalePrice(Product product) {
        Optional<Promotion> promotionOpt = promotionService.getActivePromotionForToday();
        if (promotionOpt.isEmpty()) {
            return product.getSalePrice();
        }

        Promotion promotion = promotionOpt.get();
        if (Boolean.FALSE.equals(promotion.getApplyToAllProducts())) {
            return product.getSalePrice();
        }

        BigDecimal discountPercent = promotion.getDiscountPercent();
        if (discountPercent == null || discountPercent.compareTo(BigDecimal.ZERO) <= 0) {
            return product.getSalePrice();
        }

        BigDecimal discountMultiplier = BigDecimal.ONE.subtract(
                discountPercent.divide(BigDecimal.valueOf(100), 4, RoundingMode.HALF_UP));

        return product.getSalePrice()
                .multiply(discountMultiplier)
                .setScale(2, RoundingMode.HALF_UP);
    }
}
