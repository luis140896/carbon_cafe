import { useState, useEffect } from 'react'
import { useSelector } from 'react-redux'
import { Download, BarChart3, TrendingUp, DollarSign, Loader2, Package, CreditCard, FileText, X, Plus, Edit2, Trash2, Wallet } from 'lucide-react'
import toast from 'react-hot-toast'
import Button from '@/shared/components/ui/Button'
import Input from '@/shared/components/ui/Input'
import { reportService, SalesSummary, TopProduct, TopCustomer, InventorySummary, PaymentMethodStat } from '@/core/api/reportService'
import { invoiceService } from '@/core/api/invoiceService'
import { expenseService } from '@/core/api/expenseService'
import { Expense, ExpenseRequest, EXPENSE_CATEGORY_LABELS, ProfitComparison } from '@/types'
import { RootState } from '@/app/store'
import XLSX from 'xlsx-js-style'
import DateRangeFilter, { toLocalDateStr } from '@/shared/components/DateRangeFilter'

const TRANSFER_METHODS = new Set(['TRANSFERENCIA', 'TARJETA_CREDITO', 'TARJETA_DEBITO', 'NEQUI', 'DAVIPLATA'])

const EXPENSE_CATEGORIES = Object.keys(EXPENSE_CATEGORY_LABELS)
const EXPENSE_PAYMENT_METHODS = ['EFECTIVO', 'TRANSFERENCIA', 'NEQUI', 'DAVIPLATA', 'TARJETA_DEBITO', 'TARJETA_CREDITO', 'OTRO']

const emptyExpenseForm = (): ExpenseRequest => ({
  expenseDate: toLocalDateStr(new Date()),
  description: '',
  category: 'OTROS',
  amount: 0,
  paymentMethod: '',
  notes: '',
})

const safeNum = (v: any): number => {
  const n = Number(v)
  return Number.isFinite(n) ? n : 0
}

const buildPaymentTotals = (invoicesCompleted: any[]) =>
  invoicesCompleted.reduce(
    (acc: any, inv: any) => {
      const method: string = inv.paymentMethod || ''
      const total = safeNum(inv.total)
      const subtotal = safeNum(inv.subtotal)
      const tax = safeNum(inv.taxAmount)
      const discount = safeNum(inv.discountAmount)
      const service = safeNum(inv.serviceChargeAmount)
      const delivery = safeNum(inv.deliveryChargeAmount)
      const cashAmt = safeNum(inv.cashAmount)
      const transferAmt = safeNum(inv.transferAmount)

      acc.total += total
      acc.subtotal += subtotal
      acc.tax += tax
      acc.discount += discount
      acc.serviceCharge += service
      acc.deliveryCharge += delivery

      if (method === 'EFECTIVO') {
        acc.cash.total += total
        acc.cash.withoutService += total - service
        acc.cash.serviceOnly += service
        acc.cash.deliveryOnly += delivery
        acc.cash.netSales += total - service - delivery
      } else if (TRANSFER_METHODS.has(method)) {
        acc.transfer.total += total
        acc.transfer.withoutService += total - service
        acc.transfer.serviceOnly += service
        acc.transfer.deliveryOnly += delivery
        acc.transfer.netSales += total - service - delivery
      } else if (method === 'MIXTO') {
        acc.cash.total += cashAmt
        acc.transfer.total += transferAmt
        acc.transfer.serviceOnly += service
        acc.transfer.deliveryOnly += delivery
        acc.cash.withoutService += cashAmt
        acc.transfer.withoutService += transferAmt - service
        acc.transfer.netSales += transferAmt - service - delivery
        acc.cash.netSales += cashAmt
      } else {
        acc.other += total
      }

      return acc
    },
    {
      total: 0, subtotal: 0, tax: 0, discount: 0, serviceCharge: 0, deliveryCharge: 0,
      cash: { total: 0, withoutService: 0, serviceOnly: 0, deliveryOnly: 0, netSales: 0 },
      transfer: { total: 0, withoutService: 0, serviceOnly: 0, deliveryOnly: 0, netSales: 0 },
      other: 0,
    }
  )

