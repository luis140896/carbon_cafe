-- Secuencias atómicas para numeración de facturas y comandas de mesa.
-- Evita duplicados bajo concurrencia al usar INSERT ... ON CONFLICT ... RETURNING.
CREATE TABLE IF NOT EXISTS invoice_sequences (
    prefix VARCHAR(30) PRIMARY KEY,
    next_value BIGINT NOT NULL DEFAULT 1,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
