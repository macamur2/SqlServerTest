/*
Si ponemos como ejemplo creando una jerarquí fictícia basada en la posición de los empleados. 
Suponiendo que el título 'Manager' está por encima supervisando a otro como 'Senior'.
*/

WITH JobHierarchy AS (
-- Case base: Inicio con empleados con título 'Manager'
SELECT  BusinessEntityID,
JobTitle,
1 AS LEVEL
FROM HumanResources.Employee
WHERE JobTitle LIKE '%Manager%' -- Gerentes

UNION ALL

--Caso recursivo: Busca empleados supervisados por superiores
SELECT
    e.BusinessEntityID,
    E.JobTitle,
    jh.Level + 1 AS [Level]
FROM HumanResources.Employee e
JOIN JobHierarchy jh
    ON e.JobTitle LIKE '%Senior%' 
    AND jh.JobTitle LIKE '%Manager%'
)
SELECT
[Level],
BusinessEntityID,
JobTitle
FROM JobHierarchy
ORDER BY Level, BusinessEntityID