-- Asegura que TODO producto tenga su registro de inventario.
-- Productos creados fuera del flujo normal (SQL directo, backups) quedaban
-- sin fila en inventory y el motor de deducción/restauración los ignoraba
-- silenciosamente -> descuentos/restauraciones parciales.

INSERT INTO inventory (product_id, quantity, min_stock, max_stock)
SELECT p.id, 0, 0, 999999
FROM products p
WHERE NOT EXISTS (
    SELECT 1 FROM inventory i WHERE i.product_id = p.id
);
