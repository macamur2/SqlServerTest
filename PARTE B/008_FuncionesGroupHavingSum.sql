/* GROUP BY
   Utilizado para agrupar filas que tienen valores comunes en columnas específicas. Suele ser muy utilpara realizxar cálculos agregados como SUM, COUNT, AVG, tal y como
   se soliita también en otra parte del ejercicio.

   Ejemplo: Contar empleados por departamento
*/

SELECT DepartmentID, Count(BusinessEntityID) as TotalEmployees
FROM HumanResources.EmployeeDepartmentHistory
GROUP BY DepartmentID


/* HAVING
   Utilizada para filtrar grupos después de aplicar una función de agregado.
   Es similar a un WHERE pero se utiliza después de un GROUP BY.

   *Sólo se puede utilizar con funciones dea gregación o en combinación con un GROUP BY

   Ejemplo: Filtrar departamentos con más de 10 empleados
*/

SELECT DepartmentID, Count(BusinessEntityID) as TotalEmployees
FROM HumanResources.EmployeeDepartmentHistory
GROUP BY DepartmentID
HAVING COUNT(BusinessEntityID) > 10


/*
   AVG -> Promedio
   MAX -> Máximo
   MIN -> Mínimo

   Obtener el promedio, máximo y mínimo del precio unitario por producto
*/

SELECT ProductID,
   AVG(UnitPrice) AS AvgPrice,
   MAX(UnitPrice) AS MaxPrice,
   MIN(unitPrice) AS MinPrice
FROM Sales.SalesOrderDetail
GROUP BY ProductID

/* ORDER BY + SUM + GROUP BY
   Utilizado para ordenador los resultados agrupados 

   Ejemplo: 5 productos más vendidos, ordenado de mayor a menor
*/

SELECT TOP 5 ProductID, SUM(OrderQty) AS TotalQuantity
FROM Sales.SalesOrderDetail
GROUP BY ProductID
ORDER BY TotalQuantity DESC