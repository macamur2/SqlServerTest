SELECT 
    per.FirstName,
    per.LastName,
    dep.Name AS [DepartmentName]
FROM HumanResources.Employee emp
JOIN Person.Person per
    ON emp.BusinessEntityID = per.BusinessEntityID
JOIN HumanResources.EmployeeDepartmentHistory edh 
    ON emp.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department dep 
    ON edh.DepartmentID = dep.DepartmentID
WHERE edh.DepartmentID IN (
    SELECT DepartmentID
    FROM HumanResources.EmployeeDepartmentHistory
    GROUP BY DepartmentID
    HAVING COUNT(BusinessEntityID) > 5
)
ORDER BY dep.Name, per.LastName, per.FirstName;