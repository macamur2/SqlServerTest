/* ## PIVOT ##
   La sentencia PIVOT se utiliza para convertir filas en columnas.
   Es útil para reorganizar y resumir datos en tablas cuando necesitas agrupar datos y mostrarlos en un formato más comprensible o tabular.
   Es una buena manera de crear reportes resumidos

    Sintaxis básica:
        SELECT columnas_fijas, [nueva_columna1], [nueva_columna2], ...
        FROM (
            SELECT columnas_fijas, columna_para_valores, columna_para_encabezados
            FROM tabla
        ) AS alias_tabla
        PIVOT (
            función_agregada(columna_para_valores)
            FOR columna_para_encabezados IN ([nueva_columna1], [nueva_columna2], ...)
        ) AS alias_pivot
*/
-- Ejemplo PIVOT: Ventas por producto y año

-- Tabla original
    SELECT sod.ProductID, YEAR(soh.OrderDate) AS OrderYear, sod.LineTotal
    FROM Sales.SalesOrderDetail sod
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID;

-- Resultado con PIVOT
SELECT ProductID, [2011] AS Sales2011, [2012] AS Sales2012
FROM (
    SELECT sod.ProductID, YEAR(soh.OrderDate) AS OrderYear, sod.LineTotal
    FROM Sales.SalesOrderDetail sod
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    ) AS src
    PIVOT(SUM(LineTotal) FOR OrderYear IN ([2011], [2012])) as pvt

/* ## UNPIVOT ##
   2- La sentencia UNPIVOT  es lo contrario a PIVOT. Convierte columnas en filas, reorganizxando los datos para que cada valor de columna se transforme en una fila.
   Es una buena manera de Normalizar tablas.

   Sintaxis básica:
   SELECT columnas_fijas, nueva_columna, nueva_columna_valor
    FROM tabla
    UNPIVOT (
        nueva_columna_valor FOR nueva_columna IN (columna1, columna2, ...)
    ) AS alias_unpivot
*/

--Hacemos uso del ejemplo anterior

WITH SalesSummary AS (
    SELECT ProductID, [2011] AS Sales2011, [2012] AS Sales2012
FROM (
    SELECT sod.ProductID, YEAR(soh.OrderDate) AS OrderYear, sod.LineTotal
    FROM Sales.SalesOrderDetail sod
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    ) AS src
    PIVOT(SUM(LineTotal) FOR OrderYear IN ([2011], [2012])) as pvt
)
SELECT ProductID, OrderYear, Sales
FROM(
    SELECT ProductID, Sales2011, Sales2012
    FROM SalesSummary
) AS src
UNPIVOT(
    Sales FOR OrderYear IN(Sales2011, Sales2012)
) as unpvt