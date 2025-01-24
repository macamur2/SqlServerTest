/*
Voy a crear dos tablas:
   - Production.GamePlatforms => Para los tipos de plataformas de juego (PC, XBOX...). Utilizará una clave primaria compuesta (PlatformID y Name)
      * PlatformID 
      * Name
      * Region
   - Production.Games => Para los detalles de cada juego almacenando la relación entre los juegos y su plataforma. Funcionará con claves compuestas. ya que un juego puede estar disponible en varias plataformas
      * GameID
      * GameName
      * PlatformID
      * PlatformName
      * ReleaseDate
*/

CREATE TABLE Production.GamePlatforms (
   PlatformID INT NOT NULL,
   Name NVARCHAR(50) NOT NULL,
   Region NVARCHAR(50) NULL,
   CONSTRAINT PK_GamePlatforms PRIMARY KEY (PlatformID, Name)
)

CREATE TABLE Production.GameReleases (
   GameID INT NOT NULL,
   GameName NVarchar(100) NOT NULL,
   PlatformID INT NOT NULL,
   PlatformName NVARCHAR(50) NOT NULL,
   ReleaseDate DATE NOT NULL,
   CONSTRAINT PK_GameReleases PRIMARY KEY (GameID, PlatformID, PlatformName),
   CONSTRAINT FK_GameReleases_GamePlatforms FOREIGN KEY (PlatformID, PlatformName) REFERENCES Production.GamePlatforms (PlatformID, Name)
)

INSERT INTO Production.GamePlatforms (PlatformID, Name, Region)
VALUES
(1, 'PC', 'Global'),
(2, 'Xbox', 'Global'),
(3, 'PlayStation', 'Global');

INSERT INTO Production.GameReleases (GameID, GameName, PlatformID, PlatformName, ReleaseDate)
VALUES
(1, 'Call of Duty', 1, 'PC', '2023-11-01'), 
(1, 'Call of Duty', 2, 'Xbox', '2023-11-01'), 
(2, 'FIFA 22', 3, 'PlayStation', '2021-09-30'), 
(3, 'Minecraft', 1, 'PC', '2023-01-01'); 