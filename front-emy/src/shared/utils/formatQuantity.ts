/**
 * Formatea cantidades de stock mostrando hasta 3 decimales,
 * recortando ceros a la derecha: 10 -> "10", 10.5 -> "10.5", 10.125 -> "10.125".
 */
export const formatQuantity = (value: number | string | null | undefined): string => {
  if (value === null || value === undefined || value === '') return '0'
  const num = Number(value)
  if (Number.isNaN(num)) return '0'
  return new Intl.NumberFormat('es-CO', {
    minimumFractionDigits: 0,
    maximumFractionDigits: 3,
  }).format(num)
}

/** Compara dos cantidades considerando la precisión de 3 decimales. */
export const toQty = (value: number | string | null | undefined): number => {
  const num = Number(value)
  return Number.isNaN(num) ? 0 : Math.round(num * 1000) / 1000
}
