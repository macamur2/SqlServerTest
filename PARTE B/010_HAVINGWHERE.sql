/*
Una cláusula HAVING es como una cláusulua WHERE pero el WHERE filtra filas individuales antes de que se realicen agregaciones o agrupamientos.
Sin embargo, el HAVING se aplica aa grupos de datos YA resultantes después de aplicar el agrupamiento (Group BY) o funcionades de agregado como SUM o COUNT

   Ejemplo: Queremos obtener la cantidad total de proudctos vendidos para cada ProductID para las filas con un precio unitario mayor a 10
   y mostrar los productos que hayan vendido más de 100 unidades en total
*/

SELECT ProductID, SUM(OrderQty) AS TotalQuantity
FROM Sales.SalesOrderDetail
WHERE UnitPrice > 10
GROUP BY ProductID
HAVING SUM(OrderQty) > 100


