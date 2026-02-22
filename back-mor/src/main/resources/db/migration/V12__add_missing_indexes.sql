-- =====================================================
-- SISTEMA POS MORALES - Migración V12
-- Índices de rendimiento faltantes identificados en análisis
-- =====================================================

-- Cocina: acelerar consulta de pedidos activos ordenados por tiempo
CREATE INDEX IF NOT EXISTS idx_kitchen_orders_status_ordertime
    ON kitchen_orders(status, order_time ASC);

-- Cocina: acelerar agrupación por mesa y número de lote
CREATE INDEX IF NOT EXISTS idx_kitchen_orders_table_sequence
    ON kitchen_orders(table_id, sequence_number);

-- Inventario: acelerar consultas de stock bajo y sin stock
CREATE INDEX IF NOT EXISTS idx_inventory_quantity_minstock
    ON inventory(quantity, min_stock);

-- Facturas: acelerar filtros por fecha y estado (reportes, dashboard)
CREATE INDEX IF NOT EXISTS idx_invoices_created_status
    ON invoices(created_at, status);

-- Facturas: acelerar búsqueda por cliente
CREATE INDEX IF NOT EXISTS idx_invoices_customer_id
    ON invoices(customer_id);
