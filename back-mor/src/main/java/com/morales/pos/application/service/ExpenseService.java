package com.morales.pos.application.service;

import com.morales.pos.application.dto.request.ExpenseRequest;
import com.morales.pos.application.dto.response.ExpenseResponse;
import com.morales.pos.domain.entity.Expense;
import com.morales.pos.domain.entity.User;
import com.morales.pos.domain.repository.ExpenseRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ExpenseService {

    private final ExpenseRepository expenseRepository;

    @Transactional(readOnly = true)
    public List<ExpenseResponse> getByDateRange(LocalDate start, LocalDate end) {
        return expenseRepository
                .findByExpenseDateBetweenOrderByExpenseDateDescCreatedAtDesc(start, end)
                .stream()
                .map(ExpenseResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional
    public ExpenseResponse create(ExpenseRequest request, User user) {
        Expense expense = Expense.builder()
                .expenseDate(request.getExpenseDate())
                .description(request.getDescription().trim())
                .category(request.getCategory().trim().toUpperCase())
                .amount(request.getAmount())
                .paymentMethod(request.getPaymentMethod())
                .notes(request.getNotes())
                .createdBy(user)
                .build();
        return ExpenseResponse.fromEntity(expenseRepository.save(expense));
    }

    @Transactional
    public ExpenseResponse update(Long id, ExpenseRequest request) {
        Expense expense = expenseRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Gasto no encontrado: " + id));

        expense.setExpenseDate(request.getExpenseDate());
        expense.setDescription(request.getDescription().trim());
        expense.setCategory(request.getCategory().trim().toUpperCase());
        expense.setAmount(request.getAmount());
        expense.setPaymentMethod(request.getPaymentMethod());
        expense.setNotes(request.getNotes());

        return ExpenseResponse.fromEntity(expenseRepository.save(expense));
    }

    @Transactional
    public void delete(Long id) {
        if (!expenseRepository.existsById(id)) {
            throw new EntityNotFoundException("Gasto no encontrado: " + id);
        }
        expenseRepository.deleteById(id);
    }
}
