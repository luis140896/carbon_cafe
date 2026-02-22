package com.morales.pos.application.dto.response;

import com.morales.pos.domain.entity.RestaurantTable;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TableResponse {

    private Long id;
    private Integer tableNumber;
    private String name;
    private Integer capacity;
    private String status;
    private String zone;
    private Integer displayOrder;
    private Boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Session info (only if table is occupied)
    private TableSessionResponse activeSession;

    public static TableResponse fromEntity(RestaurantTable table) {
        return fromEntity(table, null);
    }

    public static TableResponse fromEntity(RestaurantTable table, TableSessionResponse session) {
        return TableResponse.builder()
                .id(table.getId())
                .tableNumber(table.getTableNumber())
                .name(table.getName())
                .capacity(table.getCapacity())
                .status(table.getStatus() != null ? table.getStatus().name() : null)
                .zone(table.getZone())
                .displayOrder(table.getDisplayOrder())
                .isActive(table.getIsActive())
                .createdAt(table.getCreatedAt())
                .updatedAt(table.getUpdatedAt())
                .activeSession(session)
                .build();
    }
}
