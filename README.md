# 🏪 Sistema POS Morales

Sistema de Punto de Venta moderno y adaptable para restaurantes y negocios de retail, desarrollado con Java Spring Boot (backend) y React + TypeScript (frontend).

## 📋 Módulos del Sistema

| Módulo | Descripción |
|---|---|
| **POS** | Ventas rápidas con carrito, descuentos, domicilio y pre-cuenta |
| **Mesas** | Gestión de mesas por zonas, sesiones activas y pago con cargo de servicio |
| **Cocina** | Display en tiempo real de pedidos pendientes con prioridad y agrupación por lote |
| **Productos** | Catálogo con categorías jerárquicas, imágenes y precios |
| **Inventario** | Stock, alertas de mínimo y movimientos con trazabilidad |
| **Facturas** | Historial de ventas con impresión térmica 58mm |
| **Clientes** | Base de datos con historial de compras |
| **Promociones** | Descuentos por día de semana y rango de fechas |
| **Reportes** | Análisis de ventas con filtros por fecha |
| **Usuarios** | Gestión de usuarios con asignación de roles |
| **Roles** | Control de acceso granular por módulo y permiso |
| **Configuración** | Tema, colores, empresa y ajustes de mesas |

## 🛠️ Tecnologías

### Backend (`back-mor`)
- Java 17
- Spring Boot 3.2
- Spring Security + JWT (access + refresh token)
- Spring Data JPA / Hibernate
- PostgreSQL 14+
- Flyway (migraciones versionadas V1–V11)
- Server-Sent Events (SSE) para tiempo real
- Maven

### Frontend (`front-emy`)
- React 18 + TypeScript
- Vite
- Redux Toolkit (auth, carrito, settings)
- React Router v6
- Tailwind CSS
- Lucide Icons
- Axios con interceptores de refresh token automático

## 📁 Estructura del Proyecto

```
sistema_morales/
├── back-mor/                          # Backend Spring Boot
│   ├── src/main/java/com/morales/pos/
│   │   ├── application/
│   │   │   ├── dto/                   # Request/Response DTOs
│   │   │   └── service/               # Lógica de negocio
│   │   ├── domain/
│   │   │   ├── entity/                # Entidades JPA
│   │   │   ├── enums/                 # KitchenStatus, PaymentMethod, etc.
│   │   │   └── repository/            # Repositorios Spring Data
│   │   ├── infrastructure/
│   │   │   └── security/              # JWT, filtros, configuración CORS
│   │   └── presentation/
│   │       └── controller/            # Controladores REST
│   └── src/main/resources/
│       ├── db/migration/              # V1–V11 scripts Flyway
│       └── application.yml            # Configuración principal
│
├── front-emy/                         # Frontend React
│   ├── src/
│   │   ├── app/                       # Store Redux, App.tsx, rutas
│   │   ├── core/
│   │   │   ├── api/                   # Servicios Axios por módulo
│   │   │   ├── auth/                  # ProtectedRoute, RoleGuard
│   │   │   └── hooks/                 # useSseEvents, useTokenExpiry
│   │   ├── modules/                   # Un directorio por módulo
│   │   │   ├── auth/
│   │   │   ├── dashboard/
│   │   │   ├── pos/
│   │   │   ├── tables/
│   │   │   ├── kitchen/
│   │   │   ├── products/
│   │   │   ├── categories/
│   │   │   ├── inventory/
│   │   │   ├── invoices/
│   │   │   ├── customers/
│   │   │   ├── promotions/
│   │   │   ├── reports/
│   │   │   ├── users/
│   │   │   ├── roles/
│   │   │   └── settings/
│   │   └── shared/
│   │       ├── components/            # Button, Input, Layout, etc.
│   │       └── utils/                 # printInvoice.ts (térmica 58mm)
│   └── package.json
```

## 🔑 Roles del Sistema

| Rol | Acceso |
|---|---|
| **ADMIN** | Acceso total a todos los módulos |
| **SUPERVISOR** | Productos, categorías, inventario, promociones, mesas, reportes, roles |
| **CAJERO** | POS, facturas, clientes, mesas |
| **MESERO** | Mesas (abrir, agregar ítems, notas), productos (solo ver) |
| **COCINERO** | Cocina (ver pedidos, actualizar estado) |
| **INVENTARIO** | Productos, categorías, inventario |

> Los roles de sistema (ADMIN, SUPERVISOR, CAJERO, MESERO, COCINERO) no pueden eliminarse. Se pueden crear roles personalizados con permisos granulares desde el módulo **Roles**.

## 🚀 Instalación

### Requisitos Previos

