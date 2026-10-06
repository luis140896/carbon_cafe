package com.morales.pos.application.service;

import com.morales.pos.application.dto.response.InventoryResponse;
import com.morales.pos.domain.entity.Inventory;
import com.morales.pos.domain.entity.InventoryMovement;
import com.morales.pos.domain.entity.User;
import com.morales.pos.domain.enums.MovementType;
import com.morales.pos.domain.repository.InventoryMovementRepository;
import com.morales.pos.domain.repository.InventoryRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class InventoryService {

    private final InventoryRepository inventoryRepository;
    private final InventoryMovementRepository movementRepository;
    private final NotificationService notificationService;

    @Transactional(readOnly = true)
    public List<InventoryResponse> findAll() {
        return inventoryRepository.findAllWithProduct().stream()
                .map(InventoryResponse::fromEntity)
                .toList();
    }

    @Transactional(readOnly = true)
    public InventoryResponse findByProductId(Long productId) {
        Inventory inventory = inventoryRepository.findByProductIdWithProduct(productId)
                .orElseThrow(() -> new RuntimeException("Inventario no encontrado para producto ID: " + productId));
        return InventoryResponse.fromEntity(inventory);
    }

    @Transactional(readOnly = true)
    public Inventory findEntityByProductId(Long productId) {
        return inventoryRepository.findByProductId(productId)
                .orElseThrow(() -> new RuntimeException("Inventario no encontrado para producto ID: " + productId));
    }

    @Transactional(readOnly = true)
    public List<InventoryResponse> findLowStock() {
        return inventoryRepository.findLowStockProducts().stream()
                .map(InventoryResponse::fromEntity)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<InventoryResponse> findOutOfStock() {
        return inventoryRepository.findOutOfStockProducts().stream()
                .map(InventoryResponse::fromEntity)
                .toList();
    }

    @Transactional
    public InventoryResponse addStock(Long productId, BigDecimal quantity, String reason, User user) {
        // Atomic increase
        int affected = inventoryRepository.increaseStock(productId, quantity);
        if (affected == 0) {
            throw new RuntimeException("No existe control de inventario para el producto ID: " + productId);
        }
        return recordMovement(productId, quantity, MovementType.ENTRADA, reason, user);
    }

    @Transactional
    public InventoryResponse removeStock(Long productId, BigDecimal quantity, String reason, User user) {
        // Atomic decrease with guard against negative stock
        int affected = inventoryRepository.decreaseStock(productId, quantity);
        if (affected == 0) {
            Inventory inventory = inventoryRepository.findByProductId(productId).orElse(null);
            if (inventory == null) {
                throw new RuntimeException("No existe control de inventario para el producto ID: " + productId);
            }
            throw new RuntimeException("Stock insuficiente. Disponible: " + inventory.getQuantity());
        }
        return recordMovement(productId, quantity.negate(), MovementType.SALIDA, reason, user);
    }

    @Transactional
    public InventoryResponse adjustStock(Long productId, BigDecimal quantity, MovementType type, String reason, User user) {
        if (quantity == null || quantity.compareTo(BigDecimal.ZERO) == 0) {
            throw new IllegalArgumentException("La cantidad no puede ser nula ni cero");
        }
        if (quantity.stripTrailingZeros().scale() > 3) {
            throw new IllegalArgumentException("La cantidad admite máximo 3 decimales");
        }

        Inventory inventory = findEntityByProductId(productId);
        BigDecimal previousQuantity = inventory.getQuantity();
        BigDecimal newQuantity = previousQuantity.add(quantity);

        if (newQuantity.compareTo(BigDecimal.ZERO) < 0) {
            throw new RuntimeException("El stock no puede ser negativo");
        }

        // Use atomic update to avoid read-modify-write races
        int affected = type == MovementType.ENTRADA
                ? inventoryRepository.increaseStock(productId, quantity)
                : inventoryRepository.decreaseStock(productId, quantity.abs());
        if (affected == 0) {
            throw new RuntimeException("No se pudo actualizar el stock; puede que el producto no controle inventario.");
        }

        return recordMovement(productId, quantity, type, reason, user);
    }

    private InventoryResponse recordMovement(Long productId, BigDecimal quantity, MovementType type, String reason, User user) {
        Inventory inventory = findEntityByProductId(productId);
        BigDecimal previousQuantity = inventory.getQuantity().subtract(quantity);
        BigDecimal newQuantity = inventory.getQuantity();

        if (type == MovementType.ENTRADA) {
            inventory.setLastRestockDate(LocalDateTime.now());
        }
        inventory.setUpdatedAt(LocalDateTime.now());
        inventoryRepository.save(inventory);

        InventoryMovement movement = InventoryMovement.builder()
                .product(inventory.getProduct())
                .movementType(type)
                .quantity(quantity.abs())
                .previousQuantity(previousQuantity)
                .newQuantity(newQuantity)
                .reason(reason)
                .user(user)
                .build();
        movementRepository.save(movement);

        log.info("Stock ajustado para producto {}: {} -> {} ({})",
                productId, previousQuantity, newQuantity, type);

        try {
            String productName = inventory.getProduct().getName();
            int currentQty = newQuantity.intValue();
            int minQty = inventory.getMinStock().intValue();
            if (currentQty == 0) {
                notificationService.notifyOutOfStock(productName, productId);
            } else if (currentQty <= minQty) {
                notificationService.notifyLowStock(productName, productId, currentQty, minQty);
            }
        } catch (Exception e) {
            log.warn("Error al crear notificación de stock: {}", e.getMessage());
        }

        return InventoryResponse.fromEntity(inventory);
    }

    @Transactional
    public InventoryResponse updateStockLimits(Long productId, BigDecimal minStock, BigDecimal maxStock, String location) {
        Inventory inventory = findEntityByProductId(productId);
        inventory.setMinStock(minStock);
        inventory.setMaxStock(maxStock);
        if (location != null) {
            inventory.setLocation(location.isBlank() ? null : location);
        }
        log.info("Límites de stock actualizados para producto ID: {}", productId);
        return InventoryResponse.fromEntity(inventoryRepository.save(inventory));
    }

    @Transactional(readOnly = true)
    public List<InventoryMovement> getMovementsByProduct(Long productId) {
        return movementRepository.findByProductIdOrderByCreatedAtDesc(productId);
    }

    @Transactional(readOnly = true)
    public List<InventoryMovement> getMovementsByDateRange(LocalDateTime start, LocalDateTime end) {
        return movementRepository.findByCreatedAtBetweenOrderByCreatedAtDesc(start, end);
    }
}
