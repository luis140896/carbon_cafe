package com.morales.pos.application.service;

import com.morales.pos.application.dto.request.CreateProductRequest;
import com.morales.pos.application.dto.request.UpdateProductRequest;
import com.morales.pos.application.dto.response.ProductResponse;
import com.morales.pos.domain.entity.Category;
import com.morales.pos.domain.entity.Inventory;
import com.morales.pos.domain.entity.Product;
import com.morales.pos.domain.repository.CategoryRepository;
import com.morales.pos.domain.repository.InventoryRepository;
import com.morales.pos.domain.repository.ProductRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProductService {

    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;
    private final InventoryRepository inventoryRepository;

    @Transactional(readOnly = true)
    public Page<ProductResponse> findAll(Pageable pageable) {
        return productRepository.findAll(pageable)
                .map(ProductResponse::fromEntity);
    }

    @Transactional(readOnly = true)
    public List<ProductResponse> findActive() {
        return productRepository.findByIsActiveTrue().stream()
                .map(ProductResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<ProductResponse> findByCategory(Long categoryId) {
        return productRepository.findByCategoryIdAndIsActiveTrue(categoryId).stream()
                .map(ProductResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public ProductResponse findById(Long id) {
        return productRepository.findById(id)
                .map(ProductResponse::fromEntity)
                .orElseThrow(() -> new EntityNotFoundException("Producto no encontrado con ID: " + id));
    }

    @Transactional(readOnly = true)
    public Product findEntityById(Long id) {
        return productRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Producto no encontrado con ID: " + id));
    }

    @Transactional(readOnly = true)
    public ProductResponse findByCode(String code) {
        return productRepository.findByCode(code)
                .map(ProductResponse::fromEntity)
                .orElseThrow(() -> new EntityNotFoundException("Producto no encontrado con código: " + code));
    }

    @Transactional(readOnly = true)
    public ProductResponse findByBarcode(String barcode) {
        return productRepository.findByBarcode(barcode)
                .map(ProductResponse::fromEntity)
                .orElseThrow(() -> new EntityNotFoundException("Producto no encontrado con código de barras: " + barcode));
    }

    @Transactional(readOnly = true)
    public List<ProductResponse> search(String term) {
        return productRepository.searchProducts(term).stream()
                .map(ProductResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional
    public ProductResponse create(CreateProductRequest request) {
        // Auto-generate code if not provided
        String code = request.getCode();
        if (code == null || code.isBlank()) {
            code = generateProductCode();
        } else {
            if (productRepository.existsByCode(code)) {
                throw new IllegalArgumentException("Ya existe un producto con el código: " + code);
            }
        }
        
        if (request.getBarcode() != null && !request.getBarcode().isBlank() 
            && productRepository.existsByBarcode(request.getBarcode())) {
            throw new IllegalArgumentException("Ya existe un producto con el código de barras: " + request.getBarcode());
        }

        Category category = categoryRepository.findById(request.getCategoryId())
                .orElseThrow(() -> new EntityNotFoundException("Categoría no encontrada con ID: " + request.getCategoryId()));

        Product product = Product.builder()
                .code(code)
                .barcode(request.getBarcode())
                .name(request.getName())
                .description(request.getDescription())
                .category(category)
                .imageUrl(request.getImageUrl())
                .costPrice(request.getCostPrice())
                .salePrice(request.getSalePrice())
                .unit(request.getUnit())
                .taxRate(request.getTaxRate())
                .isActive(request.getIsActive())
                .build();

        Product savedProduct = productRepository.save(product);
        
        Inventory inventory = Inventory.builder()
                .product(savedProduct)
                .quantity(request.getInitialStock() != null ? request.getInitialStock() : BigDecimal.ZERO)
                .minStock(request.getMinStock() != null ? request.getMinStock() : BigDecimal.ZERO)
                .maxStock(request.getMaxStock() != null ? request.getMaxStock() : new BigDecimal("999999"))
                .location(request.getLocation())
                .build();
        inventoryRepository.save(inventory);
        savedProduct.setInventory(inventory);
        
        log.info("Producto creado: {} ({})", savedProduct.getName(), savedProduct.getCode());
        return ProductResponse.fromEntity(savedProduct);
    }

    @Transactional
    public ProductResponse update(Long id, UpdateProductRequest request) {
        Product product = findEntityById(id);
        
        if (request.getCode() != null && !product.getCode().equals(request.getCode()) && 
            productRepository.existsByCode(request.getCode())) {
            throw new IllegalArgumentException("Ya existe un producto con el código: " + request.getCode());
        }

        if (request.getBarcode() != null && !request.getBarcode().isBlank() &&
            !request.getBarcode().equals(product.getBarcode()) &&
            productRepository.existsByBarcode(request.getBarcode())) {
            throw new IllegalArgumentException("Ya existe un producto con el código de barras: " + request.getBarcode());
        }

        if (request.getCode() != null) product.setCode(request.getCode());
        if (request.getBarcode() != null) product.setBarcode(request.getBarcode());
        if (request.getName() != null) product.setName(request.getName());
        if (request.getDescription() != null) product.setDescription(request.getDescription());
        if (request.getCategoryId() != null) {
            Category category = categoryRepository.findById(request.getCategoryId())
                    .orElseThrow(() -> new EntityNotFoundException("Categoría no encontrada con ID: " + request.getCategoryId()));
            product.setCategory(category);
        }
        if (request.getImageUrl() != null) product.setImageUrl(request.getImageUrl());
        if (request.getCostPrice() != null) product.setCostPrice(request.getCostPrice());
        if (request.getSalePrice() != null) product.setSalePrice(request.getSalePrice());
        if (request.getUnit() != null) product.setUnit(request.getUnit());
        if (request.getTaxRate() != null) product.setTaxRate(request.getTaxRate());
        if (request.getIsActive() != null) product.setIsActive(request.getIsActive());
        
        Product savedProduct = productRepository.save(product);
        log.info("Producto actualizado ID: {}", id);
        return ProductResponse.fromEntity(savedProduct);
    }

    @Transactional
    public void delete(Long id) {
        Product product = findEntityById(id);
        product.setIsActive(false);
        productRepository.save(product);
        log.info("Producto desactivado ID: {}", id);
    }

    @Transactional(readOnly = true)
    public List<ProductResponse> findLowStock() {
        return productRepository.findLowStockProducts().stream()
                .map(ProductResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<ProductResponse> findOutOfStock() {
        return productRepository.findOutOfStockProducts().stream()
                .map(ProductResponse::fromEntity)
                .collect(Collectors.toList());
    }

    private String generateProductCode() {
        Integer maxCode = productRepository.findMaxAutoCode();
        int nextCode = (maxCode != null ? maxCode : 0) + 1;
        String code = String.format("PRD-%04d", nextCode);
        // Safety check: ensure uniqueness in case of manual codes matching the pattern
        while (productRepository.existsByCode(code)) {
            nextCode++;
            code = String.format("PRD-%04d", nextCode);
        }
        return code;
    }
}
