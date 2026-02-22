-- =====================================================
-- SISTEMA POS MORALES - Migración V3
-- Módulo de Mesas y Notificaciones
-- =====================================================

-- Tabla de mesas del restaurante
CREATE TABLE restaurant_tables (
    id BIGSERIAL PRIMARY KEY,
    table_number INTEGER UNIQUE NOT NULL,
    name VARCHAR(100),
    capacity INTEGER DEFAULT 4,
    status VARCHAR(30) DEFAULT 'DISPONIBLE',
    zone VARCHAR(50) DEFAULT 'INTERIOR',
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de sesiones de mesa
CREATE TABLE table_sessions (
    id BIGSERIAL PRIMARY KEY,
    table_id BIGINT NOT NULL REFERENCES restaurant_tables(id),
    invoice_id BIGINT REFERENCES invoices(id),
    opened_by BIGINT NOT NULL REFERENCES users(id),
    closed_by BIGINT REFERENCES users(id),
    opened_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    closed_at TIMESTAMP,
    guest_count INTEGER DEFAULT 1,
    notes TEXT,
    status VARCHAR(20) DEFAULT 'ABIERTA',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de notificaciones
CREATE TABLE notifications (
    id BIGSERIAL PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    title VARCHAR(200) NOT NULL,
    message TEXT,
    severity VARCHAR(20) DEFAULT 'INFO',
    target_roles JSONB DEFAULT '[]',
    reference_type VARCHAR(50),
    reference_id BIGINT,
    is_read BOOLEAN DEFAULT FALSE,
    read_by BIGINT REFERENCES users(id),
    read_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- ÍNDICES
-- =====================================================

CREATE INDEX idx_restaurant_tables_status ON restaurant_tables(status);
CREATE INDEX idx_restaurant_tables_zone ON restaurant_tables(zone);
CREATE INDEX idx_restaurant_tables_active ON restaurant_tables(is_active);

CREATE INDEX idx_table_sessions_table ON table_sessions(table_id);
CREATE INDEX idx_table_sessions_invoice ON table_sessions(invoice_id);
CREATE INDEX idx_table_sessions_status ON table_sessions(status);
CREATE INDEX idx_table_sessions_opened_at ON table_sessions(opened_at);

CREATE INDEX idx_notifications_type ON notifications(type);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_created_at ON notifications(created_at);
CREATE INDEX idx_notifications_reference ON notifications(reference_type, reference_id);
