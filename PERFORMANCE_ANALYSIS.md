# Análisis de Rendimiento - Sistema POS Morales

## Fecha: 16 de Febrero 2026

## 🔍 Causas Identificadas de Lentitud

### 1. **Backend - Queries N+1 de Hibernate**
**Problema:** Hibernate carga relaciones de forma LAZY por defecto, generando múltiples queries.

**Evidencia:**
```sql
-- Se ve en logs múltiples queries como:
SELECT * FROM products...
SELECT * FROM categories WHERE id=?  -- Por cada producto
SELECT * FROM inventory WHERE product_id=?  -- Por cada producto
```

**Solución:**
- Usar `@EntityGraph` o `JOIN FETCH` en queries críticas
- Configurar FetchType.EAGER solo donde sea necesario
- Implementar DTOs proyectados para queries específicas

---

### 2. **Frontend - Carga Excesiva de Datos**
**Problema:** Varias páginas cargan todos los datos sin paginación.

**Casos específicos:**
- `POSPage`: Carga TODOS los productos activos (puede ser 100+)
- `CategoriesPage`: Carga todas las categorías y subcategorías
- `InvoicesPage`: Carga 200 facturas por defecto

**Solución:**
- Implementar virtualización (React Window/TanStack Virtual)
- Lazy loading de imágenes de productos
- Paginación real en tablas grandes

---

### 3. **SSE (Server-Sent Events) - Reconexiones Frecuentes**
**Problema:** SSE se reconecta cada vez que hay error, generando tráfico innecesario.

**Impacto:**
- Queries constantes a `/api/notifications/unread`
- Reconexiones cada 5 segundos en caso de error

**Solución:**
- Implementar backoff exponencial en reconexiones
- Aumentar timeout de keepalive
- Deshabilitar SSE en páginas que no lo necesitan

---

### 4. **Falta de Índices en Base de Datos**
**Tablas críticas sin índices:**
```sql
-- Tabla: invoice_details
-- Falta índice en: invoice_id, product_id, kitchen_status

-- Tabla: invoices
-- Falta índice compuesto: (status, created_at)

-- Tabla: products
-- Falta índice: category_id, is_active
```

---

### 5. **Tamaño de Respuestas API**
**Problema:** DTOs incluyen información innecesaria.

**Ejemplo:**
```json
// InvoiceResponse incluye:
{
  "details": [
    {
      "product": { // Todo el producto completo
        "category": { /* toda la categoría */ },
        "inventory": { /* todo el inventario */ }
      }
    }
  ]
}
```

---

## ⚡ Optimizaciones Recomendadas (Prioridad)

### 🔴 **Alta Prioridad**
1. **Agregar índices faltantes en BD** ⏱️ 10 min
2. **Implementar JOIN FETCH en ProductService.getActive()** ⏱️ 15 min
3. **Reducir tamaño de InvoiceResponse (eliminar anidación innecesaria)** ⏱️ 20 min

### 🟡 **Media Prioridad**
4. **Implementar paginación en POSPage** ⏱️ 1 hora
5. **Lazy loading de imágenes de productos** ⏱️ 30 min
6. **Optimizar SSE con backoff exponencial** ⏱️ 45 min

### 🟢 **Baja Prioridad (Futuro)**
7. Implementar caché en Redis para productos activos
8. Comprimir respuestas HTTP (gzip)
9. Implementar Service Worker para PWA

---

## 📊 Mediciones Actuales

### Tiempos de Carga Observados:
- **POSPage inicial:** ~2-3 segundos
- **Dashboard:** ~1.5-2 segundos  
- **InvoicesPage:** ~2-3 segundos
- **TablesPage:** ~1-2 segundos

### Tamaño de Respuestas:
- `/api/products/active`: ~150KB (sin imágenes)
- `/api/invoices?size=200`: ~500KB
- `/api/categories`: ~20KB

---

## 🎯 Meta de Rendimiento

**Objetivo:** Todas las páginas deben cargar en **< 1 segundo** con conexión normal.

**Estrategia:**
1. Optimizar backend primero (80% del impacto)
2. Luego optimizar frontend (20% del impacto)
3. Monitorear con herramientas (React DevTools Profiler)

---

## 🛠️ Próximos Pasos

1. ✅ Crear migración V10 con índices faltantes
2. ✅ Modificar ProductService para usar JOIN FETCH
3. ✅ Simplificar DTOs (eliminar anidación profunda)
4. ⏳ Probar y medir mejoras
5. ⏳ Iterar según resultados
