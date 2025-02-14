/*
	Con TABLESAMPLE somos capaces de obtener una muestra de un conjunto de datos de la tabla sin tener que leer toda la tabla
	En qué escenarios es útil:
	   - Cuando solo necesitamos una parte de los datos para hacer pruebas rápidas.
	   - Cuando queremos explorar datos para ver una muestra antes de hacer consultas más grandes.
	   - Si queremos ahorrar tiempo al procesar una gran cantidad de datos.


	En el siguiente ejemplo vamos a mostrar el 20 % de las personas que hay en la "empresa".

	Total registros: 19972
	20% de registros: 3835

*/

SELECT 
    BusinessEntityID, 
    FirstName, 
    LastName
FROM 
    Person.Person
TABLESAMPLE (20 PERCENT);

-- Como ésto retorna el 20% aleatorio de los registros de la tabla, si queremos que siempre retornen los mismos elementos utilizamos la sentencia REPEATABLE(XXX),
-- siendo XXX la 'semilla' o 'seed'. Si modificamos dicha 'semilla' la muestra de datos obtenido cambia.


SELECT 
    BusinessEntityID, 
    FirstName, 
    LastName
FROM 
    Person.Person
TABLESAMPLE (20 PERCENT) REPEATABLE(111);


