package com.morales.pos.presentation.controller;

import com.morales.pos.application.dto.response.ApiResponse;
import com.morales.pos.application.service.CompanyConfigService;
import com.morales.pos.domain.entity.CompanyConfig;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/settings")
@RequiredArgsConstructor
public class CompanyConfigController {

    private final CompanyConfigService configService;

    @GetMapping
    public ResponseEntity<ApiResponse<CompanyConfig>> getConfig() {
        return ResponseEntity.ok(ApiResponse.success(configService.getConfig()));
    }

    @PutMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<CompanyConfig>> updateConfig(@RequestBody CompanyConfig config) {
        CompanyConfig updated = configService.updateConfig(config);
        return ResponseEntity.ok(ApiResponse.success(updated, "Configuración actualizada exitosamente"));
    }
}
