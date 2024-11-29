/*
En SQL Server, podemos controlar el uso de un índice en una consulta y forzar el uso de un índice específico con la sentencia (WITH (INDEX))
Esto puede ser útil en varias situaciones:
   - Cuando el optimizador no elige el índice más eficiente.  
   (El optimizador decide cómo SQL Server debe ejecutar una consulta dada, eligiendo el mejor plan de acceso a datos para minimizar el tiempo de ejecución.
   No podemos controlar directamente el optimizador.)
   - Si tenemos índices compuestos o específicos, el optimizador a veces no elige el índice adecuado.
   - Consultas con un patrón de búsqueda específico, podemos forzar el uso de un índice específico.
   - Simplemente forzamos el uso de un índice específico que puede mejorar el rendimiento.

La sintaxis base es:
    SELECT columnas
    FROM tabla
    WITH (INDEX (indice_que_queramos))
    WHERE condiciones;
*/

-- Para el ejemplo, utilizaremos la tabla Sales.SalesOrderHeader. Trabajaremos con los índices no clusterizados que existen en CustomerID y SalesPersonID
-- Consulta sin forzar el uso de un índice específico. Al visualizar el plan de ejecución, se demuestra que el optimizar hace uso de XXXXXX
SELECT SalesOrderID, CustomerID, SalesPersonID
FROM Sales.SalesOrderHeader
WHERE CustomerID > 10;

SELECT SalesOrderID, CustomerID, SalesPersonID
FROM Sales.SalesOrderHeader
WITH(INDEX(IX_SalesOrderHeader_CustomerID))
WHERE CustomerID > 10;


