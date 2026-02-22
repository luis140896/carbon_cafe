package com.morales.pos.application.dto.response;

import com.morales.pos.domain.entity.Role;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class RoleResponse {
    private Long id;
    private String name;
    private String description;
    private List<String> permissions;
    private Boolean isSystem;

    public static RoleResponse fromEntity(Role role) {
        return RoleResponse.builder()
                .id(role.getId())
                .name(role.getName())
                .description(role.getDescription())
                .permissions(role.getPermissions())
                .isSystem(role.getIsSystem())
                .build();
    }
}
