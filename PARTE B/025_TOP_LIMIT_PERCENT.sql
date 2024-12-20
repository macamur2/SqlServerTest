/*La sentencia TOP se utiliza para devolver una cantidad específica de filas*/

SELECT TOP 5 ProductID, Name, ListPrice
FROM Production.Product


/*La sentencia TOP / PERCENT devuelve un porcentaje específico de filas del total de filas resultado
Ej. Retornar el 10% de los productos del total*/

SELECT TOP 10 PERCENT ProductID, Name, ListPrice
FROM Production.Product

/* SQL Server no utiliza LIMIT, ya que LIMIT es una sintaxis específica de otros sistemas (MySQL,PostgreSQL), igual que ha pasado con otros ejercicios, 
puede utilizarse una mezcla de OFFSET y FETCH NEXT para utilizar algo similar a LIMIT*/