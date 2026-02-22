package com.morales.pos.application.service;

import com.morales.pos.application.dto.response.KitchenOrderResponse;
import com.morales.pos.domain.entity.Invoice;
import com.morales.pos.domain.entity.InvoiceDetail;
import com.morales.pos.domain.entity.KitchenOrder;
import com.morales.pos.domain.enums.KitchenStatus;
import com.morales.pos.domain.repository.InvoiceDetailRepository;
import com.morales.pos.domain.repository.KitchenOrderRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class KitchenService {

    private final InvoiceDetailRepository invoiceDetailRepository;
    private final KitchenOrderRepository kitchenOrderRepository;
    private final SseService sseService;

    @Transactional(readOnly = true)
    public List<KitchenOrderResponse> getPendingOrders() {
        List<KitchenOrder> activeOrders = kitchenOrderRepository.findActiveOrders();
        Map<String, KitchenOrderResponse> groupedByBatch = new LinkedHashMap<>();

        for (KitchenOrder kitchenOrder : activeOrders) {
            InvoiceDetail detail = kitchenOrder.getInvoiceDetail();
            Invoice invoice = detail.getInvoice();
            String batchKey = kitchenOrder.getTable().getId() + "-" + kitchenOrder.getSequenceNumber();

            KitchenOrderResponse existingBatch = groupedByBatch.get(batchKey);
            if (existingBatch == null) {
                KitchenOrderResponse newBatch = KitchenOrderResponse.builder()
                        .orderId(kitchenOrder.getId())
                        .invoiceNumber(invoice != null ? invoice.getInvoiceNumber() : null)
                        .tableNumber(kitchenOrder.getTableNumber())
                        .tableName(kitchenOrder.getTableName())
                        .waiterName(invoice != null && invoice.getUser() != null ? invoice.getUser().getFullName() : null)
                        .orderNotes(kitchenOrder.getNotes())
                        .createdAt(kitchenOrder.getOrderTime())
                        .sequenceNumber(kitchenOrder.getSequenceNumber())
                        .isUrgent(Boolean.TRUE.equals(kitchenOrder.getIsUrgent()))
                        .urgencyReason(kitchenOrder.getUrgencyReason())
                        .items(new ArrayList<>(List.of(mapKitchenItem(kitchenOrder))))
                        .build();
                groupedByBatch.put(batchKey, newBatch);
            } else {
                existingBatch.getItems().add(mapKitchenItem(kitchenOrder));
                if (!Boolean.TRUE.equals(existingBatch.getIsUrgent()) && Boolean.TRUE.equals(kitchenOrder.getIsUrgent())) {
                    existingBatch.setIsUrgent(true);
                    existingBatch.setUrgencyReason(kitchenOrder.getUrgencyReason());
                }
                if ((existingBatch.getOrderNotes() == null || existingBatch.getOrderNotes().isBlank())
                        && kitchenOrder.getNotes() != null
                        && !kitchenOrder.getNotes().isBlank()) {
                    existingBatch.setOrderNotes(kitchenOrder.getNotes());
                }
            }
        }

        return groupedByBatch.values().stream().collect(Collectors.toList());
    }

    @Transactional
    public KitchenOrderResponse.KitchenItemResponse updateItemStatus(Long detailId, String newStatus) {
        InvoiceDetail detail = invoiceDetailRepository.findById(detailId)
                .orElseThrow(() -> new EntityNotFoundException("Detalle no encontrado con ID: " + detailId));

        KitchenStatus status = KitchenStatus.valueOf(newStatus);
        detail.setKitchenStatus(status);
        InvoiceDetail saved = invoiceDetailRepository.save(detail);

        Optional<KitchenOrder> kitchenOrderOpt = kitchenOrderRepository.findByInvoiceDetailId(detailId);
        kitchenOrderOpt.ifPresent(order -> {
            order.setStatus(status);
            kitchenOrderRepository.save(order);
        });

        log.info("Kitchen status updated: detail #{} -> {}", detailId, newStatus);

        // Broadcast SSE event
        Map<String, Object> event = Map.of(
                "type", "KITCHEN_STATUS_UPDATE",
                "detailId", detailId,
                "newStatus", newStatus,
                "productName", detail.getProductName()
        );
        sseService.broadcast("kitchen_update", event);

        return KitchenOrderResponse.KitchenItemResponse.builder()
                .detailId(saved.getId())
                .productName(saved.getProductName())
                .quantity(saved.getQuantity())
                .notes(saved.getNotes())
                .kitchenStatus(saved.getKitchenStatus().name())
                .createdAt(saved.getCreatedAt())
                .build();
    }

    private KitchenOrderResponse.KitchenItemResponse mapKitchenItem(KitchenOrder ko) {
        InvoiceDetail detail = ko.getInvoiceDetail();
        return KitchenOrderResponse.KitchenItemResponse.builder()
                .detailId(detail.getId())
                .productName(detail.getProductName())
                .quantity(detail.getQuantity())
                .notes(detail.getNotes())
                .kitchenStatus(ko.getStatus().name())
                .createdAt(ko.getOrderTime())
                .build();
    }
}
