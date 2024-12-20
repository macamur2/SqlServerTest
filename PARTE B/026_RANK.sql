/*La función RANK() en SQL Server se utiliza para asignar una posición o "rango" a cada fila de una consulta.
 Si hay filas con valores iguales, comparten el mismo rango, y el siguiente rango se salta.
 Por ejemplo, podemos tener una lista de vendedores con sus ventas por territorio, y queremos clasificarlos de mayor a menor según el total vendido. 
 Asignamos un valor numérico como valor en la clasificación*/

 SELECT
    BusinessEntityID,
    TerritoryID,
    SalesYTD,
    RANK() OVER (PARTITION BY TerritoryID ORDER BY SalesYTD DESC) AS SalesRank
FROM 
    Sales.SalesPerson
WHERE 
    SalesYTD IS NOT NULL AND TerritoryID IS NOT NULL
ORDER BY 
    TerritoryID, SalesRank;