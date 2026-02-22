package com.morales.pos.application.service;

import com.morales.pos.application.dto.request.*;
import com.morales.pos.application.dto.response.InvoiceResponse;
import com.morales.pos.application.dto.response.TableResponse;
import com.morales.pos.application.dto.response.TableSessionResponse;
import com.morales.pos.domain.entity.*;
import com.morales.pos.domain.enums.*;
import com.morales.pos.domain.repository.*;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

@Service
@RequiredArgsConstructor
@Slf4j
public class TableService {

    private final RestaurantTableRepository tableRepository;
    private final TableSessionRepository sessionRepository;
    private final InvoiceRepository invoiceRepository;
    private final InvoiceDetailRepository invoiceDetailRepository;
    private final KitchenOrderService kitchenOrderService;
    private final KitchenOrderRepository kitchenOrderRepository;
    private final CustomerRepository customerRepository;
    private final ProductRepository productRepository;
    private final InventoryService inventoryService;
    private final SseService sseService;

    // ==================== TABLE CRUD ====================

    @Transactional(readOnly = true)
    public List<TableResponse> findAllTables() {
        List<RestaurantTable> tables = tableRepository.findByIsActiveTrueOrderByDisplayOrderAscTableNumberAsc();
        return tables.stream().map(table -> {
            TableSessionResponse session = sessionRepository.findActiveByTableId(table.getId())
                    .map(TableSessionResponse::fromEntity)
                    .orElse(null);
            return TableResponse.fromEntity(table, session);
        }).collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public TableResponse findTableById(Long id) {
        RestaurantTable table = findTableEntity(id);
        TableSessionResponse session = sessionRepository.findActiveByTableId(id)
                .map(s -> TableSessionResponse.fromEntity(s, true))
                .orElse(null);
        return TableResponse.fromEntity(table, session);
    }

    @Transactional
    public TableResponse createTable(CreateTableRequest request) {
        if (tableRepository.existsByTableNumber(request.getTableNumber())) {
            throw new IllegalArgumentException("Ya existe una mesa con el número " + request.getTableNumber());
        }

        Integer displayOrder = request.getDisplayOrder();
        if (displayOrder == null) {
            Integer max = tableRepository.findMaxTableNumber();
            displayOrder = max != null ? max + 1 : 1;
        }

        RestaurantTable table = RestaurantTable.builder()
                .tableNumber(request.getTableNumber())
                .name(request.getName() != null ? request.getName() : "Mesa " + request.getTableNumber())
                .capacity(request.getCapacity())
                .zone(request.getZone() != null ? request.getZone() : "INTERIOR")
                .displayOrder(displayOrder)
                .build();

        RestaurantTable saved = tableRepository.save(table);
        log.info("Mesa creada: #{}", saved.getTableNumber());
        return TableResponse.fromEntity(saved);
    }

    @Transactional
    public TableResponse updateTable(Long id, UpdateTableRequest request) {
        RestaurantTable table = findTableEntity(id);

        if (request.getTableNumber() != null && !request.getTableNumber().equals(table.getTableNumber())) {
            if (tableRepository.existsByTableNumber(request.getTableNumber())) {
                throw new IllegalArgumentException("Ya existe una mesa con el número " + request.getTableNumber());
            }
            table.setTableNumber(request.getTableNumber());
        }
        if (request.getName() != null) table.setName(request.getName());
        if (request.getCapacity() != null) table.setCapacity(request.getCapacity());
        if (request.getZone() != null) table.setZone(request.getZone());
        if (request.getDisplayOrder() != null) table.setDisplayOrder(request.getDisplayOrder());
        if (request.getIsActive() != null) table.setIsActive(request.getIsActive());

        RestaurantTable saved = tableRepository.save(table);
        log.info("Mesa actualizada: #{}", saved.getTableNumber());
        return TableResponse.fromEntity(saved);
    }

    @Transactional
    public void deleteTable(Long id) {
        RestaurantTable table = findTableEntity(id);
        if (table.getStatus() == TableStatus.OCUPADA) {
            throw new IllegalArgumentException("No se puede eliminar una mesa ocupada");
        }
        table.setIsActive(false);
        tableRepository.save(table);
        log.info("Mesa desactivada: #{}", table.getTableNumber());
    }

    @Transactional
    public TableResponse changeTableStatus(Long id, String newStatus) {
        RestaurantTable table = findTableEntity(id);
        TableStatus status = TableStatus.valueOf(newStatus);

        if (table.getStatus() == TableStatus.OCUPADA && status != TableStatus.FUERA_DE_SERVICIO) {
            throw new IllegalArgumentException("No se puede cambiar el estado de una mesa ocupada. Cierre primero la sesión.");
        }

        table.setStatus(status);
        RestaurantTable saved = tableRepository.save(table);
        log.info("Mesa #{} cambió a estado: {}", table.getTableNumber(), status);
        return TableResponse.fromEntity(saved);
    }

    // ==================== TABLE SESSIONS ====================

    @Transactional
    public TableSessionResponse openTable(Long tableId, OpenTableRequest request, User user) {
        RestaurantTable table = findTableEntity(tableId);

        if (table.getStatus() == TableStatus.OCUPADA) {
            throw new IllegalArgumentException("La mesa #" + table.getTableNumber() + " ya está ocupada");
        }
        if (table.getStatus() == TableStatus.FUERA_DE_SERVICIO) {
            throw new IllegalArgumentException("La mesa #" + table.getTableNumber() + " está fuera de servicio");
        }

        // Verify no active session exists (double check)
        if (sessionRepository.existsByRestaurantTableIdAndStatus(tableId, TableSessionStatus.ABIERTA)) {
            throw new IllegalArgumentException("La mesa ya tiene una sesión abierta");
        }

        // Resolve customer if provided
        Customer customer = null;
        if (request.getCustomerId() != null) {
            customer = customerRepository.findById(request.getCustomerId())
                    .orElseThrow(() -> new EntityNotFoundException("Cliente no encontrado"));
        }

        // Create an ABIERTA invoice for this table session
        String invoiceNumber = generateTableInvoiceNumber(table.getTableNumber());
        Invoice invoice = Invoice.builder()
                .invoiceNumber(invoiceNumber)
                .invoiceType(InvoiceType.VENTA)
                .customer(customer)
                .user(user)
                .status(InvoiceStatus.ABIERTA)
                .paymentStatus(PaymentStatus.PENDIENTE)
                .build();
        Invoice savedInvoice = invoiceRepository.save(invoice);

        // Create session
        TableSession session = TableSession.builder()
                .restaurantTable(table)
                .invoice(savedInvoice)
                .openedBy(user)
                .openedAt(LocalDateTime.now())
                .guestCount(request.getGuestCount())
                .notes(request.getNotes())
                .status(TableSessionStatus.ABIERTA)
                .build();
        TableSession savedSession = sessionRepository.save(session);

        // Mark table as occupied
        table.setStatus(TableStatus.OCUPADA);
        tableRepository.save(table);

        log.info("Mesa #{} abierta por {} - Factura: {}", table.getTableNumber(), user.getFullName(), invoiceNumber);
        return TableSessionResponse.fromEntity(savedSession, true);
    }

    @Transactional
    public TableSessionResponse addItemsToTable(Long tableId, AddTableItemsRequest request, User user) {
        TableSession session = findActiveSession(tableId);
        Invoice invoice = session.getInvoice();

        if (invoice == null) {
            throw new IllegalStateException("La sesión no tiene una factura asociada");
        }

        Integer batchSequence = kitchenOrderService.getNextSequenceNumberForTable(session.getRestaurantTable().getId());
        LocalDateTime batchOrderTime = LocalDateTime.now();
        boolean isPriorityBatch = Boolean.TRUE.equals(request.getPriority());
        String priorityReason = request.getPriorityReason() != null ? request.getPriorityReason().trim() : null;
        if (priorityReason != null && priorityReason.isEmpty()) {
            priorityReason = null;
        }

        for (AddTableItemsRequest.TableItemRequest item : request.getItems()) {
            Product product = productRepository.findById(item.getProductId())
                    .orElseThrow(() -> new EntityNotFoundException("Producto no encontrado: " + item.getProductId()));

            if (!product.getIsActive()) {
                throw new IllegalArgumentException("El producto '" + product.getName() + "' no está activo");
            }

            // Validate stock
            Inventory inventory = inventoryService.findEntityByProductId(product.getId());
            if (inventory.getQuantity().compareTo(item.getQuantity()) < 0) {
                throw new IllegalArgumentException(
                        String.format("Stock insuficiente para %s. Disponible: %s, Solicitado: %s",
                                product.getName(), inventory.getQuantity(), item.getQuantity()));
            }

            BigDecimal discountAmt = item.getDiscountAmount() != null ? item.getDiscountAmount() : BigDecimal.ZERO;

            // Check if this product already exists in the active invoice — if so, merge quantities
            java.util.Optional<InvoiceDetail> existingDetailOpt =
                    invoiceDetailRepository.findByInvoiceIdAndProductId(invoice.getId(), product.getId());

            InvoiceDetail savedDetail;
            if (existingDetailOpt.isPresent()) {
                // Merge: increment quantity on the existing line
                InvoiceDetail existing = existingDetailOpt.get();
                BigDecimal newQty = existing.getQuantity().add(item.getQuantity());
                existing.setQuantity(newQty);

                BigDecimal lineSubtotal = existing.getUnitPrice().multiply(newQty).subtract(existing.getDiscountAmount());
                BigDecimal lineTax = lineSubtotal.multiply(product.getTaxRate().divide(BigDecimal.valueOf(100)));
                existing.setSubtotal(lineSubtotal);
                existing.setTaxAmount(lineTax);

                // Append notes if provided
                if (item.getNotes() != null && !item.getNotes().isBlank()) {
                    String prevNotes = existing.getNotes() != null ? existing.getNotes() + " | " : "";
                    existing.setNotes(prevNotes + item.getNotes());
                }

                savedDetail = invoiceDetailRepository.save(existing);
            } else {
                // New product line
                InvoiceDetail detail = InvoiceDetail.builder()
                        .invoice(invoice)
                        .product(product)
                        .productName(product.getName())
                        .quantity(item.getQuantity())
                        .unitPrice(item.getUnitPrice())
                        .costPrice(product.getCostPrice())
                        .discountAmount(discountAmt)
                        .notes(item.getNotes())
                        .build();

                BigDecimal lineSubtotal = detail.getUnitPrice().multiply(detail.getQuantity()).subtract(discountAmt);
                BigDecimal lineTax = lineSubtotal.multiply(product.getTaxRate().divide(BigDecimal.valueOf(100)));
                detail.setSubtotal(lineSubtotal);
                detail.setTaxAmount(lineTax);

                savedDetail = invoiceDetailRepository.save(detail);
                invoice.addDetail(savedDetail);
            }

            // Create kitchen order for this batch (always, even on merge — cocina necesita saber del nuevo pedido)
            try {
                kitchenOrderService.createKitchenOrder(
                        savedDetail,
                        session.getRestaurantTable(),
                        batchOrderTime,
                        batchSequence,
                        isPriorityBatch,
                        priorityReason
                );
            } catch (Exception e) {
                log.error("Error creating kitchen order for detail {}: {}", savedDetail.getId(), e.getMessage());
            }

            // Deduct stock immediately
            inventoryService.removeStock(
                    product.getId(),
                    item.getQuantity(),
                    "Mesa #" + session.getRestaurantTable().getTableNumber() + " - " + invoice.getInvoiceNumber(),
                    user
            );
        }

        // Recalculate totals from all details (handles both new items and merged items correctly)
        List<InvoiceDetail> allDetails = invoiceDetailRepository.findByInvoiceId(invoice.getId());
        BigDecimal subtotal = allDetails.stream().map(InvoiceDetail::getSubtotal).reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal taxAmount = allDetails.stream().map(InvoiceDetail::getTaxAmount).reduce(BigDecimal.ZERO, BigDecimal::add);

        invoice.setSubtotal(subtotal);
        invoice.setTaxAmount(taxAmount);
        invoice.setTotal(subtotal.add(taxAmount).subtract(
                invoice.getDiscountAmount() != null ? invoice.getDiscountAmount() : BigDecimal.ZERO));
        invoiceRepository.save(invoice);

        // Flush to ensure details are persisted and visible
        invoiceRepository.flush();

        log.info("Items agregados a Mesa #{} - {} items", session.getRestaurantTable().getTableNumber(), request.getItems().size());

        // Broadcast SSE event for kitchen
        try {
            sseService.broadcast("new_order", Map.of(
                    "type", "NEW_TABLE_ITEMS",
                    "tableNumber", session.getRestaurantTable().getTableNumber(),
                    "invoiceId", invoice.getId(),
                    "invoiceNumber", invoice.getInvoiceNumber()
            ));
        } catch (Exception e) {
            log.warn("Error broadcasting SSE event: {}", e.getMessage());
        }

        return TableSessionResponse.fromEntity(session, true);
    }

    @Transactional
    public TableSessionResponse removeItemFromTable(Long tableId, Long detailId, User user) {
        TableSession session = findActiveSession(tableId);
        Invoice invoice = session.getInvoice();

        InvoiceDetail detail = invoiceDetailRepository.findById(detailId)
                .orElseThrow(() -> new EntityNotFoundException("Detalle no encontrado: " + detailId));

        if (!detail.getInvoice().getId().equals(invoice.getId())) {
            throw new IllegalArgumentException("El detalle no pertenece a esta mesa");
        }

        // Restore stock
        inventoryService.addStock(
                detail.getProduct().getId(),
                detail.getQuantity(),
                "Eliminado de Mesa #" + session.getRestaurantTable().getTableNumber(),
                user
        );

        // Recalculate totals
        BigDecimal subtotal = invoice.getSubtotal().subtract(detail.getSubtotal());
        BigDecimal taxAmount = invoice.getTaxAmount().subtract(detail.getTaxAmount());

        // Remove from in-memory collection and delete
        invoice.getDetails().remove(detail);
        invoiceDetailRepository.delete(detail);

        invoice.setSubtotal(subtotal);
        invoice.setTaxAmount(taxAmount);
        invoice.setTotal(subtotal.add(taxAmount).subtract(
                invoice.getDiscountAmount() != null ? invoice.getDiscountAmount() : BigDecimal.ZERO));
        invoiceRepository.save(invoice);
        invoiceRepository.flush();

        log.info("Item eliminado de Mesa #{}", session.getRestaurantTable().getTableNumber());
        return TableSessionResponse.fromEntity(session, true);
    }

    @Transactional
    public InvoiceResponse payTable(Long tableId, PayTableRequest request, User user) {
        TableSession session = findActiveSession(tableId);
        Invoice invoice = session.getInvoice();

        if (invoice.getDetails() == null || invoice.getDetails().isEmpty()) {
            throw new IllegalArgumentException("No se puede pagar una venta sin productos");
        }

        // Apply discount if provided
        if (request.getDiscountPercent() != null && request.getDiscountPercent().compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal discountAmount = invoice.getSubtotal()
                    .multiply(request.getDiscountPercent())
                    .divide(BigDecimal.valueOf(100), 2, java.math.RoundingMode.HALF_UP);
            invoice.setDiscountPercent(request.getDiscountPercent());
            invoice.setDiscountAmount(discountAmount);
            invoice.setTotal(invoice.getSubtotal().add(invoice.getTaxAmount()).subtract(discountAmount));
        }

        // Apply service charge if provided (e.g. 10%)
        BigDecimal serviceChargePercent = request.getServiceChargePercent() != null ? request.getServiceChargePercent() : BigDecimal.ZERO;
        if (serviceChargePercent.compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal serviceChargeAmount = invoice.getTotal()
                    .multiply(serviceChargePercent)
                    .divide(BigDecimal.valueOf(100), 2, java.math.RoundingMode.HALF_UP);
            invoice.setServiceChargePercent(serviceChargePercent);
            invoice.setServiceChargeAmount(serviceChargeAmount);
            invoice.setTotal(invoice.getTotal().add(serviceChargeAmount));
        }

        // Apply delivery charge if provided
        BigDecimal deliveryChargeAmount = request.getDeliveryChargeAmount() != null ? request.getDeliveryChargeAmount() : BigDecimal.ZERO;
        if (deliveryChargeAmount.compareTo(BigDecimal.ZERO) > 0) {
            invoice.setDeliveryChargeAmount(deliveryChargeAmount);
            invoice.setTotal(invoice.getTotal().add(deliveryChargeAmount));
        }

        // Process payment
        invoice.setPaymentMethod(PaymentMethod.valueOf(request.getPaymentMethod()));
        invoice.setAmountReceived(request.getAmountReceived());
        invoice.setChangeAmount(request.getAmountReceived().subtract(invoice.getTotal()));
        invoice.setStatus(InvoiceStatus.COMPLETADA);
        invoice.setPaymentStatus(PaymentStatus.PAGADO);
        if (request.getNotes() != null) {
            invoice.setNotes(request.getNotes());
        }

        Invoice savedInvoice = invoiceRepository.save(invoice);

        // Close session
        session.setStatus(TableSessionStatus.CERRADA);
        session.setClosedAt(LocalDateTime.now());
        session.setClosedBy(user);
        sessionRepository.save(session);

        // Free the table
        RestaurantTable table = session.getRestaurantTable();
        table.setStatus(TableStatus.DISPONIBLE);
        tableRepository.save(table);

        // Mark all kitchen items as ENTREGADO (InvoiceDetail + KitchenOrder)
        if (savedInvoice.getDetails() != null && !savedInvoice.getDetails().isEmpty()) {
            List<Long> detailIds = savedInvoice.getDetails().stream()
                    .map(InvoiceDetail::getId)
                    .collect(Collectors.toList());

            // Update InvoiceDetail kitchen status
            for (InvoiceDetail d : savedInvoice.getDetails()) {
                d.setKitchenStatus(KitchenStatus.ENTREGADO);
            }
            invoiceRepository.save(savedInvoice);

            // Update KitchenOrder status so they disappear from kitchen display
            List<KitchenOrder> kitchenOrders = kitchenOrderRepository.findByInvoiceDetailIdIn(detailIds);
            for (KitchenOrder ko : kitchenOrders) {
                ko.setStatus(KitchenStatus.ENTREGADO);
            }
            if (!kitchenOrders.isEmpty()) {
                kitchenOrderRepository.saveAll(kitchenOrders);
            }
        }

        log.info("Mesa #{} pagada - Total: {} - Método: {}",
                table.getTableNumber(), savedInvoice.getTotal(), request.getPaymentMethod());

        // Broadcast SSE event
        try {
            sseService.broadcast("order_paid", Map.of(
                    "type", "ORDER_PAID",
                    "invoiceId", savedInvoice.getId(),
                    "tableNumber", table.getTableNumber()
            ));
        } catch (Exception e) {
            log.warn("Error broadcasting SSE event: {}", e.getMessage());
        }

        return InvoiceResponse.fromEntity(savedInvoice);
    }

    @Transactional
    public TableResponse releaseTable(Long tableId, User user) {
        TableSession session = findActiveSession(tableId);
        Invoice invoice = session.getInvoice();

        // Only allow release if no items have been added
        if (invoice.getDetails() != null && !invoice.getDetails().isEmpty()) {
            throw new IllegalArgumentException("No se puede liberar una mesa con productos. Use la opción de pagar o eliminar los productos primero.");
        }

        // Free the table first
        RestaurantTable table = session.getRestaurantTable();
        table.setStatus(TableStatus.DISPONIBLE);
        tableRepository.save(table);

        // Close session
        session.setStatus(TableSessionStatus.CERRADA);
        session.setClosedAt(LocalDateTime.now());
        session.setClosedBy(user);
        sessionRepository.save(session);

        // Mark invoice as cancelled
        invoice.setStatus(InvoiceStatus.ANULADA);
        invoice.setVoidReason("Mesa liberada sin pedido");
        invoiceRepository.save(invoice);

        log.info("Mesa #{} liberada por {} (sin pedido)", table.getTableNumber(), user.getFullName());
        return TableResponse.fromEntity(table);
    }

    @Transactional(readOnly = true)
    public TableSessionResponse getActiveSession(Long tableId) {
        return sessionRepository.findActiveByTableId(tableId)
                .map(s -> TableSessionResponse.fromEntity(s, true))
                .orElseThrow(() -> new EntityNotFoundException(
                        "No hay sesión activa para la mesa con ID: " + tableId));
    }

    @Transactional(readOnly = true)
    public List<TableSessionResponse> getActiveSessions() {
        return sessionRepository.findAllActive().stream()
                .map(TableSessionResponse::fromEntity)
                .collect(Collectors.toList());
    }

    // ==================== HELPERS ====================

    private RestaurantTable findTableEntity(Long id) {
        return tableRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Mesa no encontrada con ID: " + id));
    }

    private TableSession findActiveSession(Long tableId) {
        return sessionRepository.findActiveByTableId(tableId)
                .orElseThrow(() -> new EntityNotFoundException(
                        "No hay sesión activa para la mesa con ID: " + tableId));
    }

    private String generateTableInvoiceNumber(Integer tableNumber) {
        String prefix = "M" + tableNumber + "-";
        String datePart = java.time.LocalDate.now().format(java.time.format.DateTimeFormatter.ofPattern("MMdd"));
        Long count = invoiceRepository.countByInvoiceNumberStartingWith(prefix + datePart) + 1;
        return String.format("%s%s-%04d", prefix, datePart, count);
    }
}
