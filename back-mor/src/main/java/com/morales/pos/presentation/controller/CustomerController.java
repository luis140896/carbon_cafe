package com.morales.pos.presentation.controller;

import com.morales.pos.application.dto.request.CreateCustomerRequest;
import com.morales.pos.application.dto.request.UpdateCustomerRequest;
import com.morales.pos.application.dto.response.ApiResponse;
import com.morales.pos.application.dto.response.CustomerResponse;
import com.morales.pos.application.service.CustomerService;
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
@RequestMapping("/customers")
@RequiredArgsConstructor
public class CustomerController {

    private final CustomerService customerService;

    @GetMapping
    public ResponseEntity<ApiResponse<Page<CustomerResponse>>> findAll(
            @PageableDefault(size = 20) Pageable pageable) {
        return ResponseEntity.ok(ApiResponse.success(customerService.findAll(pageable)));
    }

    @GetMapping("/active")
    public ResponseEntity<ApiResponse<List<CustomerResponse>>> findActive() {
        return ResponseEntity.ok(ApiResponse.success(customerService.findActive()));
    }

    @GetMapping("/search")
    public ResponseEntity<ApiResponse<List<CustomerResponse>>> search(@RequestParam String term) {
        return ResponseEntity.ok(ApiResponse.success(customerService.search(term)));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<CustomerResponse>> findById(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.success(customerService.findById(id)));
    }

    @GetMapping("/document/{documentType}/{documentNumber}")
    public ResponseEntity<ApiResponse<CustomerResponse>> findByDocument(
            @PathVariable String documentType,
            @PathVariable String documentNumber) {
        return ResponseEntity.ok(ApiResponse.success(
                customerService.findByDocument(documentType, documentNumber)));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'CAJERO', 'SUPERVISOR')")
    public ResponseEntity<ApiResponse<CustomerResponse>> create(@Valid @RequestBody CreateCustomerRequest request) {
        CustomerResponse created = customerService.create(request);
        return ResponseEntity.ok(ApiResponse.success(created, "Cliente creado exitosamente"));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'CAJERO', 'SUPERVISOR')")
    public ResponseEntity<ApiResponse<CustomerResponse>> update(
            @PathVariable Long id, 
            @Valid @RequestBody UpdateCustomerRequest request) {
        CustomerResponse updated = customerService.update(id, request);
        return ResponseEntity.ok(ApiResponse.success(updated, "Cliente actualizado exitosamente"));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPERVISOR')")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable Long id) {
        customerService.delete(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Cliente eliminado exitosamente"));
    }
}
