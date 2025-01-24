/*EL lenguaje DCL (Lenguaje de Control de Datos), es una parte del lenguaje SQL utilizada para el control de PERMISOS y SEGURIDAD en una base de datos.
Por ejemplo, pueden definirse quién tiene acceso a qué recursos y qué operaciones pueden realizarse.
Hay dos operaciones principales: GRANT y REVOKE

Tal y como indican sus nombres, GRANT sirve para otorgar permisos a usuarios o roles. REVOKE, revoca los permisos otorgados previamente.

¿Para qué se utiliza entonces?
   - Gestión de usuarios: Tal y como he comentado anteriormente, se puede utilziar para asignar permisos a usuarios y así puedan realizar acciones específicas en una base de datos.
   - Seguridad: Si se asignan permisos a diversos usuarios, aseguramos la protección de datos, ya que solo las personas autorizadas pueden acceder o modificar dicha información.
   - Auditoría: Pueden configurarse audotrías para rastrear quién tiene permisos sobre qué y quién está ejecutando comandos "sensibles".

   Aunque sus principales comandos son GRANT y REVOKE tal y como he comentado, pueden integrarse con funciones más avanzadas a nivel de seguridad.
      - Se pueden establecer/revocar permisos a nivel de columna, filas, ejecución de funciones o procedimientos almacenados.
      - Se pueden otorgar también permisos para el uso de vistas sin que por ello los usuarios deban tener permisos en las tablas utilizadas por dicha vista.
      - Pueden denegarse permisos explícitos. (Denegar a un usuario que no tenga acceso a un recursoo incluso aunque pertenezca a un rol que sí tiene permiso.)
      - Puede integrarse con Active Directory
      - Habilidad para que otros usuarios puedan otorgar permisos a otros

Para el ejemplo voy a crear un rol llamado "Ventas", voy a otorgarle permisos de INSERT y SELECT en la tabla Sales.SalesOrderHeader
y posteriormente añadiré a un usuario al rol, que heredará dichos permisos.*/

CREATE ROLE Ventas;

GRANT SELECT, INSERT ON Sales.SalesOrderHeader TO Ventas;

EXEC sp_addrolemember 'Ventas', Manuel; -- El usuario debe existir

--Ahora voy a revocar los anteriores permisos al rol creado (SELECT, INSERT, UPDATE, DELETE, EXECUTE)
REVOKE SELECT, INSERT ON Sales.SalesOrderHeader FROM Ventas;

--Añadir permisos al usuario Manuel para ejecutar un procedimiento almacenado (Están ya creados en AdventureWorks2022 "Programmability/Stored Procedures").
GRANT EXECUTE ON dbo.uspGetEmployeeManagers TO Manuel
