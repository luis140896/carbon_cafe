package com.morales.pos.domain.repository;

import com.morales.pos.domain.entity.InvoiceSequence;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface InvoiceSequenceRepository extends JpaRepository<InvoiceSequence, String> {
}
