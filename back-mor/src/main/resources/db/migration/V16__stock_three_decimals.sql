-- Pasar stock y cantidades a 3 decimales (precisión DECIMAL, sin pérdida de datos)
-- DECIMAL(12,2) -> DECIMAL(12,3) es segura: conserva valores existentes

-- Inventario
ALTER TABLE inventory
    ALTER COLUMN quantity TYPE DECIMAL(12,3),
    ALTER COLUMN min_stock TYPE DECIMAL(12,3),
    ALTER COLUMN max_stock TYPE DECIMAL(12,3);

-- Movimientos de inventario
ALTER TABLE inventory_movements
    ALTER COLUMN quantity TYPE DECIMAL(12,3),
    ALTER COLUMN previous_quantity TYPE DECIMAL(12,3),
    ALTER COLUMN new_quantity TYPE DECIMAL(12,3);

-- Cantidades vendidas (permite vender fracciones, ej. 0.5 kg)
ALTER TABLE invoice_details
    ALTER COLUMN quantity TYPE DECIMAL(12,3);

-- Rendimiento de receta (porciones que rinde, puede ser fracción)
ALTER TABLE recipes
    ALTER COLUMN yield_qty TYPE DECIMAL(12,3);
