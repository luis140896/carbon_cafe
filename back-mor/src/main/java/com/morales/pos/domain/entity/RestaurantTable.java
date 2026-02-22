package com.morales.pos.domain.entity;

import com.morales.pos.domain.enums.TableStatus;
import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Entity
@Table(name = "restaurant_tables")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
public class RestaurantTable extends BaseEntity {

    @Column(name = "table_number", unique = true, nullable = false)
    private Integer tableNumber;

    @Column(name = "name", length = 100)
    private String name;

    @Column(name = "capacity")
    @Builder.Default
    private Integer capacity = 4;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", length = 30)
    @Builder.Default
    private TableStatus status = TableStatus.DISPONIBLE;

    @Column(name = "zone", length = 50)
    @Builder.Default
    private String zone = "INTERIOR";

    @Column(name = "display_order")
    @Builder.Default
    private Integer displayOrder = 0;

    @Column(name = "is_active")
    @Builder.Default
    private Boolean isActive = true;
}
