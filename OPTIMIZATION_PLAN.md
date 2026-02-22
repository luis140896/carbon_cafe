# Plan de Optimización — Sistema POS Morales

Análisis profundo del codebase: rendimiento, reutilización, seguridad y preparación para despliegue.

---

## 1. BACKEND — Problemas identificados

### 1.1 Problema N+1 en KitchenService.getPendingOrders()

**Archivo:** `KitchenService.java` línea 37-40  
**Problema:** Por cada `KitchenOrder` se accede a `detail.getInvoice()` y `invoice.getUser()` en lazy load. Con 50 pedidos activos = 100+ queries adicionales.

**Solución:** Agregar JOIN FETCH en `KitchenOrderRepository.findActiveOrders()`:
```java
@Query("SELECT ko FROM KitchenOrder ko " +
       "LEFT JOIN FETCH ko.invoiceDetail d " +
       "LEFT JOIN FETCH d.invoice i " +
       "LEFT JOIN FETCH i.user " +
       "WHERE ko.status <> 'ENTREGADO' " +
       "ORDER BY ko.orderTime ASC")
List<KitchenOrder> findActiveOrders();
```

---

### 1.2 Problema N+1 en TableService.addItemsToTable()

**Archivo:** `TableService.java`  
**Problema:** Por cada ítem se llama `productRepository.findById()` individualmente dentro del bucle. Con 10 ítems = 10 queries separadas.

**Solución:** Pre-cargar todos los productos en una sola query antes del bucle:
```java
List<Long> productIds = request.getItems().stream()
    .map(AddTableItemsRequest.TableItemRequest::getProductId)
    .collect(Collectors.toList());
Map<Long, Product> productMap = productRepository.findAllById(productIds)
    .stream().collect(Collectors.toMap(Product::getId, p -> p));
// Luego usar productMap.get(item.getProductId()) dentro del bucle
```

---

### 1.3 Problema N+1 en InvoiceService.createSale()

**Mismo patrón:** `productRepository.findById()` dentro del bucle de detalles.  
**Misma solución:** Pre-cargar con `findAllById()` antes del bucle.

---

### 1.4 Método calculateTotals() en Invoice.java no se usa

**Archivo:** `Invoice.java` líneas 120-138  
**Problema:** Existe `calculateTotals()` pero `InvoiceService` y `TableService` calculan los totales manualmente duplicando la lógica.  
**Solución:** Usar `invoice.calculateTotals()` en los servicios y extender el método para incluir serviceCharge y deliveryCharge.

---

### 1.5 Consultas de inventario sin índice en columna quantity

**Archivo:** `V10__add_performance_indexes.sql`  
**Problema:** `findLowStockProducts()` y `findOutOfStockProducts()` hacen `WHERE i.quantity <= i.minStock` sin índice compuesto.  
**Solución:** Agregar en una nueva migración V12:
```sql
CREATE INDEX idx_inventory_quantity_minstock ON inventory(quantity, min_stock);
```

---

### 1.6 UserRepository.findById() en InventoryController

**Archivo:** `InventoryController.java` líneas 56-57  
**Problema:** Se hace una query extra a `UserRepository` para obtener el `User` cuando ya está disponible en el `SecurityContext` via `CustomUserDetails`.  
**Solución:** Inyectar `UserRepository` en el servicio o pasar el ID directamente al servicio y resolverlo allí una sola vez.

---

### 1.7 Swagger expuesto en producción

**Archivo:** `application.yml`  
**Problema:** Swagger UI (`/swagger-ui.html`) está habilitado sin restricción de perfil.  
**Solución:** Deshabilitar en producción:
```yaml
# En application-prod.yml:
springdoc:
  api-docs:
    enabled: false
  swagger-ui:
    enabled: false
```

---

### 1.8 Generación de número de factura con race condition

**Archivo:** `InvoiceService.generateInvoiceNumber()` y `TableService.generateTableInvoiceNumber()`  
**Problema:** Usan `COUNT + 1` para generar el número. En alta concurrencia, dos transacciones simultáneas pueden obtener el mismo número.  
**Solución:** Usar una secuencia de PostgreSQL:
```sql
-- V12: CREATE SEQUENCE invoice_seq START 1;
-- Luego: SELECT nextval('invoice_seq')
```

---

### 1.9 SseService — emitters sin límite de tiempo

**Archivo:** `SseService.java`  
**Problema:** Los emitters SSE no tienen timeout configurado. Conexiones muertas acumulan memoria.  
**Solución:** Configurar timeout al crear el emitter:
```java
SseEmitter emitter = new SseEmitter(300_000L); // 5 minutos
```

---

## 2. FRONTEND — Problemas identificados

### 2.1 TablesPage.tsx — Carga de productos en cada apertura de modal

**Problema:** `fetchProducts()` y `fetchCategories()` se llaman cada vez que se abre el modal de agregar ítems, aunque los datos raramente cambian.  
**Solución:** Cargar una sola vez al montar el componente y refrescar solo si hay un cambio explícito (ej: después de crear un producto).

---

### 2.2 POSPage.tsx — Componente demasiado grande (~1700 líneas)

**Problema:** Un solo componente maneja carrito, modal de pago, pre-cuenta, búsqueda, promociones, etc.  
**Solución:** Extraer subcomponentes:
- `PaymentModal.tsx` — modal de pago
- `CartPanel.tsx` — panel del carrito
- `ProductGrid.tsx` — grilla de productos
- `PreBillModal.tsx` — modal de pre-cuenta

---

### 2.3 TablesPage.tsx — Mismo problema de tamaño (~1700 líneas)

**Misma solución:** Extraer:
- `TableGrid.tsx`
- `TableDetailPanel.tsx`
- `AddItemsModal.tsx`
- `PayTableModal.tsx`

