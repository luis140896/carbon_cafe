package com.morales.pos.presentation.controller;

import com.morales.pos.application.dto.request.ExpenseRequest;
import com.morales.pos.application.dto.response.ApiResponse;
import com.morales.pos.application.dto.response.ExpenseResponse;
import com.morales.pos.application.service.ExpenseService;
import com.morales.pos.domain.entity.User;
import com.morales.pos.domain.repository.UserRepository;
import com.morales.pos.infrastructure.security.jwt.CustomUserDetails;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/expenses")
@RequiredArgsConstructor
public class ExpenseController {

    private final ExpenseService expenseService;
    private final UserRepository userRepository;

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPERVISOR', 'CAJERO', 'REPORTES')")
    public ResponseEntity<ApiResponse<List<ExpenseResponse>>> getByDateRange(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        return ResponseEntity.ok(ApiResponse.success(expenseService.getByDateRange(startDate, endDate)));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPERVISOR', 'CAJERO')")
    public ResponseEntity<ApiResponse<ExpenseResponse>> create(
            @Valid @RequestBody ExpenseRequest request,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        User user = resolveUser(userDetails);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(expenseService.create(request, user), "Gasto registrado exitosamente"));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPERVISOR', 'CAJERO')")
    public ResponseEntity<ApiResponse<ExpenseResponse>> update(
            @PathVariable Long id,
            @Valid @RequestBody ExpenseRequest request) {
        return ResponseEntity.ok(ApiResponse.success(expenseService.update(id, request), "Gasto actualizado exitosamente"));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPERVISOR')")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable Long id) {
        expenseService.delete(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Gasto eliminado exitosamente"));
    }

    private User resolveUser(CustomUserDetails userDetails) {
        return userRepository.findById(userDetails.getId())
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
    }
}
