/* INNER JOIN - Devuelve solo los registros que tienen coincidencias en ambas tablas.
   - Obtener los empleados y sus departamentos
*/

SELECT e.BusinessEntityID, e.JobTitle, d.Name AS Department
FROM HumanResources.Employee e
INNER JOIN HumanResources.EmployeeDepartmentHistory edh
    ON e.BusinessEntityID = edh.BusinessEntityID
INNER JOIN HumanResources.Department d
    ON edh.DepartmentID = d.DepartmentID;

/* LEFT JOIN - Devuelve todos los registros de la tabla izquierda y solo las coincidencias de la derecha.
   - Obtener todos los empleados, incluso si no tienen departamento.
*/

SELECT e.BusinessEntityID, e.JobTitle, d.Name AS Department
FROM HumanResources.Employee e
LEFT JOIN HumanResources.EmployeeDepartmentHistory edh
    ON e.BusinessEntityID = edh.BusinessEntityID
LEFT JOIN HumanResources.Department d
    ON edh.DepartmentID = d.DepartmentID;


/* RIGHT JOIN - Devuelve todos los registros de la tabla derecha y solo las coincidencias de la izquierda.
   - Obtener todos los departamentos, incluso si no tienen empleados asignados.
*/

SELECT e.BusinessEntityID, e.JobTitle, d.Name AS Department
FROM HumanResources.Employee e
RIGHT JOIN HumanResources.EmployeeDepartmentHistory edh
    ON e.BusinessEntityID = edh.BusinessEntityID
RIGHT JOIN HumanResources.Department d
    ON edh.DepartmentID = d.DepartmentID;

    /* FULL JOIN - Devuelve todos los registros de ambas tablas, con NULL en las filas sin coincidencias.
   -  Obtener todas las combinaciones de empleados y departamentos.
*/

SELECT e.BusinessEntityID, e.JobTitle, d.Name AS Department
FROM HumanResources.Employee e
CROSS JOIN HumanResources.Department d;