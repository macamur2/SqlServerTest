/*Las funciones SCOPTE_IDENTITY(), IDENTITY(), @@IDENTITY e IDENT_CURRENT() sirven para trabajar con valores de columnas autoincrementales.
Procedo a explicar que hace cada uno.

SCOPE IDENTITY()
   - Devuelve el último valor de identidad generado dentro de la misma sesión/ámbito
   (por ejemplo dentro del mismo procedimiento almacenado o bloque de código)
   
   Ejemplo: Insertar un nuevo departamento a la tabla HumanResources.Department y obtener el ID generado
      - LastGeneratedID = 17*/

INSERT INTO HumanResources.Department (Name, GroupName, ModifiedDate)
VALUES ('TeamLeader', 'Engineering', GETDATE());

SELECT SCOPE_IDENTITY() AS LastGeneratedID;

/*
@@IDENTITY
   - Devuelve el último valor de identidad generado en la misma sesión, incluso si ha sido fuera del ámbito de ejecución
    (Por ejemplo, si un trigger hace alguna inserción adicional)
    
    Haciendo uso del siguietne comando, obtendremos el mismo valor que el anterior, pero si hubiera un trigger que generase entradas en otra tabla, retornaría ese ID.*/
    
    SELECT @@IDENTITY AS LastGeneratedID;


/*IDENT_CURRENT('XXXX')
      
         - Consulta el último ID generado en una tabla específica. No importa quien lo generó o cuando.*/

SELECT IDENT_CURRENT('HumanResources.Department') AS LastGeneratedID;


/*IDENTITY()

   - Realmente es una configuración que le dice a SQL Server que se utiliza para que una columna genere número automáticamente.
   Sirve por ejemplo para crear tablas donde los IDs se generan solos sin que tengamos que preocuparnos por asignarlos.
   
   Por ejemplo, configurar una columna "ID" para que se autogenere. Cada vez que agregue una nueva entrada, esa columna se creará con un número nuevo.
   En el siguiente ejemplo voy a crear una tabla nueva con un campo autoincremental marcada como IDENTITY empezando por 1 y aumentando por 1*/

   CREATE TABLE Person.FundanetPerson (
    ID INT IDENTITY(1,1),
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50)
);

INSERT INTO Person.FundanetPerson (FirstName, LastName)
VALUES ('Manuel', 'Campo'),
       ('Miguel', 'Saras');

SELECT * FROM Person.FundanetPerson;
DROP TABLE Person.FundanetPerson;
    