import api from './axiosInstance'
import { Expense, ExpenseRequest } from '@/types'

export const expenseService = {
  getByDateRange: (startDate: string, endDate: string) =>
    api.get<Expense[]>(`/expenses?startDate=${startDate}&endDate=${endDate}`),

  create: (data: ExpenseRequest) =>
    api.post<Expense>('/expenses', data),

  update: (id: number, data: ExpenseRequest) =>
    api.put<Expense>(`/expenses/${id}`, data),

  delete: (id: number) =>
    api.delete(`/expenses/${id}`),
}
