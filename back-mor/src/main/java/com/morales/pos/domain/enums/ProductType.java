package com.morales.pos.domain.enums;

/**
 * Clasificacion de productos para el modelo de inventario hibrido.
 * - DIRECTO: se vende y descuenta 1:1 (gaseosas, cervezas, empaquetados).
 * - PREPARADO: plato de cocina; al venderse descuenta sus ingredientes segun receta.
 * - INSUMO: materia prima / ingrediente; se compra y se consume, no se vende directo.
 */
public enum ProductType {
    DIRECTO,
    PREPARADO,
    INSUMO
}
