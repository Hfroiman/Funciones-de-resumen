-- 1
-- Listado con la cantidad de agentes

SELECT COUNT(a.IdAgente) CantAgentes FROM Agentes a

-- 2
-- Listado con importe de referencia promedio de los tipos de infracciones

SELECT AVG(ti.ImporteReferencia) Promedioti FROM TipoInfracciones ti

SELECT (SUM(ti.ImporteReferencia)/COUNT(ti.ImporteReferencia)) as Promedio FROM TipoInfracciones ti 

-- 3
-- Listado con la suma de los montos de las multas. Indistintamente de si fueron pagadas o no.

SELECT SUM(m.Monto) TotalMontos FROM Multas m

-- 4
-- Listado con la cantidad de pagos que se realizaron.

SELECT COUNT(m.Pagada) CantPagos FROM Multas m WHERE m.Pagada=1

SELECT * from Multas

update Multas set Pagada=1 WHERE IdMulta=1 --Se modifico el id multa para la consulta

-- 5
-- Listado con la cantidad de multas realizadas en la provincia de Buenos Aires.
-- NOTA: Utilizar el nombre 'Buenos Aires' de la provincia.

SELECT COUNT(m.IdMulta) CantMultas_BSAS FROM Multas m INNER JOIN Localidades loc on m.IDLocalidad=loc.IDLocalidad JOIN Provincias pr on loc.IDProvincia=pr.IDProvincia WHERE pr.Provincia='Buenos Aires'

-- 6
-- Listado con el promedio de antigüedad de los agentes que se encuentren activos.

SELECT AVG(DATEDIFF(YEAR,a.FechaIngreso,GETDATE())) FROM Agentes a WHERE a.Activo=1

SELECT (SUM(DATEDIFF(YEAR, a.FechaIngreso, GETDATE()))/COUNT(a.IdAgente)) as PromedioAgente FROM Agentes a WHERE a.Activo=1

-- 7
-- Listado con el monto más elevado que se haya registrado en una multa.

SELECT MAX(m.Monto) FROM Multas m 

-- 8
-- Listado con el importe de pago más pequeño que se haya registrado.

SELECT MIN(p.Importe) importeMIN FROM Pagos p

-- 9
-- Por cada agente, listar Legajo, Apellidos y Nombres y la cantidad de multas que registraron.

SELECT a.Legajo, a.Apellidos, a.Nombres, COUNT(m.IdMulta) MultasRegistradas FROM Agentes a INNER JOIN Multas m on a.IdAgente=m.IdAgente GROUP BY a.Legajo, a.Apellidos, a.Nombres

-- 10
-- Por cada tipo de infracción, listar la descripción y el promedio de montos de las multas asociadas a dicho tipo de infracción.

SELECT ti.Descripcion, AVG(ti.ImporteReferencia) Promedio FROM TipoInfracciones ti  GROUP BY ti.Descripcion

-- 11
-- Por cada multa, indicar la fecha, la patente, el importe de la multa y la cantidad de pagos realizados. Solamente mostrar la información de las multas que hayan sido pagadas en su totalidad.

SELECT m.FechaHora, m.Patente, m.Monto, COUNT(p.Importe) FROM Multas m INNER JOIN Pagos p on m.IdMulta=p.IDMulta GROUP BY m.FechaHora, m.Patente, m.Monto HAVING SUM(p.Importe)>=m.Monto

-- 12
-- Listar todos los datos de las multas que hayan registrado más de un pago.

SELECT m.IdMulta, m.IdAgente FROM Multas m INNER JOIN Pagos p on m.IdMulta=p.IDMulta GROUP BY m.IdMulta, m.IdAgente HAVING COUNT(p.IDPago)> 1

-- 13
-- Listar todos los datos de todos los agentes que hayan registrado multas con un monto que en promedio supere los $10000

SELECT a.Apellidos, a.Nombres, a.Legajo FROM Agentes a INNER JOIN Multas m on a.IdAgente=m.IdAgente GROUP BY a.Apellidos, a.Nombres, a.Legajo HAVING AVG(m.Monto)>10000

-- 14
-- Listar el tipo de infracción que más cantidad de multas haya registrado.

SELECT top 1 ti.Descripcion FROM TipoInfracciones ti INNER JOIN Multas m on ti.IdTipoInfraccion=m.IdTipoInfraccion GROUP BY ti.Descripcion ORDER BY COUNT(m.IdTipoInfraccion) desc

-- 15
-- Listar por cada patente, la cantidad de infracciones distintas que se cometieron.

SELECT m.Patente, COUNT(distinct m.IdMulta) DistintasInfracc FROM Multas m GROUP BY m.Patente

-- 16
-- Listar por cada patente, el texto literal 'Multas pagadas' y el monto total de los pagos registrados por esa patente. Además, por cada patente, el texto literal 'Multas por pagar' y el monto total de lo que se adeuda.

SELECT m.Patente, SUM(p.Importe) as 'Multas pagadas', (SUM(m.Monto)-SUM(p.Importe)) as 'Multas por pagar' FROM Multas m INNER JOIN Pagos p on m.IdMulta=p.IDMulta GROUP BY m.Patente

-- 17
-- Listado con los nombres de los medios de pagos que se hayan utilizado más de 3 veces.

SELECT mp.Nombre FROM Pagos p INNER JOIN MediosPago mp on p.IDMedioPago=mp.IDMedioPago GROUP BY mp.Nombre HAVING COUNT(distinct p.IDMedioPago)>3

-- 18
-- Los legajos, apellidos y nombres de los agentes que hayan labrado más de 2 multas con tipos de infracciones distintas.



-- 19
-- El total recaudado en concepto de pagos discriminado por nombre de medio de pago.
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