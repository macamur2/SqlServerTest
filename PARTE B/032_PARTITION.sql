/*
Lo primero es entender que es el particionado de tablas. 
El particionado de tablas permite dividir una tabla grande en partes más pequeñas (particiones), sin que el usuario note la diferencia al consultar datos.
Se usa principalmente para mejorar el rendimiento y hacer más fácil la administración de bases de datos con muchos registros.

Los objetivos del particionado incluyen, consultas más rápidas, mejor administración y más eficiencia.

Para su definición primero tenemos que definir el esquema de particion.
Haciendo uso del ejemplo anterior vamos a particionar la tabla GameReleases de acuerdo a la fecha de lanzamiento de los juegos. 
Normalmente los lanzamientos más antiguos se suelen consultar menos.
*/

-- Primero, creamos la función de partición. Ésta utilizará la columna ReleaseDate. Crearemos particiones para los años 2020, 2021, 2022 y 2023
CREATE PARTITION FUNCTION ReleaseYearPartitionFunction (DATE)
AS RANGE RIGHT FOR VALUES ('2020-01-01', '2021-01-01', '2022-01-01', '2023-01-01');

--Segundo, creamos el esquema de partición. Así asignamos las particiones a un almacenamiento específico. (PRIMARY) *Pendiente más información por parte de Pedro

CREATE PARTITION SCHEME ReleaseYearPartitionScheme
AS PARTITION ReleaseYearPartitionFunction
TO ([PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY]);

-- Por último, creamos la tabla y aplicamos el particionado en la columna ReleaseDate:
CREATE TABLE Production.GameReleasesPartitioned (
    GameID INT NOT NULL,
    GameName NVARCHAR(100) NOT NULL,
    PlatformID INT NOT NULL,
    PlatformName NVARCHAR(50) NOT NULL,
    ReleaseDate DATE NOT NULL, 
    CONSTRAINT PK_GameReleasesPartitioned PRIMARY KEY (GameID, PlatformID, PlatformName, ReleaseDate)
)
ON ReleaseYearPartitionScheme (ReleaseDate); 

--Ahora, cuando se inserten datos, SQL Server auomáticamente colocará los datos en la partición correspondiente según el año. 
INSERT INTO Production.GameReleasesPartitioned (GameID, GameName, PlatformID, PlatformName, ReleaseDate)
VALUES
(1, 'Call of Duty', 1, 'PC', '2023-11-01'),
(1, 'Call of Duty', 2, 'Xbox', '2023-11-01'),
(2, 'FIFA 22', 3, 'PlayStation', '2021-09-30'),
(3, 'Minecraft', 1, 'PC', '2023-01-01');