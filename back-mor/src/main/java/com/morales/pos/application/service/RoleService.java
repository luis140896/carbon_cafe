package com.morales.pos.application.service;

import com.morales.pos.application.dto.request.CreateRoleRequest;
import com.morales.pos.application.dto.request.UpdateRoleRequest;
import com.morales.pos.application.dto.response.RoleResponse;
import com.morales.pos.domain.entity.Role;
import com.morales.pos.domain.repository.RoleRepository;
import com.morales.pos.domain.repository.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class RoleService {

    private final RoleRepository roleRepository;
    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public List<RoleResponse> findAll() {
        return roleRepository.findAll().stream()
                .map(RoleResponse::fromEntity)
                .toList();
    }

    @Transactional(readOnly = true)
    public RoleResponse findById(Long id) {
        Role role = roleRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Rol no encontrado con ID: " + id));
        return RoleResponse.fromEntity(role);
    }

    @Transactional
    public RoleResponse create(CreateRoleRequest request) {
        String name = request.getName() != null ? request.getName().trim().toUpperCase() : null;
        if (name == null || name.isBlank()) {
            throw new IllegalArgumentException("El nombre del rol es requerido");
        }
        if (roleRepository.existsByName(name)) {
            throw new IllegalArgumentException("Ya existe un rol con ese nombre");
        }

        Role role = Role.builder()
                .name(name)
                .description(request.getDescription())
                .permissions(request.getPermissions() != null ? request.getPermissions() : List.of())
                .isSystem(false)
                .build();

        Role saved = roleRepository.save(role);
        return RoleResponse.fromEntity(saved);
    }

    @Transactional
    public RoleResponse update(Long id, UpdateRoleRequest request) {
        Role role = roleRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Rol no encontrado con ID: " + id));

        if (request.getName() != null) {
            String nextName = request.getName().trim().toUpperCase();
            if (role.getIsSystem() != null && role.getIsSystem() && !nextName.equals(role.getName())) {
                throw new IllegalStateException("No se puede cambiar el nombre de un rol de sistema");
            }
            if (!nextName.equals(role.getName()) && roleRepository.existsByName(nextName)) {
                throw new IllegalArgumentException("Ya existe un rol con ese nombre");
            }
            role.setName(nextName);
        }

        if (request.getDescription() != null) {
            role.setDescription(request.getDescription());
        }

        if (request.getPermissions() != null) {
            role.setPermissions(request.getPermissions());
        }

        Role saved = roleRepository.save(role);
        return RoleResponse.fromEntity(saved);
    }

    @Transactional
    public void delete(Long id) {
        Role role = roleRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Rol no encontrado con ID: " + id));

        if (role.getIsSystem() != null && role.getIsSystem()) {
            throw new IllegalStateException("No se puede eliminar un rol de sistema");
        }

        long users = userRepository.countByRoleId(id);
        if (users > 0) {
            throw new IllegalStateException("No se puede eliminar el rol porque tiene " + users + " usuario(s) asociado(s)");
        }

        roleRepository.delete(role);
    }
}
