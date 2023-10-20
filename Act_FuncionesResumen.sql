-- Actividad 2.3
-- Consulta
-- 1
-- Listado con la cantidad de agentes

SELECT COUNT(*) CantAgentes from Agentes

-- 2
-- Listado con importe de referencia promedio de los tipos de infracciones

SELECT ti.Descripcion ,AVG(ti.ImporteReferencia) Importe_de_Referencia_Promedio FROM TipoInfracciones ti GROUP BY ti.Descripcion

-- 3
-- Listado con la suma de los montos de las multas. Indistintamente de si fueron pagadas o no.

SELECT SUM(m.Monto) SumaTotal_Multas FROM Multas m

-- 4
-- Listado con la cantidad de pagos que se realizaron

SELECT COUNT(m.Pagada) Multas_Pagadas FROM Multas m where m.Pagada=0

-- 5
-- Listado con la cantidad de multas realizadas en la provincia de Buenos Aires.
-- NOTA: Utilizar el nombre 'Buenos Aires' de la provincia.

SELECT COUNT(*) Multas_Bs_As FROM Multas m INNER JOIN Localidades loc on m.IDLocalidad=loc.IDLocalidad INNER JOIN Provincias pr on loc.IDProvincia=pr.IDProvincia WHERE pr.Provincia='Buenos Aires'

-- 6
-- Listado con el promedio de antigüedad de los agentes que se encuentren activos.

SELECT AVG(DATEDIFF(YEAR, a.FechaIngreso, GETDATE())) Promedio_Antiguedad FROM Agentes a WHERE a.Activo=1

-- 7
-- Listado con el monto más elevado que se haya registrado en una multa.

SELECT MAX(m.Monto) Max_Monto_Multa FROM Multas m 

-- 8
-- Listado con el importe de pago más pequeño que se haya registrado.

SELECT MAX(m.Monto) Min_Monto_Multa FROM Multas m WHERE m.Pagada=1

-- 9
-- Por cada agente, listar Legajo, Apellidos y Nombres y la cantidad de multas que registraron.

SELECT a.Legajo, a.Apellidos, a.Nombres, COUNT(m.IdMulta) Cant_Multas FROM Agentes a INNER JOIN Multas m on m.IdAgente=a.IdAgente GROUP BY a.Legajo, a.Apellidos, a.Nombres

-- 10
-- Por cada tipo de infracción, listar la descripción y el promedio de montos de las multas asociadas a dicho tipo de infracción.

SELECT ti.Descripcion, AVG(m.Monto) MontoXtipoInfraccion FROM TipoInfracciones ti INNER JOIN Multas m on ti.IdTipoInfraccion=m.IdTipoInfraccion GROUP BY ti.Descripcion

-- 11
-- Por cada multa, indicar la fecha, la patente, el importe de la multa y la cantidad de pagos realizados. Solamente mostrar la información de las multas que hayan sido pagadas en su totalidad.

SELECT m.FechaHora, m.Patente, m.Monto, COUNT(p.Importe)CantDePagosRealizados FROM Multas m INNER JOIN Pagos p on m.IdMulta=p.IDMulta WHERE m.Pagada=0 GROUP BY m.FechaHora, m.Patente, m.Monto

-- 12
-- Listar todos los datos de las multas que hayan registrado más de un pago.

SELECT m.IdMulta, m.IdTipoInfraccion, m.IDLocalidad, m.IdAgente, m.Patente, m.Monto FROM Multas m INNER JOIN Pagos p on m.IdMulta=p.IDMulta GROUP BY m.IdMulta, m.IdTipoInfraccion, m.IDLocalidad, m.IdAgente, m.Patente, m.Monto HAVING COUNT(p.IDPago)>1

-- 13
-- Listar todos los datos de todos los agentes que hayan registrado multas con un monto que en promedio supere los $10000

SELECT a.Apellidos, a.Nombres FROM Agentes a LEFT JOIN Multas m on a.IdAgente=m.IdAgente GROUP BY a.Apellidos, a.Nombres HAVING AVG(m.Monto)>10000

-- 14
-- Listar el tipo de infracción que más cantidad de multas haya registrado.

SELECT top 1 ti.Descripcion, COUNT(m.IdMulta) Cant_Multas FROM TipoInfracciones ti INNER JOIN Multas m on ti.IdTipoInfraccion=m.IdTipoInfraccion GROUP BY ti.Descripcion ORDER BY COUNT(m.IdMulta) desc

-- 15
-- Listar por cada patente, la cantidad de infracciones distintas que se cometieron.

SELECT m.Patente, COUNT(distinct m.IdTipoInfraccion) Cant_Infracciones FROM Multas m GROUP BY m.Patente ORDER BY m.Patente asc

