package com.morales.pos.domain.repository;

import com.morales.pos.domain.entity.Inventory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Repository
public interface InventoryRepository extends JpaRepository<Inventory, Long> {

    Optional<Inventory> findByProductId(Long productId);

    @Query("SELECT i FROM Inventory i JOIN FETCH i.product")
    List<Inventory> findAllWithProduct();

    @Query("SELECT i FROM Inventory i JOIN FETCH i.product WHERE i.product.id = :productId")
    Optional<Inventory> findByProductIdWithProduct(@Param("productId") Long productId);

    @Query("SELECT i FROM Inventory i JOIN FETCH i.product WHERE i.quantity <= i.minStock")
    List<Inventory> findLowStock();

    @Query("SELECT i FROM Inventory i JOIN FETCH i.product WHERE i.quantity <= i.minStock AND i.product.isActive = true")
    List<Inventory> findLowStockProducts();

    @Query("SELECT i FROM Inventory i JOIN FETCH i.product WHERE i.quantity <= 0")
    List<Inventory> findOutOfStock();

    @Query("SELECT i FROM Inventory i JOIN FETCH i.product WHERE i.quantity <= 0 AND i.product.isActive = true")
    List<Inventory> findOutOfStockProducts();

    @Modifying
    @Query("UPDATE Inventory i SET i.quantity = i.quantity - :quantity WHERE i.product.id = :productId AND i.quantity >= :quantity")
    int decreaseStock(@Param("productId") Long productId, @Param("quantity") BigDecimal quantity);

    @Modifying
    @Query("UPDATE Inventory i SET i.quantity = i.quantity + :quantity WHERE i.product.id = :productId")
    int increaseStock(@Param("productId") Long productId, @Param("quantity") BigDecimal quantity);

    @Query("SELECT SUM(i.quantity * i.product.costPrice) FROM Inventory i WHERE i.product.isActive = true")
    BigDecimal getTotalCostValue();

    @Query("SELECT SUM(i.quantity * i.product.salePrice) FROM Inventory i WHERE i.product.isActive = true")
    BigDecimal getTotalSaleValue();
}
