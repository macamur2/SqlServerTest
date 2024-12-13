
/*
El siguiente ejemplo recorrerá la tabla Production.Product e imprimirá el ProductID y el nombre de los productos. 
El bucle se detendrá cuando encuentre un producto con un ListPrice superior a 1000, para ello se utilizará la instrucción BREAK.

Se usará tambien OFFSET ROWS y FETCH NEXT porque si no repetiría el producto con el último ID encontrado tantas veces hasta el siguiente ID que exista.
Esto se hace así por el caso encontrado del ProductID. Hay un salto del ID 4 al 316, si no se pusiera esto, el contador subiría hasta 316 repitiendo el último registro válido (el 4).
*/


DECLARE @Contador INT = 1;
DECLARE @ProductID INT;
DECLARE @ProductName NVARCHAR(100);
DECLARE @ProductPrice DECIMAL(10, 2);
DECLARE @TotalProducts INT;

-- Obtener el total de productos 
SELECT @TotalProducts = COUNT(*) FROM Production.Product;

-- Bucle para recorrer los productos sin saltos
WHILE @Contador <= @TotalProducts
BEGIN
    -- Obtener el siguiente producto
    SELECT 
        @ProductID = pro.ProductID, 
        @ProductName = pro.Name,
        @ProductPrice = pro.ListPrice
    FROM 
        Production.Product pro
    ORDER BY pro.ProductID
    OFFSET @Contador - 1 ROWS
    FETCH NEXT 1 ROWS ONLY;

    -- Mostrar el producto
    PRINT 'Producto ' + CAST(@ProductID AS NVARCHAR) + ': ' + @ProductName + ' - Precio: ' + CAST(@ProductPrice AS NVARCHAR);

    -- Si el precio es mayor que 1000, salir del bucle
    IF @ProductPrice > 1000
    BEGIN
        PRINT 'Producto con precio mayor a 1000 encontrado. Rompiendo el bucle.';
        BREAK;
    END

    -- Incrementar el contador
    SET @Contador = @Contador + 1;
END
