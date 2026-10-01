package com.morales.pos.presentation.controller;

import com.morales.pos.application.dto.request.SaveRecipeRequest;
import com.morales.pos.application.dto.response.ApiResponse;
import com.morales.pos.application.dto.response.RecipeAvailabilityResponse;
import com.morales.pos.application.dto.response.RecipeResponse;
import com.morales.pos.application.service.RecipeService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/recipes")
@RequiredArgsConstructor
public class RecipeController {

    private final RecipeService recipeService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<RecipeResponse>>> findAll() {
        return ResponseEntity.ok(ApiResponse.success(recipeService.findAll()));
    }

    @GetMapping("/availability")
    public ResponseEntity<ApiResponse<List<RecipeAvailabilityResponse>>> availability() {
        return ResponseEntity.ok(ApiResponse.success(recipeService.computeAvailability()));
    }

    @GetMapping("/product/{productId}")
    public ResponseEntity<ApiResponse<RecipeResponse>> findByProductId(@PathVariable Long productId) {
        return ResponseEntity.ok(ApiResponse.success(recipeService.findByProductId(productId)));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<RecipeResponse>> save(@Valid @RequestBody SaveRecipeRequest request) {
        return ResponseEntity.ok(ApiResponse.success(recipeService.save(request), "Receta guardada exitosamente"));
    }

    @DeleteMapping("/product/{productId}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<Void>> deleteByProductId(@PathVariable Long productId) {
        recipeService.deleteByProductId(productId);
        return ResponseEntity.ok(ApiResponse.success(null, "Receta inactivada exitosamente"));
    }
}
