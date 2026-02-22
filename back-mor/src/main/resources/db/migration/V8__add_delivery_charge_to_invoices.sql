-- Agregar campo de cargo por domicilio a facturas
ALTER TABLE invoices ADD COLUMN delivery_charge_amount DECIMAL(12,2) DEFAULT 0;
