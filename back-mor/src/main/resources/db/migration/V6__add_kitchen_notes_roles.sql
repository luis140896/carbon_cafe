-- =====================================================
-- SISTEMA POS MORALES - Migración V6
-- Notas/Exigencias por producto, Estado de cocina, Roles nuevos
-- =====================================================

-- Agregar campo de notas (exigencias) por detalle de factura
ALTER TABLE invoice_details ADD COLUMN notes VARCHAR(500);

-- Agregar estado de cocina por detalle
ALTER TABLE invoice_details ADD COLUMN kitchen_status VARCHAR(30) DEFAULT 'PENDIENTE';

-- Índice para consultas de cocina
CREATE INDEX idx_invoice_details_kitchen_status ON invoice_details(kitchen_status);

-- =====================================================
-- ROLES: MESERO y COCINERO
-- =====================================================

INSERT INTO roles (name, description, permissions, is_system, created_at, updated_at)
VALUES (
    'MESERO',
    'Mesero - puede abrir mesas, agregar productos y notas',
    '["tables.view","tables.open","tables.add_items","tables.add_notes","products.view","categories.view","customers.view"]'::jsonb,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
)
ON CONFLICT (name) DO NOTHING;

INSERT INTO roles (name, description, permissions, is_system, created_at, updated_at)
VALUES (
    'COCINERO',
    'Cocinero - ve pedidos pendientes con exigencias, actualiza estado',
    '["kitchen.view","kitchen.update_status"]'::jsonb,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
)
ON CONFLICT (name) DO NOTHING;
