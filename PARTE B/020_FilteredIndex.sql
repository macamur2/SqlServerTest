/*
Un índice filtrado es una forma eficiente de buscar datos en una base de datos grande sin revisar toda la tabla. 
Imaginemos que tenemos una lista enorme de pedidos y que solo nos interesan aquellos con más de 10 unidades vendidas. 
Crear un índice filtrado nos permite enfocarnos solo en esos pedidos específicos y no en toda la lista.

Se define con una condición específica en la cláusula WHERE. 
Esto lo hace útil para tablas grandes con consultas que solo afectan a un subconjunto de datos, permitiendo mejorar el rendimiento de las consultas y reducir el tamaño del índice.

Si utilizásemos el ejemplo superior de ventas y cantidades vendidas:
*/

--Esta consulta puede ser lenta si la tabla tiene muchos datos.
SELECT SalesOrderID, ProductID, OrderQty, LineTotal
FROM Sales.SalesOrderDetail
WHERE OrderQty > 10;

-- Para hacer que la consulta sea más rápida, podemos crear un índice filtrado que solo incluya los pedidos con más de 10 unidades.

CREATE INDEX IX_SalesOrderDetail_OrderQtyFiltered
ON Sales.SalesOrderDetail (SalesOrderID, ProductID, OrderQty)
WHERE OrderQty > 10;

/*
Ventajas:
   - Menor Tamaño: Al no incluir todos los datos de la tabla, el índice es más pequeño y ocupa menos espacio en la BD
   - Mayor rapidez: Búsquedas más rapidas porque el índice solo revisa las filas que nos interesan
   - Menor mantenimiento: Más fácil y rápido de actualizar cuando los datos cambian.
   
   Guardamos la información de las filas que cumplen con una condición específica y no información de toda la tabla.
*/

