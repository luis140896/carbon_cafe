package com.morales.pos.application.dto.response;

import com.morales.pos.domain.entity.Invoice;
import com.morales.pos.domain.entity.InvoiceDetail;
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
public class InvoiceResponse {

    private Long id;
    private String invoiceNumber;
    private String invoiceType;
    
    // Customer info
    private Long customerId;
    private String customerName;
    private String customerDocument;
    
    // User info
    private Long userId;
    private String userName;
    
    // Amounts
    private BigDecimal subtotal;
    private BigDecimal taxAmount;
    private BigDecimal discountAmount;
    private BigDecimal discountPercent;
    private BigDecimal serviceChargePercent;
    private BigDecimal serviceChargeAmount;
    private BigDecimal deliveryChargeAmount;
    private BigDecimal total;
    
    // Payment info
    private String paymentMethod;
    private String paymentStatus;
    private BigDecimal amountReceived;
    private BigDecimal changeAmount;
    
    // Status
    private String status;
    private String notes;
    
    // Void info
    private Long voidedBy;
    private String voidedByName;
    private LocalDateTime voidedAt;
    private String voidReason;
    
    // Details
    private List<InvoiceDetailResponse> details;
    
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static InvoiceResponse fromEntity(Invoice invoice) {
        return fromEntity(invoice, true);
    }

    public static InvoiceResponse fromEntity(Invoice invoice, boolean includeDetails) {
        InvoiceResponseBuilder builder = InvoiceResponse.builder()
                .id(invoice.getId())
                .invoiceNumber(invoice.getInvoiceNumber())
                .invoiceType(invoice.getInvoiceType() != null ? invoice.getInvoiceType().name() : null)
                .subtotal(invoice.getSubtotal())
                .taxAmount(invoice.getTaxAmount())
                .discountAmount(invoice.getDiscountAmount())
                .discountPercent(invoice.getDiscountPercent())
                .serviceChargePercent(invoice.getServiceChargePercent())
                .serviceChargeAmount(invoice.getServiceChargeAmount())
                .deliveryChargeAmount(invoice.getDeliveryChargeAmount())
                .total(invoice.getTotal())
                .paymentMethod(invoice.getPaymentMethod() != null ? invoice.getPaymentMethod().name() : null)
                .paymentStatus(invoice.getPaymentStatus() != null ? invoice.getPaymentStatus().name() : null)
                .amountReceived(invoice.getAmountReceived())
                .changeAmount(invoice.getChangeAmount())
                .status(invoice.getStatus() != null ? invoice.getStatus().name() : null)
                .notes(invoice.getNotes())
                .voidedAt(invoice.getVoidedAt())
                .voidReason(invoice.getVoidReason())
                .createdAt(invoice.getCreatedAt())
                .updatedAt(invoice.getUpdatedAt());

        if (invoice.getCustomer() != null) {
            builder.customerId(invoice.getCustomer().getId())
                   .customerName(invoice.getCustomer().getFullName())
                   .customerDocument(invoice.getCustomer().getDocumentNumber());
        }

        if (invoice.getUser() != null) {
            builder.userId(invoice.getUser().getId())
                   .userName(invoice.getUser().getFullName());
        }

        if (invoice.getVoidedBy() != null) {
            builder.voidedBy(invoice.getVoidedBy().getId())
                   .voidedByName(invoice.getVoidedBy().getFullName());
        }

        if (includeDetails && invoice.getDetails() != null) {
            builder.details(invoice.getDetails().stream()
                    .map(InvoiceDetailResponse::fromEntity)
                    .collect(Collectors.toList()));
        }

        return builder.build();
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class InvoiceDetailResponse {
        private Long id;
        private Long productId;
        private String productCode;
        private String productName;
        private BigDecimal quantity;
        private BigDecimal unitPrice;
        private BigDecimal costPrice;
        private BigDecimal discountAmount;
        private BigDecimal taxAmount;
        private BigDecimal subtotal;
        private String notes;
        private String kitchenStatus;

        public static InvoiceDetailResponse fromEntity(InvoiceDetail detail) {
            InvoiceDetailResponseBuilder builder = InvoiceDetailResponse.builder()
                    .id(detail.getId())
                    .productName(detail.getProductName())
                    .quantity(detail.getQuantity())
                    .unitPrice(detail.getUnitPrice())
                    .costPrice(detail.getCostPrice())
                    .discountAmount(detail.getDiscountAmount())
                    .taxAmount(detail.getTaxAmount())
                    .subtotal(detail.getSubtotal())
                    .notes(detail.getNotes())
                    .kitchenStatus(detail.getKitchenStatus() != null ? detail.getKitchenStatus().name() : null);

            if (detail.getProduct() != null) {
                builder.productId(detail.getProduct().getId())
                       .productCode(detail.getProduct().getCode());
            }

            return builder.build();
        }
    }
}
