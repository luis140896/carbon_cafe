-- Add split payment columns for MIXTO payment method
ALTER TABLE invoices ADD COLUMN IF NOT EXISTS cash_amount NUMERIC(12,2) DEFAULT 0;
ALTER TABLE invoices ADD COLUMN IF NOT EXISTS transfer_amount NUMERIC(12,2) DEFAULT 0;
