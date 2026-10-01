/**
 * Utilidad reutilizable para impresión de facturas en impresora térmica 58mm.
 *
 * Problemas que resuelve respecto a window.print() genérico:
 *  - Papel en blanco al final: @page { margin: 0 } + height auto en body
 *  - Márgenes excesivos del navegador: se anulan con @page y body padding mínimo
 *  - Páginas extra vacías: overflow: hidden en @media print
 *  - Colores que no imprimen: -webkit-print-color-adjust: exact
 *
 * Uso:
 *   import { printInvoice } from '@/shared/utils/printInvoice'
 *   printInvoice(invoiceObject)                    // factura normal
 *   printInvoice(invoiceObject, { isPreBill: true }) // pre-cuenta
 */

// ── Formateadores de datos ──────────────────────────────────────────────────

/** Formatea un número como moneda colombiana (COP) sin decimales. Ej: 15000 → $15.000 */
const formatCurrency = (value: number) =>
  new Intl.NumberFormat('es-CO', { style: 'currency', currency: 'COP', minimumFractionDigits: 0 }).format(value || 0)

/** Convierte una fecha ISO a formato legible en español. Ej: "2026-02-21T23:00:00" → "21/02/2026, 11:00 p. m." */
const formatDate = (dateStr: string) => {
  const date = new Date(dateStr)
  return date.toLocaleDateString('es-CO', { day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit' })
}

/** Traduce el código de método de pago al texto visible en el ticket. */
const getPaymentMethodLabel = (method: string) => {
  switch (method) {
    case 'EFECTIVO': return 'Efectivo'
    case 'TRANSFERENCIA': return 'Transferencia'
    case 'TARJETA_CREDITO': return 'Tarjeta Crédito'
    case 'TARJETA_DEBITO': return 'Tarjeta Débito'
    case 'NEQUI': return 'Nequi'
    case 'DAVIPLATA': return 'Daviplata'
    default: return method
  }
}

// ── Tipos ──────────────────────────────────────────────────────────────────

/** Estructura mínima que necesita printInvoice para generar el ticket.
 *  Compatible con InvoiceResponse del backend y con objetos construidos manualmente (pre-cuenta). */
interface PrintableInvoice {
  invoiceNumber: string
  createdAt: string
  customer?: { fullName?: string } | null
  customerName?: string
  userName?: string
  details?: Array<{ quantity: number; productName: string; subtotal: number; notes?: string }>
  subtotal: number
  discountAmount: number
  discountPercent?: number
  serviceChargeAmount?: number
  serviceChargePercent?: number
  deliveryChargeAmount?: number
  total: number
  paymentMethod?: string
  amountReceived?: number
  changeAmount?: number
}

/** Opciones de impresión. isPreBill=true muestra banner "PRE-CUENTA" y omite datos de pago. */
interface PrintOptions {
  isPreBill?: boolean
}

// ── CSS térmico ─────────────────────────────────────────────────────────────
/**
 * CSS optimizado para impresoras térmicas 58mm.
 * - @page { size: 58mm auto } → papel de ancho fijo, largo variable según contenido
 * - margin: 0 en @page → elimina márgenes del navegador que dejan hoja en blanco
 * - overflow: hidden en @media print → evita scroll que genera páginas extra
 * - font-family Courier New → monoespaciado para alineación de columnas
 * - font-weight 600 global → compensa la tinta diluida de impresoras térmicas
 */
const thermalCSS = `
  * { margin: 0; padding: 0; box-sizing: border-box; }
  @page {
    size: 58mm auto;
    margin: 0;
  }
  @media print {
    html, body {
      width: 58mm;
      margin: 0;
      padding: 0;
      overflow: hidden;
      -webkit-print-color-adjust: exact;
      print-color-adjust: exact;
    }
  }
  body {
    font-family: 'Courier New', monospace;
    padding: 1mm 0.5mm;
    width: 54mm;
    max-width: 54mm;
    font-size: 12px;
    line-height: 1.3;
    color: #000000 !important;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    font-weight: 600;
  }
  .header { text-align: center; margin-bottom: 6px; border-bottom: 1px dashed #000; padding-bottom: 6px; }
  .header h1 { margin: 0 0 2px; font-size: 19px; text-transform: uppercase; font-weight: 900; color: #000000 !important; }
  .header .invoice-num { font-size: 15px; font-weight: 900; color: #000000 !important; }
  .header p { margin: 1px 0; font-size: 12px; color: #000000 !important; font-weight: 600; }
  .header p.whatsapp { font-weight: 900; }
  .pre-bill-banner { text-align: center; font-size: 14px; font-weight: 900; border: 2px dashed #000; padding: 4px; margin-bottom: 6px; text-transform: uppercase; color: #000000 !important; }
  .info { margin-bottom: 6px; }
  .info div { margin: 1px 0; font-size: 13px; color: #000000 !important; font-weight: 600; }
  .items { border-top: 1px dashed #000; border-bottom: 1px dashed #000; padding: 4px 0; margin: 4px 0; }
  .item { display: flex; justify-content: space-between; margin: 1px 0; font-size: 12px; color: #000000 !important; font-weight: 600; padding-right: 1mm; }
  .item span:first-child { flex: 1; margin-right: 3px; word-break: break-word; }
  .item span:last-child { flex-shrink: 0; text-align: right; white-space: nowrap; }
  .item-notes { font-size: 11px; color: #000000 !important; margin-left: 8px; margin-bottom: 2px; font-weight: 500; }
  .totals div { display: flex; justify-content: space-between; margin: 1px 0; font-size: 12px; color: #000000 !important; font-weight: 600; padding-right: 1mm; }
  .totals div span:first-child { flex: 1; margin-right: 2px; }
  .totals div span:last-child { flex-shrink: 0; text-align: right; white-space: nowrap; }
  .total-final { font-size: 16px; font-weight: 900; border-top: 2px solid #000; padding-top: 4px; margin-top: 4px; color: #000000 !important; }
  .payment-info { border-top: 1px dashed #000; margin-top: 6px; padding-top: 4px; }
  .payment-info div { display: flex; justify-content: space-between; margin: 1px 0; color: #000000 !important; font-weight: 600; padding-right: 1mm; font-size: 12px; }
  .payment-info div span:first-child { flex: 1; margin-right: 2px; }
  .payment-info div span:last-child { flex-shrink: 0; text-align: right; white-space: nowrap; }
  .footer { text-align: center; margin-top: 8px; font-size: 11px; color: #000000 !important; border-top: 1px dashed #000; padding-top: 6px; font-weight: 600; }
  .cut-line { text-align: center; margin-top: 10px; font-size: 11px; color: #000000 !important; }
  .whatsapp-line { display: flex; align-items: center; justify-content: center; gap: 4px; font-weight: 900; font-size: 12px; margin-top: 4px; }
  .whatsapp-line svg { display: inline-block; vertical-align: -1px; }
`

// ── Función principal ───────────────────────────────────────────────────────

/**
 * Abre una ventana emergente con el HTML del ticket y lanza window.print().
 * La ventana se cierra automáticamente después de imprimir (onafterprint)
 * o tras 3 segundos como fallback para navegadores que no soportan onafterprint.
 */
export function printInvoice(inv: PrintableInvoice, options: PrintOptions = {}) {
  // Leer nombre de empresa desde configuración guardada en localStorage
  const settings = JSON.parse(localStorage.getItem('pos_settings') || '{}')
  const companyName = settings?.company?.companyName || 'Mi Empresa'
  const whatsapp = settings?.company?.whatsapp || '302 272 0909'
  const { isPreBill = false } = options

  // Generar filas de productos: "cantidad x nombre" alineado con subtotal a la derecha
  const itemsHtml = (inv.details || []).map((d) => {
    return `<div class="item"><span>${d.quantity} x ${d.productName}</span><span>${formatCurrency(d.subtotal)}</span></div>`
  }).join('')

  // Banner de pre-cuenta solo si se solicita (no es factura fiscal)
  const preBillBanner = isPreBill ? '<div class="pre-bill-banner">*** PRE-CUENTA ***</div>' : ''

  const html = `<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>${isPreBill ? 'Pre-cuenta' : 'Factura'} ${inv.invoiceNumber}</title>
  <style>${thermalCSS}</style>
</head>
<body>
  ${preBillBanner}
  <div class="header">
    <h1>${companyName}</h1>
    <div class="invoice-num">N° ${inv.invoiceNumber}</div>
    <p>${formatDate(inv.createdAt)}</p>
  </div>
  <div class="info">
    <div>Cliente: ${inv.customer?.fullName || inv.customerName || 'Cliente General'}</div>
    <div>Cajero: ${inv.userName || '-'}</div>
  </div>
  <div class="items">
    ${itemsHtml}
  </div>
  <div class="totals">
    <div><span>Total consumo:</span><span>${formatCurrency(inv.subtotal)}</span></div>
    ${inv.discountAmount > 0 ? `<div><span>Descuento${inv.discountPercent ? ` (${inv.discountPercent}%)` : ''}:</span><span>-${formatCurrency(inv.discountAmount)}</span></div>` : ''}
    ${(inv.serviceChargeAmount || 0) > 0 ? `<div><span>Servicio opcional (${inv.serviceChargePercent || 5}%):</span><span>+${formatCurrency(inv.serviceChargeAmount!)}</span></div>
    <div><span>Total con servicio:</span><span>${formatCurrency(inv.subtotal - (inv.discountAmount || 0) + (inv.serviceChargeAmount || 0))}</span></div>` : ''}
    ${(inv.deliveryChargeAmount || 0) > 0 ? `<div><span>Cargo Domicilio:</span><span>+${formatCurrency(inv.deliveryChargeAmount!)}</span></div>` : ''}
    <div class="total-final"><span>TOTAL A PAGAR:</span><span>${formatCurrency(inv.total)}</span></div>
  </div>
  ${inv.paymentMethod ? `
  <div class="payment-info">
    <div><span>Método:</span><span>${getPaymentMethodLabel(inv.paymentMethod)}</span></div>
    ${!isPreBill && (inv.amountReceived || 0) > 0 ? `<div><span>Recibido:</span><span>${formatCurrency(inv.amountReceived!)}</span></div>` : ''}
    ${!isPreBill && (inv.changeAmount || 0) > 0 ? `<div style="font-weight:bold;"><span>Cambio:</span><span>${formatCurrency(inv.changeAmount!)}</span></div>` : ''}
  </div>` : ''}
  <div class="footer">
    ${!isPreBill ? '<p>¡Gracias por su compra!</p>' : ''}
    ${whatsapp ? `<div class="whatsapp-line"><svg width="13" height="13" viewBox="0 0 24 24" fill="#000000"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413"/></svg>${whatsapp}</div>` : ''}
  </div>
  <div class="cut-line">- - - - - - - - - - - - -</div>
  <script>
    window.onload = function() {
      window.print();
      window.onafterprint = function() { window.close(); };
      setTimeout(function() { window.close(); }, 3000);
    };
  </script>
</body>
</html>`

  const printWindow = window.open('', '_blank')
  if (printWindow) {
    printWindow.document.write(html)
    printWindow.document.close()
  }
}
