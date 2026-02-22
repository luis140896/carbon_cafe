package com.morales.pos.domain.repository;

import com.morales.pos.domain.entity.InvoiceDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface InvoiceDetailRepository extends JpaRepository<InvoiceDetail, Long> {

    List<InvoiceDetail> findByInvoiceId(Long invoiceId);

    @Query("SELECT d FROM InvoiceDetail d WHERE d.product.id = :productId ORDER BY d.createdAt DESC")
    List<InvoiceDetail> findByProductIdOrderByCreatedAtDesc(@Param("productId") Long productId);

    @Query("SELECT SUM(d.quantity * d.product.costPrice) FROM InvoiceDetail d " +
           "WHERE d.invoice.createdAt BETWEEN :start AND :end AND d.invoice.status = 'COMPLETADA'")
    BigDecimal sumCostByDateRange(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);

    @Query(value = "SELECT p.id, p.code, p.name, SUM(d.quantity), SUM(d.subtotal) " +
           "FROM invoice_details d JOIN products p ON d.product_id = p.id " +
           "JOIN invoices i ON d.invoice_id = i.id " +
           "WHERE i.created_at BETWEEN :start AND :end AND i.status = 'COMPLETADA' " +
           "GROUP BY p.id, p.code, p.name ORDER BY SUM(d.quantity) DESC LIMIT :limit", nativeQuery = true)
    List<Object[]> getTopProducts(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end, @Param("limit") int limit);

    @Query(value = "SELECT c.id, c.name, SUM(d.subtotal), COUNT(DISTINCT d.id) " +
           "FROM invoice_details d JOIN products p ON d.product_id = p.id " +
           "JOIN categories c ON p.category_id = c.id " +
           "JOIN invoices i ON d.invoice_id = i.id " +
           "WHERE i.created_at BETWEEN :start AND :end AND i.status = 'COMPLETADA' " +
           "GROUP BY c.id, c.name ORDER BY SUM(d.subtotal) DESC", nativeQuery = true)
    List<Object[]> getSalesByCategory(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);
}
