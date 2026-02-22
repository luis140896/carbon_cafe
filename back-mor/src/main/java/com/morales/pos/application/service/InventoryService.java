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
        return adjustStock(productId, quantity, MovementType.ENTRADA, reason, user);
    }

    @Transactional
    public InventoryResponse removeStock(Long productId, BigDecimal quantity, String reason, User user) {
        Inventory inventory = findEntityByProductId(productId);
        if (inventory.getQuantity().compareTo(quantity) < 0) {
            throw new RuntimeException("Stock insuficiente. Disponible: " + inventory.getQuantity());
        }
        return adjustStock(productId, quantity.negate(), MovementType.SALIDA, reason, user);
    }

    @Transactional
    public InventoryResponse adjustStock(Long productId, BigDecimal quantity, MovementType type, String reason, User user) {
        Inventory inventory = findEntityByProductId(productId);
        BigDecimal previousQuantity = inventory.getQuantity();
        BigDecimal newQuantity = previousQuantity.add(quantity);
        
        if (newQuantity.compareTo(BigDecimal.ZERO) < 0) {
            throw new RuntimeException("El stock no puede ser negativo");
        }
        
        inventory.setQuantity(newQuantity);
        inventory.setUpdatedAt(LocalDateTime.now());
        
        if (type == MovementType.ENTRADA) {
            inventory.setLastRestockDate(LocalDateTime.now());
        }
        
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
        Inventory savedInventory = inventoryRepository.save(inventory);
        
        log.info("Stock ajustado para producto {}: {} -> {} ({})", 
                productId, previousQuantity, newQuantity, type);

        // Check stock alerts
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

        return InventoryResponse.fromEntity(savedInventory);
    }

    @Transactional
    public InventoryResponse updateStockLimits(Long productId, BigDecimal minStock, BigDecimal maxStock, String location) {
        Inventory inventory = findEntityByProductId(productId);
        inventory.setMinStock(minStock);
        inventory.setMaxStock(maxStock);
        inventory.setLocation(location);
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
