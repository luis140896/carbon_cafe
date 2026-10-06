# INFORME DE AUDITORÍA — Sistema POS Morales

- **Fecha del análisis:** octubre 2026.
- **Tipo:** auditoría estática del código fuente, sin ejecución ni modificaciones.
- **Alcance:** backend `back-mor`, frontend `front-emy`, migraciones Flyway V2–V18, arquitectura, seguridad, flujos de negocio y preparación para funcionalidad de bar.

---

## 1. RESUMEN EJECUTIVO

El proyecto es un **POS para restaurante** compuesto por:

- **Backend:** Java 17 + Spring Boot 3.2 (`web`, `data-jpa`, `security`, `validation`, `flyway`, `caching`, `scheduling`), PostgreSQL, JWT con access/refresh tokens, SSE para cocina/notificaciones, MapStruct, Lombok, SpringDoc.
- **Frontend:** React 18 + TypeScript + Vite, Redux Toolkit 3 slices (`auth`, `cart`, `settings`), React Router v6, TailwindCSS, Axios, react-hook-form + Zod, impresión térmica 58 mm, recharts, exportación Excel.

### Estado general

La arquitectura por capas es razonable y los flujos básicos de venta, mesas, inventario y cocina están implementados. Sin embargo, **hay defectos de integridad que deben corregirse antes de poner en producción** y varias funcionalidades declaradas en el esquema o en la UI que aún no operan de forma coherente.

### Top 6 hallazgos críticos

| ID | Nivel | Hallazgo |
|----|-------|----------|
| C1 | Crítico | `InvoiceService.voidInvoice` restaura stock del **producto** vendido, no de sus ingredientes (ignora recetas), por lo que las anulaciones de productos `PREPARADO` dejan el inventario incoherente. |
| C2 | Crítico | El backend acepta y persiste `unitPrice` enviado por el cliente en `createSale`, `addItems` y `payTable`; un cliente manipulado puede vender a cualquier precio. |
| C3 | Crítico | Numeración de facturas y de secuencias de cocina por mesa usa `COUNT + 1` no atómico; bajo concurrencia genera duplicados o errores 500 por constraint `UNIQUE`. |
| C4 | Crítico | La deducción de stock es `validate()` y luego `deduct()` (lectura + escritura separadas) sin locks pesimistas; bajo concurrencia permite overselling. |
| C5 | Crítico | `TableService.addItemsToTable` captura la excepción de `createKitchenOrder` y solo loggea; el ítem se factura y descuenta stock, pero **nunca entra a cocina**. |
| C6 | Alto | El modelo de permisos está roto: los seeds usan formato `pos:*` / `reports:*`; `RoleGuard` exige `pos.sell` exacto y sin wildcard → roles distintos de `ADMIN` quedan bloqueados en rutas protegidas. |

---

## 2. RECONOCIMIENTO DEL STACK Y CONFIGURACIÓN

### 2.1 Tecnologías

- **Backend:** `pom.xml` confirma Java 17, Spring Boot 3.2.x, PostgreSQL 42.x, Flyway, JJWT, Spring Security 6, Hibernate, MapStruct, Lombok, SpringDoc.
- **Frontend:** `package.json` React 18.3, TypeScript 5, Vite 5, Redux Toolkit, React Router 6, Tailwind 3, Axios, react-hook-form + Zod, react-hot-toast, recharts, `xlsx-js-style`.
- **Base de datos:** PostgreSQL 14+; ejemplo de conexión local `jdbc:postgresql://localhost:5435/morales_pos`.
- **Tiempo real:** SSE (`SseService` en backend, `useSseEvents` en frontend) con reconexión automática.
- **Despliegue:** Dockerfile multi-stage (Maven + Temurin JRE 17); Render para backend, Vercel para frontend.

### 2.2 Variables de entorno relevantes

`SPRING_PROFILES_ACTIVE`, `PORT`, `DB_HOST/PORT/NAME/USERNAME/PASSWORD/SSLMODE`, `JWT_SECRET`, `CORS_ORIGINS`, `app.upload.path`, `VITE_API_URL`, `VITE_SSE_URL`.

### 2.3 Configuraciones identificadas

