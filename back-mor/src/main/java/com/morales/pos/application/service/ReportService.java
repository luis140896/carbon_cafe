package com.morales.pos.application.service;

import com.morales.pos.application.dto.response.ReportResponse.*;
import com.morales.pos.domain.enums.InvoiceStatus;
import com.morales.pos.domain.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class ReportService {

    private final InvoiceRepository invoiceRepository;
    private final InvoiceDetailRepository invoiceDetailRepository;
    private final ProductRepository productRepository;
    private final InventoryRepository inventoryRepository;

    @Transactional(readOnly = true)
    public SalesSummary getSalesSummary(LocalDateTime start, LocalDateTime end) {
        BigDecimal totalSales = invoiceRepository.sumTotalByDateRangeAndStatus(start, end, InvoiceStatus.COMPLETADA);
        Long salesCount = invoiceRepository.countByCreatedAtBetweenAndStatus(start, end, InvoiceStatus.COMPLETADA);
        BigDecimal totalCost = invoiceDetailRepository.sumCostByDateRange(start, end);

        totalSales = totalSales != null ? totalSales : BigDecimal.ZERO;
        salesCount = salesCount != null ? salesCount : 0L;
        totalCost = totalCost != null ? totalCost : BigDecimal.ZERO;

        BigDecimal averageTicket = salesCount > 0 
            ? totalSales.divide(BigDecimal.valueOf(salesCount), 2, RoundingMode.HALF_UP)
            : BigDecimal.ZERO;

        BigDecimal grossProfit = totalSales.subtract(totalCost);
        BigDecimal profitMargin = totalSales.compareTo(BigDecimal.ZERO) > 0
            ? grossProfit.divide(totalSales, 4, RoundingMode.HALF_UP).multiply(BigDecimal.valueOf(100))
            : BigDecimal.ZERO;

        return SalesSummary.builder()
                .totalSales(totalSales)
                .salesCount(salesCount)
                .averageTicket(averageTicket)
                .totalCost(totalCost)
                .grossProfit(grossProfit)
                .profitMargin(profitMargin)
                .build();
    }

    @Transactional(readOnly = true)
    public SalesSummary getTodaySalesSummary() {
        LocalDateTime startOfDay = LocalDate.now().atStartOfDay();
        LocalDateTime endOfDay = LocalDate.now().atTime(23, 59, 59);
        return getSalesSummary(startOfDay, endOfDay);
    }

    @Transactional(readOnly = true)
    public SalesSummary getMonthSalesSummary() {
        LocalDateTime startOfMonth = LocalDate.now().withDayOfMonth(1).atStartOfDay();
        LocalDateTime endOfMonth = LocalDate.now().atTime(23, 59, 59);
        return getSalesSummary(startOfMonth, endOfMonth);
    }

    @Transactional(readOnly = true)
    public List<DailySales> getDailySales(LocalDate startDate, LocalDate endDate) {
        List<Object[]> results = invoiceRepository.getDailySales(
            startDate.atStartOfDay(), 
            endDate.atTime(23, 59, 59)
        );

        List<DailySales> dailySales = new ArrayList<>();
        for (Object[] row : results) {
            dailySales.add(DailySales.builder()
                    .date((LocalDate) row[0])
                    .total((BigDecimal) row[1])
                    .count(((Number) row[2]).longValue())
                    .build());
        }
        return dailySales;
    }

    @Transactional(readOnly = true)
    public List<DailySales> getLast7DaysSales() {
        return getDailySales(LocalDate.now().minusDays(6), LocalDate.now());
    }

    @Transactional(readOnly = true)
    public List<TopProduct> getTopProducts(LocalDateTime start, LocalDateTime end, int limit) {
        List<Object[]> results = invoiceDetailRepository.getTopProducts(start, end, limit);

        List<TopProduct> topProducts = new ArrayList<>();
        for (Object[] row : results) {
            topProducts.add(TopProduct.builder()
                    .productId(((Number) row[0]).longValue())
                    .productCode((String) row[1])
                    .productName((String) row[2])
                    .quantitySold((BigDecimal) row[3])
                    .totalRevenue((BigDecimal) row[4])
                    .build());
        }
        return topProducts;
    }

    @Transactional(readOnly = true)
    public List<TopCustomer> getTopCustomers(LocalDateTime start, LocalDateTime end, int limit) {
        List<Object[]> results = invoiceRepository.getTopCustomers(start, end, limit);

        List<TopCustomer> topCustomers = new ArrayList<>();
        for (Object[] row : results) {
            topCustomers.add(TopCustomer.builder()
                    .customerId(((Number) row[0]).longValue())
                    .customerName((String) row[1])
                    .purchaseCount(((Number) row[2]).longValue())
                    .totalSpent((BigDecimal) row[3])
                    .build());
        }
        return topCustomers;
    }

    @Transactional(readOnly = true)
    public List<SalesByCategory> getSalesByCategory(LocalDateTime start, LocalDateTime end) {
        List<Object[]> results = invoiceDetailRepository.getSalesByCategory(start, end);
        BigDecimal totalSales = results.stream()
                .map(r -> (BigDecimal) r[2])
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        List<SalesByCategory> salesByCategory = new ArrayList<>();
        for (Object[] row : results) {
            BigDecimal categoryTotal = (BigDecimal) row[2];
            BigDecimal percentage = totalSales.compareTo(BigDecimal.ZERO) > 0
                    ? categoryTotal.divide(totalSales, 4, RoundingMode.HALF_UP).multiply(BigDecimal.valueOf(100))
                    : BigDecimal.ZERO;

            salesByCategory.add(SalesByCategory.builder()
                    .categoryId(((Number) row[0]).longValue())
                    .categoryName((String) row[1])
                    .totalSales(categoryTotal)
                    .itemCount(((Number) row[3]).longValue())
                    .percentage(percentage)
                    .build());
        }
        return salesByCategory;
    }

    @Transactional(readOnly = true)
    public List<SalesByPaymentMethod> getSalesByPaymentMethod(LocalDateTime start, LocalDateTime end) {
        List<Object[]> results = invoiceRepository.getSalesByPaymentMethod(start, end);
        BigDecimal totalSales = results.stream()
                .map(r -> (BigDecimal) r[1])
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        List<SalesByPaymentMethod> salesByPayment = new ArrayList<>();
        for (Object[] row : results) {
            BigDecimal methodTotal = (BigDecimal) row[1];
            BigDecimal percentage = totalSales.compareTo(BigDecimal.ZERO) > 0
                    ? methodTotal.divide(totalSales, 4, RoundingMode.HALF_UP).multiply(BigDecimal.valueOf(100))
                    : BigDecimal.ZERO;

            String paymentMethodName = row[0] != null ? row[0].toString() : "DESCONOCIDO";

            salesByPayment.add(SalesByPaymentMethod.builder()
                    .paymentMethod(paymentMethodName)
                    .totalSales(methodTotal)
                    .count(((Number) row[2]).longValue())
                    .percentage(percentage)
                    .build());
        }
        return salesByPayment;
    }

    @Transactional(readOnly = true)
    public InventoryValue getInventoryValue() {
        BigDecimal totalCostValue = inventoryRepository.getTotalCostValue();
        BigDecimal totalSaleValue = inventoryRepository.getTotalSaleValue();
        Long totalProducts = productRepository.countByIsActiveTrue();
        Long lowStockProducts = (long) productRepository.findLowStockProducts().size();
        Long outOfStockProducts = (long) productRepository.findOutOfStockProducts().size();

        return InventoryValue.builder()
                .totalCostValue(totalCostValue != null ? totalCostValue : BigDecimal.ZERO)
                .totalSaleValue(totalSaleValue != null ? totalSaleValue : BigDecimal.ZERO)
                .totalProducts(totalProducts != null ? totalProducts : 0L)
                .lowStockProducts(lowStockProducts)
                .outOfStockProducts(outOfStockProducts)
                .build();
    }

    @Transactional(readOnly = true)
    public DashboardSummary getDashboardSummary() {
        LocalDateTime monthStart = LocalDate.now().withDayOfMonth(1).atStartOfDay();
        LocalDateTime now = LocalDateTime.now();

        return DashboardSummary.builder()
                .todaySales(getTodaySalesSummary())
                .monthSales(getMonthSalesSummary())
                .inventoryValue(getInventoryValue())
                .topProducts(getTopProducts(monthStart, now, 5))
                .last7DaysSales(getLast7DaysSales())
                .build();
    }
}
