package com.morales.pos.application.dto.response;

import com.morales.pos.domain.entity.Expense;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ExpenseResponse {

    private Long id;
    private LocalDate expenseDate;
    private String description;
    private String category;
    private BigDecimal amount;
    private String paymentMethod;
    private String notes;
    private Long createdById;
    private String createdByName;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static ExpenseResponse fromEntity(Expense expense) {
        ExpenseResponseBuilder builder = ExpenseResponse.builder()
                .id(expense.getId())
                .expenseDate(expense.getExpenseDate())
                .description(expense.getDescription())
                .category(expense.getCategory())
                .amount(expense.getAmount())
                .paymentMethod(expense.getPaymentMethod())
                .notes(expense.getNotes())
                .createdAt(expense.getCreatedAt())
                .updatedAt(expense.getUpdatedAt());

        if (expense.getCreatedBy() != null) {
            builder.createdById(expense.getCreatedBy().getId())
                   .createdByName(expense.getCreatedBy().getFullName());
        }

        return builder.build();
    }
}
