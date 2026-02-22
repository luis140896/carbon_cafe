/**
 * Utilidades de formateo compartidas entre todos los módulos.
 * Centraliza: moneda, fechas, métodos de pago.
 */

/** Formatea un número como moneda colombiana (COP) sin decimales. Ej: 15000 → $15.000 */
export const formatCurrency = (value: number) =>
  new Intl.NumberFormat('es-CO', { style: 'currency', currency: 'COP', minimumFractionDigits: 0 }).format(value || 0)

/** Convierte una fecha ISO a formato legible en español. Ej: "2026-02-21T23:00:00" → "21/02/2026, 11:00 p. m." */
export const formatDate = (dateStr: string) => {
  const date = new Date(dateStr)
  return date.toLocaleDateString('es-CO', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  })
}

/** Traduce el código de método de pago al texto visible en la UI y en tickets. */
export const getPaymentMethodLabel = (method: string): string => {
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

/** Calcula los minutos transcurridos desde una fecha ISO hasta ahora. */
export const getElapsedMinutes = (dateStr: string): number => {
  const diff = Date.now() - new Date(dateStr).getTime()
  return Math.floor(diff / 60_000)
}

/** Lee de forma segura el objeto de configuración guardado en localStorage. */
export const getSafeSettings = (): Record<string, any> => {
  try {
    return JSON.parse(localStorage.getItem('pos_settings') || '{}')
  } catch {
    return {}
  }
}
