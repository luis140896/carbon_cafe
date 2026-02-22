package com.morales.pos.presentation.controller;

import com.morales.pos.application.dto.request.CreateCategoryRequest;
import com.morales.pos.application.dto.request.ReorderCategoriesRequest;
import com.morales.pos.application.dto.request.UpdateCategoryRequest;
import com.morales.pos.application.dto.response.ApiResponse;
import com.morales.pos.application.dto.response.CategoryResponse;
import com.morales.pos.application.service.CategoryService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/categories")
@RequiredArgsConstructor
public class CategoryController {

    private final CategoryService categoryService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<CategoryResponse>>> findAll() {
        return ResponseEntity.ok(ApiResponse.success(categoryService.findAll()));
    }

    @GetMapping("/active")
    public ResponseEntity<ApiResponse<List<CategoryResponse>>> findActive() {
        return ResponseEntity.ok(ApiResponse.success(categoryService.findActive()));
    }

    @GetMapping("/root")
    public ResponseEntity<ApiResponse<List<CategoryResponse>>> findRootCategories() {
        return ResponseEntity.ok(ApiResponse.success(categoryService.findRootCategories()));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<CategoryResponse>> findById(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.success(categoryService.findById(id)));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'INVENTARIO')")
    public ResponseEntity<ApiResponse<CategoryResponse>> create(@Valid @RequestBody CreateCategoryRequest request) {
        CategoryResponse created = categoryService.create(request);
        return ResponseEntity.ok(ApiResponse.success(created, "Categoría creada exitosamente"));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'INVENTARIO')")
    public ResponseEntity<ApiResponse<CategoryResponse>> update(
            @PathVariable Long id, 
            @Valid @RequestBody UpdateCategoryRequest request) {
        CategoryResponse updated = categoryService.update(id, request);
        return ResponseEntity.ok(ApiResponse.success(updated, "Categoría actualizada exitosamente"));
    }

    @PutMapping("/reorder")
    @PreAuthorize("hasAnyRole('ADMIN', 'INVENTARIO')")
    public ResponseEntity<ApiResponse<Void>> reorder(@Valid @RequestBody ReorderCategoriesRequest request) {
        categoryService.reorder(request.getCategoryIds());
        return ResponseEntity.ok(ApiResponse.success(null, "Orden de categorías actualizado"));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'INVENTARIO')")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable Long id) {
        categoryService.delete(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Categoría eliminada exitosamente"));
    }
}
