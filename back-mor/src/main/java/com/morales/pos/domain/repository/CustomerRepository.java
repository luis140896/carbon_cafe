package com.morales.pos.domain.repository;

import com.morales.pos.domain.entity.Customer;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CustomerRepository extends JpaRepository<Customer, Long> {

    Optional<Customer> findByDocumentTypeAndDocumentNumber(String documentType, String documentNumber);

    List<Customer> findByIsActiveTrue();

    @Query("SELECT c FROM Customer c WHERE c.isActive = true AND " +
           "(LOWER(c.fullName) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "c.documentNumber LIKE CONCAT('%', :search, '%') OR " +
           "c.phone LIKE CONCAT('%', :search, '%'))")
    Page<Customer> searchCustomersPaged(@Param("search") String search, Pageable pageable);

    @Query("SELECT c FROM Customer c WHERE c.isActive = true AND " +
           "(LOWER(c.fullName) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "c.documentNumber LIKE CONCAT('%', :search, '%') OR " +
           "c.phone LIKE CONCAT('%', :search, '%'))")
    List<Customer> searchCustomers(@Param("search") String search);

    boolean existsByDocumentTypeAndDocumentNumber(String documentType, String documentNumber);
}
