package com.morales.pos.application.service;

import com.morales.pos.domain.entity.CompanyConfig;
import com.morales.pos.domain.repository.CompanyConfigRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class CompanyConfigService {

    private final CompanyConfigRepository configRepository;

    @Transactional(readOnly = true)
    public CompanyConfig getConfig() {
        return configRepository.findAll().stream()
                .findFirst()
                .orElseThrow(() -> new EntityNotFoundException("Configuración de empresa no encontrada"));
    }

    @Transactional
    public CompanyConfig updateConfig(CompanyConfig updates) {
        CompanyConfig config = getConfig();

        if (updates.getCompanyName() != null) config.setCompanyName(updates.getCompanyName());
        if (updates.getLegalName() != null) config.setLegalName(updates.getLegalName());
        if (updates.getTaxId() != null) config.setTaxId(updates.getTaxId());
        if (updates.getLogoUrl() != null) config.setLogoUrl(updates.getLogoUrl());
        if (updates.getPrimaryColor() != null) config.setPrimaryColor(updates.getPrimaryColor());
        if (updates.getSecondaryColor() != null) config.setSecondaryColor(updates.getSecondaryColor());
        if (updates.getAccentColor() != null) config.setAccentColor(updates.getAccentColor());
        if (updates.getBackgroundColor() != null) config.setBackgroundColor(updates.getBackgroundColor());
        if (updates.getCardColor() != null) config.setCardColor(updates.getCardColor());
        if (updates.getSidebarColor() != null) config.setSidebarColor(updates.getSidebarColor());
        if (updates.getBusinessType() != null) config.setBusinessType(updates.getBusinessType());
        if (updates.getCurrency() != null) config.setCurrency(updates.getCurrency());
        if (updates.getTaxRate() != null) config.setTaxRate(updates.getTaxRate());
        if (updates.getAddress() != null) config.setAddress(updates.getAddress());
        if (updates.getPhone() != null) config.setPhone(updates.getPhone());
        if (updates.getEmail() != null) config.setEmail(updates.getEmail());

        return configRepository.save(config);
    }
}
