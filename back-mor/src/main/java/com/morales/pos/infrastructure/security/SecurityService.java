package com.morales.pos.infrastructure.security;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Service;

@Service("securityService")
public class SecurityService {

    /**
     * Verifica si la autenticación actual tiene un permiso con soporte para wildcards.
     * Soporta tanto notación punto (pos.sell) como notación dos puntos (pos:sell).
     * Un permiso terminado en .* o :* concede todo el prefijo.
     *
     * Ejemplos:
     *  - requerido "pos.sell", concedido "pos:*"   -> true
     *  - requerido "invoices.read", concedido "*" -> true
     *  - requerido "users.manage", concedido "users.read" -> false
     */
    public boolean hasPermission(Authentication authentication, String permission) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return false;
        }

        String required = normalize(permission);
        return authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .map(SecurityService::normalize)
                .anyMatch(granted -> matches(required, granted));
    }

    private static String normalize(String permission) {
        return permission == null ? "" : permission.replace(':', '.').trim();
    }

    private static boolean matches(String required, String granted) {
        if (granted.isEmpty() || required.isEmpty()) {
            return false;
        }
        if (granted.equals("*") || granted.equals(".*")) {
            return true;
        }
        if (granted.endsWith(".*")) {
            String prefix = granted.substring(0, granted.length() - 2);
            return required.equals(prefix) || required.startsWith(prefix + ".");
        }
        return granted.equals(required);
    }
}
