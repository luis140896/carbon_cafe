import { useEffect, useRef } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { useNavigate } from 'react-router-dom'
import toast from 'react-hot-toast'
import { logout } from '@/modules/auth/store/authSlice'
import { RootState, AppDispatch } from '@/app/store'

/**
 * Decodifica el payload de un JWT sin verificar firma.
 * Solo para leer la fecha de expiración en el cliente.
 */
function getTokenExpiry(token: string): number | null {
  try {
    const payload = token.split('.')[1]
    if (!payload) return null
    const decoded = JSON.parse(atob(payload.replace(/-/g, '+').replace(/_/g, '/')))
    return typeof decoded.exp === 'number' ? decoded.exp * 1000 : null
  } catch {
    return null
  }
}

/**
 * Hook que monitorea la expiración del access token y cierra la sesión
 * automáticamente cuando expira, mostrando un aviso 60 segundos antes.
 */
export function useTokenExpiry() {
  const dispatch = useDispatch<AppDispatch>()
  const navigate = useNavigate()
  const { accessToken, isAuthenticated } = useSelector((state: RootState) => state.auth)
  const warningShownRef = useRef(false)
  const warningTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null)
  const logoutTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null)

  useEffect(() => {
    // Limpiar timers anteriores
    if (warningTimerRef.current) clearTimeout(warningTimerRef.current)
    if (logoutTimerRef.current) clearTimeout(logoutTimerRef.current)
    warningShownRef.current = false

    if (!isAuthenticated || !accessToken) return

    const expiryMs = getTokenExpiry(accessToken)
    if (!expiryMs) return

    const now = Date.now()
    const msUntilExpiry = expiryMs - now

    // Si ya expiró, cerrar sesión inmediatamente
    if (msUntilExpiry <= 0) {
      dispatch(logout())
      navigate('/login', { replace: true })
      return
    }

    // Aviso 60 segundos antes de expirar
    const msUntilWarning = msUntilExpiry - 60_000
    if (msUntilWarning > 0) {
      warningTimerRef.current = setTimeout(() => {
        if (!warningShownRef.current) {
          warningShownRef.current = true
          toast('Tu sesión expirará en 1 minuto. Guarda tu trabajo.', {
            icon: '⏰',
            duration: 10_000,
          })
        }
      }, msUntilWarning)
    }

    // Cerrar sesión al expirar
    logoutTimerRef.current = setTimeout(() => {
      dispatch(logout())
      toast.error('Tu sesión ha expirado. Por favor inicia sesión nuevamente.')
      navigate('/login', { replace: true })
    }, msUntilExpiry)

    return () => {
      if (warningTimerRef.current) clearTimeout(warningTimerRef.current)
      if (logoutTimerRef.current) clearTimeout(logoutTimerRef.current)
    }
  }, [accessToken, isAuthenticated, dispatch, navigate])
}