- `MoralesPosApplication.java:18` fija la zona horaria a `America/Bogota` en código; esto cumple con la preferencia registrada, aunque conviene complementar con variable `TZ` en runtime.
- `SecurityConfig` desactiva CSRF (correcto para JWT en header), deja públicos `/auth/**`, `/uploads/**`, swagger y health.
- `JwtAuthenticationFilter` acepta token por **header** y por **query param `token`** para SSE; esto expone el JWT a logs/proxies.
- `CorsConfig` configura CORS dos veces (`WebMvcConfigurer` + `CorsConfigurationSource`); es redundante.
- Flyway: `baseline-on-migrate=true`, `validate-on-migrate=false` (oculta posible drift entre migraciones y entidades).
- `application-prod.yml`: `ddl-auto: none`, logging `WARN/INFO`; JWT secret debe venir por env.

---

## 3. MAPA DE MÓDULOS

### 3.1 Backend

| Módulo | Controller | Servicios principales | Roles permitidos |
|--------|------------|----------------------|-------------------|
| Autenticación | `AuthController` | `AuthService` | público |
| Productos | `ProductController` | `ProductService` | lectura auth; mutaciones ADMIN, SUPERVISOR, INVENTARIO |
| Categorías | `CategoryController` | `CategoryService` | lectura auth; mutaciones ADMIN, SUPERVISOR |
| Inventario | `InventoryController` | `InventoryService` | lectura auth; ajustes ADMIN, SUPERVISOR, INVENTARIO |
| Facturación | `InvoiceController` | `InvoiceService` | lectura auth; rango ADMIN, SUPERVISOR, REPORTES; venta ADMIN, CAJERO, SUPERVISOR; anulación ADMIN, SUPERVISOR |
| Clientes | `CustomerController` | `CustomerService` | lectura auth; mutaciones ADMIN, CAJERO, SUPERVISOR |
| Mesas/sesiones | `TableController` | `TableService` | sesiones ADMIN, SUPERVISOR, CAJERO, MESERO; CRUD mesas ADMIN; estado ADMIN, SUPERVISOR |
| Cocina | `KitchenController` | `KitchenService`, `KitchenOrderService` | ADMIN, SUPERVISOR, COCINERO, CAJERO |
| Reportes | `ReportController` | `ReportService` | ADMIN, SUPERVISOR, REPORTES |
| Dashboard | `DashboardController` | `ReportService` | **cualquier autenticado** (sin @PreAuthorize) |
| Gastos | `ExpenseController` | `ExpenseService` | ADMIN, SUPERVISOR |
| Promociones | `PromotionController` | `PromotionService` | ADMIN, SUPERVISOR (delete solo ADMIN) |
| Recetas | `RecipeController` | `RecipeService` | lectura auth; mutaciones ADMIN |
| Notificaciones | `NotificationController` | `NotificationService` | autenticado |
| SSE | `SseController` | `SseService` | autenticado |
| Usuarios/Roles | `UserController`, `RoleController` | `UserService`, `RoleService` | ADMIN, SUPERVISOR |
| Configuración | `CompanyConfigController` | `CompanyConfigService` | lectura auth; PUT ADMIN |
| Archivos | `FileUploadController` | `FileUploadService` | roles con permiso |

### 3.2 Frontend

Rutas con guardia de permisos (`RoleGuard`):

- `/`, `/pos` → `pos.sell`
- `/tables` → `tables.view`
- `/kitchen` → `kitchen.view`
- `/products` → `products.read`
- `/categories` → `categories.read`
- `/inventory` → `inventory.read`
- `/recipes` → `recipes.read`
- `/invoices` → `invoices.read`
- `/customers` → `customers.read`
- `/reports` → `reports.view`
- `/users`, `/roles` → `users.manage`
- `/promotions` → `promotions.manage`
- `/settings`, `/settings/tables` → `settings.view`

---

## 4. HALLAZGOS DETALLADOS POR SEVERIDAD

### 4.1 Críticos (integridad / seguridad / concurrencia)

#### C1 — Restauración incorrecta de stock al anular facturas

- **Archivo:** `back-mor/src/main/java/com/morales/pos/application/service/InvoiceService.java` (método `voidInvoice`).
- **Descripción:** recorre `invoice.getDetails()` y llama a `inventoryService.addStock(detail.getProduct().getId(), detail.getQuantity(), ...)`. Para productos `PREPARADO` que se descontaron por receta, esto solo devuelve stock del producto final, no de los ingredientes.
- **Impacto:** inventario corrupto tras cada anulación de productos preparados.
- **Corrección:** reutilizar `StockDeductionService` con el mismo flujo de expansión de recetas (`computeRequired`) y llamar a `restore()`.

