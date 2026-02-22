-- Add service charge columns to invoices table
ALTER TABLE invoices ADD COLUMN IF NOT EXISTS service_charge_percent DECIMAL(5,2) DEFAULT 0;
ALTER TABLE invoices ADD COLUMN IF NOT EXISTS service_charge_amount DECIMAL(12,2) DEFAULT 0;
