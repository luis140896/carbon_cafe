-- V9: Create promotions table for scheduled discounts
CREATE TABLE promotions (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(500),
    discount_percent DECIMAL(5,2) NOT NULL,
    schedule_type VARCHAR(20) NOT NULL,
    days_of_week VARCHAR(50),
    start_date DATE,
    end_date DATE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    apply_to_all_products BOOLEAN NOT NULL DEFAULT TRUE,
    priority INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_is_active ON promotions(is_active);
CREATE INDEX idx_schedule_type ON promotions(schedule_type);
CREATE INDEX idx_priority ON promotions(priority);

-- Insert sample promotion for demonstration
INSERT INTO promotions (name, description, discount_percent, schedule_type, days_of_week, is_active, apply_to_all_products, priority)
VALUES ('Martes de Descuento', 'Descuento especial todos los martes', 20.00, 'WEEKLY', '[2]', false, true, 1);
