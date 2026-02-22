# Diseño Completo: Módulo Mesas + Notificaciones + UI/UX + Sincronización

## 1. MÓDULO DE MESAS (Restaurante)

### 1.1 Entidades

#### RestaurantTable (Mesa)
| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | Long | PK auto-increment |
| number | Integer | Número de mesa (único) |
| name | String | Nombre/etiqueta (ej: "Mesa VIP 1") |
| capacity | Integer | Capacidad de personas |
| status | TableStatus | DISPONIBLE, OCUPADA, RESERVADA, FUERA_DE_SERVICIO |
| zone | String | Zona (INTERIOR, TERRAZA, BAR, VIP) |
| displayOrder | Integer | Orden visual |
| isActive | Boolean | Soft delete |
| createdAt | LocalDateTime | Auditoría |
| updatedAt | LocalDateTime | Auditoría |

#### TableSession (Sesión de mesa - vincula mesa con invoice)
| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | Long | PK |
| table | RestaurantTable | FK mesa |
| invoice | Invoice | FK factura/venta |
| openedBy | User | Quién abrió la mesa |
| openedAt | LocalDateTime | Cuándo se abrió |
| closedAt | LocalDateTime | Cuándo se cerró (null = abierta) |
| guestCount | Integer | Número de comensales |
| notes | String | Notas de la sesión |
| status | TableSessionStatus | ABIERTA, CERRADA, TRANSFERIDA |

### 1.2 Enums

```java
TableStatus: DISPONIBLE, OCUPADA, RESERVADA, FUERA_DE_SERVICIO
TableSessionStatus: ABIERTA, CERRADA, TRANSFERIDA
```

### 1.3 Modificaciones a Invoice existente

Se agrega campo `tableSession` (nullable) a Invoice:
- Si `tableSession != null` → es venta de mesa
- Si `tableSession == null` → es venta normal (POS directo)

Se agrega nuevo estado a InvoiceStatus: `ABIERTA` (venta en curso, sin pagar)

### 1.4 Estados y Transiciones

```
Invoice:
  ABIERTA → COMPLETADA (cuando se paga)
  ABIERTA → ANULADA (con permisos ADMIN/SUPERVISOR)
  COMPLETADA → ANULADA (con permisos)

Mesa:
  DISPONIBLE → OCUPADA (al abrir sesión)
  OCUPADA → DISPONIBLE (al cerrar sesión/pagar)
  DISPONIBLE ↔ RESERVADA (manual)
  * ↔ FUERA_DE_SERVICIO (admin)
```

### 1.5 Reglas de Negocio
- Una mesa OCUPADA tiene exactamente 1 sesión ABIERTA
- No se puede abrir una sesión si la mesa ya está OCUPADA
- No se puede pagar una venta sin productos
- Al pagar, la sesión se cierra y la mesa vuelve a DISPONIBLE
- Al anular una venta abierta, se restaura stock y mesa
- Mesero solo puede ver/editar sus propias mesas (configurable)

### 1.6 Endpoints

```
GET    /tables                    → Listar todas las mesas
GET    /tables/{id}               → Detalle de mesa
POST   /tables                    → Crear mesa (ADMIN)
PUT    /tables/{id}               → Editar mesa (ADMIN)
DELETE /tables/{id}               → Desactivar mesa (ADMIN)
PUT    /tables/{id}/status        → Cambiar estado (RESERVADA, FUERA_SERVICIO)

POST   /tables/{id}/open          → Abrir mesa (crea sesión + invoice ABIERTA)
POST   /tables/{id}/add-items     → Agregar productos a venta abierta
POST   /tables/{id}/remove-item   → Quitar producto de venta abierta
POST   /tables/{id}/pay           → Pagar y cerrar mesa
GET    /tables/{id}/session       → Ver sesión actual con detalle de venta

GET    /table-sessions            → Historial de sesiones
GET    /table-sessions/active     → Sesiones activas (mesas abiertas)
```

### 1.7 Roles
| Acción | ADMIN | SUPERVISOR | CAJERO | MESERO |
|--------|-------|------------|--------|--------|
| CRUD mesas | ✅ | ❌ | ❌ | ❌ |
| Abrir mesa | ✅ | ✅ | ✅ | ✅ |
| Agregar productos | ✅ | ✅ | ✅ | ✅ |
| Pagar mesa | ✅ | ✅ | ✅ | ❌ |
| Anular venta | ✅ | ✅ | ❌ | ❌ |
| Ver todas las mesas | ✅ | ✅ | ✅ | Solo las suyas |

---

## 2. MÓDULO DE NOTIFICACIONES

