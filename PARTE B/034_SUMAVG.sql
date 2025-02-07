/*
   Promedio de ventas por año.
   Si queremos calcular el promedio de ventas anuales, lo hacemos con AVG() OVER(PARTITION BY YEAR).
   
   ### Para recordar, la cláusula PARTITION BY se usa en las funciones para dividir los datos en grupos sin eliminar detalles de cada fila. Es como un GROUP BY, pero sin colapsar filas.
*/

SELECT 
    YEAR(soh.OrderDate) AS OrderYear,
    soh.SalesOrderID,
    soh.TotalDue,
    AVG(soh.TotalDue) OVER (PARTITION BY YEAR(soh.OrderDate)) AS AvgSalesByYear
FROM Sales.SalesOrderHeader soh;