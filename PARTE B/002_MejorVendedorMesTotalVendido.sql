--Ventas Mensuales por cada vendedor y mes
WITH MonthlySales AS (
SELECT 
    soh.SalesPersonID,
    FORMAT(soh.OrderDate, 'dd/MM') as [SalesMonth],
    SUM(soh.TotalDue) as [TotalSales]
FROM 
    Sales.SalesOrderHeader soh
WHERE 
    soh.SalesPersonID IS NOT NULL -- Que tengan un vendedor asignado a la orden de venta
GROUP BY soh.SalesPersonID, soh.OrderDate),

--Empleado con mayor ventas por mes
RankedSales AS (
SELECT 
    ms.SalesPersonID,
    ms.SalesMonth,
    ms.TotalSales,
    ROW_NUMBER() OVER (PARTITION BY ms.SalesMonth ORDER BY ms.TotalSales DESC) AS RankedNumber --Asignar un valor numérico ordenado por el total de cada vendedor de manera descendente
FROM
    MonthlySales ms 
)

SELECT 
    per.FirstName,
    per.LastName,
    rs.SalesMonth,
    rs.TotalSales
FROM RankedSales rs
JOIN HumanResources.Employee emp
    ON emp.BusinessEntityID = rs.SalesPersonID
JOIN Person.Person per
    ON emp.BusinessEntityID = per.BusinessEntityID
WHERE rs.RankedNumber = 1