#### C2 — Precios controlados por el cliente

- **Archivos:** `InvoiceService.createSale`, `TableService.addItemsToTable` / `payTable`.
- **Descripción:** el DTO incluye `unitPrice` y se persiste sin validar contra `Product.salePrice`. El backend solo usa el precio del request para subtotales.
- **Impacto:** manipulación directa de ingresos.
- **Corrección:** recalcular `unitPrice` en servidor a partir del producto (respetando promociones); rechazar discrepancias o al menos auditarlas.

#### C3 — Condiciones de carrera en numeración

- **Archivos:** `InvoiceService.generateInvoiceNumber`, `KitchenOrderService.getNextSequenceNumberForTable`.
- **Descripción:** ambos usan `COUNT(...)` + 1 dentro de una transacción pero sin bloqueo pesimista o secuencia SQL. Si dos transacciones concurrentes obtienen el mismo número, la constraint `UNIQUE` provoca error 500.
- **Impacto:** fallos de venta/mesa concurrentes; números de factura duplicados percibidos.
- **Corrección:** usar `SELECT ... FOR UPDATE` sobre una tabla de secuencias o generar número **después** de insertar y reintentar en caso de violación.

#### C4 — Stock no atómico

- **Archivos:** `StockDeductionService.deduct`, `InventoryService.adjustStock`.
- **Descripción:** `validate()` lee stock, luego `deduct()` vuelve a leer y resta. Entre ambas lecturas otro hilo puede agotar el mismo producto. `adjustStock` carga entidad, setea y guarda; sin `@Lock` ni query atómica.
- **Impacto:** overselling (ventas con stock negativo en la práctica).
- **Corrección:** usar `InventoryRepository.decreaseStock` (query UPDATE con retorno de filas afectadas) o `SELECT ... FOR UPDATE`.

#### C5 — Items de mesa que nunca llegan a cocina

- **Archivo:** `back-mor/src/main/java/com/morales/pos/application/service/TableService.java` (`addItemsToTable`).
- **Descripción:** dentro del `for` de detalles, `createKitchenOrder(...)` está envuelto en try/catch con `log.error` y continúa. El detalle se guarda y se descuenta stock; si falla la cocina, no hay rollback del detalle.
- **Impacto:** ítems cobrados pero ausentes en cocina; inconsistencia operativa.
- **Corrección:** eliminar el try/catch interno (dejar que la transacción falle) o hacer rollback explícito.

#### C6 — Permisos rotos entre backend y frontend

- **Archivos:** seeds en `V2__create_initial_schema.sql`, `RoleGuard.tsx`, `Sidebar.tsx`.
- **Descripción:**
  - Backend almacena permisos con formato `pos:*` / `reports:*`.
  - `RoleGuard` compara exactamente con `pos.sell`, `tables.view`, etc. y no normaliza ni soporta wildcards.
  - `Sidebar` sí normaliza `:` → `.` y expande `*`, por lo que el menú se muestra, pero al hacer clic `RoleGuard` redirige a `/unauthorized`.
  - Backend usa `@PreAuthorize("hasRole(...)")` exclusivamente, por lo que los permisos granulares del JSONB no se usan para autorización.
- **Impacto:** roles como CAJERO, MESERO, INVENTARIO probablemente no puedan acceder a sus módulos en frontend; autorización real solo por rol nominal.
- **Corrección:** unificar a un solo formato, implementar wildcard en `RoleGuard`, y usar `@PreAuthorize` con expresión que lea los permisos reales del `CustomUserDetails`.

### 4.2 Alto (seguridad / disponibilidad / inconsistencias)

#### A1 — Contraseña admin reescrita en cada arranque

- **Archivo:** `DataInitializer.java`.
- **Descripción:** `userRepository.findByUsername("admin").ifPresent(...)` setea `admin123` hasheada y guarda en cada inicio.
- **Impacto:** puerta trasera activa en producción.
- **Corrección:** solo crear el usuario si no existe; nunca resetear contraseña existente automáticamente.

#### A2 — Logout sin invalidar refresh token

- **Archivo:** `AuthController.java`.
- **Descripción:** `logout` devuelve `200` con comentario "en una implementación completa invalidaríamos el refresh token"; la tabla `user_sessions` existe en V2 pero no hay entidad/repositorio.
- **Impacto:** tokens refresh permanecen válidos hasta expirar (7 días).
- **Corrección:** persistir refresh tokens y marcarlos revocados/invalidate-on-logout.

