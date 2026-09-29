import { ArrowDown, ArrowUp, ArrowUpDown } from 'lucide-react'
import { SortState } from '@/shared/hooks/useSortableTable'

interface SortableHeaderProps {
  label: string
  columnKey: string
  sort: SortState | null
  onToggle: (key: string) => void
  className?: string
}

/**
 * Header de tabla clickeable con indicador de orden (asc/desc/neutro).
 * Usar junto a `useSortableTable`.
 */
const SortableHeader = ({ label, columnKey, sort, onToggle, className = '' }: SortableHeaderProps) => {
  const active = sort?.key === columnKey
  return (
    <th
      className={`table-header cursor-pointer select-none hover:bg-primary-100 transition-colors ${className}`}
      onClick={() => onToggle(columnKey)}
      title="Ordenar"
    >
      <span className="inline-flex items-center gap-1">
        {label}
        {active && sort?.direction === 'asc' && <ArrowUp size={14} className="text-primary-600" />}
        {active && sort?.direction === 'desc' && <ArrowDown size={14} className="text-primary-600" />}
        {!active && <ArrowUpDown size={14} className="text-gray-300" />}
      </span>
    </th>
  )
}

export default SortableHeader
