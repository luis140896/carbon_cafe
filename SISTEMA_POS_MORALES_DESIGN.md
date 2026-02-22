# 🏪 SISTEMA POS MORALES - Documento de Diseño Completo

## 📋 Tabla de Contenidos
1. [Visión General](#visión-general)
2. [Análisis de Requerimientos](#análisis-de-requerimientos)
3. [Arquitectura del Sistema](#arquitectura-del-sistema)
4. [Estructura de Carpetas](#estructura-de-carpetas)
5. [Módulos del Sistema](#módulos-del-sistema)
6. [Diseño de Base de Datos](#diseño-de-base-de-datos)
7. [Seguridad](#seguridad)
8. [Mejoras Sugeridas](#mejoras-sugeridas)
9. [Recursos de Diseño](#recursos-de-diseño)
10. [Guía de GitHub](#guía-de-github)
11. [Tecnologías y Dependencias](#tecnologías-y-dependencias)

---

## 🎯 Visión General

**Nombre del Proyecto:** Sistema POS Morales  
**Tipo:** Sistema de Punto de Venta Multiempresa  
**Adaptable a:** Restaurantes, Ferreterías, Droguerías, Tiendas, Supermercados

### Características Principales
- ✅ **Multinegocios:** Configurable para cualquier tipo de comercio
- ✅ **Personalizable:** Colores, títulos, logos y diseño modificables
- ✅ **Modular:** Arquitectura por módulos fácil de mantener
- ✅ **Seguro:** Control de acceso basado en roles y permisos
- ✅ **Reportes:** Informes por día, semana, mes, año y rangos personalizados

---

## 📊 Análisis de Requerimientos

### Requerimientos Funcionales

| Módulo | Funcionalidad |
|--------|---------------|
| **Productos** | CRUD completo, categorías, imágenes, precios de costo y venta |
| **Inventario** | Control de stock, alertas de bajo inventario, movimientos |
| **Facturación** | Ventas, devoluciones, múltiples formas de pago |
| **Reportes** | Por período (día/semana/mes/año), rango de fechas personalizado |
| **Usuarios** | Roles, permisos granulares, auditoría de acciones |
| **Configuración** | Personalización de colores, títulos, logo, datos empresa |

### Requerimientos No Funcionales

| Aspecto | Especificación |
|---------|----------------|
| **Frontend** | React + TypeScript |
| **Backend** | Java + Spring Boot |
| **Base de Datos** | PostgreSQL (compatible DBeaver) |
| **Arquitectura** | Clean Architecture |
| **Diseño UI** | Degradados, bordes redondeados, fondo morado claro |

---

## 🏗️ Arquitectura del Sistema

### Clean Architecture - Capas

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  (Controllers, DTOs, Request/Response, Exception Handlers)  │
├─────────────────────────────────────────────────────────────┤
│                    APPLICATION LAYER                         │
│        (Use Cases, Services, Mappers, Validators)           │
├─────────────────────────────────────────────────────────────┤
│                      DOMAIN LAYER                            │
│     (Entities, Value Objects, Repository Interfaces)         │
├─────────────────────────────────────────────────────────────┤
│                   INFRASTRUCTURE LAYER                       │
│  (Repository Impl, External APIs, Database, Security)        │
└─────────────────────────────────────────────────────────────┘
```

### Diagrama de Comunicación

```
┌──────────────┐     HTTP/REST      ┌──────────────┐
│              │ ◄───────────────►  │              │
│  front-emy   │      JSON/JWT      │   back-mor   │
│   (React)    │                    │ (Spring Boot)│
│              │                    │              │
└──────────────┘                    └──────┬───────┘
                                           │
                                           │ JDBC
                                           ▼
                                    ┌──────────────┐
                                    │  PostgreSQL  │
                                    │   Database   │
                                    └──────────────┘
```

---

## 📁 Estructura de Carpetas

### Backend (back-mor)

```
back-mor/
├── src/
│   ├── main/
│   │   ├── java/com/morales/pos/
│   │   │   │
│   │   │   ├── domain/                          # CAPA DOMINIO
│   │   │   │   ├── entity/
│   │   │   │   │   ├── Product.java
│   │   │   │   │   ├── Category.java
│   │   │   │   │   ├── User.java
│   │   │   │   │   ├── Role.java
│   │   │   │   │   ├── Permission.java
│   │   │   │   │   ├── Invoice.java
│   │   │   │   │   ├── InvoiceDetail.java
│   │   │   │   │   ├── Inventory.java
│   │   │   │   │   ├── InventoryMovement.java
│   │   │   │   │   ├── Customer.java
│   │   │   │   │   ├── Supplier.java
│   │   │   │   │   └── CompanyConfig.java
│   │   │   │   │
│   │   │   │   ├── repository/                  # Interfaces
│   │   │   │   │   ├── ProductRepository.java
│   │   │   │   │   ├── CategoryRepository.java
│   │   │   │   │   ├── UserRepository.java
│   │   │   │   │   ├── InvoiceRepository.java
│   │   │   │   │   ├── InventoryRepository.java
│   │   │   │   │   └── ReportRepository.java
│   │   │   │   │
│   │   │   │   ├── valueobject/
│   │   │   │   │   ├── Money.java
│   │   │   │   │   ├── Email.java
│   │   │   │   │   └── DateRange.java
│   │   │   │   │
│   │   │   │   └── exception/
│   │   │   │       ├── DomainException.java
│   │   │   │       ├── ProductNotFoundException.java
│   │   │   │       └── InsufficientStockException.java
│   │   │   │
│   │   │   ├── application/                     # CAPA APLICACIÓN
│   │   │   │   ├── usecase/
│   │   │   │   │   ├── product/
│   │   │   │   │   │   ├── CreateProductUseCase.java
│   │   │   │   │   │   ├── UpdateProductUseCase.java
│   │   │   │   │   │   ├── DeleteProductUseCase.java
│   │   │   │   │   │   └── GetProductUseCase.java
│   │   │   │   │   ├── invoice/
│   │   │   │   │   │   ├── CreateInvoiceUseCase.java
│   │   │   │   │   │   ├── CancelInvoiceUseCase.java
│   │   │   │   │   │   └── GetInvoiceUseCase.java
│   │   │   │   │   ├── inventory/
│   │   │   │   │   │   ├── AdjustInventoryUseCase.java
│   │   │   │   │   │   └── TransferInventoryUseCase.java
│   │   │   │   │   ├── report/
│   │   │   │   │   │   ├── GenerateSalesReportUseCase.java
│   │   │   │   │   │   ├── GenerateInventoryReportUseCase.java
│   │   │   │   │   │   └── GenerateFinancialReportUseCase.java
│   │   │   │   │   └── auth/
│   │   │   │   │       ├── LoginUseCase.java
│   │   │   │   │       └── RefreshTokenUseCase.java
│   │   │   │   │
│   │   │   │   ├── service/
│   │   │   │   │   ├── ProductService.java
│   │   │   │   │   ├── CategoryService.java
│   │   │   │   │   ├── InvoiceService.java
│   │   │   │   │   ├── InventoryService.java
│   │   │   │   │   ├── ReportService.java
│   │   │   │   │   ├── UserService.java
│   │   │   │   │   └── ConfigService.java
│   │   │   │   │
│   │   │   │   ├── dto/
│   │   │   │   │   ├── request/
│   │   │   │   │   │   ├── ProductRequest.java
│   │   │   │   │   │   ├── InvoiceRequest.java
│   │   │   │   │   │   ├── LoginRequest.java
│   │   │   │   │   │   └── ReportRequest.java
│   │   │   │   │   └── response/
│   │   │   │   │       ├── ProductResponse.java
│   │   │   │   │       ├── InvoiceResponse.java
│   │   │   │   │       ├── ReportResponse.java
│   │   │   │   │       └── ApiResponse.java
│   │   │   │   │
│   │   │   │   ├── mapper/
│   │   │   │   │   ├── ProductMapper.java
│   │   │   │   │   ├── InvoiceMapper.java
│   │   │   │   │   └── UserMapper.java
│   │   │   │   │
│   │   │   │   └── validator/
│   │   │   │       ├── ProductValidator.java
│   │   │   │       └── InvoiceValidator.java
│   │   │   │
│   │   │   ├── infrastructure/                  # CAPA INFRAESTRUCTURA
│   │   │   │   ├── persistence/
│   │   │   │   │   ├── jpa/
│   │   │   │   │   │   ├── JpaProductRepository.java
│   │   │   │   │   │   ├── JpaCategoryRepository.java
│   │   │   │   │   │   ├── JpaInvoiceRepository.java
│   │   │   │   │   │   └── JpaUserRepository.java
│   │   │   │   │   └── specification/
│   │   │   │   │       ├── ProductSpecification.java
│   │   │   │   │       └── InvoiceSpecification.java
│   │   │   │   │
│   │   │   │   ├── security/
│   │   │   │   │   ├── jwt/
│   │   │   │   │   │   ├── JwtTokenProvider.java
│   │   │   │   │   │   ├── JwtAuthenticationFilter.java
│   │   │   │   │   │   └── JwtAuthenticationEntryPoint.java
│   │   │   │   │   ├── CustomUserDetailsService.java
│   │   │   │   │   └── SecurityConfig.java
│   │   │   │   │
│   │   │   │   ├── storage/
│   │   │   │   │   ├── FileStorageService.java
│   │   │   │   │   └── ImageStorageService.java
│   │   │   │   │
│   │   │   │   ├── audit/
│   │   │   │   │   ├── AuditListener.java
│   │   │   │   │   └── AuditLog.java
│   │   │   │   │
│   │   │   │   └── config/
│   │   │   │       ├── DatabaseConfig.java
│   │   │   │       ├── CorsConfig.java
│   │   │   │       ├── SwaggerConfig.java
│   │   │   │       └── CacheConfig.java
│   │   │   │
│   │   │   ├── presentation/                    # CAPA PRESENTACIÓN
│   │   │   │   ├── controller/
│   │   │   │   │   ├── ProductController.java
│   │   │   │   │   ├── CategoryController.java
│   │   │   │   │   ├── InvoiceController.java
│   │   │   │   │   ├── InventoryController.java
│   │   │   │   │   ├── ReportController.java
│   │   │   │   │   ├── UserController.java
│   │   │   │   │   ├── AuthController.java
│   │   │   │   │   └── ConfigController.java
│   │   │   │   │
│   │   │   │   └── exception/
│   │   │   │       ├── GlobalExceptionHandler.java
│   │   │   │       └── ErrorResponse.java
│   │   │   │
│   │   │   └── MoralesPosApplication.java
│   │   │
│   │   └── resources/
│   │       ├── application.yml
│   │       ├── application-dev.yml
│   │       ├── application-prod.yml
│   │       ├── db/migration/                    # Flyway migrations
│   │       │   ├── V1__create_users_table.sql
│   │       │   ├── V2__create_categories_table.sql
│   │       │   ├── V3__create_products_table.sql
│   │       │   ├── V4__create_invoices_table.sql
│   │       │   └── V5__create_inventory_table.sql
│   │       └── messages/
│   │           ├── messages_es.properties
│   │           └── messages_en.properties
│   │
│   └── test/
│       └── java/com/morales/pos/
│           ├── unit/
│           ├── integration/
│           └── e2e/
│
├── pom.xml
├── Dockerfile
├── docker-compose.yml
└── README.md
```

### Frontend (front-emy)

```
front-emy/
├── public/
│   ├── index.html
│   ├── favicon.ico
│   └── assets/
│       └── images/
│
├── src/
│   ├── app/                                     # Configuración App
│   │   ├── App.tsx
│   │   ├── store.ts                            # Redux Store
│   │   └── routes.tsx
│   │
│   ├── core/                                    # NÚCLEO
│   │   ├── api/
│   │   │   ├── axiosInstance.ts
│   │   │   ├── endpoints.ts
│   │   │   └── interceptors.ts
│   │   │
│   │   ├── auth/
│   │   │   ├── AuthContext.tsx
│   │   │   ├── AuthProvider.tsx
│   │   │   ├── ProtectedRoute.tsx
│   │   │   └── useAuth.ts
│   │   │
│   │   ├── config/
│   │   │   ├── constants.ts
│   │   │   └── environment.ts
│   │   │
│   │   ├── hooks/
│   │   │   ├── useApi.ts
│   │   │   ├── useDebounce.ts
│   │   │   ├── useLocalStorage.ts
│   │   │   └── useTheme.ts
│   │   │
│   │   ├── types/
│   │   │   ├── api.types.ts
│   │   │   ├── product.types.ts
│   │   │   ├── invoice.types.ts
│   │   │   ├── user.types.ts
│   │   │   └── report.types.ts
│   │   │
│   │   └── utils/
│   │       ├── formatters.ts
│   │       ├── validators.ts
│   │       ├── dateUtils.ts
│   │       └── currencyUtils.ts
│   │
│   ├── shared/                                  # COMPONENTES COMPARTIDOS
│   │   ├── components/
│   │   │   ├── ui/
│   │   │   │   ├── Button/
│   │   │   │   │   ├── Button.tsx
│   │   │   │   │   ├── Button.styles.ts
│   │   │   │   │   └── index.ts
│   │   │   │   ├── Input/
│   │   │   │   ├── Modal/
│   │   │   │   ├── Card/
│   │   │   │   ├── Table/
│   │   │   │   ├── Select/
│   │   │   │   ├── DatePicker/
│   │   │   │   ├── Toast/
│   │   │   │   ├── Loader/
│   │   │   │   └── Badge/
│   │   │   │
│   │   │   ├── layout/
│   │   │   │   ├── Sidebar/
│   │   │   │   ├── Header/
│   │   │   │   ├── Footer/
│   │   │   │   └── MainLayout/
│   │   │   │
│   │   │   └── common/
│   │   │       ├── SearchBar/
│   │   │       ├── Pagination/
│   │   │       ├── ConfirmDialog/
│   │   │       └── ImageUploader/
│   │   │
│   │   └── styles/
│   │       ├── globals.css
│   │       ├── variables.css                   # Colores personalizables
│   │       ├── gradients.css                   # Degradados
│   │       └── animations.css
│   │
│   ├── modules/                                 # MÓDULOS FUNCIONALES
│   │   │
│   │   ├── auth/
│   │   │   ├── components/
│   │   │   │   ├── LoginForm.tsx
│   │   │   │   └── ForgotPassword.tsx
│   │   │   ├── pages/
│   │   │   │   └── LoginPage.tsx
│   │   │   ├── services/
│   │   │   │   └── authService.ts
│   │   │   └── store/
│   │   │       └── authSlice.ts
│   │   │
│   │   ├── products/
│   │   │   ├── components/
│   │   │   │   ├── ProductCard.tsx
│   │   │   │   ├── ProductForm.tsx
│   │   │   │   ├── ProductList.tsx
│   │   │   │   ├── ProductGrid.tsx
│   │   │   │   ├── CategoryFilter.tsx
│   │   │   │   └── PriceEditor.tsx
│   │   │   ├── pages/
│   │   │   │   ├── ProductsPage.tsx
│   │   │   │   ├── ProductDetailPage.tsx
│   │   │   │   └── ProductFormPage.tsx
│   │   │   ├── services/
│   │   │   │   └── productService.ts
│   │   │   └── store/
│   │   │       └── productSlice.ts
│   │   │
│   │   ├── categories/
│   │   │   ├── components/
│   │   │   │   ├── CategoryCard.tsx
│   │   │   │   ├── CategoryForm.tsx
│   │   │   │   └── CategoryList.tsx
│   │   │   ├── pages/
│   │   │   │   └── CategoriesPage.tsx
│   │   │   ├── services/
│   │   │   │   └── categoryService.ts
│   │   │   └── store/
│   │   │       └── categorySlice.ts
│   │   │
│   │   ├── pos/                                # PUNTO DE VENTA
│   │   │   ├── components/
│   │   │   │   ├── POSLayout.tsx
│   │   │   │   ├── ProductSelector.tsx
│   │   │   │   ├── CategoryTabs.tsx
│   │   │   │   ├── Cart.tsx
│   │   │   │   ├── CartItem.tsx
│   │   │   │   ├── PaymentModal.tsx
│   │   │   │   ├── CustomerSearch.tsx
│   │   │   │   └── ReceiptPreview.tsx
│   │   │   ├── pages/
│   │   │   │   └── POSPage.tsx
│   │   │   ├── services/
│   │   │   │   └── posService.ts
│   │   │   └── store/
│   │   │       └── cartSlice.ts
│   │   │
│   │   ├── invoices/
│   │   │   ├── components/
│   │   │   │   ├── InvoiceList.tsx
│   │   │   │   ├── InvoiceDetail.tsx
│   │   │   │   ├── InvoiceFilters.tsx
│   │   │   │   └── InvoicePrint.tsx
│   │   │   ├── pages/
│   │   │   │   ├── InvoicesPage.tsx
│   │   │   │   └── InvoiceDetailPage.tsx
│   │   │   ├── services/
│   │   │   │   └── invoiceService.ts
│   │   │   └── store/
│   │   │       └── invoiceSlice.ts
│   │   │
│   │   ├── inventory/
│   │   │   ├── components/
│   │   │   │   ├── InventoryTable.tsx
│   │   │   │   ├── StockAdjustment.tsx
│   │   │   │   ├── MovementHistory.tsx
│   │   │   │   └── LowStockAlert.tsx
│   │   │   ├── pages/
│   │   │   │   ├── InventoryPage.tsx
│   │   │   │   └── MovementsPage.tsx
│   │   │   ├── services/
│   │   │   │   └── inventoryService.ts
│   │   │   └── store/
│   │   │       └── inventorySlice.ts
│   │   │
│   │   ├── reports/
│   │   │   ├── components/
│   │   │   │   ├── ReportFilters.tsx
│   │   │   │   ├── DateRangePicker.tsx
│   │   │   │   ├── SalesChart.tsx
│   │   │   │   ├── TopProductsChart.tsx
│   │   │   │   ├── RevenueChart.tsx
│   │   │   │   └── ReportExport.tsx
│   │   │   ├── pages/
│   │   │   │   ├── ReportsPage.tsx
│   │   │   │   ├── SalesReportPage.tsx
│   │   │   │   ├── InventoryReportPage.tsx
│   │   │   │   └── FinancialReportPage.tsx
│   │   │   ├── services/
│   │   │   │   └── reportService.ts
│   │   │   └── store/
│   │   │       └── reportSlice.ts
│   │   │
│   │   ├── users/
│   │   │   ├── components/
│   │   │   │   ├── UserForm.tsx
│   │   │   │   ├── UserList.tsx
│   │   │   │   ├── RoleSelector.tsx
│   │   │   │   └── PermissionMatrix.tsx
│   │   │   ├── pages/
│   │   │   │   ├── UsersPage.tsx
│   │   │   │   └── RolesPage.tsx
│   │   │   ├── services/
│   │   │   │   └── userService.ts
│   │   │   └── store/
│   │   │       └── userSlice.ts
│   │   │
│   │   ├── customers/
│   │   │   ├── components/
│   │   │   │   ├── CustomerForm.tsx
│   │   │   │   └── CustomerList.tsx
│   │   │   ├── pages/
│   │   │   │   └── CustomersPage.tsx
│   │   │   ├── services/
│   │   │   │   └── customerService.ts
│   │   │   └── store/
│   │   │       └── customerSlice.ts
│   │   │
│   │   └── settings/
│   │       ├── components/
│   │       │   ├── GeneralSettings.tsx
│   │       │   ├── ThemeSettings.tsx
│   │       │   ├── CompanySettings.tsx
│   │       │   ├── ColorPicker.tsx
│   │       │   └── LogoUploader.tsx
│   │       ├── pages/
│   │       │   └── SettingsPage.tsx
│   │       ├── services/
│   │       │   └── settingsService.ts
│   │       └── store/
│   │           └── settingsSlice.ts
│   │
│   ├── theme/                                   # TEMA PERSONALIZABLE
│   │   ├── ThemeContext.tsx
│   │   ├── ThemeProvider.tsx
│   │   ├── defaultTheme.ts
│   │   └── themeUtils.ts
│   │
│   └── index.tsx
│
├── package.json
├── tsconfig.json
├── tailwind.config.js
├── vite.config.ts
├── .env.example
├── Dockerfile
└── README.md
```

---

## 🗄️ Diseño de Base de Datos

### Diagrama Entidad-Relación

```
┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐
│  company_config │      │      users      │      │      roles      │
├─────────────────┤      ├─────────────────┤      ├─────────────────┤
│ id              │      │ id              │◄────►│ id              │
│ company_name    │      │ username        │      │ name            │
│ logo_url        │      │ email           │      │ description     │
│ primary_color   │      │ password_hash   │      │ permissions     │
│ secondary_color │      │ role_id         │      │ created_at      │
│ accent_color    │      │ is_active       │      └─────────────────┘
│ business_type   │      │ created_at      │
│ currency        │      │ last_login      │
│ tax_rate        │      └─────────────────┘
└─────────────────┘

┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐
│   categories    │      │    products     │      │    inventory    │
├─────────────────┤      ├─────────────────┤      ├─────────────────┤
│ id              │◄────►│ id              │◄────►│ id              │
│ name            │      │ code            │      │ product_id      │
│ description     │      │ name            │      │ quantity        │
│ image_url       │      │ description     │      │ min_stock       │
│ parent_id       │      │ category_id     │      │ max_stock       │
│ display_order   │      │ image_url       │      │ location        │
│ is_active       │      │ cost_price      │      │ last_updated    │
│ created_at      │      │ sale_price      │      └─────────────────┘
└─────────────────┘      │ barcode         │
                         │ unit            │
                         │ is_active       │
                         │ created_at      │
                         └─────────────────┘

┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐
│   customers     │      │    invoices     │      │ invoice_details │
├─────────────────┤      ├─────────────────┤      ├─────────────────┤
│ id              │◄────►│ id              │◄────►│ id              │
│ document_type   │      │ invoice_number  │      │ invoice_id      │
│ document_number │      │ customer_id     │      │ product_id      │
│ name            │      │ user_id         │      │ quantity        │
│ email           │      │ subtotal        │      │ unit_price      │
│ phone           │      │ tax             │      │ cost_price      │
│ address         │      │ discount        │      │ discount        │
│ is_active       │      │ total           │      │ subtotal        │
│ created_at      │      │ payment_method  │      └─────────────────┘
└─────────────────┘      │ status          │
                         │ notes           │
                         │ created_at      │
                         └─────────────────┘

┌─────────────────────┐      ┌─────────────────┐
│ inventory_movements │      │   audit_logs    │
├─────────────────────┤      ├─────────────────┤
│ id                  │      │ id              │
│ product_id          │      │ user_id         │
│ movement_type       │      │ action          │
│ quantity            │      │ entity          │
│ reference_id        │      │ entity_id       │
│ reason              │      │ old_value       │
│ user_id             │      │ new_value       │
│ created_at          │      │ ip_address      │
└─────────────────────┘      │ created_at      │
                             └─────────────────┘
```

### Scripts SQL para PostgreSQL

```sql
-- V1__create_initial_schema.sql

-- Tabla de configuración de empresa
CREATE TABLE company_config (
    id SERIAL PRIMARY KEY,
    company_name VARCHAR(200) NOT NULL,
    legal_name VARCHAR(200),
    tax_id VARCHAR(50),
    logo_url TEXT,
    primary_color VARCHAR(7) DEFAULT '#9b87f5',
    secondary_color VARCHAR(7) DEFAULT '#7c3aed',
    accent_color VARCHAR(7) DEFAULT '#c4b5fd',
    background_color VARCHAR(7) DEFAULT '#f3e8ff',
    business_type VARCHAR(50) DEFAULT 'GENERAL',
    currency VARCHAR(3) DEFAULT 'COP',
    tax_rate DECIMAL(5,2) DEFAULT 19.00,
    address TEXT,
    phone VARCHAR(50),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de roles
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    permissions JSONB DEFAULT '[]',
    is_system BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de usuarios
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(200),
    role_id INTEGER REFERENCES roles(id),
    avatar_url TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    must_change_password BOOLEAN DEFAULT FALSE,
    last_login TIMESTAMP,
    failed_login_attempts INTEGER DEFAULT 0,
    locked_until TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de categorías
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    image_url TEXT,
    parent_id INTEGER REFERENCES categories(id),
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de productos
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    barcode VARCHAR(50),
    name VARCHAR(200) NOT NULL,
    description TEXT,
    category_id INTEGER REFERENCES categories(id),
    image_url TEXT,
    cost_price DECIMAL(12,2) NOT NULL DEFAULT 0,
    sale_price DECIMAL(12,2) NOT NULL DEFAULT 0,
    profit_margin DECIMAL(5,2) GENERATED ALWAYS AS 
        (CASE WHEN cost_price > 0 THEN ((sale_price - cost_price) / cost_price * 100) ELSE 0 END) STORED,
    unit VARCHAR(20) DEFAULT 'UNIDAD',
    tax_rate DECIMAL(5,2) DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_by INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de inventario
CREATE TABLE inventory (
    id SERIAL PRIMARY KEY,
    product_id INTEGER UNIQUE REFERENCES products(id),
    quantity DECIMAL(12,2) DEFAULT 0,
    min_stock DECIMAL(12,2) DEFAULT 0,
    max_stock DECIMAL(12,2) DEFAULT 0,
    location VARCHAR(100),
    last_restock_date TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de movimientos de inventario
CREATE TABLE inventory_movements (
    id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(id),
    movement_type VARCHAR(20) NOT NULL, -- ENTRADA, SALIDA, AJUSTE, VENTA, DEVOLUCION
    quantity DECIMAL(12,2) NOT NULL,
    previous_quantity DECIMAL(12,2),
    new_quantity DECIMAL(12,2),
    reference_type VARCHAR(50), -- INVOICE, ADJUSTMENT, PURCHASE
    reference_id INTEGER,
    reason TEXT,
    user_id INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de clientes
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    document_type VARCHAR(10) DEFAULT 'CC',
    document_number VARCHAR(20),
    full_name VARCHAR(200) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(50),
    address TEXT,
    city VARCHAR(100),
    notes TEXT,
    credit_limit DECIMAL(12,2) DEFAULT 0,
    current_balance DECIMAL(12,2) DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(document_type, document_number)
);

-- Tabla de facturas/ventas
CREATE TABLE invoices (
    id SERIAL PRIMARY KEY,
    invoice_number VARCHAR(50) UNIQUE NOT NULL,
    invoice_type VARCHAR(20) DEFAULT 'VENTA', -- VENTA, COTIZACION, DEVOLUCION
    customer_id INTEGER REFERENCES customers(id),
    user_id INTEGER REFERENCES users(id),
    subtotal DECIMAL(12,2) NOT NULL DEFAULT 0,
    tax_amount DECIMAL(12,2) DEFAULT 0,
    discount_amount DECIMAL(12,2) DEFAULT 0,
    discount_percent DECIMAL(5,2) DEFAULT 0,
    total DECIMAL(12,2) NOT NULL DEFAULT 0,
    payment_method VARCHAR(50), -- EFECTIVO, TARJETA, TRANSFERENCIA, MIXTO
    payment_status VARCHAR(20) DEFAULT 'PAGADO', -- PAGADO, PENDIENTE, PARCIAL
    amount_received DECIMAL(12,2) DEFAULT 0,
    change_amount DECIMAL(12,2) DEFAULT 0,
    status VARCHAR(20) DEFAULT 'COMPLETADA', -- COMPLETADA, ANULADA, PENDIENTE
    notes TEXT,
    voided_by INTEGER REFERENCES users(id),
    voided_at TIMESTAMP,
    void_reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de detalles de factura
CREATE TABLE invoice_details (
    id SERIAL PRIMARY KEY,
    invoice_id INTEGER REFERENCES invoices(id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products(id),
    product_name VARCHAR(200), -- Snapshot del nombre
    quantity DECIMAL(12,2) NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    cost_price DECIMAL(12,2) NOT NULL, -- Para reportes de utilidad
    discount_amount DECIMAL(12,2) DEFAULT 0,
    tax_amount DECIMAL(12,2) DEFAULT 0,
    subtotal DECIMAL(12,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de pagos (para pagos múltiples)
CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    invoice_id INTEGER REFERENCES invoices(id),
    payment_method VARCHAR(50) NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    reference VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de proveedores
CREATE TABLE suppliers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    contact_name VARCHAR(200),
    email VARCHAR(100),
    phone VARCHAR(50),
    address TEXT,
    tax_id VARCHAR(50),
    notes TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de auditoría
CREATE TABLE audit_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    action VARCHAR(50) NOT NULL,
    entity_type VARCHAR(50) NOT NULL,
    entity_id INTEGER,
    old_values JSONB,
    new_values JSONB,
    ip_address VARCHAR(50),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de sesiones
CREATE TABLE user_sessions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    token_hash VARCHAR(255) NOT NULL,
    ip_address VARCHAR(50),
    user_agent TEXT,
    expires_at TIMESTAMP NOT NULL,
    is_valid BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índices para mejorar rendimiento
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_code ON products(code);
CREATE INDEX idx_products_barcode ON products(barcode);
CREATE INDEX idx_products_active ON products(is_active);
CREATE INDEX idx_invoices_date ON invoices(created_at);
CREATE INDEX idx_invoices_customer ON invoices(customer_id);
CREATE INDEX idx_invoices_status ON invoices(status);
CREATE INDEX idx_invoice_details_invoice ON invoice_details(invoice_id);
CREATE INDEX idx_inventory_product ON inventory(product_id);
CREATE INDEX idx_audit_entity ON audit_logs(entity_type, entity_id);
CREATE INDEX idx_audit_date ON audit_logs(created_at);

-- Datos iniciales
INSERT INTO roles (name, description, permissions, is_system) VALUES
('ADMIN', 'Administrador del sistema', '["*"]', true),
('CAJERO', 'Operador de caja', '["pos:*", "invoices:read", "products:read", "customers:*"]', true),
('INVENTARIO', 'Gestor de inventario', '["products:*", "categories:*", "inventory:*", "suppliers:*"]', true),
('REPORTES', 'Solo visualización de reportes', '["reports:*", "products:read", "invoices:read"]', true);

INSERT INTO company_config (company_name, business_type) VALUES
('Mi Negocio', 'GENERAL');
```

---

## 🔒 Seguridad

### Medidas Implementadas

#### 1. Autenticación y Autorización
```java
// JWT con refresh tokens
- Access Token: Expira en 15 minutos
- Refresh Token: Expira en 7 días
- Blacklist de tokens revocados
- Rotación automática de tokens
```

#### 2. Protección de Contraseñas
```java
// BCrypt con salt factor 12
- Hasheo seguro de contraseñas
- Políticas de contraseñas fuertes
- Bloqueo después de 5 intentos fallidos
- Historial de contraseñas (no repetir últimas 5)
```

#### 3. Protección CSRF y XSS
```java
// Headers de seguridad
- Content-Security-Policy
- X-Content-Type-Options: nosniff
- X-Frame-Options: DENY
- X-XSS-Protection: 1; mode=block
```

#### 4. Validación de Datos
```java
// Validación en múltiples capas
- Frontend: Validación de formularios
- Backend: DTOs con anotaciones @Valid
- Base de datos: Constraints
```

#### 5. Control de Acceso Basado en Permisos
```java
// Permisos granulares
products:read, products:create, products:update, products:delete
invoices:read, invoices:create, invoices:void
inventory:read, inventory:adjust
reports:sales, reports:inventory, reports:financial
users:read, users:create, users:update, users:delete
settings:read, settings:update
```

#### 6. Auditoría Completa
```java
// Registro de todas las acciones
- Usuario, acción, entidad, timestamp
- Valores anteriores y nuevos
- IP y User Agent
```

#### 7. Rate Limiting
```java
// Límites de peticiones
- Login: 5 intentos por minuto
- API general: 100 peticiones por minuto
- Reportes pesados: 10 por hora
```

### Configuración de Seguridad Recomendada

```yaml
# application-prod.yml
security:
  jwt:
    secret: ${JWT_SECRET}  # Variable de entorno
    access-token-expiration: 900000  # 15 min
    refresh-token-expiration: 604800000  # 7 días
  
  cors:
    allowed-origins: ${ALLOWED_ORIGINS}
    allowed-methods: GET,POST,PUT,DELETE,PATCH
    
  rate-limit:
    enabled: true
    requests-per-minute: 100
```

---

## 💡 Mejoras Sugeridas

### Funcionalidades Adicionales Recomendadas

| Funcionalidad | Descripción | Prioridad |
|---------------|-------------|-----------|
| **Código de barras** | Escaneo con cámara o lector USB | Alta |
| **Modo offline** | PWA con sincronización | Alta |
| **Múltiples cajas** | Apertura/cierre de caja por turno | Alta |
| **Notificaciones** | Alertas de stock bajo, ventas | Media |
| **Dashboard** | Métricas en tiempo real | Media |
| **Cotizaciones** | Generar y convertir a venta | Media |
| **Devoluciones** | Proceso completo de devoluciones | Alta |
| **Descuentos** | Por producto, categoría, cliente | Alta |
| **Impresión térmica** | Recibos en impresora POS | Alta |
| **Backup automático** | Respaldos programados | Alta |
| **Multi-sucursal** | Manejo de varias tiendas | Baja |
| **Fidelización** | Puntos y descuentos por cliente | Baja |
| **Integración contable** | Exportar a software contable | Media |

### Mejoras Técnicas

1. **Cache con Redis** - Para productos más consultados
2. **WebSockets** - Actualización en tiempo real del inventario
3. **Elasticsearch** - Búsqueda rápida de productos
4. **Docker Compose** - Despliegue simplificado
5. **CI/CD con GitHub Actions** - Automatización

---

## 🎨 Recursos de Diseño

### Paleta de Colores Sugerida (Morado Degradado)

```css
:root {
  /* Colores principales */
  --primary-50: #faf5ff;
  --primary-100: #f3e8ff;
  --primary-200: #e9d5ff;
  --primary-300: #d8b4fe;
  --primary-400: #c084fc;
  --primary-500: #a855f7;
  --primary-600: #9333ea;
  --primary-700: #7c3aed;
  --primary-800: #6b21a8;
  --primary-900: #581c87;
  
  /* Fondo degradado suave */
  --bg-gradient: linear-gradient(135deg, #f3e8ff 0%, #e9d5ff 50%, #faf5ff 100%);
  
  /* Botones con degradado */
  --btn-gradient: linear-gradient(135deg, #9333ea 0%, #7c3aed 100%);
  --btn-gradient-hover: linear-gradient(135deg, #7c3aed 0%, #6b21a8 100%);
}
```

### Páginas Recomendadas para Diseño

| Recurso | URL | Uso |
|---------|-----|-----|
| **Dribbble** | dribbble.com | Inspiración UI/UX para POS |
| **Behance** | behance.net | Diseños completos de dashboards |
| **Figma Community** | figma.com/community | Templates gratuitos |
| **Tailwind UI** | tailwindui.com | Componentes premium |
| **shadcn/ui** | ui.shadcn.com | Componentes React gratuitos |
| **Lucide Icons** | lucide.dev | Íconos modernos |
| **Heroicons** | heroicons.com | Íconos SVG |
| **Coolors** | coolors.co | Generador de paletas |
| **UI Gradients** | uigradients.com | Degradados |
| **Undraw** | undraw.co | Ilustraciones SVG |
| **Unsplash** | unsplash.com | Imágenes de productos |

### Ejemplos de Búsqueda en Dribbble
- "POS System UI"
- "Restaurant Dashboard"
- "Point of Sale Design"
- "Inventory Management UI"
- "Admin Dashboard Purple"

---

## 📤 Guía de GitHub

### Paso 1: Configuración Inicial de Git

```bash
# Instalar Git si no lo tienes
# Descargar de: https://git-scm.com/download/win

# Configurar tu identidad
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"
```

### Paso 2: Crear Repositorio en GitHub

1. Ve a **github.com** e inicia sesión
2. Click en **"+"** → **"New repository"**
3. Nombre: `sistema-pos-morales`
4. Descripción: "Sistema POS multiempresa con React y Spring Boot"
5. Visibilidad: **Private** (recomendado)
6. **NO** marcar "Initialize with README"
7. Click **"Create repository"**

### Paso 3: Inicializar Proyecto Local

```bash
# Navegar a la carpeta del proyecto
cd c:\sistema_morales

# Inicializar Git
git init

# Crear archivo .gitignore
# (Lo crearemos en el proyecto)

# Agregar todos los archivos
git add .

# Primer commit
git commit -m "feat: Inicialización del proyecto POS Morales"

# Conectar con GitHub (reemplaza con tu usuario)
git remote add origin https://github.com/TU_USUARIO/sistema-pos-morales.git

# Subir al repositorio
git branch -M main
git push -u origin main
```

### Paso 4: Flujo de Trabajo Diario

```bash
# Ver estado de cambios
git status

# Agregar cambios específicos
git add nombre-archivo.java

# O agregar todos los cambios
git add .

# Hacer commit con mensaje descriptivo
git commit -m "feat(products): Agregar endpoint de búsqueda por categoría"

# Subir cambios a GitHub
git push

# Descargar cambios del repositorio
git pull
```

### Paso 5: Convención de Commits (Recomendada)

```
feat:     Nueva funcionalidad
fix:      Corrección de bug
docs:     Cambios en documentación
style:    Formato (no afecta lógica)
refactor: Refactorización de código
test:     Agregar o modificar tests
chore:    Tareas de mantenimiento

Ejemplos:
feat(auth): Implementar login con JWT
fix(invoice): Corregir cálculo de impuestos
docs(readme): Actualizar instrucciones de instalación
refactor(products): Separar lógica en use cases
```

### Paso 6: Ramas (Branches)

```bash
# Crear nueva rama para una funcionalidad
git checkout -b feature/modulo-inventario

# Trabajar y hacer commits...

# Cambiar a main
git checkout main

# Fusionar rama
git merge feature/modulo-inventario

# Eliminar rama local
git branch -d feature/modulo-inventario

# Subir todo
git push
```

---

## 🛠️ Tecnologías y Dependencias

### Backend (back-mor)

```xml
<!-- pom.xml principales dependencias -->
<dependencies>
    <!-- Spring Boot Core -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    
    <!-- Spring Data JPA -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    
    <!-- Spring Security -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-security</artifactId>
    </dependency>
    
    <!-- JWT -->
    <dependency>
        <groupId>io.jsonwebtoken</groupId>
        <artifactId>jjwt-api</artifactId>
        <version>0.11.5</version>
    </dependency>
    
    <!-- PostgreSQL -->
    <dependency>
        <groupId>org.postgresql</groupId>
        <artifactId>postgresql</artifactId>
    </dependency>
    
    <!-- Flyway Migrations -->
    <dependency>
        <groupId>org.flywaydb</groupId>
        <artifactId>flyway-core</artifactId>
    </dependency>
    
    <!-- Validation -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-validation</artifactId>
    </dependency>
    
    <!-- Lombok -->
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
    </dependency>
    
    <!-- MapStruct -->
    <dependency>
        <groupId>org.mapstruct</groupId>
        <artifactId>mapstruct</artifactId>
        <version>1.5.5.Final</version>
    </dependency>
    
    <!-- OpenAPI/Swagger -->
    <dependency>
        <groupId>org.springdoc</groupId>
        <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
        <version>2.2.0</version>
    </dependency>
</dependencies>
```

### Frontend (front-emy)

```json
{
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.20.0",
    "@reduxjs/toolkit": "^1.9.7",
    "react-redux": "^8.1.3",
    "axios": "^1.6.0",
    "tailwindcss": "^3.3.5",
    "@headlessui/react": "^1.7.17",
    "lucide-react": "^0.294.0",
    "recharts": "^2.10.0",
    "react-hook-form": "^7.48.0",
    "@hookform/resolvers": "^3.3.2",
    "zod": "^3.22.4",
    "date-fns": "^2.30.0",
    "react-hot-toast": "^2.4.1",
    "react-query": "^3.39.3",
    "@tanstack/react-table": "^8.10.7",
    "framer-motion": "^10.16.5",
    "clsx": "^2.0.0",
    "tailwind-merge": "^2.0.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.0",
    "@vitejs/plugin-react": "^4.2.0",
    "typescript": "^5.2.0",
    "vite": "^5.0.0",
    "autoprefixer": "^10.4.16",
    "postcss": "^8.4.31"
  }
}
```

---

## ✅ Resumen y Próximos Pasos

### Lo que incluye este diseño:
1. ✅ Arquitectura Clean Architecture completa
2. ✅ Estructura modular para backend y frontend
3. ✅ Diseño de base de datos PostgreSQL
4. ✅ Sistema de seguridad robusto
5. ✅ Control de permisos granular
6. ✅ Personalización de colores y tema
7. ✅ Reportes flexibles por fechas
8. ✅ Gestión de productos con imágenes y categorías
9. ✅ Precios de costo y venta
10. ✅ Auditoría completa

### Orden de Implementación Sugerido:

1. **Fase 1 - Base (Semana 1-2)**
   - Configurar proyecto Spring Boot
   - Configurar React con Vite
   - Crear base de datos PostgreSQL
   - Implementar autenticación JWT

2. **Fase 2 - Core (Semana 3-4)**
   - Módulo de usuarios y roles
   - Módulo de categorías
   - Módulo de productos
   - Módulo de inventario básico

3. **Fase 3 - POS (Semana 5-6)**
   - Interfaz de punto de venta
   - Carrito de compras
   - Proceso de facturación
   - Clientes

4. **Fase 4 - Reportes (Semana 7-8)**
   - Reportes de ventas
   - Reportes de inventario
   - Dashboard con gráficos
   - Exportación a PDF/Excel

5. **Fase 5 - Pulido (Semana 9-10)**
   - Configuración de empresa
   - Personalización de tema
   - Optimización
   - Testing

---

**¿Deseas que comience a implementar algún módulo específico?**
