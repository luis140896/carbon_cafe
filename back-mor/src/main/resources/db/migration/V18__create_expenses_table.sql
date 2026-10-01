-- =====================================================
-- SISTEMA POS MORALES - Migración V18
-- Tabla de gastos operativos (registro diario) para
-- compararlos contra ventas netas en el módulo Reportes.
-- =====================================================

-- IF NOT EXISTS: la tabla ya existe en Neon (creada por Hibernate ddl-auto).
-- Flyway igualmente la registrará como aplicada.
CREATE TABLE IF NOT EXISTS expenses (
    id BIGSERIAL PRIMARY KEY,
    expense_date DATE NOT NULL,
    description VARCHAR(255) NOT NULL,
    category VARCHAR(50) NOT NULL,
    amount NUMERIC(14,2) NOT NULL CHECK (amount > 0),
    payment_method VARCHAR(50),
    notes TEXT,
    created_by BIGINT REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_expenses_date ON expenses(expense_date);
CREATE INDEX IF NOT EXISTS idx_expenses_category ON expenses(category);
