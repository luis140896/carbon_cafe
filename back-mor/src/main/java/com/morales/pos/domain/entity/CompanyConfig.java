package com.morales.pos.domain.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "company_config")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CompanyConfig {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "company_name", nullable = false, length = 200)
    private String companyName;

    @Column(name = "legal_name", length = 200)
    private String legalName;

    @Column(name = "tax_id", length = 50)
    private String taxId;

    @Column(name = "logo_url")
    private String logoUrl;

    @Column(name = "primary_color", length = 7)
    @Builder.Default
    private String primaryColor = "#9b87f5";

    @Column(name = "secondary_color", length = 7)
    @Builder.Default
    private String secondaryColor = "#7c3aed";

    @Column(name = "accent_color", length = 7)
    @Builder.Default
    private String accentColor = "#c4b5fd";

    @Column(name = "background_color", length = 7)
    @Builder.Default
    private String backgroundColor = "#f3e8ff";

    @Column(name = "card_color", length = 7)
    @Builder.Default
    private String cardColor = "#ffffff";

    @Column(name = "sidebar_color", length = 7)
    @Builder.Default
    private String sidebarColor = "#ffffff";

    @Column(name = "business_type", length = 50)
    @Builder.Default
    private String businessType = "GENERAL";

    @Column(name = "currency", length = 3)
    @Builder.Default
    private String currency = "COP";

    @Column(name = "tax_rate", precision = 5, scale = 2)
    @Builder.Default
    private BigDecimal taxRate = new BigDecimal("19.00");

    @Column(name = "address", columnDefinition = "TEXT")
    private String address;

    @Column(name = "phone", length = 50)
    private String phone;

    @Column(name = "email", length = 100)
    private String email;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    public void prePersist() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}