### 2.1 Entidad Notification
| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | Long | PK |
| type | NotificationType | Tipo de evento |
| title | String | Título corto |
| message | String | Mensaje detallado |
| severity | NotificationSeverity | INFO, WARNING, ERROR, CRITICAL |
| targetRoles | String (JSON) | Roles que deben ver esta notificación |
| referenceType | String | Tipo de entidad referenciada (TABLE, INVOICE, PRODUCT) |
| referenceId | Long | ID de la entidad referenciada |
| isRead | Boolean | Leída por default false |
| readBy | User | Quién la leyó |
| readAt | LocalDateTime | Cuándo se leyó |
| createdAt | LocalDateTime | Cuándo se creó |

### 2.2 Enums
```java
NotificationType:
  TABLE_LONG_OPEN          // Mesa abierta > 40 min
  TABLE_IDLE               // Mesa sin actividad > 15 min
  INVOICE_PENDING_PAYMENT  // Venta pendiente de pago
  LOW_STOCK                // Stock bajo mínimo
  OUT_OF_STOCK             // Sin stock
  CASH_REGISTER_OPEN       // Caja abierta sin cierre
  VOID_ATTEMPT             // Intento de anulación
  SYSTEM_ERROR             // Error de sistema

NotificationSeverity: INFO, WARNING, ERROR, CRITICAL
```

### 2.3 Eventos → Notificaciones
| Evento | Tipo | Severidad | Roles destino |
|--------|------|-----------|---------------|
| Mesa abierta > 40 min | TABLE_LONG_OPEN | WARNING | ADMIN, SUPERVISOR, MESERO |
| Mesa sin agregar productos > 15 min | TABLE_IDLE | INFO | ADMIN, SUPERVISOR |
| Venta pendiente de pago | INVOICE_PENDING_PAYMENT | WARNING | ADMIN, CAJERO |
| Stock bajo mínimo | LOW_STOCK | WARNING | ADMIN, INVENTARIO |
| Stock agotado | OUT_OF_STOCK | ERROR | ADMIN, INVENTARIO, CAJERO |
| Anulación de venta | VOID_ATTEMPT | CRITICAL | ADMIN, SUPERVISOR |
| Error de sistema | SYSTEM_ERROR | ERROR | ADMIN |

### 2.4 Estrategia: Polling (fase 1) → WebSocket (fase 2)
- **Fase 1**: Polling cada 30 segundos desde frontend (`GET /notifications/unread`)
- **Fase 2 (futuro)**: WebSocket con STOMP para tiempo real
- Las notificaciones periódicas (mesa larga, stock bajo) se generan via `@Scheduled` cada 5 minutos

### 2.5 Endpoints
```
GET    /notifications              → Listar notificaciones del usuario (paginado)
GET    /notifications/unread       → Contar no leídas
GET    /notifications/unread/list  → Listar no leídas (para dropdown)
PUT    /notifications/{id}/read    → Marcar como leída
PUT    /notifications/read-all     → Marcar todas como leídas
```

### 2.6 Frontend
- Badge con contador en el ícono Bell del Header
- Dropdown con lista scrollable de notificaciones
- Click en notificación → navegar a la entidad referenciada
- Filtros por tipo y severidad (vista completa)

---

## 3. MEJORAS UI/UX POS

### 3.1 Tarjetas de Categorías
- gap-3 en lugar de gap-2
- Padding interno p-2.5
- Border visible: `border border-gray-200`
- Sombra sutil en hover
- Fondo más diferenciado para seleccionada

### 3.2 Tarjetas de Productos
- Grid con gap-4
- Border: `border border-gray-200`
- Sombra: `shadow-sm hover:shadow-md`
- Padding: p-4
- Imagen más grande y separada del texto
- Precio prominente con color
- Badge de stock con colores

### 3.3 Responsive
- xl: 4 columnas productos
- lg: 3 columnas
- md: 2 columnas
- sm: 1 columna

---

## 4. SINCRONIZACIÓN MULTI-ROL

### 4.1 Datos de ventas/mesas (Fase 1: Polling)
- Polling cada 30s para estado de mesas
- Polling cada 30s para notificaciones
- Refetch al realizar acciones (abrir, pagar, cerrar mesa)

### 4.2 Configuración visual
- CompanyConfig se carga al login y se almacena en Redux
- Al cambiar configuración, se invalida caché
- Todos los roles ven la misma configuración

### 4.3 Futuro: WebSocket
- Canal `/topic/tables` para actualizaciones de mesas
- Canal `/topic/notifications` para notificaciones en tiempo real
- Canal `/topic/config` para cambios de configuración

---

## 5. MEJORAS FUTURAS
- **Dividir cuenta**: Crear N invoices desde una sesión
- **Unir mesas**: Vincular múltiples mesas a una sesión
- **Mover pedidos**: Transferir items entre sesiones
- **Comanda a cocina**: Imprimir/enviar items nuevos a impresora de cocina
- **Reservas**: Calendario de reservas con mesa y hora
