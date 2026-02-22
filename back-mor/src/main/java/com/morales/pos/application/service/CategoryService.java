package com.morales.pos.application.service;

import com.morales.pos.application.dto.request.CreateCategoryRequest;
import com.morales.pos.application.dto.request.UpdateCategoryRequest;
import com.morales.pos.application.dto.response.CategoryResponse;
import com.morales.pos.domain.entity.Category;
import com.morales.pos.domain.repository.CategoryRepository;
import com.morales.pos.domain.repository.ProductRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class CategoryService {

    private final CategoryRepository categoryRepository;
    private final ProductRepository productRepository;

    @Transactional(readOnly = true)
    public List<CategoryResponse> findAll() {
        return categoryRepository.findAllByOrderByDisplayOrderAsc().stream()
                .map(CategoryResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<CategoryResponse> findActive() {
        return categoryRepository.findByIsActiveTrueOrderByDisplayOrderAsc().stream()
                .map(CategoryResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<CategoryResponse> findRootCategories() {
        return categoryRepository.findByParentIsNullAndIsActiveTrueOrderByDisplayOrderAsc().stream()
                .map(c -> CategoryResponse.fromEntity(c, true))
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public CategoryResponse findById(Long id) {
        return categoryRepository.findById(id)
                .map(CategoryResponse::fromEntity)
                .orElseThrow(() -> new EntityNotFoundException("Categoría no encontrada con ID: " + id));
    }

    @Transactional(readOnly = true)
    public Category findEntityById(Long id) {
        return categoryRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Categoría no encontrada con ID: " + id));
    }

    @Transactional
    public CategoryResponse create(CreateCategoryRequest request) {
        Category parent = null;
        if (request.getParentId() != null) {
            parent = findEntityById(request.getParentId());
        }

        Integer displayOrder = request.getDisplayOrder();
        if (displayOrder == null || displayOrder == 0) {
            Integer maxOrder = categoryRepository.findMaxDisplayOrder();
            displayOrder = maxOrder != null ? maxOrder + 1 : 1;
        }

        Category category = Category.builder()
                .name(request.getName())
                .description(request.getDescription())
                .imageUrl(request.getImageUrl())
                .parent(parent)
                .displayOrder(displayOrder)
                .isActive(request.getIsActive())
                .build();

        log.info("Creando categoría: {}", category.getName());
        return CategoryResponse.fromEntity(categoryRepository.save(category));
    }

    @Transactional
    public CategoryResponse update(Long id, UpdateCategoryRequest request) {
        Category category = findEntityById(id);

        if (request.getName() != null) category.setName(request.getName());
        if (request.getDescription() != null) category.setDescription(request.getDescription());
        if (request.getImageUrl() != null) category.setImageUrl(request.getImageUrl());
        if (request.getParentId() != null) {
            Category parent = findEntityById(request.getParentId());
            category.setParent(parent);
        }
        if (request.getDisplayOrder() != null) category.setDisplayOrder(request.getDisplayOrder());
        if (request.getIsActive() != null) category.setIsActive(request.getIsActive());

        log.info("Actualizando categoría ID: {}", id);
        return CategoryResponse.fromEntity(categoryRepository.save(category));
    }

    @Transactional
    public void delete(Long id) {
        Category category = findEntityById(id);

        // Validar que no tenga productos asociados
        List<com.morales.pos.domain.entity.Product> products = productRepository.findByCategoryId(id);
        if (!products.isEmpty()) {
            throw new IllegalStateException(
                    "No se puede eliminar la categoría '" + category.getName() +
                    "' porque tiene " + products.size() + " producto(s) asociado(s). " +
                    "Mueve o elimina los productos primero.");
        }

        // Validar que no tenga subcategorías
        if (category.getChildren() != null && !category.getChildren().isEmpty()) {
            throw new IllegalStateException(
                    "No se puede eliminar la categoría '" + category.getName() +
                    "' porque tiene subcategorías. Elimínalas primero.");
        }

        categoryRepository.deleteById(id);
        log.info("Categoría eliminada permanentemente ID: {}", id);
    }

    @Transactional
    public void hardDelete(Long id) {
        if (!categoryRepository.existsById(id)) {
            throw new EntityNotFoundException("Categoría no encontrada con ID: " + id);
        }
        categoryRepository.deleteById(id);
        log.info("Eliminando permanentemente categoría ID: {}", id);
    }

    @Transactional
    public void reorder(List<Long> categoryIds) {
        List<Category> categories = categoryRepository.findAllById(categoryIds);
        Map<Long, Category> byId = new HashMap<>();
        for (Category c : categories) {
            byId.put(c.getId(), c);
        }

        int displayOrder = 1;
        for (Long id : categoryIds) {
            Category category = byId.get(id);
            if (category == null) {
                throw new EntityNotFoundException("Categoría no encontrada con ID: " + id);
            }
            category.setDisplayOrder(displayOrder);
            displayOrder++;
        }

        categoryRepository.saveAll(categories);
        log.info("Reordenando categorías. Total: {}", categoryIds.size());
    }
}
