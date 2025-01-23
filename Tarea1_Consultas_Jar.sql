-- 1.Listar información básica de las oficinas
SELECT codigo_oficina, ciudad, pais, telefono 
FROM oficina;

-- 2.Obtener los empleados por oficina
SELECT codigo_oficina, nombre, apellido1, puesto 
FROM empleado
ORDER BY codigo_oficina;

-- 3.Calcular el promedio de salario de los clientes por región
SELECT region, AVG(limite_credito) AS promedio_limite_credito 
FROM cliente
GROUP BY region;

-- 4.Listar clientes con sus representantes de ventas
SELECT c.nombre AS cliente, CONCAT(e.nombre, ' ', e.apellido1) AS representante_ventas
FROM cliente c
JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado;

-- 5.Obtener productos disponibles y en stock
SELECT codigo_producto, nombre, cantidad_en_stock
FROM producto
WHERE cantidad_en_stock > 0;

-- 6.Productos con precios por debajo del promedio
SELECT codigo_producto, nombre, precio_venta
FROM producto
WHERE precio_venta < (SELECT AVG(precio_venta) FROM producto);

-- 7.Pedidos pendientes por cliente
SELECT p.codigo_pedido, p.estado, c.nombre 
FROM pedido p
JOIN cliente c ON p.codigo_cliente = c.codigo_cliente
WHERE p.estado != 'Entregado';

-- 8.Total de productos por categoría
SELECT gama, COUNT(*) AS total_productos 
FROM producto
GROUP BY gama;

-- 9.Ingresos totales generados por cliente
SELECT c.nombre, SUM(p.monto) AS ingresos_totales
FROM pago p
JOIN cliente c ON p.codigo_cliente = c.codigo_cliente
GROUP BY c.codigo_cliente;

-- 10.Pedidos realizados en un rango de fechas
SELECT codigo_pedido, fecha_pedido
FROM pedido
WHERE fecha_pedido BETWEEN '2023-01-01' AND '2023-12-31';

-- 11.Detalles de un pedido específico
SELECT l.codigo_pedido, l.codigo_producto, l.cantidad, (l.cantidad * l.precio_unidad) AS precio_total
FROM detalle_pedido l
WHERE l.codigo_pedido = ?;

-- 12.Productos más vendidos
SELECT p.codigo_producto, p.nombre, SUM(d.cantidad) AS total_vendido
FROM producto p
JOIN detalle_pedido d ON p.codigo_producto = d.codigo_producto
GROUP BY p.codigo_producto
ORDER BY total_vendido DESC;

-- 13.Pedidos con un valor total superior al promedio
SELECT codigo_pedido, SUM(cantidad * precio_unidad) AS valor_total
FROM detalle_pedido
GROUP BY codigo_pedido
HAVING valor_total > (SELECT AVG(cantidad * precio_unidad) FROM detalle_pedido);

-- 14.Clientes sin representante de ventas asignado
SELECT nombre
FROM cliente
WHERE codigo_empleado_rep_ventas IS NULL;

-- 15.Número total de empleados por oficina
SELECT codigo_oficina, COUNT(*) AS total_empleados
FROM empleado
GROUP BY codigo_oficina;

-- 16.Pagos realizados en una forma específica
SELECT *
FROM pago
WHERE forma_pago = 'Tarjeta de Crédito';

-- 17.Ingresos mensuales
SELECT MONTH(fecha_pago) AS mes, SUM(monto) AS ingresos_totales
FROM pago
GROUP BY MONTH(fecha_pago);

-- 18.Clientes con múltiples pedidos
SELECT c.nombre
FROM cliente c
JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
GROUP BY c.codigo_cliente
HAVING COUNT(p.codigo_pedido) > 1;

-- 19.Pedidos con productos agotados
SELECT DISTINCT p.codigo_pedido
FROM pedido p
JOIN detalle_pedido d ON p.codigo_pedido = d.codigo_pedido
JOIN producto pr ON d.codigo_producto = pr.codigo_producto
WHERE pr.cantidad_en_stock = 0;

-- 20.Promedio, máximo y mínimo del límite de crédito de los clientes por país
SELECT pais, AVG(limite_credito) AS promedio, MAX(limite_credito) AS maximo, MIN(limite_credito) AS minimo
FROM cliente
GROUP BY pais;

-- 21.Historial de transacciones de un cliente
SELECT fecha_pago, monto, forma_pago
FROM pago
WHERE codigo_cliente = ?;

-- 22.Empleados sin jefe directo asignado
SELECT nombre, apellido1
FROM empleado
WHERE codigo_jefe IS NULL;

-- 23.Productos cuyo precio supera el promedio de su categoría
SELECT codigo_producto, nombre, precio_venta
FROM producto p
WHERE precio_venta > (SELECT AVG(precio_venta) FROM producto WHERE gama = p.gama);

-- 24.Promedio de días de entrega por estado
SELECT estado, AVG(DATEDIFF(fecha_entrega, fecha_pedido)) AS promedio_dias
FROM pedido
WHERE fecha_entrega IS NOT NULL
GROUP BY estado;

-- 25.Clientes por país con más de un pedido
SELECT pais, COUNT(DISTINCT codigo_cliente) AS clientes_con_multiples_pedidos
FROM cliente c
JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
GROUP BY pais
HAVING COUNT(p.codigo_pedido) > 1;