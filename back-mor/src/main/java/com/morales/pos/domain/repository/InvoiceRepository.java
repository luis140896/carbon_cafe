package com.morales.pos.domain.repository;

import com.morales.pos.domain.entity.Invoice;
import com.morales.pos.domain.enums.InvoiceStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.morales.pos.domain.enums.KitchenStatus;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface InvoiceRepository extends JpaRepository<Invoice, Long>, JpaSpecificationExecutor<Invoice> {

    Optional<Invoice> findByInvoiceNumber(String invoiceNumber);

    @Query("SELECT i FROM Invoice i LEFT JOIN FETCH i.details WHERE i.id = :id")
    Optional<Invoice> findByIdWithDetails(@Param("id") Long id);

    @Query("SELECT i FROM Invoice i WHERE i.createdAt BETWEEN :startDate AND :endDate AND i.status = :status")
    List<Invoice> findByDateRangeAndStatus(
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate,
            @Param("status") InvoiceStatus status);

    @Query("SELECT i FROM Invoice i WHERE i.createdAt BETWEEN :startDate AND :endDate")
    Page<Invoice> findByDateRange(
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate,
            Pageable pageable);

    @Query("SELECT SUM(i.total) FROM Invoice i WHERE i.createdAt BETWEEN :startDate AND :endDate AND i.status = 'COMPLETADA'")
    BigDecimal sumTotalByDateRange(
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate);

    @Query("SELECT COUNT(i) FROM Invoice i WHERE i.createdAt BETWEEN :startDate AND :endDate AND i.status = 'COMPLETADA'")
    Long countByDateRange(
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate);

    @Query("SELECT COALESCE(MAX(CAST(SUBSTRING(i.invoiceNumber, 5) AS integer)), 0) FROM Invoice i WHERE i.invoiceNumber LIKE :prefix%")
    Integer findMaxInvoiceNumberByPrefix(@Param("prefix") String prefix);

    @Query("SELECT i FROM Invoice i WHERE i.customer.id = :customerId ORDER BY i.createdAt DESC")
    Page<Invoice> findByCustomerId(@Param("customerId") Long customerId, Pageable pageable);

    List<Invoice> findByCustomerIdOrderByCreatedAtDesc(Long customerId);

    @Query("SELECT i FROM Invoice i WHERE i.status <> 'ABIERTA' ORDER BY i.createdAt DESC")
    Page<Invoice> findAllExcludingOpen(Pageable pageable);

    List<Invoice> findByCreatedAtBetweenOrderByCreatedAtDesc(LocalDateTime start, LocalDateTime end);

    Long countByCreatedAtBetween(LocalDateTime start, LocalDateTime end);

    @Query("SELECT COUNT(i) FROM Invoice i WHERE i.invoiceNumber LIKE :prefix%")
    Long countByInvoiceNumberStartingWith(@Param("prefix") String prefix);

    @Query("SELECT SUM(i.total) FROM Invoice i WHERE i.createdAt BETWEEN :start AND :end AND i.status = :status")
    BigDecimal sumTotalByDateRangeAndStatus(
            @Param("start") LocalDateTime start,
            @Param("end") LocalDateTime end,
            @Param("status") InvoiceStatus status);

    @Query("SELECT COUNT(i) FROM Invoice i WHERE i.createdAt BETWEEN :start AND :end AND i.status = :status")
    Long countByCreatedAtBetweenAndStatus(
            @Param("start") LocalDateTime start,
            @Param("end") LocalDateTime end,
            @Param("status") InvoiceStatus status);

    @Query("SELECT CAST(i.createdAt AS LocalDate), SUM(i.total), COUNT(i) FROM Invoice i " +
           "WHERE i.createdAt BETWEEN :start AND :end AND i.status = 'COMPLETADA' " +
           "GROUP BY CAST(i.createdAt AS LocalDate) ORDER BY CAST(i.createdAt AS LocalDate)")
    List<Object[]> getDailySales(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);

    @Query(value = "SELECT c.id, c.full_name, COUNT(i.id), SUM(i.total) FROM invoices i " +
           "JOIN customers c ON i.customer_id = c.id WHERE i.created_at BETWEEN :start AND :end AND i.status = 'COMPLETADA' " +
           "GROUP BY c.id, c.full_name ORDER BY SUM(i.total) DESC LIMIT :limit", nativeQuery = true)
    List<Object[]> getTopCustomers(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end, @Param("limit") int limit);

    @Query("SELECT i.paymentMethod, SUM(i.total), COUNT(i) FROM Invoice i " +
           "WHERE i.createdAt BETWEEN :start AND :end AND i.status = 'COMPLETADA' " +
           "GROUP BY i.paymentMethod ORDER BY SUM(i.total) DESC")
    List<Object[]> getSalesByPaymentMethod(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);

    @Query("SELECT DISTINCT i FROM Invoice i LEFT JOIN FETCH i.details d LEFT JOIN FETCH i.user " +
           "LEFT JOIN FETCH i.tableSession ts LEFT JOIN FETCH ts.restaurantTable " +
           "WHERE i.status IN :statuses AND d.kitchenStatus IN :kitchenStatuses " +
           "ORDER BY i.createdAt ASC")
    List<Invoice> findInvoicesWithPendingKitchenItems(
            @Param("statuses") List<InvoiceStatus> statuses,
            @Param("kitchenStatuses") List<KitchenStatus> kitchenStatuses);
}
