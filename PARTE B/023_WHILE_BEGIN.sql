/*
SQL Server hace una "simulación" de un bucle FOR utilizando WHILE o cursores. 
En el siguiente ejemplo, utilizaremos un ejemplo de uso de WHILE sencillo sin cursores.
Recorreremos los primeros 5 productos de la tabla Production.Product y mostraremos su ProductID y Name
*/


DECLARE @Contador INT = 1;
DECLARE @ProductID INT;
DECLARE @ProductName NVARCHAR(100);

WHILE @Contador <= 5
BEGIN
-- Seleccionar el producto por el index del contador definido
    SELECT 
        @ProductID = ProductID, 
        @ProductName = Name
    FROM 
        Production.Product
    WHERE 
-- Filtrar por el ProductID (del 1 al 5)
        ProductID = @Contador;  

-- Mostrar el producto actual
    PRINT 'Producto ' + CAST(@ProductID AS NVARCHAR) + ': ' + @ProductName;

-- Incrementar el contador
    SET @Contador = @Contador + 1;
END


