/*
Crea una nueva base de datos llamada ‘smcdb1’. Establece el collation de smcdb1 en
Modern_spanish_ci_a
*/
CREATE DATABASE smcdb1 COLLATE modern_spanish_ci_ai;
SELECT name, collation_name FROM sys.databases WHERE name = 'smcdb1';

/*Dentro de smcdb1, crea una tabla llamada ‘Test’
Dentro de la tabla ‘Test’ crea un campo clave llamado Code de tipo string char(20).*/
CREATE TABLE Test (
	Code char(20) PRIMARY KEY
	);
GO	

/*Crea una segunda base de datos llamada ‘smcdb2’. Establece el collation de smcdb2 en
Latin1_general_cs_as*/
CREATE DATABASE smcdb2 COLLATE Latin1_General_CS_AS;
GO

SELECT name, collation_name FROM sys.databases WHERE name = 'smcdb2';



/*Añade un campo por cada tipo diferente (char, nchar, unique identifier, int, double, money, etc).*/
use smcdb1;

ALTER TABLE Test
ADD charType char(10), 
ncharType nchar(10),
guid UNIQUEIDENTIFIER,
intType INT,
doubleType FLOAT,
moneyType money,
varcharType varchar(20),
boolType BIT,
dateType DATE,
nvarcharType NVARCHAR(20),
imageType IMAGE,
timeType TIME,
datetimeType DATETIME,
binaryType VARBINARY(4),
xmlType XML;

/*Crea algunos datos de prueba en la tabla Test.*/
INSERT INTO Test (Code, charType, ncharType, guid, intType, doubleType, moneyType, varcharType, boolType, dateType, nvarcharType, imageType, timeType, datetimeType, binaryType, xmlType)
VALUES
('01','ABC', N'ABC', NEWID(), 123, 123.45, 500.75, 'TextValue', 1, '2022-01-01', N'UnicodeText', 0x01, '12:34:56', '2022-02-01 14:30:00', 0x01A2B3C4, '<root><element>value</element></root>');

