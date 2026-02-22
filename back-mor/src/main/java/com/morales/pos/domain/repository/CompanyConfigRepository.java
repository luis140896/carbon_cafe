package com.morales.pos.domain.repository;

import com.morales.pos.domain.entity.CompanyConfig;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CompanyConfigRepository extends JpaRepository<CompanyConfig, Long> {
}
