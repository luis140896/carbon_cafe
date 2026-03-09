import api from '@/core/api/axiosInstance'

export const authService = {
  login: async (credentials: { username: string; password: string }) => {
    return api.post('/auth/login', credentials)
  },

  refreshToken: async (refreshToken: string) => {
    return api.post('/auth/refresh', { refreshToken })
  },

  logout: async () => {
    return api.post('/auth/logout')
  },
}
