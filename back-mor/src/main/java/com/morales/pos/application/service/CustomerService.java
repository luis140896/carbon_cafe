package com.morales.pos.application.service;

import com.morales.pos.application.dto.request.CreateCustomerRequest;
import com.morales.pos.application.dto.request.UpdateCustomerRequest;
import com.morales.pos.application.dto.response.CustomerResponse;
import com.morales.pos.domain.entity.Customer;
import com.morales.pos.domain.repository.CustomerRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class CustomerService {

    private final CustomerRepository customerRepository;

    @Transactional(readOnly = true)
    public Page<CustomerResponse> findAll(Pageable pageable) {
        return customerRepository.findAll(pageable)
                .map(CustomerResponse::fromEntity);
    }

    @Transactional(readOnly = true)
    public List<CustomerResponse> findActive() {
        return customerRepository.findByIsActiveTrue().stream()
                .map(CustomerResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public CustomerResponse findById(Long id) {
        return customerRepository.findById(id)
                .map(CustomerResponse::fromEntity)
                .orElseThrow(() -> new EntityNotFoundException("Cliente no encontrado con ID: " + id));
    }

    @Transactional(readOnly = true)
    public Customer findEntityById(Long id) {
        return customerRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Cliente no encontrado con ID: " + id));
    }

    @Transactional(readOnly = true)
    public CustomerResponse findByDocument(String documentType, String documentNumber) {
        return customerRepository.findByDocumentTypeAndDocumentNumber(documentType, documentNumber)
                .map(CustomerResponse::fromEntity)
                .orElseThrow(() -> new EntityNotFoundException("Cliente no encontrado con documento: " + documentType + " " + documentNumber));
    }

    @Transactional(readOnly = true)
    public List<CustomerResponse> search(String term) {
        return customerRepository.searchCustomers(term).stream()
                .map(CustomerResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional
    public CustomerResponse create(CreateCustomerRequest request) {
        if (request.getDocumentNumber() != null && !request.getDocumentNumber().isBlank() &&
            customerRepository.existsByDocumentTypeAndDocumentNumber(
                request.getDocumentType(), request.getDocumentNumber())) {
            throw new IllegalArgumentException("Ya existe un cliente con este documento");
        }

        Customer customer = Customer.builder()
                .documentType(request.getDocumentType())
                .documentNumber(request.getDocumentNumber())
                .fullName(request.getFullName())
                .email(request.getEmail())
                .phone(request.getPhone())
                .address(request.getAddress())
                .city(request.getCity())
                .notes(request.getNotes())
                .creditLimit(request.getCreditLimit())
                .isActive(request.getIsActive())
                .build();

        log.info("Creando cliente: {}", customer.getFullName());
        return CustomerResponse.fromEntity(customerRepository.save(customer));
    }

    @Transactional
    public CustomerResponse update(Long id, UpdateCustomerRequest request) {
        Customer customer = findEntityById(id);
        
        if (request.getDocumentNumber() != null && !request.getDocumentNumber().isBlank() &&
            !request.getDocumentNumber().equals(customer.getDocumentNumber()) &&
            customerRepository.existsByDocumentTypeAndDocumentNumber(
                request.getDocumentType() != null ? request.getDocumentType() : customer.getDocumentType(),
                request.getDocumentNumber())) {
            throw new IllegalArgumentException("Ya existe un cliente con este documento");
        }

        if (request.getDocumentType() != null) customer.setDocumentType(request.getDocumentType());
        if (request.getDocumentNumber() != null) customer.setDocumentNumber(request.getDocumentNumber());
        if (request.getFullName() != null) customer.setFullName(request.getFullName());
        if (request.getEmail() != null) customer.setEmail(request.getEmail());
        if (request.getPhone() != null) customer.setPhone(request.getPhone());
        if (request.getAddress() != null) customer.setAddress(request.getAddress());
        if (request.getCity() != null) customer.setCity(request.getCity());
        if (request.getNotes() != null) customer.setNotes(request.getNotes());
        if (request.getCreditLimit() != null) customer.setCreditLimit(request.getCreditLimit());
        if (request.getIsActive() != null) customer.setIsActive(request.getIsActive());
        
        log.info("Actualizando cliente ID: {}", id);
        return CustomerResponse.fromEntity(customerRepository.save(customer));
    }

    @Transactional
    public void delete(Long id) {
        Customer customer = findEntityById(id);
        customer.setIsActive(false);
        customerRepository.save(customer);
        log.info("Desactivando cliente ID: {}", id);
    }
}
