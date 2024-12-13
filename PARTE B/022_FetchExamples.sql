/*
El comando FETCH puede tener diferentes contextos en base a su uso, principalmente:
   - Con el uso de cursores -> Para recorrer fila por fila un conjunto de resultados
   - Con OFFSET para paginar o limitar los resultados de una consulta (Como el ejemplo del ejercicio anterior)
*/

-- CURSORES: Ejemplo del uso de fetch con cursores (Recorrer productos de la tabla Production.Product con un cursor para productos cuyo precio sea mayor de 100)

DECLARE @ProductID INT;
DECLARE @Name NVARCHAR(100);

-- Declarar el cursor
DECLARE product_cursor CURSOR FOR
SELECT 
    ProductID, 
    Name
FROM 
    Production.Product
WHERE 
    ListPrice > 100;

-- Abrimos el cursor
OPEN product_cursor;

-- Recuperamos la primera fila
FETCH NEXT FROM product_cursor INTO @ProductID, @Name;

-- Recorremos todas las filas (Se ejecuta hasta que ya no haya más filas)
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'ID del Producto: ' + CAST(@ProductID AS NVARCHAR) + ', Nombre: ' + @Name;

-- Recuperamos la siguiente fila
    FETCH NEXT FROM product_cursor INTO @ProductID, @Name;
END

-- Cerramos y liberamos el cursor
CLOSE product_cursor;
DEALLOCATE product_cursor;


-- PAGINACIÓN: (Hay ejemplos en el ejercicio 021. Igualmente, trataremos de recuperar los primeros 5 productos con el precio más alto ordenados de mayor a menor
SELECT 
    ProductID, 
    Name, 
    ListPrice
FROM 
    Production.Product
ORDER BY 
    ListPrice DESC
OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY;

-- Obtener la segunda página de 10 filas.
SELECT 
    SalesOrderID, 
    OrderDate, 
    TotalDue
FROM 
    Sales.SalesOrderHeader
ORDER BY 
    OrderDate
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;

