package com.morales.pos.application.service;

import com.morales.pos.application.dto.request.CreateSaleRequest;
import com.morales.pos.application.dto.request.VoidInvoiceRequest;
import com.morales.pos.application.dto.response.InvoiceResponse;
import com.morales.pos.domain.entity.*;
import com.morales.pos.domain.enums.InvoiceStatus;
import com.morales.pos.domain.enums.InvoiceType;
import com.morales.pos.domain.enums.KitchenStatus;
import com.morales.pos.domain.enums.PaymentMethod;
import com.morales.pos.domain.enums.PaymentStatus;
import com.morales.pos.domain.repository.*;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class InvoiceService {

    private final InvoiceRepository invoiceRepository;
    private final InvoiceDetailRepository invoiceDetailRepository;
    private final CustomerRepository customerRepository;
    private final ProductRepository productRepository;
    private final InventoryService inventoryService;
    private final SseService sseService;
    private final NotificationService notificationService;

    @Transactional(readOnly = true)
    public Page<InvoiceResponse> findAll(Pageable pageable) {
        return invoiceRepository.findAllExcludingOpen(pageable)
                .map(inv -> InvoiceResponse.fromEntity(inv, false));
    }

    @Transactional(readOnly = true)
    public InvoiceResponse findById(Long id) {
        return invoiceRepository.findByIdWithDetails(id)
                .map(InvoiceResponse::fromEntity)
                .orElseThrow(() -> new EntityNotFoundException("Factura no encontrada con ID: " + id));
    }

    @Transactional(readOnly = true)
    public Invoice findEntityById(Long id) {
        return invoiceRepository.findByIdWithDetails(id)
                .orElseThrow(() -> new EntityNotFoundException("Factura no encontrada con ID: " + id));
    }

    @Transactional(readOnly = true)
    public InvoiceResponse findByInvoiceNumber(String invoiceNumber) {
        return invoiceRepository.findByInvoiceNumber(invoiceNumber)
                .map(InvoiceResponse::fromEntity)
                .orElseThrow(() -> new EntityNotFoundException("Factura no encontrada: " + invoiceNumber));
    }

    @Transactional(readOnly = true)
    public List<InvoiceResponse> findByCustomer(Long customerId) {
        return invoiceRepository.findByCustomerIdOrderByCreatedAtDesc(customerId).stream()
                .map(inv -> InvoiceResponse.fromEntity(inv, false))
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<InvoiceResponse> findByDateRange(LocalDateTime start, LocalDateTime end) {
        return invoiceRepository.findByCreatedAtBetweenOrderByCreatedAtDesc(start, end).stream()
                .map(inv -> InvoiceResponse.fromEntity(inv, false))
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<InvoiceResponse> findTodaySales() {
        LocalDateTime startOfDay = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0);
        LocalDateTime endOfDay = LocalDateTime.now().withHour(23).withMinute(59).withSecond(59);
        return invoiceRepository.findByCreatedAtBetweenOrderByCreatedAtDesc(startOfDay, endOfDay).stream()
                .map(inv -> InvoiceResponse.fromEntity(inv, false))
                .collect(Collectors.toList());
    }

    @Transactional
    public InvoiceResponse createSale(CreateSaleRequest request, User user) {
        // Validar stock antes de procesar
        for (CreateSaleRequest.SaleDetailRequest detail : request.getDetails()) {
            Inventory inventory = inventoryService.findEntityByProductId(detail.getProductId());
            if (inventory.getQuantity().compareTo(detail.getQuantity()) < 0) {
                Product product = productRepository.findById(detail.getProductId())
                        .orElseThrow(() -> new EntityNotFoundException("Producto no encontrado"));
                throw new IllegalArgumentException(
                        String.format("Stock insuficiente para %s. Disponible: %s, Solicitado: %s",
                                product.getName(), inventory.getQuantity(), detail.getQuantity()));
            }
        }

        String invoiceNumber = generateInvoiceNumber();

        Customer customer = null;
        if (request.getCustomerId() != null) {
            customer = customerRepository.findById(request.getCustomerId())
                    .orElseThrow(() -> new EntityNotFoundException("Cliente no encontrado"));
        }

        Invoice invoice = Invoice.builder()
                .invoiceNumber(invoiceNumber)
                .invoiceType(InvoiceType.VENTA)
                .customer(customer)
                .user(user)
                .paymentMethod(PaymentMethod.valueOf(request.getPaymentMethod()))
                .discountPercent(request.getDiscountPercent())
                .amountReceived(request.getAmountReceived())
                .notes(request.getNotes())
                .status(InvoiceStatus.COMPLETADA)
                .paymentStatus(PaymentStatus.PAGADO)
                .build();

        Invoice savedInvoice = invoiceRepository.save(invoice);

        BigDecimal subtotal = BigDecimal.ZERO;
        BigDecimal taxAmount = BigDecimal.ZERO;

        for (CreateSaleRequest.SaleDetailRequest detailRequest : request.getDetails()) {
            Product product = productRepository.findById(detailRequest.getProductId())
                    .orElseThrow(() -> new EntityNotFoundException("Producto no encontrado: " + detailRequest.getProductId()));

            InvoiceDetail detail = InvoiceDetail.builder()
                    .invoice(savedInvoice)
                    .product(product)
                    .productName(product.getName())
                    .quantity(detailRequest.getQuantity())
                    .unitPrice(detailRequest.getUnitPrice())
                    .costPrice(product.getCostPrice())
                    .discountAmount(detailRequest.getDiscountAmount() != null ? detailRequest.getDiscountAmount() : BigDecimal.ZERO)
                    .notes(detailRequest.getNotes())
                    .kitchenStatus(KitchenStatus.ENTREGADO)
                    .build();

            BigDecimal lineSubtotal = detail.getUnitPrice().multiply(detail.getQuantity()).subtract(detail.getDiscountAmount());
            BigDecimal lineTax = lineSubtotal.multiply(product.getTaxRate().divide(BigDecimal.valueOf(100)));

            detail.setSubtotal(lineSubtotal);
            detail.setTaxAmount(lineTax);

            subtotal = subtotal.add(lineSubtotal);
            taxAmount = taxAmount.add(lineTax);

            invoiceDetailRepository.save(detail);

            inventoryService.removeStock(
                    product.getId(),
                    detail.getQuantity(),
                    "Venta - Factura " + invoiceNumber,
                    user
            );
        }

        BigDecimal discountAmount = request.getDiscountPercent() != null && request.getDiscountPercent().compareTo(BigDecimal.ZERO) > 0
                ? subtotal.multiply(request.getDiscountPercent().divide(BigDecimal.valueOf(100), 2, java.math.RoundingMode.HALF_UP))
                : BigDecimal.ZERO;

        BigDecimal afterDiscount = subtotal.add(taxAmount).subtract(discountAmount);

        // Service charge (optional, e.g. 10%)
        BigDecimal serviceChargePercent = request.getServiceChargePercent() != null ? request.getServiceChargePercent() : BigDecimal.ZERO;
        BigDecimal serviceChargeAmount = BigDecimal.ZERO;
        if (serviceChargePercent.compareTo(BigDecimal.ZERO) > 0) {
            serviceChargeAmount = afterDiscount.multiply(serviceChargePercent).divide(BigDecimal.valueOf(100), 2, java.math.RoundingMode.HALF_UP);
        }

        // Delivery charge (domicilio)
        BigDecimal deliveryChargeAmount = request.getDeliveryChargeAmount() != null ? request.getDeliveryChargeAmount() : BigDecimal.ZERO;

        savedInvoice.setSubtotal(subtotal);
        savedInvoice.setTaxAmount(taxAmount);
        savedInvoice.setDiscountAmount(discountAmount);
        savedInvoice.setServiceChargePercent(serviceChargePercent);
        savedInvoice.setServiceChargeAmount(serviceChargeAmount);
        savedInvoice.setDeliveryChargeAmount(deliveryChargeAmount);
        savedInvoice.setTotal(afterDiscount.add(serviceChargeAmount).add(deliveryChargeAmount));

        if (request.getAmountReceived() != null) {
            savedInvoice.setChangeAmount(request.getAmountReceived().subtract(savedInvoice.getTotal()));
        }

        Invoice finalInvoice = invoiceRepository.save(savedInvoice);
        log.info("Venta creada: {} - Total: {}", invoiceNumber, finalInvoice.getTotal());

        // Ventas directas del POS no emiten SSE a cocina — solo mesas activas lo hacen

        return InvoiceResponse.fromEntity(finalInvoice);
    }

    @Transactional
    public InvoiceResponse voidInvoice(Long id, VoidInvoiceRequest request, User user) {
        Invoice invoice = findEntityById(id);
        
        if (InvoiceStatus.ANULADA.equals(invoice.getStatus())) {
            throw new IllegalArgumentException("La factura ya está anulada");
        }

        for (InvoiceDetail detail : invoice.getDetails()) {
            inventoryService.addStock(
                    detail.getProduct().getId(),
                    detail.getQuantity(),
                    "Anulación - Factura " + invoice.getInvoiceNumber(),
                    user
            );
        }

        invoice.setStatus(InvoiceStatus.ANULADA);
        invoice.setVoidedBy(user);
        invoice.setVoidedAt(LocalDateTime.now());
        invoice.setVoidReason(request.getReason());

        Invoice voidedInvoice = invoiceRepository.save(invoice);
        log.info("Factura anulada: {} - Razón: {}", invoice.getInvoiceNumber(), request.getReason());

        try {
            notificationService.notifyVoidAttempt(invoice.getInvoiceNumber(), user.getFullName());
        } catch (Exception e) {
            log.warn("Error al crear notificación de anulación: {}", e.getMessage());
        }

        return InvoiceResponse.fromEntity(voidedInvoice);
    }

    private String generateInvoiceNumber() {
        String prefix = "V";
        String datePart = java.time.LocalDate.now().format(java.time.format.DateTimeFormatter.ofPattern("MMdd"));
        Long count = invoiceRepository.countByInvoiceNumberStartingWith(prefix + datePart) + 1;
        return String.format("%s%s-%04d", prefix, datePart, count);
    }

    @Transactional(readOnly = true)
    public BigDecimal getTodaySalesTotal() {
        LocalDateTime startOfDay = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0);
        LocalDateTime endOfDay = LocalDateTime.now().withHour(23).withMinute(59).withSecond(59);
        BigDecimal total = invoiceRepository.sumTotalByDateRange(startOfDay, endOfDay);
        return total != null ? total : BigDecimal.ZERO;
    }

    @Transactional(readOnly = true)
    public Long getTodaySalesCount() {
        LocalDateTime startOfDay = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0);
        LocalDateTime endOfDay = LocalDateTime.now().withHour(23).withMinute(59).withSecond(59);
        return invoiceRepository.countByCreatedAtBetween(startOfDay, endOfDay);
    }
}
