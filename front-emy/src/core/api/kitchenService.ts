import api from './axiosInstance'

export interface KitchenItem {
  detailId: number
  productName: string
  quantity: number
  notes: string | null
  kitchenStatus: string
  createdAt: string
}

// Nuevo endpoint /kitchen/orders/grouped retorna grupos por mesa.
// Lo normalizamos a la misma forma KitchenOrder[] que usa la UI.
export interface GroupedKitchenResponse {
  tableGroups: {
    tableId: number
    tableName: string
    tableNumber: number
    totalOrders: number
    hasUrgentOrders: boolean
    orders: {
      id: number
      orderTime: string
      sequenceNumber: number
      status: string
      isUrgent: boolean
      urgencyReason: string | null
      notes: string | null
      elapsedMinutes: number
      productName: string
      quantity: number
    }[]
  }[]
  totalTables: number
  totalOrders: number
}

export interface KitchenOrder {
  orderId: number
  invoiceNumber: string
  tableNumber: number | null
  tableName: string | null
  waiterName: string | null
  orderNotes: string | null
  createdAt: string
  sequenceNumber?: number
  isUrgent?: boolean
  urgencyReason?: string | null
  items: KitchenItem[]
}

const normalizeGroupedResponse = (response: GroupedKitchenResponse): KitchenOrder[] => {
  if (!response?.tableGroups) return []
  return response.tableGroups.flatMap((group) =>
    group.orders.map((order) => ({
      orderId: order.id,
      invoiceNumber: `Lote #${order.sequenceNumber ?? order.id}`,
      tableNumber: group.tableNumber ?? null,
      tableName: group.tableName ?? null,
      waiterName: null,
      orderNotes: order.notes,
      createdAt: order.orderTime,
      sequenceNumber: order.sequenceNumber,
      isUrgent: order.isUrgent,
      urgencyReason: order.urgencyReason,
      items: [
        {
          detailId: order.id,
          productName: order.productName,
          quantity: order.quantity,
          notes: order.notes,
          kitchenStatus: order.status,
          createdAt: order.orderTime,
        },
      ],
    }))
  )
}

export const kitchenService = {
  getPendingOrders: async () => {
    const res = await api.get<GroupedKitchenResponse>('/kitchen/orders/grouped')
    return normalizeGroupedResponse(res)
  },

  updateItemStatus: (orderId: number, status: string) =>
    api.put<KitchenItem>(`/kitchen/orders/${orderId}/status`, { status }),

  markAsUrgent: (orderId: number, reason: string) =>
    api.post(`/kitchen/orders/${orderId}/urgent`, { reason }),
}
