-- Corregir datos existentes: todas las facturas COMPLETADA deben tener sus items como ENTREGADO
-- ya que son ventas directas del POS que no pasan por cocina
UPDATE invoice_details SET kitchen_status = 'ENTREGADO'
WHERE invoice_id IN (SELECT id FROM invoices WHERE status = 'COMPLETADA')
  AND (kitchen_status IS NULL OR kitchen_status = 'PENDIENTE');

-- También marcar como ENTREGADO items de facturas ANULADA
UPDATE invoice_details SET kitchen_status = 'ENTREGADO'
WHERE invoice_id IN (SELECT id FROM invoices WHERE status = 'ANULADA')
  AND (kitchen_status IS NULL OR kitchen_status = 'PENDIENTE');
