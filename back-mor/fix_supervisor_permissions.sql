-- Script para actualizar permisos del rol SUPERVISOR
-- Ejecutar en PostgreSQL (base morales_pos)

UPDATE roles 
SET permissions = '["pos:*", "invoices:*", "products:read", "customers:*", "reports:*", "users:*", "roles:read", "tables:*", "settings:view", "promotions:manage"]'::jsonb
WHERE name = 'SUPERVISOR';

-- Verificar cambios
SELECT name, permissions FROM roles WHERE name = 'SUPERVISOR';
