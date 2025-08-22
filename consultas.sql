-- Consulta 1 --
/*Mostrar el nombre, telefono y email de todos los clientes que tienen un alquiler activo 
(es decir, cuya fecha actual esté dentro del rango entre fecha_inicio y fecha_fin).*/
SELECT clientes.nombre, clientes.telefono, clientes.email
FROM clientes
INNER JOIN alquileres ON clientes.id_cliente = alquileres.id_cliente
WHERE alquileres.fecha_inicio <= CURDATE() AND alquileres.fecha_fin >= CURDATE();

-- Consulta 2 --
/*Mostrar los vehículos que se alquilaron en el mes de marzo de 2025. Debe mostrar el 
modelo, marca, y precio_dia de esos vehículos.*/
SELECT vehiculos.modelo, vehiculos.marca, vehiculos.precio_dia
FROM vehiculos
INNER JOIN alquileres ON vehiculos.id_vehiculo = alquileres.id_vehiculo
WHERE MONTH(alquileres.fecha_inicio) = 3 AND YEAR(alquileres.fecha_inicio) = 2025;

-- Consulta 3 --
/*Calcular el precio total del alquiler para cada cliente, considerando el número de 
días que alquiló el vehículo (el precio por día de cada vehículo multiplicado por la 
cantidad de días de alquiler).*/
SELECT clientes.nombre, SUM(vehiculos.precio_dia * DATEDIFF(alquileres.fecha_fin, alquileres.fecha_inicio)) AS precio_total
FROM clientes
INNER JOIN alquileres ON clientes.id_cliente = alquileres.id_cliente
INNER JOIN vehiculos ON alquileres.id_vehiculo = vehiculos.id_vehiculo
GROUP BY clientes.id_cliente;

-- Consulta 4 --
/*Encontrar los clientes que no han realizado ningún pago (no tienen registros en la 
tabla Pagos). Muestra su nombre y email.*/
SELECT clientes.nombre, clientes.email
FROM clientes
INNER JOIN alquileres ON clientes.id_cliente = alquileres.id_cliente
LEFT JOIN pagos ON alquileres.id_alquiler = pagos.id_alquiler
WHERE pagos.id_pago IS NULL;

-- Consulta 5 --
/*Calcular el promedio de los pagos realizados por cada cliente. Muestra el nombre del 
cliente y el promedio de pago.*/
SELECT clientes.nombre, AVG(pagos.monto) AS promedio_pago
FROM clientes
INNER JOIN alquileres ON clientes.id_cliente = alquileres.id_cliente
INNER JOIN pagos ON alquileres.id_alquiler = pagos.id_alquiler
GROUP BY clientes.id_cliente;

-- Consulta 6 --
/*Mostrar los vehículos que están disponibles para alquilar en una fecha específica 
(por ejemplo, 2025-03-18). Debe mostrar el modelo, marca y precio_dia. Si el vehículo 
está ocupado, no se debe incluir.*/
SELECT v.marca, v.modelo, v.precio_dia
FROM vehiculos v
WHERE v.id_vehiculo NOT IN (
    SELECT a.id_vehiculo
    FROM alquileres a
    WHERE '2025-03-18' BETWEEN a.fecha_inicio AND a.fecha_fin
);

-- Consulta 7 --
/*Encontrar la marca y el modelo de los vehículos que se alquilaron más de una vez en 
el mes de marzo de 2025.*/
SELECT v.marca, v.modelo, COUNT(a.id_vehiculo) AS veces_alquilado
FROM vehiculos v JOIN alquileres a ON v.id_vehiculo = a.id_vehiculo
WHERE MONTH(a.fecha_inicio) = 3 AND YEAR(a.fecha_inicio) = 2025 
GROUP BY a.id_vehiculo
HAVING veces_alquilado > 1;

-- Consulta 8 --
/*Mostrar el total de monto pagado por cada cliente. Debe mostrar el nombre del cliente
 y la cantidad total de pagos realizados (suma del monto de los pagos).*/
SELECT c.nombre, SUM(p.monto) AS total_pagado
FROM alquileres a join clientes c ON a.id_cliente = c.id_cliente  join pagos p ON a.id_alquiler = p.id_alquiler
GROUP BY c.id_cliente;

-- Consulta 9 --
/*Mostrar los clientes que alquilaron el vehículo Ford Focus (con id_vehiculo = 3). Debe 
mostrar el nombre del cliente y la fecha del alquiler.*/
SELECT c.nombre, a.fecha_inicio AS fecha_alquiler
FROM clientes c JOIN alquileres a ON c.id_cliente = a.id_cliente
WHERE a.id_vehiculo = 3;

-- Consulta 10 --
/*Realizar una consulta que muestre el nombre del cliente y el total de días alquilados 
de cada cliente, ordenado de mayor a menor total de días. El total de días es calculado 
como la diferencia entre fecha_inicio y fecha_fin.*/
SELECT c.nombre, SUM(DATEDIFF(a.fecha_fin, a.fecha_inicio)) AS total_dias
FROM clientes c JOIN alquileres a ON c.id_cliente = a.id_cliente
GROUP BY c.id_cliente
ORDER BY total_dias DESC;