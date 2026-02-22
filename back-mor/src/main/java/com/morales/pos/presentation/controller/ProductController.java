package com.morales.pos.presentation.controller;

import com.morales.pos.application.dto.request.CreateProductRequest;
import com.morales.pos.application.dto.request.UpdateProductRequest;
import com.morales.pos.application.dto.response.ApiResponse;
import com.morales.pos.application.dto.response.ProductResponse;
import com.morales.pos.application.service.ProductService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/products")
@RequiredArgsConstructor
public class ProductController {

    private final ProductService productService;

    @GetMapping
    public ResponseEntity<ApiResponse<Page<ProductResponse>>> findAll(
            @PageableDefault(size = 20) Pageable pageable) {
        return ResponseEntity.ok(ApiResponse.success(productService.findAll(pageable)));
    }

    @GetMapping("/active")
    public ResponseEntity<ApiResponse<List<ProductResponse>>> findActive() {
        return ResponseEntity.ok(ApiResponse.success(productService.findActive()));
    }

    @GetMapping("/category/{categoryId}")
    public ResponseEntity<ApiResponse<List<ProductResponse>>> findByCategory(@PathVariable Long categoryId) {
        return ResponseEntity.ok(ApiResponse.success(productService.findByCategory(categoryId)));
    }

    @GetMapping("/search")
    public ResponseEntity<ApiResponse<List<ProductResponse>>> search(@RequestParam String term) {
        return ResponseEntity.ok(ApiResponse.success(productService.search(term)));
    }

    @GetMapping("/low-stock")
    public ResponseEntity<ApiResponse<List<ProductResponse>>> findLowStock() {
        return ResponseEntity.ok(ApiResponse.success(productService.findLowStock()));
    }

    @GetMapping("/out-of-stock")
    public ResponseEntity<ApiResponse<List<ProductResponse>>> findOutOfStock() {
        return ResponseEntity.ok(ApiResponse.success(productService.findOutOfStock()));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<ProductResponse>> findById(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.success(productService.findById(id)));
    }

    @GetMapping("/code/{code}")
    public ResponseEntity<ApiResponse<ProductResponse>> findByCode(@PathVariable String code) {
        return ResponseEntity.ok(ApiResponse.success(productService.findByCode(code)));
    }

    @GetMapping("/barcode/{barcode}")
    public ResponseEntity<ApiResponse<ProductResponse>> findByBarcode(@PathVariable String barcode) {
        return ResponseEntity.ok(ApiResponse.success(productService.findByBarcode(barcode)));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'INVENTARIO')")
    public ResponseEntity<ApiResponse<ProductResponse>> create(@Valid @RequestBody CreateProductRequest request) {
        ProductResponse created = productService.create(request);
        return ResponseEntity.ok(ApiResponse.success(created, "Producto creado exitosamente"));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'INVENTARIO')")
    public ResponseEntity<ApiResponse<ProductResponse>> update(
            @PathVariable Long id, 
            @Valid @RequestBody UpdateProductRequest request) {
        ProductResponse updated = productService.update(id, request);
        return ResponseEntity.ok(ApiResponse.success(updated, "Producto actualizado exitosamente"));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'INVENTARIO')")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable Long id) {
        productService.delete(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Producto eliminado exitosamente"));
    }
}
