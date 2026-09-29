import { useMemo, useState } from 'react'

export type SortDirection = 'asc' | 'desc'

export interface SortState {
  key: string
  direction: SortDirection
}

type Accessor<T> = (item: T) => string | number | null | undefined

/**
 * Hook reutilizable de ordenamiento de tablas.
 *
 * - `accessors`: mapa de columna -> función que extrae el valor ordenable.
 * - Click en un header: asc -> desc -> sin orden.
 * - Strings se comparan con localeCompare 'es' (tildes/ñ/ñ-insensitive, numérico natural).
 *
 * Uso:
 *   const { sortedItems, sort, toggleSort } = useSortableTable(items, {
 *     name: p => p.name,
 *     stock: p => p.inventory?.quantity,
 *   }, { key: 'name', direction: 'asc' })
 */
export function useSortableTable<T>(
  items: T[],
  accessors: Record<string, Accessor<T>>,
  defaultSort?: SortState,
) {
  const [sort, setSort] = useState<SortState | null>(defaultSort ?? null)

  const toggleSort = (key: string) => {
    setSort((prev) => {
      if (prev?.key !== key) return { key, direction: 'asc' }
      if (prev.direction === 'asc') return { key, direction: 'desc' }
      return null
    })
  }

  const sortedItems = useMemo(() => {
    if (!sort) return items
    const accessor = accessors[sort.key]
    if (!accessor) return items
    const dir = sort.direction === 'asc' ? 1 : -1
    return [...items].sort((a, b) => {
      const va = accessor(a)
      const vb = accessor(b)
      if (va == null && vb == null) return 0
      if (va == null) return dir // nulos al final en asc
      if (vb == null) return -dir
      if (typeof va === 'number' && typeof vb === 'number') {
        return (va - vb) * dir
      }
      return String(va).localeCompare(String(vb), 'es', { sensitivity: 'base', numeric: true }) * dir
    })
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [items, sort])

  return { sortedItems, sort, toggleSort }
}
