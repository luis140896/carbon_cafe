-- Add card_color and sidebar_color columns to company_config
ALTER TABLE company_config ADD COLUMN IF NOT EXISTS card_color VARCHAR(7) DEFAULT '#ffffff';
ALTER TABLE company_config ADD COLUMN IF NOT EXISTS sidebar_color VARCHAR(7) DEFAULT '#ffffff';
