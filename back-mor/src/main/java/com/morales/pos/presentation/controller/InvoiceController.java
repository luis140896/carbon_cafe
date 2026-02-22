package com.morales.pos.presentation.controller;

import com.morales.pos.application.dto.request.CreateSaleRequest;
import com.morales.pos.application.dto.request.VoidInvoiceRequest;
import com.morales.pos.application.dto.response.ApiResponse;
import com.morales.pos.application.dto.response.InvoiceResponse;
import com.morales.pos.application.service.InvoiceService;
import com.morales.pos.domain.entity.User;
import com.morales.pos.domain.repository.UserRepository;
import com.morales.pos.infrastructure.security.jwt.CustomUserDetails;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/invoices")
@RequiredArgsConstructor
public class InvoiceController {

    private final InvoiceService invoiceService;
    private final UserRepository userRepository;

    @GetMapping
    public ResponseEntity<ApiResponse<Page<InvoiceResponse>>> findAll(
            @PageableDefault(size = 20) Pageable pageable) {
        return ResponseEntity.ok(ApiResponse.success(invoiceService.findAll(pageable)));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<InvoiceResponse>> findById(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.success(invoiceService.findById(id)));
    }

    @GetMapping("/number/{invoiceNumber}")
    public ResponseEntity<ApiResponse<InvoiceResponse>> findByInvoiceNumber(@PathVariable String invoiceNumber) {
        return ResponseEntity.ok(ApiResponse.success(invoiceService.findByInvoiceNumber(invoiceNumber)));
    }

    @GetMapping("/customer/{customerId}")
    public ResponseEntity<ApiResponse<List<InvoiceResponse>>> findByCustomer(@PathVariable Long customerId) {
        return ResponseEntity.ok(ApiResponse.success(invoiceService.findByCustomer(customerId)));
    }

    @GetMapping("/today")
    public ResponseEntity<ApiResponse<List<InvoiceResponse>>> findTodaySales() {
        return ResponseEntity.ok(ApiResponse.success(invoiceService.findTodaySales()));
    }

    @GetMapping("/date-range")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPERVISOR', 'REPORTES')")
    public ResponseEntity<ApiResponse<List<InvoiceResponse>>> findByDateRange(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime end) {
        return ResponseEntity.ok(ApiResponse.success(invoiceService.findByDateRange(start, end)));
    }

    @GetMapping("/stats/today")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getTodayStats() {
        Map<String, Object> stats = Map.of(
                "totalSales", invoiceService.getTodaySalesTotal(),
                "salesCount", invoiceService.getTodaySalesCount()
        );
        return ResponseEntity.ok(ApiResponse.success(stats));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'CAJERO', 'SUPERVISOR')")
    public ResponseEntity<ApiResponse<InvoiceResponse>> createSale(
            @Valid @RequestBody CreateSaleRequest request,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        User user = userRepository.findById(userDetails.getId())
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
        InvoiceResponse invoice = invoiceService.createSale(request, user);
        return ResponseEntity.ok(ApiResponse.success(invoice, "Venta registrada exitosamente"));
    }

    @PostMapping("/{id}/void")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPERVISOR')")
    public ResponseEntity<ApiResponse<InvoiceResponse>> voidInvoice(
            @PathVariable Long id,
            @Valid @RequestBody VoidInvoiceRequest request,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        User user = userRepository.findById(userDetails.getId())
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
        InvoiceResponse invoice = invoiceService.voidInvoice(id, request, user);
        return ResponseEntity.ok(ApiResponse.success(invoice, "Factura anulada exitosamente"));
    }
}