---

### 2.4 formatCurrency duplicado en múltiples archivos

**Problema:** `formatCurrency` está definido en `printInvoice.ts`, `TablesPage.tsx`, `POSPage.tsx` y otros.  
**Solución:** Mover a `src/shared/utils/formatters.ts` y exportar desde allí:
```ts
export const formatCurrency = (value: number) =>
  new Intl.NumberFormat('es-CO', { style: 'currency', currency: 'COP', minimumFractionDigits: 0 }).format(value || 0)
```

---

### 2.5 getPaymentMethodLabel duplicado

**Mismo problema:** Definido en `printInvoice.ts` y en `TablesPage.tsx` (ya eliminado en esta sesión).  
**Solución:** Mover a `src/shared/utils/formatters.ts`.

---

### 2.6 useEffect sin cleanup en useSseEvents

**Archivo:** `useSseEvents.ts`  
**Problema:** Si el componente se desmonta y remonta rápidamente (ej: navegación), puede haber múltiples conexiones SSE activas.  
**Estado actual:** Ya tiene cleanup, pero verificar que `eventSource.close()` se llame correctamente en todos los paths.

---

### 2.7 Falta de React.memo en componentes de lista

**Problema:** Componentes como las tarjetas de mesa o los ítems del carrito se re-renderizan en cada cambio de estado del padre.  
**Solución:** Envolver componentes puros en `React.memo()`.

---

### 2.8 localStorage sin manejo de errores

**Problema:** `JSON.parse(localStorage.getItem('pos_settings') || '{}')` puede fallar si el valor está corrupto.  
**Solución:**
```ts
function safeGetSettings() {
  try {
    return JSON.parse(localStorage.getItem('pos_settings') || '{}')
  } catch {
    return {}
  }
}
```

---

## 3. SEGURIDAD — Problemas identificados y estado

| # | Problema | Estado |
|---|---|---|
| 1 | `DB_PASSWORD` hardcodeado en `application.yml` | ✅ Corregido en esta sesión |
| 2 | `JWT_SECRET` hardcodeado en `application.yml` | ✅ Corregido en esta sesión |
| 3 | URLs de Cloudflare en CORS | ✅ Corregido en esta sesión |
| 4 | Credenciales de dev en `application-dev.yml` con fallback | ✅ Aceptable (solo dev) |
| 5 | Swagger sin restricción de perfil | ⚠️ Pendiente |
| 6 | `allowed-headers: "*"` en CORS | ⚠️ Considerar restringir en producción |
| 7 | Contraseña admin por defecto `admin123` | ⚠️ Cambiar en producción |
| 8 | No hay rate limiting en `/auth/login` | ⚠️ Agregar en producción |

---

## 4. BASE DE DATOS — Esquema y migraciones

### 4.1 Índices faltantes identificados

```sql
-- V12 (pendiente):
-- Mejorar consultas de cocina
CREATE INDEX idx_kitchen_orders_status_ordertime ON kitchen_orders(status, order_time);
CREATE INDEX idx_kitchen_orders_table_sequence ON kitchen_orders(table_id, sequence_number);

-- Mejorar consultas de inventario
CREATE INDEX idx_inventory_quantity_minstock ON inventory(quantity, min_stock);

-- Mejorar búsqueda de facturas por fecha
CREATE INDEX idx_invoices_created_status ON invoices(created_at, status);
```

### 4.2 Columnas sin restricciones de longitud

- `Invoice.notes` — `TEXT` sin límite. Considerar `VARCHAR(1000)`.
- `KitchenOrder.urgencyReason` — verificar longitud máxima.

### 4.3 Falta de soft-delete consistente

- `Product` usa `isActive = false` (soft delete) ✅
- `Category` usa hard delete con validación ✅
- `Invoice` usa `status = ANULADA` ✅
- `KitchenOrder` no tiene soft delete — se elimina por status ✅
- **Inconsistencia:** `User` — verificar si tiene soft delete.

---

## 5. REUTILIZACIÓN — Oportunidades

### 5.1 Crear `src/shared/utils/formatters.ts`

Centralizar:
- `formatCurrency()`
- `formatDate()`
- `getPaymentMethodLabel()`
- `getElapsedMinutes()`

### 5.2 Crear hook `useProducts()`

```ts
// src/core/hooks/useProducts.ts
export function useProducts() {
  const [products, setProducts] = useState<Product[]>([])
  const [categories, setCategories] = useState<Category[]>([])
  const [loading, setLoading] = useState(true)
  // ... lógica de carga compartida entre POSPage y TablesPage
}
```

### 5.3 Crear hook `useTableSession(tableId)`

Encapsular la lógica de sesión activa de mesa que se repite en `TablesPage`.

---

## 6. PRIORIDAD DE IMPLEMENTACIÓN

| Prioridad | Tarea | Impacto |
|---|---|---|
| 🔴 Alta | Fix N+1 en KitchenService (JOIN FETCH) | Rendimiento cocina |
| 🔴 Alta | Fix N+1 en InvoiceService/TableService (pre-cargar productos) | Rendimiento ventas |
| 🔴 Alta | Deshabilitar Swagger en producción | Seguridad |
| 🟡 Media | Migración V12 con índices faltantes | Rendimiento BD |
| 🟡 Media | Extraer `formatters.ts` compartido | Mantenibilidad |
| 🟡 Media | Rate limiting en `/auth/login` | Seguridad |
| 🟢 Baja | Dividir POSPage y TablesPage en subcomponentes | Mantenibilidad |
| 🟢 Baja | Hook `useProducts()` compartido | Reutilización |
| 🟢 Baja | `calculateTotals()` unificado en Invoice | Consistencia |

---

*Generado: Febrero 2026 — Sistema POS Morales v1.1.0*
