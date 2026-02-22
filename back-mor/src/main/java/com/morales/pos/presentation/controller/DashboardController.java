package com.morales.pos.presentation.controller;

import com.morales.pos.application.dto.response.ApiResponse;
import com.morales.pos.application.dto.response.ReportResponse.*;
import com.morales.pos.application.service.ReportService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Dashboard endpoints accessible to ALL authenticated users.
 * Delegates to ReportService but without role restrictions,
 * so every role (CAJERO, MESERO, etc.) can see the Dashboard.
 */
@RestController
@RequestMapping("/dashboard")
@RequiredArgsConstructor
public class DashboardController {

    private final ReportService reportService;

    @GetMapping("/summary")
    public ResponseEntity<ApiResponse<DashboardSummary>> getDashboardSummary() {
        return ResponseEntity.ok(ApiResponse.success(reportService.getDashboardSummary()));
    }

    @GetMapping("/sales/summary")
    public ResponseEntity<ApiResponse<SalesSummary>> getSalesSummary(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime end) {
        return ResponseEntity.ok(ApiResponse.success(reportService.getSalesSummary(start, end)));
    }

    @GetMapping("/sales/daily")
    public ResponseEntity<ApiResponse<List<DailySales>>> getDailySales(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        return ResponseEntity.ok(ApiResponse.success(reportService.getDailySales(startDate, endDate)));
    }
}
