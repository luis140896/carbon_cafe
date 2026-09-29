-- ============================================================
-- Fase 1: Tipado de productos + Recetas (BOM) para descuento
-- automatico de ingredientes al vender productos preparados.
-- Aditivo y no destructivo: no altera datos existentes.
-- ============================================================

-- Tipo de producto: DIRECTO (venta 1:1), PREPARADO (usa receta), INSUMO (materia prima)
ALTER TABLE products ADD COLUMN IF NOT EXISTS product_type VARCHAR(20) NOT NULL DEFAULT 'DIRECTO';
CREATE INDEX IF NOT EXISTS idx_products_product_type ON products(product_type);

-- Cabecera de receta: 1 por producto preparado
CREATE TABLE IF NOT EXISTS recipes (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT NOT NULL UNIQUE REFERENCES products(id) ON DELETE CASCADE,
    yield_qty DECIMAL(12,2) NOT NULL DEFAULT 1,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Lineas de receta (ingredientes y cantidades)
CREATE TABLE IF NOT EXISTS recipe_items (
    id BIGSERIAL PRIMARY KEY,
    recipe_id BIGINT NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
    ingredient_product_id BIGINT NOT NULL REFERENCES products(id),
    quantity DECIMAL(18,6) NOT NULL,
    waste_percent DECIMAL(5,2) NOT NULL DEFAULT 0,
    sort_order INT DEFAULT 0,
    CONSTRAINT uq_recipe_ingredient UNIQUE (recipe_id, ingredient_product_id)
);
CREATE INDEX IF NOT EXISTS idx_recipe_items_recipe ON recipe_items(recipe_id);
CREATE INDEX IF NOT EXISTS idx_recipe_items_ingredient ON recipe_items(ingredient_product_id);
