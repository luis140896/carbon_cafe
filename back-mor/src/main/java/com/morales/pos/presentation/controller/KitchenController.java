package com.morales.pos.presentation.controller;

import com.morales.pos.application.service.KitchenOrderService;
import com.morales.pos.application.service.KitchenService;
import com.morales.pos.domain.enums.KitchenStatus;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/kitchen")
@RequiredArgsConstructor
@PreAuthorize("hasAnyRole('ADMIN', 'SUPERVISOR', 'COCINERO', 'CAJERO')")
public class KitchenController {

    private final KitchenService kitchenService;
    private final KitchenOrderService kitchenOrderService;

    /**
     * Get active orders grouped by table (NEW SYSTEM)
     */
    @GetMapping("/orders/grouped")
    public ResponseEntity<?> getActiveOrdersGrouped() {
        return ResponseEntity.ok(kitchenOrderService.getActiveOrdersGrouped());
    }

    /**
     * Update order status (NEW SYSTEM)
     */
    @PutMapping("/orders/{orderId}/status")
    public ResponseEntity<?> updateOrderStatus(
            @PathVariable Long orderId,
            @RequestBody Map<String, String> request) {
        String statusStr = request.get("status");
        KitchenStatus status = KitchenStatus.valueOf(statusStr);
        return ResponseEntity.ok(kitchenOrderService.updateOrderStatus(orderId, status));
    }

    /**
     * Mark order as urgent (NEW SYSTEM)
     */
    @PostMapping("/orders/{orderId}/urgent")
    public ResponseEntity<?> markOrderAsUrgent(
            @PathVariable Long orderId,
            @RequestBody Map<String, String> request) {
        String reason = request.get("reason");
        return ResponseEntity.ok(kitchenOrderService.markAsUrgent(orderId, reason));
    }

    /**
     * LEGACY: Get pending orders (OLD SYSTEM - keeping for backwards compatibility)
     */
    @GetMapping("/orders")
    public ResponseEntity<?> getPendingOrders() {
        return ResponseEntity.ok(kitchenService.getPendingOrders());
    }

    /**
     * LEGACY: Update item status (OLD SYSTEM - keeping for backwards compatibility)
     */
    @PutMapping("/orders/items/{detailId}/status")
    public ResponseEntity<?> updateItemStatus(
            @PathVariable Long detailId,
            @RequestBody Map<String, String> request) {
        String status = request.get("status");
        return ResponseEntity.ok(kitchenService.updateItemStatus(detailId, status));
    }
}
