package com.morales.pos.domain.repository;

import com.morales.pos.domain.entity.KitchenOrder;
import com.morales.pos.domain.enums.KitchenStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface KitchenOrderRepository extends JpaRepository<KitchenOrder, Long> {

    // Find all orders that are NOT delivered (for kitchen display)
    @Query("SELECT ko FROM KitchenOrder ko " +
           "JOIN FETCH ko.table t " +
           "JOIN FETCH ko.invoiceDetail d " +
           "JOIN FETCH d.invoice i " +
           "LEFT JOIN FETCH i.user " +
           "LEFT JOIN FETCH i.tableSession ts " +
           "LEFT JOIN FETCH ts.restaurantTable " +
           "WHERE ko.status <> 'ENTREGADO' " +
           "ORDER BY ko.orderTime ASC")
    List<KitchenOrder> findActiveOrders();

    // Find by table
    List<KitchenOrder> findByTableIdAndStatusNotOrderByOrderTimeAsc(Long tableId, KitchenStatus status);

    // Find by invoice detail
    Optional<KitchenOrder> findByInvoiceDetailId(Long invoiceDetailId);

    // Get max sequence number for a table
    @Query("SELECT COALESCE(MAX(ko.sequenceNumber), 0) FROM KitchenOrder ko WHERE ko.table.id = :tableId")
    Integer findMaxSequenceNumberByTableId(@Param("tableId") Long tableId);

    // Count by status
    long countByStatus(KitchenStatus status);

    // Count urgent orders
    long countByIsUrgentTrueAndStatusNot(KitchenStatus status);
}
