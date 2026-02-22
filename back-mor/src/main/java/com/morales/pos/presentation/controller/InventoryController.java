package com.morales.pos.presentation.controller;

import com.morales.pos.application.dto.response.ApiResponse;
import com.morales.pos.application.dto.response.InventoryResponse;
import com.morales.pos.application.service.InventoryService;
import com.morales.pos.domain.entity.InventoryMovement;
import com.morales.pos.domain.entity.User;
import com.morales.pos.domain.repository.UserRepository;
import com.morales.pos.infrastructure.security.jwt.CustomUserDetails;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/inventory")
@RequiredArgsConstructor
public class InventoryController {

    private final InventoryService inventoryService;
    private final UserRepository userRepository;

    @GetMapping
    public ResponseEntity<ApiResponse<List<InventoryResponse>>> findAll() {
        return ResponseEntity.ok(ApiResponse.success(inventoryService.findAll()));
    }

    @GetMapping("/product/{productId}")
    public ResponseEntity<ApiResponse<InventoryResponse>> findByProductId(@PathVariable Long productId) {
        return ResponseEntity.ok(ApiResponse.success(inventoryService.findByProductId(productId)));
    }

    @GetMapping("/low-stock")
    public ResponseEntity<ApiResponse<List<InventoryResponse>>> findLowStock() {
        return ResponseEntity.ok(ApiResponse.success(inventoryService.findLowStock()));
    }

    @GetMapping("/out-of-stock")
    public ResponseEntity<ApiResponse<List<InventoryResponse>>> findOutOfStock() {
        return ResponseEntity.ok(ApiResponse.success(inventoryService.findOutOfStock()));
    }

    @PostMapping("/product/{productId}/add")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPERVISOR', 'INVENTARIO')")
    public ResponseEntity<ApiResponse<InventoryResponse>> addStock(
            @PathVariable Long productId,
            @RequestParam BigDecimal quantity,
            @RequestParam(required = false) String reason,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        User user = userRepository.findById(userDetails.getId())
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
        InventoryResponse inventory = inventoryService.addStock(productId, quantity, reason, user);
        return ResponseEntity.ok(ApiResponse.success(inventory, "Stock agregado exitosamente"));
    }

    @PostMapping("/product/{productId}/remove")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPERVISOR', 'INVENTARIO')")
    public ResponseEntity<ApiResponse<InventoryResponse>> removeStock(
            @PathVariable Long productId,
            @RequestParam BigDecimal quantity,
            @RequestParam(required = false) String reason,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        User user = userRepository.findById(userDetails.getId())
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
        InventoryResponse inventory = inventoryService.removeStock(productId, quantity, reason, user);
        return ResponseEntity.ok(ApiResponse.success(inventory, "Stock removido exitosamente"));
    }

    @PutMapping("/product/{productId}/limits")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPERVISOR', 'INVENTARIO')")
    public ResponseEntity<ApiResponse<InventoryResponse>> updateStockLimits(
            @PathVariable Long productId,
            @RequestParam BigDecimal minStock,
            @RequestParam BigDecimal maxStock,
            @RequestParam(required = false) String location) {
        InventoryResponse inventory = inventoryService.updateStockLimits(productId, minStock, maxStock, location);
        return ResponseEntity.ok(ApiResponse.success(inventory, "Límites de stock actualizados"));
    }

    @GetMapping("/movements/product/{productId}")
    public ResponseEntity<ApiResponse<List<InventoryMovement>>> getMovementsByProduct(@PathVariable Long productId) {
        return ResponseEntity.ok(ApiResponse.success(inventoryService.getMovementsByProduct(productId)));
    }

    @GetMapping("/movements")
    public ResponseEntity<ApiResponse<List<InventoryMovement>>> getMovementsByDateRange(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime end) {
        return ResponseEntity.ok(ApiResponse.success(inventoryService.getMovementsByDateRange(start, end)));
    }
}
