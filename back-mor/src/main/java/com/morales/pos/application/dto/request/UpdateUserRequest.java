package com.morales.pos.application.dto.request;

import jakarta.validation.constraints.Email;
import lombok.Data;

@Data
public class UpdateUserRequest {
    @Email(message = "El email no es válido")
    private String email;

    private String fullName;

    private Long roleId;

    private Boolean isActive;
}
