-- V10: Add performance indexes for optimized queries
-- Created: 2026-02-16
-- Purpose: Improve query performance on critical tables

-- Invoice details indexes
CREATE INDEX IF NOT EXISTS idx_invoice_details_invoice_id ON invoice_details(invoice_id);
CREATE INDEX IF NOT EXISTS idx_invoice_details_product_id ON invoice_details(product_id);
CREATE INDEX IF NOT EXISTS idx_invoice_details_kitchen_status ON invoice_details(kitchen_status) WHERE kitchen_status IS NOT NULL;

-- Invoices compound index for common queries
CREATE INDEX IF NOT EXISTS idx_invoices_status_created ON invoices(status, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_invoices_customer_created ON invoices(customer_id, created_at DESC) WHERE customer_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_invoices_user_created ON invoices(user_id, created_at DESC);

-- Products indexes for filtering
CREATE INDEX IF NOT EXISTS idx_products_category_active ON products(category_id, is_active);
CREATE INDEX IF NOT EXISTS idx_products_active ON products(is_active) WHERE is_active = true;

-- Categories index
CREATE INDEX IF NOT EXISTS idx_categories_parent_active ON categories(parent_id, is_active) WHERE parent_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_categories_active ON categories(is_active, display_order) WHERE is_active = true;

-- Table sessions for quick lookups
CREATE INDEX IF NOT EXISTS idx_table_sessions_status ON table_sessions(status);
CREATE INDEX IF NOT EXISTS idx_table_sessions_table_status ON table_sessions(table_id, status);

-- Notifications index
CREATE INDEX IF NOT EXISTS idx_notifications_read_created ON notifications(is_read, created_at DESC);

-- Inventory index
CREATE INDEX IF NOT EXISTS idx_inventory_product ON inventory(product_id);
CREATE INDEX IF NOT EXISTS idx_inventory_low_stock ON inventory(quantity) WHERE quantity <= min_stock;