-- 16
-- Listar por cada patente, el texto literal 'Multas pagadas' y el monto total de los pagos registrados por esa patente. Además, por cada patente, el texto literal 'Multas por pagar' y el monto total de lo que se adeuda.

SELECT m.Patente, CONCAT('Multas pagadas ', SUM(p.Importe)) Multas_Pagadas, CONCAT('Multas por pagar ', SUM(m.Monto)) Monto_Adeudado FROM Multas m INNER JOIN Pagos p on m.IdMulta=p.IDMulta GROUP BY m.Patente

-- 17
-- Listado con los nombres de los medios de pagos que se hayan utilizado más de 3 veces.

SELECT mp.Nombre FROM MediosPago mp INNER JOIN Pagos p on mp.IDMedioPago=p.IDMedioPago GROUP BY mp.Nombre HAVING COUNT(p.IDMedioPago)>3

-- 18
-- Los legajos, apellidos y nombres de los agentes que hayan labrado más de 2 multas con tipos de infracciones distintas.

SELECT a.Legajo, a.Apellidos, a.Nombres FROM Agentes a INNER JOIN Multas m on a.IdAgente=m.IdAgente GROUP BY a.Legajo, a.Apellidos, a.Nombres HAVING COUNT(distinct m.IdTipoInfraccion)>2

-- 19
-- El total recaudado en concepto de pagos discriminado por nombre de medio de pago.

SELECT mp.nombre, SUM(p.Importe) Importe_RecaudadoX_MedioPago FROM MediosPago mp INNER JOIN Pagos p on mp.IDMedioPago=p.IDMedioPago GROUP BY mp.Nombre

-- 20
-- Un listado con el siguiente formato:
-- Descripción        Tipo           Recaudado
-- -----------------------------------------------
-- Tigre              Localidad      $xxxx
-- San Fernando       Localidad      $xxxx
-- Rosario            Localidad      $xxxx
-- Buenos Aires       Provincia      $xxxx
-- Santa Fe           Provincia      $xxxx
-- Argentina          País           $xxxx

SELECT loc.Localidad Descripción, pr.Provincia Tipo, SUM(p.Importe) Recaudado  FROM Localidades loc INNER JOIN Provincias pr on loc.IDProvincia=pr.IDProvincia INNER JOIN Multas m on loc.IDLocalidad=m.IDLocalidad INNER JOIN Pagos p on m.IdMulta=p.IDMulta GROUP BY loc.Localidad, pr.Provincia



--------------------------------------------------------------------------

-- La cantidad de colaboradores que nacieron luego del año 1995.
SELECT
    count (FechaNacimiento)
from Colaboradores
where year(FechaNacimiento)>1995

-- El costo total de todos los pedidos que figuren como Pagado.
SELECT
    SUM(pe.Costo)
from Pedidos pe
where pe.Pagado=1

-- La cantidad total de unidades pedidas del producto con ID igual a 30.
    SELECT 
        SUM(p.Cantidad)
    from Pedidos p
    where p.IDProducto=30

-- La cantidad de clientes distintos que hicieron pedidos en el año 2020.
    SELECT distinct
        COUNT(p.IDCliente)
    from Pedidos p
    where year(p.FechaSolicitud)=2020

-- Por cada material, la cantidad de productos que lo utilizan.
    SELECT * from Materiales_x_Producto

    SELECT
        mp.IDMaterial,
        COUNT(mp.IDMaterial) as cantProductos
    from Materiales_x_Producto mp 
    group by mp.IDMaterial


-- Para cada producto, listar el nombre y la cantidad de pedidos pagados.
    SELECT * from Pedidos

    SELECT 
        pe.IDProducto,
        COUNT(*)
    From Pedidos pe 
    INNER JOIN Productos pr on pe.IDProducto= pr.ID
    where pe.Pagado =1
    GROUP by pe.IDProducto

    SELECT 
        pe.IDProducto,
        pr.Descripcion
    From Pedidos pe 
    INNER JOIN Productos pr on pe.IDProducto= pr.ID
    where pe.Pagado =1
    order by pe.IDProducto asc

    

-- Por cada cliente, listar apellidos y nombres de los clientes y la cantidad de productos distintos que haya pedido.
    
    SELECT
        pe.IDCliente,
        pe.IDProducto,
        cl.Apellidos,
        cl.Nombres
    from Pedidos pe
    inner join clientes cl on pe.IDCliente=cl.ID
    ORDER by pe.IDCliente

    SELECT
        c.Nombres,
        c.Apellidos,
        COUNT(distinct pe.IDProducto) cantProductoscl
    FROM Pedidos pe
    INNER JOIN Clientes c on pe.IDCliente=c.ID
    GROUP by pe.IDCliente, c.Nombres, c.Apellidos

    select * from Pedidos where IDCliente=32

