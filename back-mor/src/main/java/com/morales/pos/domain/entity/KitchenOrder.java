package com.morales.pos.domain.entity;

import com.morales.pos.domain.enums.KitchenStatus;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

@Entity
@Table(name = "kitchen_orders")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class KitchenOrder {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "table_id", nullable = false)
    private RestaurantTable table;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "invoice_detail_id", nullable = false, unique = true)
    private InvoiceDetail invoiceDetail;

    @Column(name = "order_time", nullable = false)
    private LocalDateTime orderTime;

    @Column(name = "sequence_number", nullable = false)
    private Integer sequenceNumber;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private KitchenStatus status;

    @Column(name = "is_urgent")
    private Boolean isUrgent = false;

    @Column(name = "urgency_reason", length = 200)
    private String urgencyReason;

    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (orderTime == null) {
            orderTime = LocalDateTime.now();
        }
        if (status == null) {
            status = KitchenStatus.PENDIENTE;
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    public Long getElapsedMinutes() {
        return ChronoUnit.MINUTES.between(orderTime, LocalDateTime.now());
    }

    public String getTableName() {
        return table != null ? table.getName() : "N/A";
    }

    public Integer getTableNumber() {
        return table != null ? table.getTableNumber() : null;
    }
}