1. **Java 17+**: [Descargar JDK](https://adoptium.net/)
2. **Node.js 18+**: [Descargar Node](https://nodejs.org/)
3. **PostgreSQL 14+**: [Descargar PostgreSQL](https://www.postgresql.org/download/)
4. **Maven 3.8+**: [Descargar Maven](https://maven.apache.org/download.cgi)

### 1. Configurar Base de Datos

```sql
CREATE DATABASE morales_pos;
CREATE USER morales_user WITH PASSWORD 'tu_password_seguro';
GRANT ALL PRIVILEGES ON DATABASE morales_pos TO morales_user;
```

### 2. Configurar Backend

Copiar y editar las variables de entorno antes de ejecutar:

```bash
cd back-mor
cp src/main/resources/application.yml src/main/resources/application-local.yml
# Editar application-local.yml con tus credenciales reales

mvn clean install -DskipTests
mvn spring-boot:run
```

El backend estará disponible en: `http://localhost:8080`  
Las migraciones Flyway se aplican automáticamente al iniciar.

### 3. Configurar Frontend

```bash
cd front-emy
npm install
npm run dev
```

El frontend estará disponible en: `http://localhost:5173`

## 🔐 Credenciales por Defecto

- **Usuario**: `admin`
- **Contraseña**: `admin123`

> ⚠️ **Importante**: Cambiar la contraseña inmediatamente en producción desde el módulo Usuarios.

## ⚙️ Variables de Entorno

### Backend (`application.yml`)

```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/morales_pos
    username: morales_user
    password: ${DB_PASSWORD}          # Usar variable de entorno en producción

app:
  jwt:
    secret: ${JWT_SECRET}             # Mínimo 256 bits, aleatorio
    expiration: 86400000              # 24 horas (ms)
    refresh-expiration: 604800000     # 7 días (ms)
  cors:
    allowed-origins: http://localhost:5173
```

### Frontend

Crear archivo `.env.local` (no subir al repositorio):

```env
VITE_API_URL=http://localhost:8080/api
```

## 📡 API Endpoints Principales

### Autenticación
- `POST /api/auth/login` — Iniciar sesión
- `POST /api/auth/refresh` — Refrescar access token
- `POST /api/auth/logout` — Cerrar sesión

### Mesas
- `GET /api/tables` — Listar mesas
- `POST /api/tables/{id}/open` — Abrir mesa
- `POST /api/tables/{id}/add-items` — Agregar productos (con prioridad opcional)
- `POST /api/tables/{id}/pay` — Pagar mesa

### Cocina
- `GET /api/kitchen/orders/grouped` — Pedidos agrupados por lote (SSE-ready)
- `PUT /api/kitchen/orders/{detailId}/status` — Actualizar estado de ítem
- `GET /api/sse/events` — Stream SSE de eventos en tiempo real

### Productos / Inventario / Facturas
- `GET|POST|PUT|DELETE /api/products`
- `GET|POST /api/inventory/product/{id}/add`
- `GET /api/invoices` — Historial de facturas

*(Documentación Swagger disponible en: `http://localhost:8080/swagger-ui.html`)*

## 🖨️ Impresión Térmica

El sistema usa `printInvoice.ts` — una utilidad centralizada para impresoras térmicas de **58mm**:

- CSS optimizado: `@page { size: 58mm auto; margin: 0 }`
- Fuente monoespaciada Courier New para alineación de columnas
- Soporte para: factura normal, pre-cuenta, cargo de servicio y domicilio
- Cierre automático de ventana tras imprimir

Todos los módulos (POS, Mesas, Historial de Facturas) usan la misma utilidad para garantizar consistencia visual.

## ⚡ Tiempo Real (SSE)

El módulo de Cocina y las notificaciones usan **Server-Sent Events**:

- El frontend se suscribe a `/api/sse/events?token={jwt}`
- El backend emite eventos al crear pedidos, actualizar estados y al pagar mesas
- El hook `useSseEvents` maneja reconexión automática cada 5 segundos

## 🔒 Seguridad

- Autenticación JWT con access token (24h) + refresh token (7d)
- `@PreAuthorize` en cada endpoint sensible del backend
- Cierre automático de sesión en el frontend cuando el JWT expira (`useTokenExpiry`)
- Contraseñas hasheadas con BCrypt
- CORS configurado para orígenes específicos
- Permisos granulares por rol almacenados en JSONB

## 🎨 Personalización del Tema

El tema es completamente dinámico desde la página de Configuración:

- Color primario, secundario, fondo, tarjetas y sidebar
- Los colores se aplican como variables CSS en tiempo real sin recargar
- Se persisten en la base de datos y se cargan al iniciar sesión

## 📦 Despliegue en Producción

### Backend

```bash
mvn clean package -DskipTests
java -jar target/pos-morales-1.0.0.jar \
  --spring.profiles.active=prod \
  --DB_PASSWORD=tu_password \
  --JWT_SECRET=tu_secret_256bits
```

### Frontend

```bash
npm run build
# Servir la carpeta dist/ con Nginx, Apache o cualquier CDN
```

### Variables de entorno recomendadas en producción

```bash
DB_PASSWORD=password_seguro_aleatorio
JWT_SECRET=cadena_aleatoria_minimo_64_caracteres
CORS_ORIGINS=https://tu-dominio.com
```

## 🧪 Testing

```bash
# Backend
cd back-mor && mvn test

# Frontend (type-check)
cd front-emy && npm run build
```

## 📄 Licencia

Este proyecto es privado y de uso exclusivo para Sistema Morales.

## 👥 Contacto

Desarrollado por el equipo de Sistema POS Morales.

---

**Versión**: 1.1.0  
**Última actualización**: Febrero 2026

### Historial de cambios recientes
- **v1.1.0**: Módulo de Cocina con SSE, pedidos por lote y prioridad; módulo de Mesas con zonas dinámicas; roles MESERO y COCINERO; impresión térmica unificada 58mm; cierre automático de sesión; permisos SUPERVISOR en productos/inventario/categorías; módulo Promociones en gestión de roles.
- **v1.0.0**: POS, Productos, Inventario, Facturas, Clientes, Reportes, Usuarios, Roles, Configuración.