#### A3 — Subida de archivos pública y sin restricción de tamaño

- **Archivo:** `FileUploadController` / `SecurityConfig`.
- **Descripción:** `/uploads/**` es público por `SecurityConfig`. El controlador valida extensiones, pero el listado de directorio o acceso directo a imágenes es intencionalmente abierto.
- **Impacto:** aceptable para imágenes, pero riesgo de enumeración o malware si se relaja la validación.
- **Corrección:** servir imágenes a través de un endpoint autenticado o firmar URLs.

#### A4 — Doble fuente de verdad en cocina

- **Archivos:** `KitchenService` (legacy, trabaja sobre `invoice_details.kitchen_status`) y `KitchenOrderService` (nuevo, tabla `kitchen_orders`).
- **Descripción:** ambos conviven; `KitchenController` expone ambos; frontend `KitchenPage.tsx` usa legacy.
- **Impacto:** estado de cocina puede divergir; `kitchen_orders` crece en paralelo sin uso visible en UI.
- **Corrección:** deprecar `KitchenService` y migrar UI al nuevo modelo; o bien sincronizar ambas columnas de forma transaccional.

#### A5 — `DataInitializer` y otras configuraciones sin perfil condicional

- `DataInitializer` corre en todos los perfiles.
- Imagen por defecto `/uploads/default-avatar.png` se asume existente sin verificación.

### 4.3 Medio (lógica de negocio / UX)

#### M1 — Promociones declaradas pero inertes

- **Archivos:** `PromotionController`, `PromotionService`, `PromotionRepository`, `POSPage.tsx`.
- **Descripción:** hay CRUD completo de promociones, scheduler (`DAILY`, `WEEKLY`, `SPECIFIC_DATE`), prioridad; pero `InvoiceService.createSale` / `TableService.payTable` no las consultan ni aplican.
- **Impacto:** descuentos programados no funcionan.
- **Corrección:** integrar `findActivePromotionsForToday` en el cálculo de precios de venta.

#### M2 — Descuento fijo del carrito se pierde

- **Archivo:** `POSPage.tsx`.
- **Descripción:** el frontend permite descuento por monto (`discountType === 'amount'`), pero solo envía `discountPercent` al backend.
- **Impacto:** descuento fijo no se aplica.
- **Corrección:** enviar `discountAmount` y/o recalcular porcentaje equivalente en servidor.

#### M3 — Estado `EN_PREPARACION` del enum `KitchenStatus` no se usa

- **Archivos:** `KitchenStatus.java`, `KitchenPage.tsx`.
- **Descripción:** la UI solo permite `PENDIENTE → LISTO` y `LISTO → ENTREGADO`.
- **Impacto:** flujo real de cocina no refleja "en preparación".
- **Corrección:** agregar botón/interfaz para el estado intermedio.

#### M4 — Notificaciones leídas por rol, no por usuario

- **Archivo:** `NotificationService.markAllAsRead`.
- **Descripción:** marca todas las notificaciones de un rol como leídas y fija `readAt`, pero no asocia el usuario lector en el `markAll` masivo.
- **Impacto:** un usuario puede marcar como leídas notificaciones dirigidas a compañeros del mismo rol.
- **Corrección:** leer por usuario o al menos guardar `readBy` en cada notificación individual.

#### M5 — `DashboardController` sin restricción de rol

- Cualquier usuario autenticado ve ventas, ticket promedio, etc.
- Corrección: restringir a ADMIN, SUPERVISOR, REPORTES o leer según permisos.

#### M6 — Cambio manual de estado de mesa puede dejar sesión abierta

- `TableService.changeStatus` permite pasar a `FUERA_DE_SERVICIO` incluso con sesión activa.
- Corrección: validar que no haya sesión abierta o cerrarla explícitamente.

### 4.4 Bajo (deuda técnica / calidad)

- **Tablas muertas en V2:** `payments`, `suppliers`, `user_sessions` no tienen entidad/repositorio/uso.
- **Entidad `AuditLog` sin repositorio:** tabla `audit_logs` existe, entidad existe, pero nunca se escribe.
- **`Invoice.calculateTotals()` no se usa:** la lógica vive duplicada en `InvoiceService.createSale` y `payTable`.
- **SSE duplicado:** `TableService.addItemsToTable` emite `new_order` y `KitchenOrderService.createKitchenOrder` también emite `new_order`.
- **N+1 queries:** `TableService.findAllTables` carga sesión activa por cada mesa.
- **`useTokenExpiry` redundante:** interceptor de Axios ya refresca token en 401; el hook desconecta al usuario 60s antes de expirar, interfiriendo con renovación automática.
- **Impresión `printInvoice`:** usa valores hardcodeados (WhatsApp del encabezado) si `company.whatsapp` no está presente en localStorage; cae en default en vez de fetch.
- **Falta de tests:** no se encontraron pruebas unitarias ni de integración.
- **Validaciones inconsistentes:** algunos campos `@NotNull` en DTOs, pero `amountReceived` puede ser nulo en `PayTableRequest` y usarse sin null-check.

