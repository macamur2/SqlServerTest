/*
Full Text Search es una característica de SQL Server que permite realizar búsquedas avanzadas de texto dentro de columans de texto (VARCHAR, NVARCHAR, TEXT) 
de manera más eficiente que con las consultas tradicionales con LIKE. Con FTS pueden buscarse palabras o frases completos, términos cercanos...

Para habilitarlo en AdventureWorks, vamos a utilizar la tabla Production.ProductionDescription, que almacena las descripciones de los productos.
Pasos a realizar:
   1. Crear el índice de texto completo (Puede realizarse también creando un catálogo de texto completo, 
        si no lo creamos nosotros, se asigna automáticamente el catálogo predeterminado)
   2. Realizar búsquedas usando CONTAINS, FREETEXT, CONTAINSTABLE y FREETEXTTABLE
   3. Comparar tiempos de ejecución
*/
/*Para la medidión del tiempo se utiliza el comando SET STATISTICS TIME ON; 
Éste mostrará en la vetnana de mensajes del MAnagement Studio o del Azure Data Studio el tiempo después de ejecutar la consulta.
Ej: 
    Tiempo de análisis y compilación de SQL Server: 
    Tiempo de CPU = 0 ms, tiempo transcurrido = 0 ms.
*/


-- Verificar si FTS está habilitado (1 = True) #Se ha tenido que instalar FTS en la instancia de SQL
SELECT FULLTEXTSERVICEPROPERTY('IsFullTextInstalled') AS FullTextInstalled;

-- Crear índice de texto completo sobre la columna Description en la tabla Production.ProductDescription (LANGUAGE utiliza códigos LocaleId. Cod. 1033 => English)
CREATE FULLTEXT INDEX ON Production.ProductDescription (Description LANGUAGE 1033)
KEY INDEX PK_ProductDescription_ProductDescriptionID;

-- Realizar búsquedas con CONTAINS 
-- (Más eficiente que usar LIKE si el índice está configurado correctamente)
SET STATISTICS TIME ON;
SELECT ProductDescriptionID, [Description]
FROM Production.ProductDescription
WHERE CONTAINS([Description], 'steel')

/*Realizar búsquedas con FREETEXT 
(Utilizado para realizar búsquedas basadas en el significado semántico de las palabras, Busca sinónimos o términos relacionados)

Tiempo de análisis y compilación de SQL Server: 
   Tiempo de CPU = 0 ms, tiempo transcurrido = 0 ms.

 Tiempos de ejecución de SQL Server:
   Tiempo de CPU = 0 ms, tiempo transcurrido = 0 ms.
(16 rows affected)
*/
SET STATISTICS TIME ON;
SELECT ProductDescriptionID, [Description]
FROM Production.ProductDescription
WHERE FREETEXT(Description, 'performance')

/* ## Realizar búsquedas con CONTAINSTABLE ##
(Retorna una tabla temporal con la relevancia de cada coincidencia. Útil si quieres ordenar los resultados según la improtancia de las palabras clave)
Tiempo de análisis y compilación de SQL Server: 
   Tiempo de CPU = 2 ms, tiempo transcurrido = 22 ms.

 Tiempos de ejecución de SQL Server:
   Tiempo de CPU = 0 ms, tiempo transcurrido = 0 ms.
(5 rows affected)
*/

SET STATISTICS TIME ON;
SELECT  pd.ProductDescriptionID, pd.[Description], ct.RANK
FROM CONTAINSTABLE(Production.ProductDescription, Description, 'technology') ct
JOIN Production.ProductDescription pd
    ON pd.ProductDescriptionID = ct.[KEY]
    ORDER BY ct.RANK DESC

/*
## Realizar búsquedas con FREETEXTTABLE ##
(Retorna resultados con un ranking de relevancia, basándose en búsqueda semántica)

Tiempo de análisis y compilación de SQL Server: 
   Tiempo de CPU = 1 ms, tiempo transcurrido = 2 ms.

 Tiempos de ejecución de SQL Server:
   Tiempo de CPU = 0 ms, tiempo transcurrido = 0 ms.
(22 rows affected)
*/

SET STATISTICS TIME ON;
SELECT pd.ProductDescriptionID, pd.Description, ft.RANK
FROM FREETEXTTABLE(Production.ProductDescription, Description, 'high performance') ft
JOIN Production.ProductDescription pd
    ON pd.ProductDescriptionID = ft.[KEY]
ORDER BY ft.RANK DESC