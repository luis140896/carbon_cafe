package com.morales.pos.presentation.controller;

import com.morales.pos.application.dto.request.*;
import com.morales.pos.application.dto.response.ApiResponse;
import com.morales.pos.application.dto.response.InvoiceResponse;
import com.morales.pos.application.dto.response.TableResponse;
import com.morales.pos.application.dto.response.TableSessionResponse;
import com.morales.pos.application.service.TableService;
import com.morales.pos.domain.entity.User;
import com.morales.pos.domain.repository.UserRepository;
import com.morales.pos.infrastructure.security.jwt.CustomUserDetails;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/tables")
@RequiredArgsConstructor
public class TableController {

    private final TableService tableService;
    private final UserRepository userRepository;

    // ==================== TABLE CRUD ====================

    @GetMapping
    public ResponseEntity<ApiResponse<List<TableResponse>>> findAll() {
        return ResponseEntity.ok(ApiResponse.success(tableService.findAllTables()));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<TableResponse>> findById(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.success(tableService.findTableById(id)));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<TableResponse>> create(@Valid @RequestBody CreateTableRequest request) {
        TableResponse table = tableService.createTable(request);
        return ResponseEntity.ok(ApiResponse.success(table, "Mesa creada exitosamente"));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<TableResponse>> update(
            @PathVariable Long id,
            @Valid @RequestBody UpdateTableRequest request) {
        TableResponse table = tableService.updateTable(id, request);
        return ResponseEntity.ok(ApiResponse.success(table, "Mesa actualizada exitosamente"));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable Long id) {
        tableService.deleteTable(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Mesa eliminada exitosamente"));
    }

    @PutMapping("/{id}/status")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPERVISOR')")
    public ResponseEntity<ApiResponse<TableResponse>> changeStatus(
            @PathVariable Long id,
            @RequestBody Map<String, String> body) {
        String newStatus = body.get("status");
        TableResponse table = tableService.changeTableStatus(id, newStatus);
        return ResponseEntity.ok(ApiResponse.success(table, "Estado de mesa actualizado"));
    }

    // ==================== TABLE SESSIONS ====================

    @PostMapping("/{id}/open")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPERVISOR', 'CAJERO', 'MESERO')")
    public ResponseEntity<ApiResponse<TableSessionResponse>> openTable(
            @PathVariable Long id,
            @Valid @RequestBody OpenTableRequest request,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        User user = resolveUser(userDetails);
        TableSessionResponse session = tableService.openTable(id, request, user);
        return ResponseEntity.ok(ApiResponse.success(session, "Mesa abierta exitosamente"));
    }

    @PostMapping("/{id}/add-items")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPERVISOR', 'CAJERO', 'MESERO')")
    public ResponseEntity<ApiResponse<TableSessionResponse>> addItems(
            @PathVariable Long id,
            @Valid @RequestBody AddTableItemsRequest request,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        User user = resolveUser(userDetails);
        TableSessionResponse session = tableService.addItemsToTable(id, request, user);
        return ResponseEntity.ok(ApiResponse.success(session, "Productos agregados exitosamente"));
    }

    @DeleteMapping("/{id}/items/{detailId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPERVISOR', 'CAJERO')")
    public ResponseEntity<ApiResponse<TableSessionResponse>> removeItem(
            @PathVariable Long id,
            @PathVariable Long detailId,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        User user = resolveUser(userDetails);
        TableSessionResponse session = tableService.removeItemFromTable(id, detailId, user);
        return ResponseEntity.ok(ApiResponse.success(session, "Producto eliminado exitosamente"));
    }

    @PostMapping("/{id}/pay")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPERVISOR', 'CAJERO')")
    public ResponseEntity<ApiResponse<InvoiceResponse>> payTable(
            @PathVariable Long id,
            @Valid @RequestBody PayTableRequest request,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        User user = resolveUser(userDetails);
        InvoiceResponse invoice = tableService.payTable(id, request, user);
        return ResponseEntity.ok(ApiResponse.success(invoice, "Mesa pagada exitosamente"));
    }

    @PostMapping("/{id}/release")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPERVISOR', 'CAJERO', 'MESERO')")
    public ResponseEntity<ApiResponse<TableResponse>> releaseTable(
            @PathVariable Long id,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        User user = resolveUser(userDetails);
        TableResponse table = tableService.releaseTable(id, user);
        return ResponseEntity.ok(ApiResponse.success(table, "Mesa liberada exitosamente"));
    }

    @GetMapping("/{id}/session")
    public ResponseEntity<ApiResponse<TableSessionResponse>> getActiveSession(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.success(tableService.getActiveSession(id)));
    }

    @GetMapping("/sessions/active")
    public ResponseEntity<ApiResponse<List<TableSessionResponse>>> getActiveSessions() {
        return ResponseEntity.ok(ApiResponse.success(tableService.getActiveSessions()));
    }

    // ==================== HELPERS ====================

    private User resolveUser(CustomUserDetails userDetails) {
        return userRepository.findById(userDetails.getId())
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
    }
}
