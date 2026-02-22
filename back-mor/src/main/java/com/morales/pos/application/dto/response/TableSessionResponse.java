package com.morales.pos.application.dto.response;

import com.morales.pos.domain.entity.TableSession;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TableSessionResponse {

    private Long id;
    private Long tableId;
    private Integer tableNumber;
    private String tableName;
    private Long invoiceId;
    private String invoiceNumber;
    private String openedByName;
    private Long openedById;
    private String closedByName;
    private LocalDateTime openedAt;
    private LocalDateTime closedAt;
    private Integer guestCount;
    private String notes;
    private String status;

    // Invoice summary
    private BigDecimal subtotal;
    private BigDecimal total;
    private Integer itemCount;
    private InvoiceResponse invoice;

    public static TableSessionResponse fromEntity(TableSession session) {
        return fromEntity(session, false);
    }

    public static TableSessionResponse fromEntity(TableSession session, boolean includeInvoiceDetails) {
        TableSessionResponseBuilder builder = TableSessionResponse.builder()
                .id(session.getId())
                .openedAt(session.getOpenedAt())
                .closedAt(session.getClosedAt())
                .guestCount(session.getGuestCount())
                .notes(session.getNotes())
                .status(session.getStatus() != null ? session.getStatus().name() : null);

        if (session.getRestaurantTable() != null) {
            builder.tableId(session.getRestaurantTable().getId())
                   .tableNumber(session.getRestaurantTable().getTableNumber())
                   .tableName(session.getRestaurantTable().getName());
        }

        if (session.getOpenedBy() != null) {
            builder.openedById(session.getOpenedBy().getId())
                   .openedByName(session.getOpenedBy().getFullName());
        }

        if (session.getClosedBy() != null) {
            builder.closedByName(session.getClosedBy().getFullName());
        }

        if (session.getInvoice() != null) {
            builder.invoiceId(session.getInvoice().getId())
                   .invoiceNumber(session.getInvoice().getInvoiceNumber())
                   .subtotal(session.getInvoice().getSubtotal())
                   .total(session.getInvoice().getTotal())
                   .itemCount(session.getInvoice().getDetails() != null
                           ? session.getInvoice().getDetails().size() : 0);

            if (includeInvoiceDetails) {
                builder.invoice(InvoiceResponse.fromEntity(session.getInvoice()));
            }
        }

        return builder.build();
    }
}
