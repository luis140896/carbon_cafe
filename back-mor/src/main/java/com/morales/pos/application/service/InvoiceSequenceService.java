package com.morales.pos.application.service;

import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class InvoiceSequenceService {

    private final EntityManager entityManager;

    /**
     * Retorna el siguiente número atómico para un prefijo dado, usando
     * INSERT ... ON CONFLICT ... RETURNING de PostgreSQL.
     * Garantiza numeración única bajo concurrencia.
     */
    @Transactional
    public Long nextValue(String prefix) {
        Object result = entityManager.createNativeQuery(
                        "INSERT INTO invoice_sequences (prefix, next_value, updated_at) " +
                        "VALUES (:prefix, 1, CURRENT_TIMESTAMP) " +
                        "ON CONFLICT (prefix) DO UPDATE " +
                        "SET next_value = invoice_sequences.next_value + 1, updated_at = CURRENT_TIMESTAMP " +
                        "RETURNING next_value")
                .setParameter("prefix", prefix)
                .getSingleResult();
        return ((Number) result).longValue();
    }
}
