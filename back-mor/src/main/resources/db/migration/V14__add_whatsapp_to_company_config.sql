-- Add whatsapp column to company_config for printed invoice contact
ALTER TABLE company_config ADD COLUMN IF NOT EXISTS whatsapp VARCHAR(50);
