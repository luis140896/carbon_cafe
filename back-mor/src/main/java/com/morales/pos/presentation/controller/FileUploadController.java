package com.morales.pos.presentation.controller;

import com.morales.pos.application.dto.response.ApiResponse;
import com.morales.pos.application.service.FileUploadService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

@RestController
@RequestMapping("/upload")
@RequiredArgsConstructor
public class FileUploadController {

    private final FileUploadService fileUploadService;

    @PreAuthorize("hasAnyRole('ADMIN', 'SUPERVISOR', 'INVENTARIO')")
    @PostMapping("/product-image")
    public ResponseEntity<ApiResponse<Map<String, String>>> uploadProductImage(
            @RequestParam("file") MultipartFile file) {
        try {
            String url = fileUploadService.uploadFile(file, "products");
            return ResponseEntity.ok(ApiResponse.success(Map.of("url", url)));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(ApiResponse.error("Error al subir imagen"));
        }
    }
}
