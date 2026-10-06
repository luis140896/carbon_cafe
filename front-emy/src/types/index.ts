export interface Category {
  id: number
  name: string
  description?: string
  imageUrl?: string
  parentId?: number | null
  displayOrder: number
  isActive: boolean
  productCount?: number
  createdAt: string
  updatedAt: string
}

export interface Product {
  id: number
  code: string
  barcode?: string
  name: string
  description?: string
  categoryId: number
  category?: Category
  imageUrl?: string
  costPrice: number
  salePrice: number
  unit: string
  productType?: 'DIRECTO' | 'PREPARADO' | 'INSUMO'
  taxRate: number
  isActive: boolean
  inventory?: Inventory
  createdAt: string
  updatedAt: string
}

export interface Promotion {
  id: number
  name: string
  description?: string
  discountPercent: number
  scheduleType: 'DAILY' | 'WEEKLY' | 'SPECIFIC_DATE'
  daysOfWeek?: string
  startDate?: string
  endDate?: string
  isActive: boolean
  applyToAllProducts: boolean
  priority: number
  createdAt: string
  updatedAt: string
}

export interface Inventory {
  id: number
  productId: number
  product?: Product
  productCode?: string
  productName?: string
  productUnit?: string
  quantity: number
  minStock: number
  maxStock: number
  location?: string
  lastRestockDate?: string
  updatedAt: string
}

export interface InventoryMovement {
  id: number
  productId: number
  product?: Product
  movementType: 'ENTRADA' | 'SALIDA' | 'AJUSTE'
  quantity: number
  previousQuantity: number
  newQuantity: number
  referenceType?: string
  referenceId?: number
  reason?: string
  userId: number
  createdAt: string
}

export interface Customer {
  id: number
  documentType: string
  documentNumber: string
  fullName: string
  email?: string
  phone?: string
  address?: string
  city?: string
  notes?: string
  creditLimit: number
  currentBalance: number
  isActive: boolean
  createdAt: string
  updatedAt: string
}

export interface Invoice {
  id: number
  invoiceNumber: string
  invoiceType: string
  customerId?: number | null
  customerName?: string
  customerDocument?: string
  customer?: Customer
  userId: number
  subtotal: number
  taxAmount: number
  discountAmount: number
  discountPercent: number
  serviceChargePercent: number
  serviceChargeAmount: number
  deliveryChargeAmount: number
  total: number
  paymentMethod?: string
  paymentStatus: 'PAGADO' | 'PENDIENTE' | 'PARCIAL'
  amountReceived: number
  changeAmount: number
  cashAmount?: number
  transferAmount?: number
  status: 'COMPLETADA' | 'ANULADA' | 'PENDIENTE'
  notes?: string
  voidedBy?: number
  voidedAt?: string
  voidReason?: string
  details?: InvoiceDetail[]
  createdAt: string
  updatedAt: string
}

export interface InvoiceDetail {
  id: number
  invoiceId: number
  productId: number
  product?: Product
  productName: string
  quantity: number
  unitPrice: number
  costPrice: number
  discountAmount: number
  taxAmount: number
  subtotal: number
  notes?: string
  kitchenStatus?: string
  createdAt: string
}

export interface Role {
  id: number
  name: string
  description?: string
  permissions: string[]
  isSystem?: boolean
}

export interface User {
  id: number
  username: string
  email: string
  fullName: string
  role?: Role
  avatarUrl?: string
  isActive: boolean
  lastLogin?: string
  createdAt?: string
  updatedAt?: string
}

// ==================== Tables ====================

export interface RestaurantTable {
  id: number
  tableNumber: number
  name: string
  capacity: number
  status: 'DISPONIBLE' | 'OCUPADA' | 'RESERVADA' | 'FUERA_DE_SERVICIO'
  zone: string
  displayOrder: number
  isActive: boolean
  activeSession?: TableSession | null
  createdAt: string
  updatedAt: string
}

export interface TableSession {
  id: number
  tableId: number
  tableNumber: number
  tableName: string
  invoiceId?: number
  invoiceNumber?: string
  openedByName: string
  openedById: number
  closedByName?: string
  openedAt: string
  closedAt?: string
  guestCount: number
  notes?: string
  status: 'ABIERTA' | 'CERRADA' | 'TRANSFERIDA'
  subtotal?: number
  total?: number
  itemCount?: number
  invoice?: Invoice
  customerName?: string
  customerPhone?: string
}

// ==================== Notifications ====================

export interface Notification {
  id: number
  type: string
  title: string
  message: string
  severity: 'INFO' | 'WARNING' | 'ERROR' | 'CRITICAL'
  targetRoles: string[]
  referenceType?: string
  referenceId?: number
  isRead: boolean
  readAt?: string
  createdAt: string
}

export interface RecipeItem {
  id?: number
  ingredientProductId: number
  ingredientProductName?: string
  ingredientUnit?: string
  quantity: number
  wastePercent?: number
  sortOrder?: number
}

export interface Recipe {
  id?: number
  productId: number
  productName?: string
  yieldQty: number
  isActive?: boolean
  items: RecipeItem[]
  createdAt?: string
  updatedAt?: string
}

export interface RecipeAvailability {
  recipeId: number
  productId: number
  productName: string
  productUnit?: string
  yieldQty: number
  isActive?: boolean
  producibleQty?: number | null
  limitingIngredient?: string
  source?: 'RECIPE' | 'PRODUCT_STOCK'
}

export type ExpenseCategory = 'ARRIENDO' | 'SERVICIOS' | 'NOMINA' | 'INSUMOS' | 'TRANSPORTE' | 'OTROS'

export const EXPENSE_CATEGORY_LABELS: Record<string, string> = {
  ARRIENDO: 'Arriendo',
  SERVICIOS: 'Servicios públicos',
  NOMINA: 'Nómina',
  INSUMOS: 'Insumos',
  TRANSPORTE: 'Transporte',
  OTROS: 'Otros',
}

export interface Expense {
  id: number
  expenseDate: string
  description: string
  category: string
  amount: number
  paymentMethod?: string
  notes?: string
  createdById?: number
  createdByName?: string
  createdAt?: string
  updatedAt?: string
}

export interface ExpenseRequest {
  expenseDate: string
  description: string
  category: string
  amount: number
  paymentMethod?: string
  notes?: string
}

export interface DailyProfitComparison {
  date: string
  netSales: number
  expenses: number
  profit: number
}

export interface ProfitComparison {
  days: DailyProfitComparison[]
  totalNetSales: number
  totalExpenses: number
  totalProfit: number
}

export interface PaginatedResponse<T> {
  content: T[]
  totalElements: number
  totalPages: number
  size: number
  number: number
  first: boolean
  last: boolean
}

export interface ApiResponse<T> {
  success: boolean
  message?: string
  data: T
  timestamp: string
}
