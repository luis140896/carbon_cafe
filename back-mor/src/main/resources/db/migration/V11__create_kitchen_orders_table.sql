-- V11: Create kitchen_orders table (SIMPLIFIED - No triggers)
-- Purpose: Track kitchen orders chronologically by order time

CREATE TABLE kitchen_orders (
    id BIGSERIAL PRIMARY KEY,
    table_id BIGINT NOT NULL,
    invoice_detail_id BIGINT NOT NULL UNIQUE,
    order_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    sequence_number INTEGER NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    is_urgent BOOLEAN DEFAULT FALSE,
    urgency_reason VARCHAR(200),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_kitchen_orders_table FOREIGN KEY (table_id) REFERENCES restaurant_tables(id),
    CONSTRAINT fk_kitchen_orders_detail FOREIGN KEY (invoice_detail_id) REFERENCES invoice_details(id) ON DELETE CASCADE
);

-- Indexes for performance
CREATE INDEX idx_kitchen_orders_table_seq ON kitchen_orders(table_id, sequence_number);
CREATE INDEX idx_kitchen_orders_status_time ON kitchen_orders(status, order_time);
CREATE INDEX idx_kitchen_orders_urgent ON kitchen_orders(is_urgent, order_time);
CREATE INDEX idx_kitchen_orders_table_status ON kitchen_orders(table_id, status);
