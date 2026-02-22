package com.morales.pos.presentation.controller;

import com.morales.pos.application.dto.response.ApiResponse;
import com.morales.pos.application.dto.response.ReportResponse.*;
import com.morales.pos.application.service.ReportService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/reports")
@RequiredArgsConstructor
@PreAuthorize("hasAnyRole('ADMIN', 'SUPERVISOR', 'REPORTES')")
public class ReportController {

    private final ReportService reportService;

    @GetMapping("/dashboard")
    public ResponseEntity<ApiResponse<DashboardSummary>> getDashboardSummary() {
        return ResponseEntity.ok(ApiResponse.success(reportService.getDashboardSummary()));
    }

    @GetMapping("/sales/summary")
    public ResponseEntity<ApiResponse<SalesSummary>> getSalesSummary(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime end) {
        return ResponseEntity.ok(ApiResponse.success(reportService.getSalesSummary(start, end)));
    }

    @GetMapping("/sales/today")
    public ResponseEntity<ApiResponse<SalesSummary>> getTodaySalesSummary() {
        return ResponseEntity.ok(ApiResponse.success(reportService.getTodaySalesSummary()));
    }

    @GetMapping("/sales/month")
    public ResponseEntity<ApiResponse<SalesSummary>> getMonthSalesSummary() {
        return ResponseEntity.ok(ApiResponse.success(reportService.getMonthSalesSummary()));
    }

    @GetMapping("/sales/daily")
    public ResponseEntity<ApiResponse<List<DailySales>>> getDailySales(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        return ResponseEntity.ok(ApiResponse.success(reportService.getDailySales(startDate, endDate)));
    }

    @GetMapping("/sales/last-7-days")
    public ResponseEntity<ApiResponse<List<DailySales>>> getLast7DaysSales() {
        return ResponseEntity.ok(ApiResponse.success(reportService.getLast7DaysSales()));
    }

    @GetMapping("/products/top")
    public ResponseEntity<ApiResponse<List<TopProduct>>> getTopProducts(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime end,
            @RequestParam(defaultValue = "10") int limit) {
        return ResponseEntity.ok(ApiResponse.success(reportService.getTopProducts(start, end, limit)));
    }

    @GetMapping("/customers/top")
    public ResponseEntity<ApiResponse<List<TopCustomer>>> getTopCustomers(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime end,
            @RequestParam(defaultValue = "10") int limit) {
        return ResponseEntity.ok(ApiResponse.success(reportService.getTopCustomers(start, end, limit)));
    }

    @GetMapping("/sales/by-category")
    public ResponseEntity<ApiResponse<List<SalesByCategory>>> getSalesByCategory(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime end) {
        return ResponseEntity.ok(ApiResponse.success(reportService.getSalesByCategory(start, end)));
    }

    @GetMapping("/sales/by-payment-method")
    public ResponseEntity<ApiResponse<List<SalesByPaymentMethod>>> getSalesByPaymentMethod(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime end) {
        return ResponseEntity.ok(ApiResponse.success(reportService.getSalesByPaymentMethod(start, end)));
    }

    @GetMapping("/inventory/value")
    public ResponseEntity<ApiResponse<InventoryValue>> getInventoryValue() {
        return ResponseEntity.ok(ApiResponse.success(reportService.getInventoryValue()));
    }
}
