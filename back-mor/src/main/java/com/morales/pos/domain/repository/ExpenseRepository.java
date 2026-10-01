package com.morales.pos.domain.repository;

import com.morales.pos.domain.entity.Expense;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface ExpenseRepository extends JpaRepository<Expense, Long> {

    List<Expense> findByExpenseDateBetweenOrderByExpenseDateDescCreatedAtDesc(LocalDate start, LocalDate end);

    @Query("SELECT e.expenseDate, SUM(e.amount) FROM Expense e " +
           "WHERE e.expenseDate BETWEEN :start AND :end " +
           "GROUP BY e.expenseDate ORDER BY e.expenseDate")
    List<Object[]> sumByDateRange(@Param("start") LocalDate start, @Param("end") LocalDate end);
}
