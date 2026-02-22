# 🏪 Sistema POS Morales

Sistema de Punto de Venta moderno y adaptable, desarrollado con Java Spring Boot (backend) y React + TypeScript (frontend).

## 📋 Características

- **Punto de Venta (POS)**: Interfaz intuitiva para ventas rápidas
- **Gestión de Productos**: Catálogo completo con categorías
- **Control de Inventario**: Stock, alertas y movimientos
- **Facturación**: Facturas, cotizaciones y devoluciones
- **Clientes**: Base de datos de clientes con historial
- **Reportes**: Análisis de ventas y estadísticas
- **Usuarios**: Control de acceso basado en roles
- **Configuración**: Personalización de tema y empresa

## 🛠️ Tecnologías

### Backend (`back-mor`)
- Java 17
- Spring Boot 3.2
- Spring Security + JWT
- Spring Data JPA
- PostgreSQL
- Flyway (migraciones)
- Maven

### Frontend (`front-emy`)
- React 18
- TypeScript
- Vite
- Redux Toolkit
- React Router v6
- Tailwind CSS
- Lucide Icons
- React Hook Form + Zod

## 📁 Estructura del Proyecto

```
sistema_morales/
├── back-mor/                    # Backend Spring Boot
│   ├── src/main/java/com/morales/pos/
│   │   ├── application/         # DTOs, servicios
│   │   ├── domain/              # Entidades, repositorios, enums
│   │   ├── infrastructure/      # Configuración, seguridad
│   │   └── presentation/        # Controladores
│   └── src/main/resources/
│       ├── db/migration/        # Scripts SQL Flyway
│       └── application.yml      # Configuración
│
├── front-emy/                   # Frontend React
│   ├── src/
│   │   ├── app/                 # Store, rutas principales
│   │   ├── core/                # API, auth, utilidades
│   │   ├── modules/             # Módulos funcionales
│   │   │   ├── auth/
│   │   │   ├── dashboard/
│   │   │   ├── pos/
│   │   │   ├── products/
│   │   │   ├── categories/
│   │   │   ├── inventory/
│   │   │   ├── invoices/
│   │   │   ├── customers/
│   │   │   ├── reports/
│   │   │   ├── users/
│   │   │   └── settings/
│   │   └── shared/              # Componentes, estilos
│   └── package.json
│
└── SISTEMA_POS_MORALES_DESIGN.md  # Documento de diseño
```

## 🚀 Instalación

### Requisitos Previos

1. **Java 17+**: [Descargar JDK](https://adoptium.net/)
2. **Node.js 18+**: [Descargar Node](https://nodejs.org/)
3. **PostgreSQL 14+**: [Descargar PostgreSQL](https://www.postgresql.org/download/)
4. **Maven 3.8+**: [Descargar Maven](https://maven.apache.org/download.cgi)

### 1. Configurar Base de Datos

```sql
-- Crear base de datos y usuario en PostgreSQL
CREATE DATABASE morales_pos;
CREATE USER morales_user WITH PASSWORD 'morales_2024';
GRANT ALL PRIVILEGES ON DATABASE morales_pos TO morales_user;
```

### 2. Configurar Backend

```bash
# Navegar al directorio del backend
cd back-mor

# Compilar el proyecto
mvn clean install -DskipTests

# Ejecutar (las migraciones se aplicarán automáticamente)
mvn spring-boot:run
```

El backend estará disponible en: `http://localhost:8080`

### 3. Configurar Frontend

```bash
# Navegar al directorio del frontend
cd front-emy

# Instalar dependencias
npm install

# Ejecutar en modo desarrollo
npm run dev
```

El frontend estará disponible en: `http://localhost:5173`

## 🔐 Credenciales por Defecto

- **Usuario**: `admin`
- **Contraseña**: `admin123`

> ⚠️ **Importante**: Cambiar la contraseña en producción.

## ⚙️ Variables de Entorno

### Backend (`application.yml`)

```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/morales_pos
    username: morales_user
    password: morales_2024

app:
  jwt:
    secret: tu-secret-key-muy-segura-de-al-menos-256-bits
    expiration: 86400000
    refresh-expiration: 604800000
```

### Frontend

Crear archivo `.env.local`:

```env
VITE_API_URL=http://localhost:8080/api
```

## 📡 API Endpoints

### Autenticación
- `POST /api/auth/login` - Iniciar sesión
- `POST /api/auth/refresh` - Refrescar token
- `POST /api/auth/logout` - Cerrar sesión

### Productos
- `GET /api/products` - Listar productos
- `POST /api/products` - Crear producto
- `PUT /api/products/{id}` - Actualizar producto
- `DELETE /api/products/{id}` - Eliminar producto

### Facturas
- `GET /api/invoices` - Listar facturas
- `POST /api/invoices` - Crear factura
- `GET /api/invoices/{id}` - Obtener factura

*(Documentación completa disponible en Swagger: `http://localhost:8080/swagger-ui.html`)*

## 🎨 Personalización del Tema

El sistema usa un tema con degradados morados. Para personalizar:

1. Editar `front-emy/tailwind.config.js` para colores
2. Editar `front-emy/src/shared/styles/globals.css` para estilos globales
3. Usar la página de Configuración para cambios dinámicos

## 📦 Despliegue en Producción

### Backend

```bash
# Compilar JAR
mvn clean package -DskipTests

# Ejecutar JAR
java -jar target/morales-pos-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod
```

### Frontend

```bash
# Generar build de producción
npm run build

# Los archivos estarán en dist/
```

## 🧪 Testing

```bash
# Backend
cd back-mor
mvn test

# Frontend
cd front-emy
npm run test
```

## 📄 Licencia

Este proyecto es privado y de uso exclusivo para Sistema Morales.

## 👥 Contacto

Desarrollado por el equipo de Sistema POS Morales.

---

**Versión**: 1.0.0  
**Última actualización**: Enero 2025
