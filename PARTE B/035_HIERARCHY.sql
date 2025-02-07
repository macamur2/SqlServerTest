/*
   Priemro hay que saber que HierarchyId es un tipo de dato en SQL Server que ayuda a representar dato de tipo: 
      - Jerárquico
         a) Estructuras de organización
         b) Categorías de productos
         c) Árboles genealógicos.

Para entenderlo mejor:

Tenemos una estructura jerárquica de empleados en una empresa:
   - CEO 
   - Gerentes
   - Empleados

HierarchyId pemrite almacenar las posiciones jerárquicas de cada persona en esta estructura sin necesidad de usar varias tablas o complicadas relaciones

Por ejemplo:
   - Raíz: el CEO estaría en el nivel más alto, represento por ejemplo con un valor como /.
   - Subordinados: empleados de nivel inferior representados como /1/, o /1/1/...


En el ejemplo vamos a crear una jerarquía de empleados utilizando uan nueva tabla (EmployeeHierarchy)

    - EmployeeID => Identificador único del empleado
    - EmployeeName => Nombre del empleado
    - PositionTitle => Cargo del empleado
    - ManagerHierarchy => Indica la posición jerárquica en la organización

*/

CREATE TABLE HumanResources.EmployeeHierarchy (
    EmployeeID INT PRIMARY KEY,         
    EmployeeName NVARCHAR(100) NOT NULL, 
    PositionTitle NVARCHAR(100),         
    ManagerHierarchy HIERARCHYID                         
);

--INSERTAMOS DATOS EN LA TABLA
-- Primero establecemos el ROOT. *Utilizamos también la sentencia GetDescendant para poder asignar los valores  directamente por debajo.

DECLARE @Root HIERARCHYID = HIERARCHYID::GetRoot();  -- Raíz de la jerarquía

INSERT INTO HumanResources.EmployeeHierarchy (EmployeeID, EmployeeName, PositionTitle, ManagerHierarchy)
VALUES (1, 'Manuel Campo', 'CEO', @Root);

-- Insertamos gerentes bajo el CEO
DECLARE @CEOHierarchy HIERARCHYID = (SELECT ManagerHierarchy FROM HumanResources.EmployeeHierarchy WHERE EmployeeID = 1);

INSERT INTO HumanResources.EmployeeHierarchy (EmployeeID, EmployeeName, PositionTitle, ManagerHierarchy)
VALUES (2, 'Miguel Saras', 'Gerente de Ventas', @CEOHierarchy.GetDescendant(NULL, NULL));

INSERT INTO HumanResources.EmployeeHierarchy (EmployeeID, EmployeeName, PositionTitle, ManagerHierarchy)
VALUES (3, 'Antonio Cambrills', 'Gerente de IT', @CEOHierarchy.GetDescendant(NULL, NULL));

-- Insertamos empleados bajo el gerente de ventas
DECLARE @SalesManagerHierarchy HIERARCHYID = (SELECT ManagerHierarchy FROM HumanResources.EmployeeHierarchy WHERE EmployeeID = 2);

INSERT INTO HumanResources.EmployeeHierarchy (EmployeeID, EmployeeName, PositionTitle, ManagerHierarchy)
VALUES (4, 'Carlos Pérez', 'Ejecutivo de Ventas', @SalesManagerHierarchy.GetDescendant(NULL, NULL));

INSERT INTO HumanResources.EmployeeHierarchy (EmployeeID, EmployeeName, PositionTitle, ManagerHierarchy)
VALUES (5, 'Juan López', 'Ejecutivo de Ventas', @SalesManagerHierarchy.GetDescendant(NULL, NULL));

SELECT 
    EmployeeID, 
    EmployeeName, 
    PositionTitle, 
    ManagerHierarchy.ToString() AS HierarchyPath,
    ManagerHierarchy.GetLevel() AS HierarchyLevel
FROM HumanResources.EmployeeHierarchy
ORDER BY ManagerHierarchy;


-- Para saber el nodo padre de un nodo determinado, se utiliza la sentencia GetAncestor(XXX), siendo XXX el núm de niveles que queremos ascender en la jerarquía.
-- Muestro el resultado en la columna ParentHierarchyPath

SELECT 
    EmployeeID, 
    EmployeeName, 
    PositionTitle, 
    ManagerHierarchy.ToString() AS HierarchyPath,
    ManagerHierarchy.GetAncestor(1).ToString() AS ParentHierarchyPath
FROM HumanResources.EmployeeHierarchy
ORDER BY ManagerHierarchy;