const ReportsPage = () => {
  const { theme, company } = useSelector((state: RootState) => state.settings)
  const [loading, setLoading] = useState(true)
  const [dateRange, setDateRange] = useState({
    start: toLocalDateStr(new Date(new Date().getFullYear(), new Date().getMonth(), 1)),
    end: toLocalDateStr(new Date())
  })
  const [salesSummary, setSalesSummary] = useState<SalesSummary | null>(null)
  const [topProducts, setTopProducts] = useState<TopProduct[]>([])
  const [topCustomers, setTopCustomers] = useState<TopCustomer[]>([])
  const [inventorySummary, setInventorySummary] = useState<InventorySummary | null>(null)
  const [paymentMethods, setPaymentMethods] = useState<PaymentMethodStat[]>([])
  const [showBasicReport, setShowBasicReport] = useState(false)
  const [expenses, setExpenses] = useState<Expense[]>([])
  const [profitComparison, setProfitComparison] = useState<ProfitComparison | null>(null)
  const [expenseModal, setExpenseModal] = useState<{ expense?: Expense } | null>(null)
  const [expenseForm, setExpenseForm] = useState<ExpenseRequest>(emptyExpenseForm())
  const [savingExpense, setSavingExpense] = useState(false)

  const fetchReports = async () => {
    try {
      setLoading(true)
      const startDateTime = `${dateRange.start}T00:00:00`
      const endDateTime = `${dateRange.end}T23:59:59`

      const [summary, products, customers, inventory, payments, expensesRes, comparison] = await Promise.all([
        reportService.getSalesSummary(startDateTime, endDateTime).catch(() => null),
        reportService.getTopProducts(startDateTime, endDateTime, 5).catch(() => []),
        reportService.getTopCustomers(startDateTime, endDateTime, 5).catch(() => []),
        reportService.getInventorySummary().catch(() => null),
        reportService.getSalesByPaymentMethod(startDateTime, endDateTime).catch(() => []),
        expenseService.getByDateRange(dateRange.start, dateRange.end).catch(() => []),
        reportService.getProfitComparison(dateRange.start, dateRange.end).catch(() => null),
      ])

      setSalesSummary(summary as SalesSummary | null)
      setTopProducts(products as TopProduct[])
      setTopCustomers(customers as TopCustomer[])
      setInventorySummary(inventory as InventorySummary | null)
      setPaymentMethods(payments as PaymentMethodStat[])
      setExpenses((expensesRes as Expense[]) ?? [])
      setProfitComparison((comparison as ProfitComparison | null) ?? null)
    } catch (error) {
      console.error('Error loading reports:', error)
      toast.error('Error al cargar reportes')
    } finally {
      setLoading(false)
    }
  }

  const exportBasicReportToExcel = () => {
    try {
      const cashNetSales = Number(totals?.cash?.netSales || 0)
      const transferNetSales = Number(totals?.transfer?.netSales || 0)
      const ownerTotal = cashNetSales + transferNetSales

      const hexToArgb = (hex: string | undefined, fallback: string) => {
        const normalized = (hex || fallback).replace('#', '').toUpperCase()
        return normalized.length === 6 ? normalized : fallback.replace('#', '').toUpperCase()
      }

      const primaryColor = hexToArgb(theme?.primaryColor, '#2563EB')
      const secondaryColor = hexToArgb(theme?.secondaryColor, '#1E3A8A')

      const data = [
        ['REPORTE BÁSICO DEL DUEÑO', ''],
        [`Período: ${dateRange.start} a ${dateRange.end}`, ''],
        ['', ''],
        ['Concepto', 'Valor Neto'],
        ['Efectivo (sin propinas ni domicilios)', cashNetSales],
        ['Transferencia (sin propinas ni domicilios)', transferNetSales],
        ['Total Dueño (Efectivo + Transferencia)', ownerTotal],
      ]

      const ws = XLSX.utils.aoa_to_sheet(data)
      ws['!cols'] = [{ wch: 52 }, { wch: 26 }]
      ws['!rows'] = [{ hpt: 28 }, { hpt: 22 }, { hpt: 8 }, { hpt: 20 }, { hpt: 20 }, { hpt: 20 }, { hpt: 24 }]
      ws['!merges'] = [
        { s: { r: 0, c: 0 }, e: { r: 0, c: 1 } },
        { s: { r: 1, c: 0 }, e: { r: 1, c: 1 } },
      ]

      const titleStyle: any = {
        font: { bold: true, sz: 15, color: { rgb: 'FFFFFF' } },
        fill: { fgColor: { rgb: secondaryColor } },
        alignment: { horizontal: 'center', vertical: 'center' },
      }

      const periodStyle: any = {
        font: { italic: true, sz: 11, color: { rgb: '334155' } },
        fill: { fgColor: { rgb: 'F8FAFC' } },
        alignment: { horizontal: 'center', vertical: 'center' },
      }

      const headerStyle: any = {
        font: { bold: true, sz: 11, color: { rgb: 'FFFFFF' } },
        fill: { fgColor: { rgb: primaryColor } },
        alignment: { horizontal: 'center', vertical: 'center' },
      }

      const labelStyle: any = {
        font: { sz: 11, color: { rgb: '1F2937' } },
        alignment: { horizontal: 'left', vertical: 'center' },
      }

      const moneyStyle: any = {
        numFmt: '"$"#,##0',
        font: { sz: 11, color: { rgb: '0F172A' } },
        alignment: { horizontal: 'right', vertical: 'center' },
      }

      const totalLabelStyle: any = {
        font: { bold: true, sz: 11, color: { rgb: 'FFFFFF' } },
        fill: { fgColor: { rgb: secondaryColor } },
        alignment: { horizontal: 'left', vertical: 'center' },
      }

      const totalMoneyStyle: any = {
        numFmt: '"$"#,##0',
        font: { bold: true, sz: 12, color: { rgb: 'FFFFFF' } },
        fill: { fgColor: { rgb: secondaryColor } },
        alignment: { horizontal: 'right', vertical: 'center' },
      }

      const titleRef = XLSX.utils.encode_cell({ r: 0, c: 0 })
      const periodRef = XLSX.utils.encode_cell({ r: 1, c: 0 })
      if (ws[titleRef]) ws[titleRef].s = titleStyle
      if (ws[periodRef]) ws[periodRef].s = periodStyle

      for (let c = 0; c <= 1; c += 1) {
        const headerRef = XLSX.utils.encode_cell({ r: 3, c })
        if (ws[headerRef]) ws[headerRef].s = headerStyle
      }

      for (let r = 4; r <= 5; r += 1) {
        const labelRef = XLSX.utils.encode_cell({ r, c: 0 })
        const valueRef = XLSX.utils.encode_cell({ r, c: 1 })
        if (ws[labelRef]) ws[labelRef].s = labelStyle
        if (ws[valueRef]) ws[valueRef].s = moneyStyle
      }

      const totalLabelRef = XLSX.utils.encode_cell({ r: 6, c: 0 })
      const totalValueRef = XLSX.utils.encode_cell({ r: 6, c: 1 })
      if (ws[totalLabelRef]) ws[totalLabelRef].s = totalLabelStyle
      if (ws[totalValueRef]) ws[totalValueRef].s = totalMoneyStyle

      const wb = XLSX.utils.book_new()
      XLSX.utils.book_append_sheet(wb, ws, 'ReporteBasico')

      XLSX.writeFile(wb, `reporte_basico_dueno_${dateRange.start}_${dateRange.end}.xlsx`)
      toast.success('Reporte básico exportado en Excel')
    } catch (error) {
      console.error('Error exporting basic report:', error)
      toast.error('Error al exportar reporte básico')
    }
  }

  // Calculate totals for visual cards and detailed report
  const [totals, setTotals] = useState<any>({
    total: 0,
    subtotal: 0,
    tax: 0,
    discount: 0,
    serviceCharge: 0,
    deliveryCharge: 0,
    cash: {
      total: 0,
      withoutService: 0,
      serviceOnly: 0,
      deliveryOnly: 0,
      netSales: 0,
    },
    transfer: {
      total: 0,
      withoutService: 0,
      serviceOnly: 0,
      deliveryOnly: 0,
      netSales: 0,
    },
    other: 0
  })
  
  useEffect(() => {
    const calculateTotals = async () => {
      try {
        const startDateTime = `${dateRange.start}T00:00:00`
        const endDateTime = `${dateRange.end}T23:59:59`
        
        const invoices = (await invoiceService.getByDateRange(startDateTime, endDateTime).catch(() => [])) as any[]
        const invoicesCompleted = invoices.filter((i) => i.status === 'COMPLETADA')
        
        const calculatedTotals = buildPaymentTotals(invoicesCompleted)
        setTotals(calculatedTotals)
      } catch (error) {
        console.error('Error calculating totals:', error)
      }
    }
    
    calculateTotals()
  }, [dateRange])

  const formatCurrency = (value: number) =>
    new Intl.NumberFormat('es-CO', { style: 'currency', currency: 'COP', minimumFractionDigits: 0 }).format(value || 0)

  // ============ EXPENSES (Gastos vs Utilidad) ============

  const openExpenseModal = (expense?: Expense) => {
    if (expense) {
      setExpenseForm({
        expenseDate: expense.expenseDate,
        description: expense.description,
        category: expense.category || 'OTROS',
        amount: safeNum(expense.amount),
        paymentMethod: expense.paymentMethod || '',
        notes: expense.notes || '',
      })
    } else {
      setExpenseForm(emptyExpenseForm())
    }
    setExpenseModal({ expense })
  }

  const handleExpenseSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!expenseForm.description.trim()) {
      toast.error('La descripción es requerida')
      return
    }
    if (!expenseForm.amount || expenseForm.amount <= 0) {
      toast.error('El monto debe ser mayor a 0')
      return
    }
    try {
      setSavingExpense(true)
      if (expenseModal?.expense) {
        await expenseService.update(expenseModal.expense.id, expenseForm)
        toast.success('Gasto actualizado')
      } else {
        await expenseService.create(expenseForm)
        toast.success('Gasto registrado')
      }
      setExpenseModal(null)
      fetchReports()
    } catch (error) {
      console.error('Error saving expense:', error)
      toast.error('Error al guardar el gasto')
    } finally {
      setSavingExpense(false)
    }
  }

  const handleDeleteExpense = async (expense: Expense) => {
    if (!window.confirm(`¿Eliminar el gasto "${expense.description}"?`)) return
    try {
      await expenseService.delete(expense.id)
      toast.success('Gasto eliminado')
      fetchReports()
    } catch (error) {
      console.error('Error deleting expense:', error)
      toast.error('Error al eliminar el gasto')
    }
  }

  const exportExpensesToExcel = () => {
    try {
      const primaryRgb = (theme.secondaryColor || '#7c3aed').replace('#', '').toUpperCase()
      const companyName = company.companyName || 'Mi Negocio'
      const infoLine = [
        (company as any).nit ? `NIT: ${(company as any).nit}` : '',
        (company as any).phone ? `Tel: ${(company as any).phone}` : '',
        (company as any).address || '',
      ].filter(Boolean).join('  ·  ')

      const thinBorder: any = {
        top: { style: 'thin', color: { rgb: '9CA3AF' } },
        bottom: { style: 'thin', color: { rgb: '9CA3AF' } },
        left: { style: 'thin', color: { rgb: '9CA3AF' } },
        right: { style: 'thin', color: { rgb: '9CA3AF' } },
      }
      const titleStyle: any = {
        font: { bold: true, sz: 14, color: { rgb: 'FFFFFF' } },
        fill: { fgColor: { rgb: primaryRgb } },
        alignment: { horizontal: 'center', vertical: 'center' },
      }
      const infoStyle: any = {
        font: { sz: 9, color: { rgb: 'FFFFFF' } },
        fill: { fgColor: { rgb: primaryRgb } },
        alignment: { horizontal: 'center', vertical: 'center' },
      }
      const subtitleStyle: any = {
        font: { bold: true, sz: 10, color: { rgb: primaryRgb } },
        fill: { fgColor: { rgb: 'F3F4F6' } },
        alignment: { horizontal: 'center', vertical: 'center' },
      }
      const headerStyle: any = {
        font: { bold: true, sz: 11, color: { rgb: 'FFFFFF' } },
        fill: { fgColor: { rgb: primaryRgb } },
        alignment: { horizontal: 'center', vertical: 'center' },
        border: thinBorder,
      }
      const cellStyle: any = { border: thinBorder, alignment: { vertical: 'center' } }
      const zebraStyle: any = { border: thinBorder, fill: { fgColor: { rgb: 'FFF7ED' } }, alignment: { vertical: 'center' } }
      const currencyStyle: any = { numFmt: '"$"#,##0', alignment: { horizontal: 'right' }, border: thinBorder }
      const currencyZebraStyle: any = { numFmt: '"$"#,##0', alignment: { horizontal: 'right' }, border: thinBorder, fill: { fgColor: { rgb: 'FFF7ED' } } }
      const percentStyle: any = { numFmt: '0.0%', alignment: { horizontal: 'right' }, border: thinBorder }
      const totalLabelStyle: any = { font: { bold: true }, border: thinBorder, fill: { fgColor: { rgb: 'FFEDD5' } } }
      const totalCurrencyStyle: any = { numFmt: '"$"#,##0', alignment: { horizontal: 'right' }, border: thinBorder, font: { bold: true }, fill: { fgColor: { rgb: 'FFEDD5' } } }
      // Ganancia: verde suave si positiva, rojo suave si negativa
      const profitPosStyle: any = { numFmt: '"$"#,##0', alignment: { horizontal: 'right' }, border: thinBorder, fill: { fgColor: { rgb: 'D1FAE5' } }, font: { color: { rgb: '065F46' }, bold: true } }
      const profitNegStyle: any = { numFmt: '"$"#,##0', alignment: { horizontal: 'right' }, border: thinBorder, fill: { fgColor: { rgb: 'FEE2E2' } }, font: { color: { rgb: '991B1B' }, bold: true } }
      const profitPosTotalStyle: any = { numFmt: '"$"#,##0', alignment: { horizontal: 'right' }, border: thinBorder, fill: { fgColor: { rgb: 'A7F3D0' } }, font: { color: { rgb: '065F46' }, bold: true } }
      const profitNegTotalStyle: any = { numFmt: '"$"#,##0', alignment: { horizontal: 'right' }, border: thinBorder, fill: { fgColor: { rgb: 'FECACA' } }, font: { color: { rgb: '991B1B' }, bold: true } }

      // Estructura por hoja: r0 empresa, r1 info (NIT/tel), r2 título+período, r3 vacío, r4 header, datos desde r5, TOTAL al final
      const styleSheet = (ws: any, colCount: number, dataCount: number, moneyCols: number[], pctCols: number[] = [], profitCol?: number) => {
        ws['!merges'] = [
          { s: { r: 0, c: 0 }, e: { r: 0, c: colCount - 1 } },
          { s: { r: 1, c: 0 }, e: { r: 1, c: colCount - 1 } },
          { s: { r: 2, c: 0 }, e: { r: 2, c: colCount - 1 } },
        ]
        // Asegurar celdas en filas combinadas para que el borde cubra todo el ancho
        for (let r = 0; r <= 2; r++) {
          for (let c = 0; c < colCount; c++) {
            const ref = XLSX.utils.encode_cell({ r, c })
            if (!ws[ref]) ws[ref] = { t: 's', v: '' }
            ws[ref].s = r === 0 ? titleStyle : r === 1 ? infoStyle : subtitleStyle
          }
        }
        for (let c = 0; c < colCount; c++) {
          const hRef = XLSX.utils.encode_cell({ r: 4, c })
          if (ws[hRef]) ws[hRef].s = headerStyle
        }
        for (let r = 0; r < dataCount; r++) {
          const zebra = r % 2 === 1
          for (let c = 0; c < colCount; c++) {
            const ref = XLSX.utils.encode_cell({ r: r + 5, c })
            if (!ws[ref]) continue
            if (profitCol !== undefined && c === profitCol) {
              ws[ref].s = safeNum(ws[ref].v) >= 0 ? profitPosStyle : profitNegStyle
            } else if (moneyCols.includes(c)) ws[ref].s = zebra ? currencyZebraStyle : currencyStyle
            else if (pctCols.includes(c)) ws[ref].s = percentStyle
            else ws[ref].s = zebra ? zebraStyle : cellStyle
          }
        }
        const totalRow = 5 + dataCount
        for (let c = 0; c < colCount; c++) {
          const ref = XLSX.utils.encode_cell({ r: totalRow, c })
          if (!ws[ref]) continue
          if (profitCol !== undefined && c === profitCol) {
            ws[ref].s = safeNum(ws[ref].v) >= 0 ? profitPosTotalStyle : profitNegTotalStyle
          } else {
            ws[ref].s = moneyCols.includes(c) || pctCols.includes(c) ? totalCurrencyStyle : totalLabelStyle
          }
        }
        // Borde exterior grueso en todo el bloque (r0..totalRow)
        for (let r = 0; r <= totalRow; r++) {
          for (let c = 0; c < colCount; c++) {
            const ref = XLSX.utils.encode_cell({ r, c })
            const cell = ws[ref]
            if (!cell) continue
            const b: any = { ...(cell.s?.border || {}) }
            const thick = { style: 'medium', color: { rgb: primaryRgb } }
            if (r === 0) b.top = thick
            if (r === totalRow) b.bottom = thick
            if (c === 0) b.left = thick
            if (c === colCount - 1) b.right = thick
            cell.s = { ...(cell.s || {}), border: { ...thinBorder, ...b } }
          }
        }
        ws['!rows'] = [{ hpt: 24 }, { hpt: 16 }, { hpt: 18 }, {}, { hpt: 20 }]
      }

      const wb = XLSX.utils.book_new()
      const totalGastos = expenses.reduce((s, e) => s + safeNum(e.amount), 0)

      // === GASTOS SHEET ===
      const expHeaders = ['Fecha', 'Descripción', 'Categoría', 'Método Pago', 'Monto', 'Notas', 'Registrado por']
      const expData = expenses.map((e) => [
        e.expenseDate,
        e.description,
        EXPENSE_CATEGORY_LABELS[e.category] || e.category,
        e.paymentMethod ? getPaymentMethodLabel(e.paymentMethod) : '',
        safeNum(e.amount),
        e.notes || '',
        e.createdByName || '',
      ])
      const expAoA: any[][] = [
        [companyName],
        [infoLine],
        [`GASTOS — Período ${dateRange.start} a ${dateRange.end}`],
        [],
        expHeaders,
        ...expData,
        ['', '', '', 'TOTAL', totalGastos, '', ''],
      ]
      const wsExp = XLSX.utils.aoa_to_sheet(expAoA)
      styleSheet(wsExp, expHeaders.length, expData.length, [4])
      wsExp['!cols'] = [{ wch: 12 }, { wch: 40 }, { wch: 18 }, { wch: 15 }, { wch: 14 }, { wch: 30 }, { wch: 18 }]
      XLSX.utils.book_append_sheet(wb, wsExp, 'Gastos')

      // === RESUMEN POR CATEGORÍA SHEET ===
      const byCategory = new Map<string, { count: number; total: number }>()
      expenses.forEach((e) => {
        const key = e.category || 'OTROS'
        const cur = byCategory.get(key) || { count: 0, total: 0 }
        cur.count += 1
        cur.total += safeNum(e.amount)
        byCategory.set(key, cur)
      })
      const catRows = [...byCategory.entries()].sort((a, b) => b[1].total - a[1].total)
      const sumHeaders = ['Categoría', '# Gastos', 'Total', '% del Total']
      const sumData = catRows.map(([cat, v]) => [
        EXPENSE_CATEGORY_LABELS[cat] || cat,
        v.count,
        v.total,
        totalGastos > 0 ? v.total / totalGastos : 0,
      ])
      const sumAoA: any[][] = [
        [companyName],
        [infoLine],
        [`RESUMEN DE GASTOS POR CATEGORÍA — ${dateRange.start} a ${dateRange.end}`],
        [],
        sumHeaders,
        ...sumData,
        ['TOTAL', expenses.length, totalGastos, 1],
      ]
      const wsSum = XLSX.utils.aoa_to_sheet(sumAoA)
      styleSheet(wsSum, sumHeaders.length, sumData.length, [2], [3])
      wsSum['!cols'] = [{ wch: 22 }, { wch: 12 }, { wch: 16 }, { wch: 14 }]
      XLSX.utils.book_append_sheet(wb, wsSum, 'ResumenPorCategoria')

      // === VENTAS VS GASTOS SHEET ===
      if (profitComparison) {
        const cmpHeaders = ['Fecha', 'Ventas Netas', 'Gastos', 'Ganancia']
        const cmpData = profitComparison.days.map((d) => [
          d.date,
          safeNum(d.netSales),
          safeNum(d.expenses),
          safeNum(d.profit),
        ])
        const cmpAoA: any[][] = [
          [companyName],
          [infoLine],
          [`VENTAS NETAS VS GASTOS — ${dateRange.start} a ${dateRange.end}`],
          [],
          cmpHeaders,
          ...cmpData,
          ['TOTAL', safeNum(profitComparison.totalNetSales), safeNum(profitComparison.totalExpenses), safeNum(profitComparison.totalProfit)],
        ]
        const wsCmp = XLSX.utils.aoa_to_sheet(cmpAoA)
        styleSheet(wsCmp, cmpHeaders.length, cmpData.length, [1, 2, 3], [], 3)
        wsCmp['!cols'] = [{ wch: 12 }, { wch: 15 }, { wch: 15 }, { wch: 15 }]
        XLSX.utils.book_append_sheet(wb, wsCmp, 'VentasVsGastos')
      }

      XLSX.writeFile(wb, `gastos_${dateRange.start}_${dateRange.end}.xlsx`)
      toast.success('Reporte de gastos exportado')
    } catch (error) {
      console.error('Error exporting expenses:', error)
      toast.error('Error al exportar gastos')
    }
  }

  const getPaymentMethodLabel = (method: string) => {
    switch (method) {
      case 'EFECTIVO':
        return 'Efectivo'
      case 'TARJETA_CREDITO':
        return 'Tarjeta Crédito'
      case 'TARJETA_DEBITO':
        return 'Tarjeta Débito'
      case 'TRANSFERENCIA':
        return 'Transferencia'
      case 'NEQUI':
        return 'Nequi'
      case 'DAVIPLATA':
        return 'Daviplata'
      case 'MIXTO':
        return 'Mixto'
      default:
        return method
    }
  }

  useEffect(() => {
    fetchReports()
  }, [dateRange])

  const exportToExcel = async () => {
    if (!salesSummary) {
      toast.error('No hay datos para exportar')
      return
    }

    const startDateTime = `${dateRange.start}T00:00:00`
    const endDateTime = `${dateRange.end}T23:59:59`

    const getPaymentMethodLabelLocal = (method?: string | null) => {
      const m = method || ''
      if (!m) return 'N/A'
      return getPaymentMethodLabel(m)
    }

    const loadingToast = toast.loading('Generando Excel...')
    try {
      const invoices = (await invoiceService.getByDateRange(startDateTime, endDateTime).catch(() => [])) as any[]

      const invoicesCompleted = invoices.filter((i) => (i as any).status === 'COMPLETADA')

      const totals = buildPaymentTotals(invoicesCompleted)

      // Helper: convert hex color to ARGB (without #)
      const hexToArgb = (hex: string) => hex.replace('#', '').toUpperCase()

      // Style definitions using theme colors
      const primaryColor = hexToArgb(theme.primaryColor || '#9b87f5')
      const secondaryColor = hexToArgb(theme.secondaryColor || '#7c3aed')
      const companyName = company.companyName || 'Mi Negocio'

      const titleStyle: any = {
        font: { bold: true, sz: 16, color: { rgb: 'FFFFFF' } },
        fill: { fgColor: { rgb: secondaryColor } },
        alignment: { horizontal: 'center', vertical: 'center' },
      }

      const headerStyle: any = {
        font: { bold: true, sz: 11, color: { rgb: 'FFFFFF' } },
        fill: { fgColor: { rgb: primaryColor } },
        alignment: { horizontal: 'center', vertical: 'center' },
        border: {
          top: { style: 'thin', color: { rgb: '000000' } },
          bottom: { style: 'thin', color: { rgb: '000000' } },
          left: { style: 'thin', color: { rgb: '000000' } },
          right: { style: 'thin', color: { rgb: '000000' } },
        },
      }

      const currencyFmt = '"$"#,##0'

      const currencyStyle: any = {
        numFmt: currencyFmt,
        alignment: { horizontal: 'right' },
      }

      const labelStyle: any = {
        font: { bold: true, sz: 11 },
        alignment: { horizontal: 'left' },
      }

      const sectionStyle: any = {
        font: { bold: true, sz: 12, color: { rgb: secondaryColor } },
        fill: { fgColor: { rgb: 'F3F4F6' } },
      }

      // Helper: auto-fit column widths based on content
      const autoFitColumns = (ws: any, data: any[][], minWidth = 10) => {
        const colWidths: number[] = []
        data.forEach(row => {
          row.forEach((cell, i) => {
            const len = cell != null ? String(cell).length : 0
            colWidths[i] = Math.max(colWidths[i] || minWidth, len + 4)
          })
        })
        ws['!cols'] = colWidths.map(w => ({ wch: Math.min(w, 50) }))
      }

      const wb = XLSX.utils.book_new()

      // === RESUMEN SHEET ===
      const resumenAoA: any[][] = [
        [companyName],
        ['REPORTE DE VENTAS'],
        [`Período: ${dateRange.start} a ${dateRange.end}`],
        [],
        ['SUBTOTALES Y TOTALES'],
        ['Subtotal (antes de cargos)', totals.subtotal],
        ['Impuestos', totals.tax],
        ['Descuentos', -totals.discount],
        ['Subtotal Neto', totals.subtotal + totals.tax - totals.discount],
        [],
        ['CARGOS ADICIONALES'],
        ['Servicio/Propina Total', totals.serviceCharge],
        ['  - En Efectivo', totals.cash.serviceOnly],
        ['  - En Transferencia', totals.transfer.serviceOnly],
        ['Domicilios Total', totals.deliveryCharge],
        [],
        ['TOTAL FACTURADO', totals.total],
        [],
        ['DISCRIMINACIÓN POR MÉTODO DE PAGO'],
        ['EFECTIVO'],
        ['  Total efectivo', totals.cash.total],
        ['  Sin servicio ni domicilio', totals.cash.netSales],
        ['  Servicio (propina)', totals.cash.serviceOnly],
        ['  Domicilios en efectivo', totals.cash.deliveryOnly],
        [],
        ['TRANSFERENCIA / MIXTO'],
        ['  Total transferencia', totals.transfer.total],
        ['  Sin servicio ni domicilio', totals.transfer.netSales],
        ['  Servicio (propina)', totals.transfer.serviceOnly],
        ['  Domicilios en transfer', totals.transfer.deliveryOnly],
        [],
        ['CIERRE DE CAJA'],
        ['Total Efectivo (sin propinas ni domicilio)', totals.cash.netSales],
        ['Total Transferencia (sin propinas ni domicilio)', totals.transfer.netSales],
        ['Total Domicilios', totals.deliveryCharge],
        ['Total Servicio/Propina', totals.serviceCharge],
        ['GRAN TOTAL DUEÑO', totals.cash.netSales + totals.transfer.netSales],
      ]

      const wsResumen = XLSX.utils.aoa_to_sheet(resumenAoA)
      wsResumen['!merges'] = [
        { s: { r: 0, c: 0 }, e: { r: 0, c: 1 } },
        { s: { r: 1, c: 0 }, e: { r: 1, c: 1 } },
        { s: { r: 2, c: 0 }, e: { r: 2, c: 1 } },
        { s: { r: 4, c: 0 }, e: { r: 4, c: 1 } },
        { s: { r: 10, c: 0 }, e: { r: 10, c: 1 } },
        { s: { r: 18, c: 0 }, e: { r: 18, c: 1 } },
        { s: { r: 19, c: 0 }, e: { r: 19, c: 1 } },
        { s: { r: 24, c: 0 }, e: { r: 24, c: 1 } },
        { s: { r: 29, c: 0 }, e: { r: 29, c: 1 } },
      ]

      // Apply styles to Resumen
      if (wsResumen['A1']) wsResumen['A1'].s = titleStyle
      if (wsResumen['A2']) wsResumen['A2'].s = { ...titleStyle, font: { ...titleStyle.font, sz: 13 } }
      if (wsResumen['A3']) wsResumen['A3'].s = { font: { italic: true, sz: 10, color: { rgb: '666666' } }, alignment: { horizontal: 'center' } }

      // Section headers (merged cells)
      if (wsResumen['A5']) wsResumen['A5'].s = sectionStyle
      if (wsResumen['A11']) wsResumen['A11'].s = sectionStyle
      if (wsResumen['A19']) wsResumen['A19'].s = sectionStyle
      if (wsResumen['A20']) wsResumen['A20'].s = sectionStyle
      if (wsResumen['A25']) wsResumen['A25'].s = sectionStyle
      if (wsResumen['A30']) wsResumen['A30'].s = sectionStyle

      // Apply label and currency styles to all data rows
      for (let r = 5; r <= 34; r++) {
        const labelRef = `A${r + 1}`
        const valRef = `B${r + 1}`
        if (wsResumen[labelRef]) wsResumen[labelRef].s = labelStyle
        if (wsResumen[valRef] && typeof wsResumen[valRef].v === 'number') {
          wsResumen[valRef].s = currencyStyle
        }
      }

      autoFitColumns(wsResumen, resumenAoA, 20)
      XLSX.utils.book_append_sheet(wb, wsResumen, 'Resumen')

      // === FACTURAS SHEET ===
      const invoicesHeaders = ['Fecha', 'Número', 'Cliente', 'Método Pago', 'Subtotal', 'Impuesto', 'Descuento', 'Servicio %', 'Servicio $', 'Domicilio $', 'Total', 'Estado']
      const invoicesData = invoices.map((inv) => [
        (inv as any).createdAt ? String((inv as any).createdAt).replace('T', ' ').slice(0, 19) : '',
        (inv as any).invoiceNumber || '',
        (inv as any).customer?.fullName || 'Cliente General',
        getPaymentMethodLabelLocal((inv as any).paymentMethod),
        safeNum((inv as any).subtotal),
        safeNum((inv as any).taxAmount),
        safeNum((inv as any).discountAmount),
        safeNum((inv as any).serviceChargePercent || 0),
        safeNum((inv as any).serviceChargeAmount || 0),
        safeNum((inv as any).deliveryChargeAmount || 0),
        safeNum((inv as any).total),
        (inv as any).status || ''
      ])
      const invoicesAoA = [invoicesHeaders, ...invoicesData]
      const wsInvoices = XLSX.utils.aoa_to_sheet(invoicesAoA)

      // Style invoice headers
      invoicesHeaders.forEach((_, i) => {
        const ref = XLSX.utils.encode_cell({ r: 0, c: i })
        if (wsInvoices[ref]) wsInvoices[ref].s = headerStyle
      })

      // Apply currency format to monetary columns (4=Subtotal, 5=Impuesto, 6=Descuento, 8=Servicio$, 9=Domicilio$, 10=Total)
      const moneyCols = [4, 5, 6, 8, 9, 10]
      invoicesData.forEach((_, rowIdx) => {
        moneyCols.forEach(colIdx => {
          const ref = XLSX.utils.encode_cell({ r: rowIdx + 1, c: colIdx })
          if (wsInvoices[ref]) wsInvoices[ref].s = currencyStyle
        })
      })

      autoFitColumns(wsInvoices, invoicesAoA, 12)
      XLSX.utils.book_append_sheet(wb, wsInvoices, 'Facturas')

      // === MÉTODOS DE PAGO SHEET ===
      // Comentado - No se exporta métodos de pago según solicitud
      // if (paymentMethods.length > 0) {
      //   const payHeaders = ['Método', 'Transacciones', 'Total', 'Porcentaje %']
      //   const payData = paymentMethods.map((m) => [
      //     getPaymentMethodLabel(m.paymentMethod),
      //     safeNum((m as any).count),
      //     safeNum((m as any).totalSales ?? (m as any).total),
      //     safeNum((m as any).percentage),
      //   ])
      //   const payAoA = [payHeaders, ...payData]
      //   const wsPay = XLSX.utils.aoa_to_sheet(payAoA)
      //   payHeaders.forEach((_, i) => {
      //     const ref = XLSX.utils.encode_cell({ r: 0, c: i })
      //     if (wsPay[ref]) wsPay[ref].s = headerStyle
      //   })
      //   payData.forEach((_, rowIdx) => {
      //     const totalRef = XLSX.utils.encode_cell({ r: rowIdx + 1, c: 2 })
      //     if (wsPay[totalRef]) wsPay[totalRef].s = currencyStyle
      //   })
      //   autoFitColumns(wsPay, payAoA)
      //   XLSX.utils.book_append_sheet(wb, wsPay, 'MetodosPago')
      // }

      // === TOP PRODUCTOS SHEET ===
      if (topProducts.length > 0) {
        const prodHeaders = ['Producto', 'Cantidad', 'Ingresos']
        const prodData = topProducts.map((p) => [
          p.productName,
          safeNum(p.totalQuantity),
          safeNum(p.totalRevenue),
        ])
        const prodAoA = [prodHeaders, ...prodData]
        const wsProd = XLSX.utils.aoa_to_sheet(prodAoA)
        prodHeaders.forEach((_, i) => {
          const ref = XLSX.utils.encode_cell({ r: 0, c: i })
          if (wsProd[ref]) wsProd[ref].s = headerStyle
        })
        prodData.forEach((_, rowIdx) => {
          const ref = XLSX.utils.encode_cell({ r: rowIdx + 1, c: 2 })
          if (wsProd[ref]) wsProd[ref].s = currencyStyle
        })
        autoFitColumns(wsProd, prodAoA)
        XLSX.utils.book_append_sheet(wb, wsProd, 'TopProductos')
      }

      // === TOP CLIENTES SHEET ===
      if (topCustomers.length > 0) {
        const custHeaders = ['Cliente', 'Compras', 'Total Gastado']
        const custData = topCustomers.map((c) => [
          c.customerName,
          safeNum(c.totalPurchases),
          safeNum(c.totalSpent),
        ])
        const custAoA = [custHeaders, ...custData]
        const wsCust = XLSX.utils.aoa_to_sheet(custAoA)
        custHeaders.forEach((_, i) => {
          const ref = XLSX.utils.encode_cell({ r: 0, c: i })
          if (wsCust[ref]) wsCust[ref].s = headerStyle
        })
        custData.forEach((_, rowIdx) => {
          const ref = XLSX.utils.encode_cell({ r: rowIdx + 1, c: 2 })
          if (wsCust[ref]) wsCust[ref].s = currencyStyle
        })
        autoFitColumns(wsCust, custAoA)
        XLSX.utils.book_append_sheet(wb, wsCust, 'TopClientes')
      }

      // === VENTAS VS GASTOS SHEET ===
      if (profitComparison) {
        const cmpHeaders = ['Fecha', 'Ventas Netas', 'Gastos', 'Ganancia']
        const cmpData = profitComparison.days.map((d) => [
          d.date,
          safeNum(d.netSales),
          safeNum(d.expenses),
          safeNum(d.profit),
        ])
        const cmpAoA = [cmpHeaders, ...cmpData, [], ['TOTAL', safeNum(profitComparison.totalNetSales), safeNum(profitComparison.totalExpenses), safeNum(profitComparison.totalProfit)]]
        const wsCmp = XLSX.utils.aoa_to_sheet(cmpAoA)
        cmpHeaders.forEach((_, i) => {
          const ref = XLSX.utils.encode_cell({ r: 0, c: i })
          if (wsCmp[ref]) wsCmp[ref].s = headerStyle
        })
        cmpData.forEach((_, rowIdx) => {
          [1, 2, 3].forEach((c) => {
            const ref = XLSX.utils.encode_cell({ r: rowIdx + 1, c })
            if (wsCmp[ref]) wsCmp[ref].s = currencyStyle
          })
        })
        wsCmp['!cols'] = [{ wch: 12 }, { wch: 15 }, { wch: 15 }, { wch: 15 }]
        XLSX.utils.book_append_sheet(wb, wsCmp, 'VentasVsGastos')
      }

      XLSX.writeFile(wb, `reporte_ventas_${dateRange.start}_${dateRange.end}.xlsx`)
      toast.success('Excel exportado correctamente')
    } catch (error) {
      console.error('Error exporting Excel:', error)
      toast.error('Error al exportar Excel')
    } finally {
      toast.dismiss(loadingToast)
    }
  }

  return (
    <div className="space-y-4 sm:space-y-6 animate-fade-in">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-xl sm:text-2xl font-bold text-gray-800">Reportes</h1>
          <p className="text-sm sm:text-base text-gray-500">Análisis y estadísticas de tu negocio</p>
        </div>
      </div>

      {/* Date Filter - compact reusable */}
      <div className="flex flex-wrap items-center gap-3">
        <DateRangeFilter dateRange={dateRange} setDateRange={setDateRange} />
        <Button variant="primary" size="sm" onClick={exportToExcel}><Download size={18} /> Exportar</Button>
        <Button variant="secondary" size="sm" onClick={() => setShowBasicReport(true)}><FileText size={18} /> Reporte Básico</Button>
      </div>

      {/* Basic Owner Report Modal */}
      {showBasicReport && (
        <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl shadow-2xl w-full max-w-sm p-6 animate-scale-in" id="basic-report-print">
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-lg font-bold text-gray-800">Reporte del Dueño</h2>
              <button onClick={() => setShowBasicReport(false)} className="text-gray-400 hover:text-gray-600 no-print">
                <X size={20} />
              </button>
            </div>
            <p className="text-xs text-gray-500 mb-4 text-center">{dateRange.start} &rarr; {dateRange.end}</p>
            <div className="space-y-3">
              <div className="flex justify-between items-center py-2 border-b border-gray-100">
                <span className="text-sm text-gray-600">Ventas Efectivo</span>
                <span className="text-base font-bold text-green-700">{formatCurrency(totals?.cash?.netSales || 0)}</span>
              </div>
              <p className="text-xs text-gray-400 -mt-2 pb-1">(sin servicio ni domicilio)</p>
              <div className="flex justify-between items-center py-2 border-b border-gray-100">
                <span className="text-sm text-gray-600">Ventas Transferencia</span>
                <span className="text-base font-bold text-blue-700">{formatCurrency(totals?.transfer?.netSales || 0)}</span>
              </div>
              <p className="text-xs text-gray-400 -mt-2 pb-1">(sin servicio ni domicilio)</p>
              <div className="flex justify-between items-center py-3 bg-emerald-50 rounded-xl px-3">
                <span className="text-sm font-bold text-emerald-800">Total Dueño</span>
                <span className="text-xl font-bold text-emerald-700">{formatCurrency((totals?.cash?.netSales || 0) + (totals?.transfer?.netSales || 0))}</span>
              </div>
              <div className="pt-2 grid grid-cols-2 gap-2 text-xs text-gray-500">
                <div className="bg-amber-50 rounded-lg p-2 text-center">
                  <p className="font-medium text-amber-800">Propinas</p>
                  <p className="font-bold text-amber-700">{formatCurrency(totals?.serviceCharge || 0)}</p>
                </div>
                <div className="bg-purple-50 rounded-lg p-2 text-center">
                  <p className="font-medium text-purple-800">Domicilios</p>
                  <p className="font-bold text-purple-700">{formatCurrency(totals?.deliveryCharge || 0)}</p>
                </div>
              </div>
            </div>
            <button
              onClick={exportBasicReportToExcel}
              className="mt-5 w-full flex items-center justify-center gap-2 px-4 py-2.5 bg-gray-800 text-white rounded-xl hover:bg-gray-700 transition-colors text-sm font-medium no-print"
            >
              <Download size={16} /> Exportar Excel
            </button>
          </div>
        </div>
      )}

      {loading ? (
        <div className="flex items-center justify-center py-12">
          <Loader2 className="w-8 h-8 animate-spin text-primary-600" />
        </div>
      ) : (
        <>
          {/* Quick Stats */}
          <div className="grid grid-cols-2 sm:grid-cols-3 xl:grid-cols-6 gap-3">
            {[
              { label: 'Ventas Totales', value: formatCurrency(salesSummary?.totalSales || 0), icon: <DollarSign className="w-5 h-5 text-white" />, color: 'from-green-500 to-green-600' },
              { label: 'Transacciones', value: String((salesSummary as any)?.salesCount || (salesSummary as any)?.totalTransactions || 0), icon: <BarChart3 className="w-5 h-5 text-white" />, color: 'from-primary-500 to-primary-600' },
              { label: 'Ticket Promedio', value: formatCurrency(salesSummary?.averageTicket || 0), icon: <TrendingUp className="w-5 h-5 text-white" />, color: 'from-blue-500 to-blue-600' },
              { label: 'Ganancia Neta', value: formatCurrency(salesSummary?.grossProfit || salesSummary?.totalProfit || 0), icon: <DollarSign className="w-5 h-5 text-white" />, color: 'from-amber-500 to-amber-600' },
              { label: 'Servicio (Propinas)', value: formatCurrency(totals?.serviceCharge || 0), icon: <DollarSign className="w-5 h-5 text-white" />, color: 'from-indigo-500 to-indigo-600' },
              { label: 'Total Neto', value: formatCurrency((totals?.total || 0) - (totals?.serviceCharge || 0)), icon: <DollarSign className="w-5 h-5 text-white" />, color: 'from-emerald-500 to-emerald-600' },
            ].map((stat) => (
              <div key={stat.label} className="card p-3 sm:p-4">
                <div className="flex items-start gap-3">
                  <div className={`w-9 h-9 rounded-xl bg-gradient-to-r ${stat.color} flex items-center justify-center shadow-soft flex-shrink-0`}>
                    {stat.icon}
                  </div>
                  <div className="min-w-0 flex-1 overflow-hidden">
                    <p className="text-xs text-gray-500 leading-tight mb-1">{stat.label}</p>
                    <p className="text-sm sm:text-base font-bold text-gray-800 break-words leading-tight">{stat.value}</p>
                  </div>
                </div>
              </div>
            ))}
          </div>

          {/* Owner Report */}
          <div className="card border-2 border-emerald-200 bg-gradient-to-r from-emerald-50 to-teal-50">
            <h3 className="text-lg font-bold text-emerald-800 mb-4">📊 Reporte del Dueño</h3>
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
              <div className="p-4 bg-white rounded-xl border border-blue-200">
                <p className="text-xs text-gray-500 mb-1">Ventas Transferencia</p>
                <p className="text-xl font-bold text-blue-700">{formatCurrency(totals?.transfer?.netSales || 0)}</p>
                <p className="text-xs text-gray-400 mt-1">Sin servicio ni domicilio</p>
                {(totals?.transfer?.deliveryOnly || 0) > 0 && (
                  <p className="text-xs text-amber-600 mt-1">Domicilios: {formatCurrency(totals.transfer.deliveryOnly)}</p>
                )}
              </div>
              <div className="p-4 bg-white rounded-xl border border-green-200">
                <p className="text-xs text-gray-500 mb-1">Ventas Efectivo</p>
                <p className="text-xl font-bold text-green-700">{formatCurrency(totals?.cash?.netSales || 0)}</p>
                <p className="text-xs text-gray-400 mt-1">Sin servicio ni domicilio</p>
              </div>
              <div className="p-4 bg-emerald-600 rounded-xl text-white">
                <p className="text-xs text-emerald-100 mb-1">Gran Total Dueño</p>
                <p className="text-xl font-bold">{formatCurrency((totals?.transfer?.netSales || 0) + (totals?.cash?.netSales || 0))}</p>
                <p className="text-xs text-emerald-200 mt-1">Transferencia + Efectivo netos</p>
              </div>
            </div>
            <div className="mt-3 pt-3 border-t border-emerald-200 grid grid-cols-2 sm:grid-cols-4 gap-2 text-xs text-gray-600">
              <span>Propinas: <strong className="text-amber-700">{formatCurrency(totals?.serviceCharge || 0)}</strong></span>
              <span>Domicilios: <strong className="text-purple-700">{formatCurrency(totals?.deliveryCharge || 0)}</strong></span>
              <span>Total Efectivo: <strong>{formatCurrency(totals?.cash?.total || 0)}</strong></span>
              <span>Total Transfer: <strong>{formatCurrency(totals?.transfer?.total || 0)}</strong></span>
            </div>
          </div>

          {/* Expenses & Profit Comparison */}
          <div className="card border-2 border-orange-200 bg-gradient-to-r from-orange-50 to-amber-50">
            <div className="flex flex-wrap items-center justify-between gap-2 mb-4">
              <h3 className="text-lg font-bold text-orange-800 flex items-center gap-2">
                <Wallet className="w-5 h-5" /> Gastos y Utilidad
              </h3>
              <div className="flex gap-2">
                <Button variant="secondary" size="sm" onClick={exportExpensesToExcel}>
                  <Download size={16} /> Exportar gastos
                </Button>
                <Button variant="primary" size="sm" onClick={() => openExpenseModal()}>
                  <Plus size={16} /> Nuevo gasto
                </Button>
              </div>
            </div>

            {/* KPIs del período */}
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 mb-4">
              <div className="p-4 bg-white rounded-xl border border-green-200">
                <p className="text-xs text-gray-500 mb-1">Ventas Netas (sin servicio ni domicilio)</p>
                <p className="text-xl font-bold text-green-700">{formatCurrency(profitComparison?.totalNetSales || 0)}</p>
              </div>
              <div className="p-4 bg-white rounded-xl border border-orange-200">
                <p className="text-xs text-gray-500 mb-1">Gastos del Período</p>
                <p className="text-xl font-bold text-orange-700">{formatCurrency(profitComparison?.totalExpenses || 0)}</p>
              </div>
              <div className={`p-4 rounded-xl text-white ${(profitComparison?.totalProfit || 0) >= 0 ? 'bg-emerald-600' : 'bg-red-600'}`}>
                <p className="text-xs text-emerald-100 mb-1">Ganancia del Período</p>
                <p className="text-xl font-bold">{formatCurrency(profitComparison?.totalProfit || 0)}</p>
                <p className="text-xs opacity-80 mt-1">Ventas netas - gastos</p>
              </div>
            </div>

            {/* Comparativo diario */}
            {profitComparison && profitComparison.days.length > 0 && (
              <div className="mb-4 bg-white rounded-xl border border-orange-100 overflow-x-auto">
                <table className="w-full text-sm">
                  <thead>
                    <tr className="border-b border-orange-100 text-left">
                      <th className="px-4 py-2 font-semibold text-gray-600">Fecha</th>
                      <th className="px-4 py-2 font-semibold text-gray-600 text-right">Ventas Netas</th>
                      <th className="px-4 py-2 font-semibold text-gray-600 text-right">Gastos</th>
                      <th className="px-4 py-2 font-semibold text-gray-600 text-right">Ganancia</th>
                    </tr>
                  </thead>
                  <tbody>
                    {profitComparison.days.map((d) => (
                      <tr key={d.date} className="border-b border-orange-50 last:border-0">
                        <td className="px-4 py-2 text-gray-700">{d.date}</td>
                        <td className="px-4 py-2 text-right font-medium text-green-700">{formatCurrency(safeNum(d.netSales))}</td>
                        <td className="px-4 py-2 text-right font-medium text-orange-600">{formatCurrency(safeNum(d.expenses))}</td>
                        <td className={`px-4 py-2 text-right font-bold ${safeNum(d.profit) >= 0 ? 'text-emerald-700' : 'text-red-600'}`}>
                          {formatCurrency(safeNum(d.profit))}
                        </td>
                      </tr>
                    ))}
                    <tr className="bg-orange-50 font-bold">
                      <td className="px-4 py-2 text-gray-800">TOTAL</td>
                      <td className="px-4 py-2 text-right text-green-700">{formatCurrency(profitComparison.totalNetSales)}</td>
                      <td className="px-4 py-2 text-right text-orange-700">{formatCurrency(profitComparison.totalExpenses)}</td>
                      <td className={`px-4 py-2 text-right ${profitComparison.totalProfit >= 0 ? 'text-emerald-700' : 'text-red-600'}`}>
                        {formatCurrency(profitComparison.totalProfit)}
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            )}

            {/* Lista de gastos */}
            <div className="bg-white rounded-xl border border-orange-100 overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="border-b border-orange-100 text-left">
                    <th className="px-4 py-2 font-semibold text-gray-600">Fecha</th>
                    <th className="px-4 py-2 font-semibold text-gray-600">Descripción</th>
                    <th className="px-4 py-2 font-semibold text-gray-600">Categoría</th>
                    <th className="px-4 py-2 font-semibold text-gray-600 hidden sm:table-cell">Método</th>
                    <th className="px-4 py-2 font-semibold text-gray-600 text-right">Monto</th>
                    <th className="px-4 py-2 font-semibold text-gray-600 hidden lg:table-cell">Registrado por</th>
                    <th className="px-4 py-2 font-semibold text-gray-600 text-center">Acciones</th>
                  </tr>
                </thead>
                <tbody>
                  {expenses.length === 0 ? (
                    <tr>
                      <td colSpan={7} className="px-4 py-6 text-center text-gray-400">
                        Sin gastos registrados en el período
                      </td>
                    </tr>
                  ) : (
                    expenses.map((expense) => (
                      <tr key={expense.id} className="border-b border-orange-50 last:border-0 hover:bg-orange-50/50">
                        <td className="px-4 py-2 text-gray-700 whitespace-nowrap">{expense.expenseDate}</td>
                        <td className="px-4 py-2 text-gray-800">
                          {expense.description}
                          {expense.notes && <p className="text-xs text-gray-400 truncate max-w-[240px]">{expense.notes}</p>}
                        </td>
                        <td className="px-4 py-2">
                          <span className="px-2 py-0.5 rounded-full text-xs font-medium bg-orange-100 text-orange-700">
                            {EXPENSE_CATEGORY_LABELS[expense.category] || expense.category}
                          </span>
                        </td>
                        <td className="px-4 py-2 text-gray-600 hidden sm:table-cell">
                          {expense.paymentMethod ? getPaymentMethodLabel(expense.paymentMethod) : '—'}
                        </td>
                        <td className="px-4 py-2 text-right font-semibold text-gray-800">{formatCurrency(safeNum(expense.amount))}</td>
                        <td className="px-4 py-2 text-gray-500 hidden lg:table-cell">{expense.createdByName || '—'}</td>
                        <td className="px-4 py-2">
                          <div className="flex items-center justify-center gap-1">
                            <button
                              onClick={() => openExpenseModal(expense)}
                              className="p-1.5 text-blue-600 hover:bg-blue-50 rounded-lg transition-colors"
                              title="Editar gasto"
                            >
                              <Edit2 size={16} />
                            </button>
                            <button
                              onClick={() => handleDeleteExpense(expense)}
                              className="p-1.5 text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                              title="Eliminar gasto"
                            >
                              <Trash2 size={16} />
                            </button>
                          </div>
                        </td>
                      </tr>
                    ))
                  )}
                </tbody>
              </table>
            </div>
          </div>

          {/* Payment Method Breakdown */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3">
            <div className="card bg-gradient-to-br from-green-50 to-green-100 border-l-4 border-green-500">
              <div className="flex items-center gap-3 mb-3">
                <div className="w-10 h-10 rounded-xl bg-green-500 flex items-center justify-center shadow-soft">
                  <CreditCard className="w-5 h-5 text-white" />
                </div>
                <h3 className="font-bold text-green-800">Efectivo</h3>
              </div>
              <div className="space-y-2 text-sm">
                <div className="flex justify-between">
                  <span className="text-gray-600">Total:</span>
                  <span className="font-semibold text-gray-800">{formatCurrency(totals?.cash?.total || 0)}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Sin servicio:</span>
                  <span className="font-semibold text-gray-800">{formatCurrency(totals?.cash?.withoutService || 0)}</span>
                </div>
                <div className="flex justify-between border-t pt-2">
                  <span className="text-gray-600">Propinas:</span>
                  <span className="font-semibold text-amber-600">{formatCurrency(totals?.cash?.serviceOnly || 0)}</span>
                </div>
              </div>
            </div>

            <div className="card bg-gradient-to-br from-blue-50 to-blue-100 border-l-4 border-blue-500">
              <div className="flex items-center gap-3 mb-3">
                <div className="w-10 h-10 rounded-xl bg-blue-500 flex items-center justify-center shadow-soft">
                  <CreditCard className="w-5 h-5 text-white" />
                </div>
                <h3 className="font-bold text-blue-800">Transferencia</h3>
              </div>
              <div className="space-y-2 text-sm">
                <div className="flex justify-between">
                  <span className="text-gray-600">Total:</span>
                  <span className="font-semibold text-gray-800">{formatCurrency(totals?.transfer?.total || 0)}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Neto (sin extras):</span>
                  <span className="font-semibold text-gray-800">{formatCurrency(totals?.transfer?.netSales || 0)}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Domicilios:</span>
                  <span className="font-semibold text-purple-600">{formatCurrency(totals?.transfer?.deliveryOnly || 0)}</span>
                </div>
                <div className="flex justify-between border-t pt-2">
                  <span className="text-gray-600">Propinas:</span>
                  <span className="font-semibold text-amber-600">{formatCurrency(totals?.transfer?.serviceOnly || 0)}</span>
                </div>
              </div>
            </div>

            <div className="card bg-gradient-to-br from-purple-50 to-purple-100 border-l-4 border-purple-500">
              <div className="flex items-center gap-3 mb-3">
                <div className="w-10 h-10 rounded-xl bg-purple-500 flex items-center justify-center shadow-soft">
                  <Package className="w-5 h-5 text-white" />
                </div>
                <h3 className="font-bold text-purple-800">Domicilios</h3>
              </div>
              <div className="space-y-2 text-sm">
                <div className="flex justify-between">
                  <span className="text-gray-600">Total:</span>
                  <span className="font-semibold text-gray-800">{formatCurrency(totals?.deliveryCharge || 0)}</span>
                </div>
              </div>
            </div>

            <div className="card bg-gradient-to-br from-emerald-50 to-emerald-100 border-l-4 border-emerald-500">
              <div className="flex items-center gap-3 mb-3">
                <div className="w-10 h-10 rounded-xl bg-emerald-500 flex items-center justify-center shadow-soft">
                  <DollarSign className="w-5 h-5 text-white" />
                </div>
                <h3 className="font-bold text-emerald-800">Total Dueño</h3>
              </div>
              <div className="space-y-2 text-sm">
                <div className="flex justify-between">
                  <span className="text-gray-600">Neto:</span>
                  <span className="font-semibold text-gray-800">{formatCurrency((totals?.total || 0) - (totals?.serviceCharge || 0))}</span>
                </div>
                <div className="text-xs text-gray-500 mt-2">
                  (Total - Propinas)
                </div>
              </div>
            </div>
          </div>

          {/* Inventory Summary */}
          {inventorySummary && (
            <div className="grid grid-cols-1 xs:grid-cols-2 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-3 sm:gap-4 lg:gap-6">
              <div className="card">
                <div className="flex items-center gap-4">
                  <div className="w-12 h-12 rounded-xl bg-gradient-to-r from-purple-500 to-purple-600 flex items-center justify-center shadow-soft">
                    <Package className="w-6 h-6 text-white" />
                  </div>
                  <div>
                    <p className="text-sm text-gray-500">Total Productos</p>
                    <p className="text-xl font-bold text-gray-800">{(inventorySummary as any).totalProducts || 0}</p>
                  </div>
                </div>
              </div>
              <div className="card">
                <div className="flex items-center gap-4">
                  <div className="w-12 h-12 rounded-xl bg-gradient-to-r from-orange-500 to-orange-600 flex items-center justify-center shadow-soft">
                    <Package className="w-6 h-6 text-white" />
                  </div>
                  <div>
                    <p className="text-sm text-gray-500">Stock Bajo</p>
                    <p className="text-xl font-bold text-orange-600">{(inventorySummary as any).lowStockProducts ?? (inventorySummary as any).lowStockCount ?? 0}</p>
                  </div>
                </div>
              </div>
              <div className="card">
                <div className="flex items-center gap-4">
                  <div className="w-12 h-12 rounded-xl bg-gradient-to-r from-red-500 to-red-600 flex items-center justify-center shadow-soft">
                    <Package className="w-6 h-6 text-white" />
                  </div>
                  <div>
                    <p className="text-sm text-gray-500">Sin Stock</p>
                    <p className="text-xl font-bold text-red-600">{(inventorySummary as any).outOfStockProducts ?? (inventorySummary as any).outOfStockCount ?? 0}</p>
                  </div>
                </div>
              </div>
            </div>
          )}

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-2 xl:grid-cols-3 gap-4 sm:gap-6">
            {/* Top Products */}
            <div className="card">
              <h3 className="text-lg font-semibold text-gray-800 mb-4">🏆 Productos Más Vendidos</h3>
              {topProducts.length === 0 ? (
                <p className="text-gray-400 text-center py-4">Sin datos para el período</p>
              ) : (
                <div className="space-y-3">
                  {topProducts.map((product, index) => (
                    <div key={product.productId} className="flex items-center justify-between p-3 bg-primary-50 rounded-xl">
                      <div className="flex items-center gap-3">
                        <span className="w-8 h-8 rounded-full bg-primary-600 text-white flex items-center justify-center font-bold text-sm">
                          {index + 1}
                        </span>
                        <span className="font-medium">{product.productName}</span>
                      </div>
                      <div className="text-right">
                        <p className="font-semibold text-primary-600">{formatCurrency(product.totalRevenue)}</p>
                        <p className="text-xs text-gray-500">{product.totalQuantity} unidades</p>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>

            {/* Top Customers */}
            <div className="card">
              <h3 className="text-lg font-semibold text-gray-800 mb-4">👥 Mejores Clientes</h3>
              {topCustomers.length === 0 ? (
                <p className="text-gray-400 text-center py-4">Sin datos para el período</p>
              ) : (
                <div className="space-y-3">
                  {topCustomers.map((customer, index) => (
                    <div key={customer.customerId} className="flex items-center justify-between p-3 bg-primary-50 rounded-xl">
                      <div className="flex items-center gap-3">
                        <span className="w-8 h-8 rounded-full bg-green-600 text-white flex items-center justify-center font-bold text-sm">
                          {index + 1}
                        </span>
                        <span className="font-medium">{customer.customerName}</span>
                      </div>
                      <div className="text-right">
                        <p className="font-semibold text-green-600">{formatCurrency(customer.totalSpent)}</p>
                        <p className="text-xs text-gray-500">{customer.totalPurchases} compras</p>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>

          {/* Payment Methods */}
          <div className="card">
            <h3 className="text-lg font-semibold text-gray-800 mb-4">💳 Métodos de Pago</h3>
            {paymentMethods.length === 0 ? (
              <p className="text-gray-400 text-center py-4">Sin datos para el período</p>
            ) : (
              <div className="grid grid-cols-1 xs:grid-cols-2 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-3 sm:gap-4">
                {paymentMethods.map((method) => (
                  <div key={method.paymentMethod} className="p-4 bg-primary-50 rounded-xl">
                    <div className="flex items-center gap-3 mb-2">
                      <CreditCard className="w-5 h-5 text-primary-600" />
                      <span className="font-medium">{getPaymentMethodLabel(method.paymentMethod)}</span>
                    </div>
                    <p className="text-xl font-bold text-primary-600">{formatCurrency((method as any).totalSales ?? (method as any).total ?? 0)}</p>
                    <p className="text-sm text-gray-500">{method.count} transacciones ({method.percentage?.toFixed(1) || 0}%)</p>
                  </div>
                ))}
              </div>
            )}
          </div>

          {/* Expense Modal */}
          {expenseModal && (
            <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
              <div className="bg-white rounded-2xl shadow-2xl w-full max-w-md p-6 animate-scale-in">
                <div className="flex items-center justify-between mb-4">
                  <h2 className="text-lg font-bold text-gray-800">
                    {expenseModal.expense ? 'Editar Gasto' : 'Nuevo Gasto'}
                  </h2>
                  <button onClick={() => setExpenseModal(null)} className="text-gray-400 hover:text-gray-600">
                    <X size={20} />
                  </button>
                </div>
                <form onSubmit={handleExpenseSubmit} className="space-y-4">
                  <div className="grid grid-cols-2 gap-3">
                    <Input
                      label="Fecha *"
                      type="date"
                      value={expenseForm.expenseDate}
                      onChange={(e) => setExpenseForm({ ...expenseForm, expenseDate: e.target.value })}
                      required
                    />
                    <Input
                      label="Monto *"
                      type="number"
                      min="0.01"
                      step="0.01"
                      value={expenseForm.amount || ''}
                      onChange={(e) => setExpenseForm({ ...expenseForm, amount: Number(e.target.value) })}
                      placeholder="0"
                      required
                    />
                  </div>
                  <Input
                    label="Descripción *"
                    type="text"
                    value={expenseForm.description}
                    onChange={(e) => setExpenseForm({ ...expenseForm, description: e.target.value })}
                    placeholder="Ej: Pago de arriendo"
                    required
                  />
                  <div className="grid grid-cols-2 gap-3">
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Categoría *</label>
                      <select
                        value={expenseForm.category}
                        onChange={(e) => setExpenseForm({ ...expenseForm, category: e.target.value })}
                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                        required
                      >
                        {EXPENSE_CATEGORIES.map((cat) => (
                          <option key={cat} value={cat}>{EXPENSE_CATEGORY_LABELS[cat]}</option>
                        ))}
                      </select>
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Método de pago</label>
                      <select
                        value={expenseForm.paymentMethod || ''}
                        onChange={(e) => setExpenseForm({ ...expenseForm, paymentMethod: e.target.value })}
                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                      >
                        <option value="">Sin especificar</option>
                        {EXPENSE_PAYMENT_METHODS.map((m) => (
                          <option key={m} value={m}>{getPaymentMethodLabel(m)}</option>
                        ))}
                      </select>
                    </div>
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">Notas</label>
                    <textarea
                      value={expenseForm.notes || ''}
                      onChange={(e) => setExpenseForm({ ...expenseForm, notes: e.target.value })}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 resize-none"
                      rows={2}
                      placeholder="Notas adicionales (opcional)"
                    />
                  </div>
                  <div className="flex gap-3 pt-2">
                    <Button type="button" variant="secondary" onClick={() => setExpenseModal(null)} className="flex-1">
                      Cancelar
                    </Button>
                    <Button type="submit" variant="primary" disabled={savingExpense} className="flex-1">
                      {savingExpense ? 'Guardando...' : expenseModal.expense ? 'Actualizar' : 'Registrar'}
                    </Button>
                  </div>
                </form>
              </div>
            </div>
          )}
        </>
      )}
    </div>
  )
}

export default ReportsPage
