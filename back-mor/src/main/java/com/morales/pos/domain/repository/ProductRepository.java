package com.morales.pos.domain.repository;

import com.morales.pos.domain.entity.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long>, JpaSpecificationExecutor<Product> {

    Optional<Product> findByCode(String code);

    Optional<Product> findByBarcode(String barcode);

    boolean existsByCode(String code);

    boolean existsByBarcode(String barcode);

    @Query("SELECT p FROM Product p WHERE p.isActive = true")
    List<Product> findAllActive();

    @Query("SELECT DISTINCT p FROM Product p LEFT JOIN FETCH p.category LEFT JOIN FETCH p.inventory WHERE p.isActive = true")
    List<Product> findByIsActiveTrue();

    @Query("SELECT DISTINCT p FROM Product p LEFT JOIN FETCH p.category LEFT JOIN FETCH p.inventory WHERE p.isActive = true AND p.category.id = :categoryId")
    List<Product> findByCategoryIdAndIsActiveTrue(@Param("categoryId") Long categoryId);

    @Query("SELECT DISTINCT p FROM Product p LEFT JOIN FETCH p.category LEFT JOIN FETCH p.inventory WHERE p.isActive = true AND p.category.id = :categoryId")
    List<Product> findByCategoryId(@Param("categoryId") Long categoryId);

    @Query("SELECT p FROM Product p WHERE p.isActive = true AND " +
           "(LOWER(p.name) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(p.code) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "p.barcode LIKE CONCAT('%', :search, '%'))")
    Page<Product> searchProductsPaged(@Param("search") String search, Pageable pageable);

    @Query("SELECT p FROM Product p WHERE p.isActive = true AND " +
           "(LOWER(p.name) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(p.code) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "p.barcode LIKE CONCAT('%', :search, '%'))")
    List<Product> searchProducts(@Param("search") String search);

    @Query("SELECT p FROM Product p JOIN p.inventory i WHERE i.quantity <= i.minStock AND p.isActive = true")
    List<Product> findLowStockProducts();

    @Query("SELECT p FROM Product p JOIN p.inventory i WHERE i.quantity <= 0 AND p.isActive = true")
    List<Product> findOutOfStockProducts();

    @Query("SELECT p FROM Product p LEFT JOIN FETCH p.category LEFT JOIN FETCH p.inventory WHERE p.id = :id")
    Optional<Product> findByIdWithDetails(@Param("id") Long id);

    Long countByIsActiveTrue();

    @Query("SELECT MAX(CAST(SUBSTRING(p.code, 5) AS integer)) FROM Product p WHERE p.code LIKE 'PRD-%'")
    Integer findMaxAutoCode();
}