-- Por cada colaborador y tarea que haya realizado, listar apellidos y nombres, nombre de la tarea y la cantidad de veces que haya realizado esa tarea.

    SELECT 
        col.Apellidos,
        col.Nombres,
        tr.Nombre,
        COUNT(txp.IDTarea) as TareasRealizadas
    from Colaboradores col
    inner JOIN Tareas_x_Pedido txp on col.Legajo=txp.Legajo
    INNER JOIN Tareas tr on txp.IDTarea=tr.ID
    group by txp.IDTarea, col.Apellidos, col.Nombres, tr.Nombre

    SELECT * from Tareas_x_Pedido


-- Por cada cliente, listar los apellidos y nombres y el importe individual más caro que hayan abonado en concepto de pago.

    SELECT
        cl.Apellidos,
        cl.Nombres,
        MAX(pe.Costo) elmenorcost
    from Clientes cl
    inner JOIN Pedidos pe on cl.ID=pe.IDCliente
    GROUP by pe.Costo, cl.Apellidos, cl.Nombres

select Costo,
IDCliente
from Pedidos
order by Costo asc

-- Por cada colaborador, apellidos y nombres y la menor cantidad de unidades solicitadas en un pedido individual en el que haya trabajado.

    SELECT
        co.Apellidos,
        co.Nombres,
        min(pe.Cantidad) cantUnidades
    from Colaboradores co
    inner JOIN Tareas_x_Pedido txp on co.Legajo=txp.Legajo
    inner join Pedidos pe on txp.IDPedido=pe.ID
    group by pe.Cantidad, co.Apellidos, co.Nombres


-- Listar apellidos y nombres de aquellos clientes que no hayan realizado ningún pedido. Es decir, que contabilicen 0 pedidos.

    select
    cl.Apellidos,
    cl.Nombres,
    pe.id
    from Clientes cl
    LEFT join Pedidos pe on cl.ID=pe.IDCliente
    where pe.id is null

    select
    cl.Apellidos,
    cl.Nombres,
    count (pe.id) Pedidosrealizados
    from Clientes cl
    LEFT join Pedidos pe on cl.ID=pe.IDCliente
    where pe.ID is null
    group by pe.ID, cl.Nombres, cl.Apellidos
    



-- Obtener un listado de productos indicando descripción y precio de aquellos productos que hayan registrado más de 15 pedidos.

SELECT 
    pr.Descripcion,
    pr.Costo,
    pe.Cantidad,
    COUNT(pr.ID) 
from Pedidos pe
inner join Productos pr on pr.ID=pe.IDCliente
where pe.Cantidad>15
GROUP by pr.ID, pr.Descripcion,pe.Cantidad, pr.Costo
order by pr.Descripcion asc

SELECT 
    pr.Descripcion,
    pr.Costo,
    COUNT(pr.Descripcion) CantProductos
from Pedidos pe
inner join Productos pr on pr.ID=pe.IDCliente
GROUP by pr.Descripcion, pr.Costo
HAVING COUNT(pr.Descripcion) >15

-- Obtener un listado de productos indicando descripción y nombre de categoría de los productos que tienen un precio promedio de pedidos mayor a 
--$25000.

SELECT 
    pr.Descripcion,
    ca.Nombre Categoria,
    pr.Costo,
    COUNT(pr.Costo) pedidosMayores
from Pedidos pe
inner join Productos pr on pr.ID=pe.IDCliente
inner join Categorias ca on pr.IDCategoria=ca.ID
where pr.Costo>25000
GROUP by pr.Descripcion, ca. Nombre, pr.Costo




-- Apellidos y nombres de los clientes que hayan registrado más de 15 pedidos que superen los $15000.

    SELECT
        cl.Apellidos,
        cl.Nombres,
        COUNT(pe.IDCliente) Clientes     
    from Pedidos pe
    inner join Clientes cl on pe.IDCliente=cl.ID
    GROUP by pe.IDCliente, cl.Apellidos, cl.Nombres
    HAVING COUNT(pe.IDCliente)>15 and SUM(pe.Costo) >15000

-- Para cada producto, listar el nombre, el texto 'Pagados'  y la cantidad de pedidos pagados. Anexar otro listado con nombre, el texto 'No pagados' y cantidad de pedidos no pagados.

SELECT 
    pr.ID,
    pr.Descripcion,
    COUNT(pe.Pagado) Pagados
from Productos pr
INNER JOIN Pedidos pe on pr.ID=pe.IDProducto
WHERE pe.Pagado=1
GROUP by pe.Pagado, pr.Descripcion, pr.ID