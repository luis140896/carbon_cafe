import api from './axiosInstance'
import { Recipe } from '@/types'

export const recipeService = {
  getAll: () => api.get<Recipe[]>('/recipes'),

  getByProductId: (productId: number) =>
    api.get<Recipe>(`/recipes/product/${productId}`),

  save: (recipe: Partial<Recipe>) =>
    api.post<Recipe>('/recipes', recipe),

  deleteByProductId: (productId: number) =>
    api.delete(`/recipes/product/${productId}`),
}