---

## 5. PERMISOS Y SEGURIDAD

### 5.1 Roles sembrados

```sql
-- V2__create_initial_schema.sql
ADMIN       -> ["*"]
CAJERO      -> ["pos:*", "invoices:read", "invoices:create", ...]
INVENTARIO  -> ["products:*", "categories:*", "inventory:*", "suppliers:*", "reports:inventory"]
SUPERVISOR  -> ["pos:*", "invoices:*", ..., "users:read"]
REPORTES    -> ["reports:*", ...]
-- V6__add_kitchen_notes_roles.sql añade MESERO y COCINERO con notación punto
MESERO      -> ["tables:*", "pos.sell"]
COCINERO    -> ["kitchen.view", "kitchen.update"]
```

### 5.2 Inconsistencia de formato

- Backend y seeds mezclan `:` y `.`.
- `RoleGuard` no normaliza ni maneja wildcards.
- Backend autoriza por rol nominal (`hasRole`), no por permisos JSONB.

### 5.3 Recomendación

1. Elegir un único separador (recomendado `.`) y actualizar seeds.
2. Normalizar en `RoleGuard` y permitir `*`.
3. Crear `PermissionEvaluator` o método en `CustomUserDetails` que exponga permisos y usar `@PreAuthorize("@securityService.hasPermission(principal, 'pos.sell')")`.

---

## 6. BASE DE DATOS Y MIGRACIONES

### 6.1 Migraciones V2–V18 resumen

- **V2:** schema base, roles, usuarios, config, productos, clientes, facturas, detalles, mesas, sesiones, notificaciones, pagos, proveedores, sesiones de usuario, logs de auditoría.
- **V3:** notificaciones con `target_roles` JSONB, severidad, referencia.
- **V4:** colores de tarjeta y sidebar en `company_config`.
- **V5:** service charge en facturas.
- **V6/V7:** estados de cocina en detalles + roles MESERO/COCINERO.
- **V8:** delivery charge.
- **V9:** tabla `promotions`.
- **V10/V12:** índices de performance.
- **V11:** `kitchen_orders`.
- **V13:** columnas de pago mixto.
- **V14:** whatsapp en config.
- **V15:** tipo de producto (`DIRECTO`, `PREPARADO`, `INSUMO`) + recetas.
- **V16:** stock a 3 decimales.
- **V17:** asegura fila de inventario por producto.
- **V18:** `expenses`.

### 6.2 Tablas huérfanas / muertas

| Tabla | Estado |
|-------|--------|
| `payments` | Sin entidad/repositorio/uso. |
| `suppliers` | Sin entidad/repositorio/uso. |
| `user_sessions` | Sin entidad/repositorio/uso (aunque logout debería usarla). |
| `audit_logs` | Entidad existe, pero sin repositorio; nunca se escribe. |

---

## 7. PREPARACIÓN PARA FUNCIONALIDAD DE BAR

El usuario expresó interés en preparar el sistema para un bar. El modelo actual ya soporta varios requisitos de bar, pero faltan mejoras:

### 7.1 Lo que ya existe y es reusable

- Productos con tipo `DIRECTO`, `PREPARADO`, `INSUMO`.
- Recetas/BOM con merma y rendimiento.
- Venta directa POS y mesas/sesiones.
- Pantalla de cocina con estados y urgencias.
- Descuentos, service charge, pago mixto, propina en factura.

### 7.2 Lo que falta o necesita reforzarse

| Requisito típico de bar | Estado actual |
|-------------------------|---------------|
| Cuentas abiertas / bar tabs | Sesiones de mesa son lo más cercano; falta "cuenta de cliente" sin mesa física. |
| Split de cuentas/pagos parciales | No implementado; tabla `payments` muerta. |
| Comandas rápidas por número/barra | No existe; se asocia todo a mesa. |
| Transmisión a barra vs cocina | Cocina es única; falta canal/estación `BAR`. |
| Happy hour / promociones horarias | CRUD existe pero no se aplica en venta. |
| Tickets de comanda por impresora de bar | `printInvoice` genera 58 mm genérico; falta template de comanda. |

