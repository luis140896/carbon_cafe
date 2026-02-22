package com.morales.pos.presentation.controller;

import com.morales.pos.application.dto.request.CreatePromotionRequest;
import com.morales.pos.application.dto.request.UpdatePromotionRequest;
import com.morales.pos.application.dto.response.PromotionResponse;
import com.morales.pos.application.service.PromotionService;
import com.morales.pos.domain.entity.Promotion;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/promotions")
@RequiredArgsConstructor
public class PromotionController {

    private final PromotionService promotionService;

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPERVISOR')")
    public ResponseEntity<List<PromotionResponse>> getAllPromotions() {
        List<Promotion> promotions = promotionService.getAllPromotions();
        List<PromotionResponse> response = promotions.stream()
                .map(PromotionResponse::fromEntity)
                .collect(Collectors.toList());
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPERVISOR')")
    public ResponseEntity<PromotionResponse> getPromotionById(@PathVariable Long id) {
        return promotionService.getPromotionById(id)
                .map(promotion -> ResponseEntity.ok(PromotionResponse.fromEntity(promotion)))
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/active")
    public ResponseEntity<List<PromotionResponse>> getActivePromotions() {
        List<Promotion> promotions = promotionService.getActivePromotions();
        List<PromotionResponse> response = promotions.stream()
                .map(PromotionResponse::fromEntity)
                .collect(Collectors.toList());
        return ResponseEntity.ok(response);
    }

    @GetMapping("/today")
    public ResponseEntity<PromotionResponse> getActivePromotionForToday() {
        return promotionService.getActivePromotionForToday()
                .map(promotion -> ResponseEntity.ok(PromotionResponse.fromEntity(promotion)))
                .orElse(ResponseEntity.noContent().build());
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPERVISOR')")
    public ResponseEntity<PromotionResponse> createPromotion(@Valid @RequestBody CreatePromotionRequest request) {
        Promotion promotion = promotionService.createPromotion(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(PromotionResponse.fromEntity(promotion));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPERVISOR')")
    public ResponseEntity<PromotionResponse> updatePromotion(
            @PathVariable Long id,
            @Valid @RequestBody UpdatePromotionRequest request
    ) {
        Promotion promotion = promotionService.updatePromotion(id, request);
        return ResponseEntity.ok(PromotionResponse.fromEntity(promotion));
    }

    @PatchMapping("/{id}/toggle")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPERVISOR')")
    public ResponseEntity<PromotionResponse> togglePromotionStatus(@PathVariable Long id) {
        Promotion promotion = promotionService.togglePromotionStatus(id);
        return ResponseEntity.ok(PromotionResponse.fromEntity(promotion));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deletePromotion(@PathVariable Long id) {
        promotionService.deletePromotion(id);
        return ResponseEntity.noContent().build();
    }
}
