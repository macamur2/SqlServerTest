/*La función DENSE_RANK() es similar a RANK, pero con una diferencia, NO se saltan los número de rango cuando hay filas con valores iguales.
Esto significa que siempre se asignan valores aunque haya empates, por ejemplo: Si varias filas tienen el mismo valor, comparten el mismo rango, 
y el siguiente rango continúa sin saltarse números.*/

 SELECT
    BusinessEntityID,
    TerritoryID,
    SalesYTD,
    DENSE_RANK() OVER (PARTITION BY TerritoryID ORDER BY SalesYTD DESC) AS SalesRank
FROM 
    Sales.SalesPerson
WHERE 
    SalesYTD IS NOT NULL AND TerritoryID IS NOT NULL
ORDER BY 
    TerritoryID, SalesRank;