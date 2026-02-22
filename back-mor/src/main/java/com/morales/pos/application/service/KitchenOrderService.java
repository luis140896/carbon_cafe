package com.morales.pos.application.service;

import com.morales.pos.domain.entity.InvoiceDetail;
import com.morales.pos.domain.entity.KitchenOrder;
import com.morales.pos.domain.entity.RestaurantTable;
import com.morales.pos.domain.enums.KitchenStatus;
import com.morales.pos.domain.repository.KitchenOrderRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class KitchenOrderService {

    private final KitchenOrderRepository kitchenOrderRepository;
    private final SseService sseService;

    /**
     * Create kitchen order for an invoice detail
     */
    @Transactional
    public KitchenOrder createKitchenOrder(InvoiceDetail invoiceDetail, RestaurantTable table) {
        Integer nextSequence = getNextSequenceNumberForTable(table.getId());
        return createKitchenOrder(invoiceDetail, table, LocalDateTime.now(), nextSequence, false, null);
    }

    @Transactional(readOnly = true)
    public Integer getNextSequenceNumberForTable(Long tableId) {
        return kitchenOrderRepository.findMaxSequenceNumberByTableId(tableId) + 1;
    }

    @Transactional
    public KitchenOrder createKitchenOrder(
            InvoiceDetail invoiceDetail,
            RestaurantTable table,
            LocalDateTime orderTime,
            Integer sequenceNumber,
            Boolean isPriority,
            String priorityReason) {
        // Get next sequence number for this table
        Integer nextSequence = sequenceNumber != null ? sequenceNumber : getNextSequenceNumberForTable(table.getId());

        KitchenOrder kitchenOrder = KitchenOrder.builder()
                .table(table)
                .invoiceDetail(invoiceDetail)
                .orderTime(orderTime != null ? orderTime : LocalDateTime.now())
                .sequenceNumber(nextSequence)
                .status(KitchenStatus.PENDIENTE)
                .isUrgent(Boolean.TRUE.equals(isPriority))
                .urgencyReason(Boolean.TRUE.equals(isPriority) ? priorityReason : null)
                .notes(invoiceDetail.getNotes())
                .build();

        KitchenOrder saved = kitchenOrderRepository.save(kitchenOrder);
        log.info("Kitchen order created: Table {} - Sequence {} - Product: {}", 
                 table.getName(), nextSequence, invoiceDetail.getProductName());

        // Emit SSE notification to kitchen
        sseService.broadcastToRoles("new_order", Map.of(
            "type", "NEW_ORDER",
            "tableId", table.getId(),
            "tableName", table.getName(),
            "orderId", saved.getId(),
            "productName", invoiceDetail.getProductName(),
            "quantity", invoiceDetail.getQuantity()
        ), "COCINERO", "ADMIN", "SUPERVISOR");

        return saved;
    }

    /**
     * Get all active orders (not ENTREGADO) grouped by table
     */
    @Transactional(readOnly = true)
    public Map<String, Object> getActiveOrdersGrouped() {
        List<KitchenOrder> activeOrders = kitchenOrderRepository.findActiveOrders();

        // Group by table
        Map<Long, List<KitchenOrder>> groupedByTable = activeOrders.stream()
                .collect(Collectors.groupingBy(ko -> ko.getTable().getId()));

        List<Map<String, Object>> tableGroups = new ArrayList<>();

        groupedByTable.forEach((tableId, orders) -> {
            Map<String, Object> tableGroup = new HashMap<>();
            KitchenOrder firstOrder = orders.get(0);

            tableGroup.put("tableId", tableId);
            tableGroup.put("tableName", firstOrder.getTableName());
            tableGroup.put("tableNumber", firstOrder.getTableNumber());
            tableGroup.put("totalOrders", orders.size());
            tableGroup.put("hasUrgentOrders", orders.stream().anyMatch(o -> Boolean.TRUE.equals(o.getIsUrgent())));
            
            // Map orders to DTOs
            List<Map<String, Object>> orderDtos = orders.stream()
                    .map(this::toDto)
                    .collect(Collectors.toList());
            
            tableGroup.put("orders", orderDtos);
            tableGroups.add(tableGroup);
        });

        // Mantener orden cronológico de llegada (no re-priorizar por urgencia)

        Map<String, Object> result = new HashMap<>();
        result.put("tableGroups", tableGroups);
        result.put("totalTables", tableGroups.size());
        result.put("totalOrders", activeOrders.size());

        return result;
    }

    /**
     * Update order status
     */
    @Transactional
    public Map<String, Object> updateOrderStatus(Long orderId, KitchenStatus newStatus) {
        KitchenOrder order = kitchenOrderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Kitchen order not found: " + orderId));

        KitchenStatus oldStatus = order.getStatus();
        order.setStatus(newStatus);
        
        // Also update the invoice detail status
        order.getInvoiceDetail().setKitchenStatus(newStatus);

        KitchenOrder updated = kitchenOrderRepository.save(order);
        log.info("Kitchen order {} status updated: {} -> {}", orderId, oldStatus, newStatus);

        // Emit SSE notification
        sseService.broadcast("kitchen_update", Map.of(
            "type", "STATUS_UPDATE",
            "orderId", orderId,
            "oldStatus", oldStatus.name(),
            "newStatus", newStatus.name(),
            "tableName", order.getTableName()
        ));

        return toDto(updated);
    }

    /**
     * Mark order as urgent
     */
    @Transactional
    public Map<String, Object> markAsUrgent(Long orderId, String reason) {
        KitchenOrder order = kitchenOrderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Kitchen order not found: " + orderId));

        order.setIsUrgent(true);
        order.setUrgencyReason(reason);

        KitchenOrder updated = kitchenOrderRepository.save(order);
        log.info("Kitchen order {} marked as URGENT: {}", orderId, reason);

        // Emit SSE notification
        sseService.broadcast("urgent_order", Map.of(
            "type", "URGENT_ORDER",
            "orderId", orderId,
            "tableName", order.getTableName(),
            "reason", reason
        ));

        return toDto(updated);
    }

    /**
     * Convert entity to DTO
     */
    private Map<String, Object> toDto(KitchenOrder order) {
        Map<String, Object> dto = new HashMap<>();
        dto.put("id", order.getId());
        dto.put("orderTime", order.getOrderTime());
        dto.put("sequenceNumber", order.getSequenceNumber());
        dto.put("status", order.getStatus().name());
        dto.put("isUrgent", order.getIsUrgent());
        dto.put("urgencyReason", order.getUrgencyReason());
        dto.put("notes", order.getNotes());
        dto.put("elapsedMinutes", order.getElapsedMinutes());
        dto.put("tableId", order.getTable() != null ? order.getTable().getId() : null);
        dto.put("tableName", order.getTableName());
        
        // Invoice detail info
        InvoiceDetail detail = order.getInvoiceDetail();
        dto.put("productName", detail.getProductName());
        dto.put("quantity", detail.getQuantity());
        
        return dto;
    }
}
