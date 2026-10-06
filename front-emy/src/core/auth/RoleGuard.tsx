import { Navigate } from 'react-router-dom'
import { ReactNode } from 'react'
import { useSelector } from 'react-redux'
import { RootState } from '@/app/store'

interface RoleGuardProps {
  allowedRoles?: string[]
  requiredPermissions?: string[]
  children: ReactNode
}

const normalize = (perm: string) => perm.replace(/:/g, '.')

const hasPermission = (required: string, userPermissions: string[]): boolean => {
  const req = normalize(required)
  return userPermissions.some((p) => {
    const np = normalize(p)
    if (np === '*' || np === '.*') return true
    if (np.endsWith('.*')) {
      const prefix = np.slice(0, -2)
      return req === prefix || req.startsWith(prefix + '.')
    }
    return np === req
  })
}

const RoleGuard = ({ allowedRoles, requiredPermissions, children }: RoleGuardProps) => {
  const { user } = useSelector((state: RootState) => state.auth)

  const roleName =
    typeof (user as any)?.role === 'string' ? ((user as any)?.role as string) : ((user as any)?.role?.name as string)

  const permissions =
    ((user as any)?.permissions as string[] | undefined) || ((user as any)?.role?.permissions as string[] | undefined) || []

  if (roleName === 'ADMIN') {
    return <>{children}</>
  }

  const roleOk =
    !allowedRoles || allowedRoles.length === 0 || (roleName ? allowedRoles.includes(roleName) : false)
  const permOk =
    !requiredPermissions ||
    requiredPermissions.length === 0 ||
    requiredPermissions.every((p) => hasPermission(p, permissions))

  if (!roleOk || !permOk) {
    return <Navigate to="/" replace />
  }

  return <>{children}</>
}

export default RoleGuard
