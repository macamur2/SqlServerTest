/*
Las cláusulas OFFSET y FETCH son útiles para devolver un subconjunto de filas, 
como cuando queremos mostrar resultados por páginas en una aplicación. (Paginación).

Es utilizado normalmente para implementar paginación en aplicaciones que muestran grandes volúmenes de datos en partes más manejables.

A tener en cuenta:
   - Es necesario tener una ordenación para poder utilizar OFFSET y FETCH correctamente.
*/

-- Ej. 
-- Simularemos la paginación mostrando varias páginas de 5 filas cada una en la tabla Sales.SalesOrderDetails. 
-- Para paginar, usamos OFFSET 0 (no saltamos ninguna fila) y FETCH NEXT 5 ROWS ONLY

-- Primera página (filas 1 a 5)
SELECT SalesOrderID, ProductID, OrderQty, LineTotal
FROM Sales.SalesOrderDetail
ORDER BY SalesOrderID
OFFSET 0 ROWS 
FETCH NEXT 5 ROWS ONLY;


-- Segunda página (filas 6 a 10)

SELECT SalesOrderID, ProductID, OrderQty, LineTotal
FROM Sales.SalesOrderDetail
ORDER BY SalesOrderID
OFFSET 5 ROWS 
FETCH NEXT 5 ROWS ONLY;

-- Tercera página (filas 11 a 15)
SELECT SalesOrderID, ProductID, OrderQty, LineTotal
FROM Sales.SalesOrderDetail
ORDER BY SalesOrderID
OFFSET 10 ROWS 
FETCH NEXT 5 ROWS ONLY;