---

## 8. PLAN DE CORRECCIÓN PROPUESTO

A continuación se presenta un orden de prioridad. **Cada fase debe completarse y probarse antes de pasar a la siguiente.**

### FASE 1 — Integridad crítica (semana 1)

1. **Corregir restauración de stock en anulaciones:**
   - En `InvoiceService.voidInvoice`, reutilizar `StockDeductionService.computeRequired` y `restore` para deshacer exactamente lo mismo que se descontó (con recetas).
2. **Evitar precios controlados por cliente:**
   - En `InvoiceService.createSale` y `TableService.addItemsToTable`, descartar `unitPrice` del request y recalcular desde `Product.salePrice` (más promociones cuando se implementen).
3. **Numeración atómica:**
   - Crear tabla `invoice_sequences` (o usar `SELECT FOR UPDATE` sobre una fila de control) para `invoice_number`.
   - Secuencia de cocina por mesa: usar `MAX(...) FOR UPDATE` o secuencia por mesa.
4. **Atomicidad en stock:**
   - Reemplazar `adjustStock` deductivo por `InventoryRepository.decreaseStock` query atómica con validación de filas afectadas.
   - Eliminar la separación `validate()`/`deduct()`; hacerlo en una sola operación atómica.

### FASE 2 — Seguridad y permisos (semana 2)

1. **Unificar formato de permisos:** migrar seeds a notación `.`, eliminar duplicados.
2. **Soportar wildcards en `RoleGuard`:** normalizar `pos:*` → `pos.sell`, `pos.view`, etc.
3. **Backend basado en permisos:** exponer permisos en `CustomUserDetails` y evaluar con expresión `@PreAuthorize`.
4. **Eliminar reset de admin en `DataInitializer`:** solo crear si no existe.
5. **Persistir refresh tokens:** crear entidad/repositorio `UserRefreshToken` y revocar en logout.

### FASE 3 — Cocina y flujo de mesas (semana 2–3)

1. Elegir un único modelo de cocina: deprecar `KitchenService` legacy y migrar `KitchenPage.tsx` a `kitchen_orders`.
2. Agregar estado `EN_PREPARACION` a la UI.
3. Corregir `addItemsToTable` para no silenciar fallos de creación de comanda.
4. Evitar doble emisión SSE.
5. Corregir `changeStatus` de mesas para no dejar sesiones abiertas en estados inválidos.

### FASE 4 — Funcionalidades inertes (semana 3–4)

1. Aplicar promociones en venta.
2. Enviar y respetar descuento por monto.
3. Activar `audit_logs` con un repositorio y un aspecto `@Around` en servicios sensibles.
4. Implementar split de pagos y pagos parciales (requiere tabla `payments` activa).
5. Limpiar tablas muertas o implementarlas.

### FASE 5 — Preparación para bar (semana 4–5)

1. Agregar tipo de estación `BAR`/`COCINA` a comandas o productos.
2. Crear comandas rápidas sin mesa física (cuenta de bar).
3. Template de impresión de comanda (ticket de bar/cocina).
4. Happy hour: activar el scheduler de promociones ya existente.

### FASE 6 — Calidad y observabilidad (continuo)

1. Agregar pruebas unitarias (Junit/Mockito) y de integración (Testcontainers).
2. Revisar y unificar validaciones de DTOs.
3. Habilitar `validate-on-migrate=true` tras estabilizar el schema.
4. Revisar queries N+1 y agregar `JOIN FETCH`.
5. Documentar API con SpringDoc actualizada.

---

## 9. CONCLUSIÓN

El sistema POS Morales tiene una base sólida para ventas de restaurante, pero **no debe entrar a producción sin corregir primero los defectos C1–C6**, pues impactan directamente en inventario, ingresos y control de acceso. La mayoría de los problemas son localizados y corregibles en cambios puntuales. Las funcionalidades avanzadas (promociones, split de pagos, bar) tienen el esquema parcialmente preparado, pero requieren completar su lógica de negocio.

**Próximo paso recomendado:** aprobar el plan de corrección y comenzar la FASE 1 (integridad crítica), partiendo de la rama actual y sin cambiar la base de datos hasta que se validen las correcciones.
