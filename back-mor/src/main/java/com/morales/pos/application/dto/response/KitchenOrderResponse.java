package com.morales.pos.application.dto.response;

import com.morales.pos.domain.entity.Invoice;
import com.morales.pos.domain.entity.InvoiceDetail;
import com.morales.pos.domain.enums.KitchenStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class KitchenOrderResponse {

    private Long orderId;
    private String invoiceNumber;
    private Integer tableNumber;
    private String tableName;
    private String waiterName;
    private String orderNotes;
    private LocalDateTime createdAt;
    private Integer sequenceNumber;
    private Boolean isUrgent;
    private String urgencyReason;
    private List<KitchenItemResponse> items;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class KitchenItemResponse {
        private Long detailId;
        private String productName;
        private BigDecimal quantity;
        private String notes;
        private String kitchenStatus;
        private LocalDateTime createdAt;
    }

    public static KitchenOrderResponse fromEntity(Invoice invoice) {
        KitchenOrderResponseBuilder builder = KitchenOrderResponse.builder()
                .orderId(invoice.getId())
                .invoiceNumber(invoice.getInvoiceNumber())
                .orderNotes(invoice.getNotes())
                .createdAt(invoice.getCreatedAt());

        if (invoice.getUser() != null) {
            builder.waiterName(invoice.getUser().getFullName());
        }

        if (invoice.getTableSession() != null && invoice.getTableSession().getRestaurantTable() != null) {
            builder.tableNumber(invoice.getTableSession().getRestaurantTable().getTableNumber())
                   .tableName(invoice.getTableSession().getRestaurantTable().getName());
        }

        if (invoice.getDetails() != null) {
            builder.items(invoice.getDetails().stream()
                    .filter(d -> d.getKitchenStatus() != KitchenStatus.ENTREGADO)
                    .map(KitchenOrderResponse::mapItem)
                    .collect(Collectors.toList()));
        }

        return builder.build();
    }

    private static KitchenItemResponse mapItem(InvoiceDetail detail) {
        return KitchenItemResponse.builder()
                .detailId(detail.getId())
                .productName(detail.getProductName())
                .quantity(detail.getQuantity())
                .notes(detail.getNotes())
                .kitchenStatus(detail.getKitchenStatus() != null ? detail.getKitchenStatus().name() : "PENDIENTE")
                .createdAt(detail.getCreatedAt())
                .build();
    }
}
