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
('01','ABC', N'ABC', NEWID(), 123, 123.45, 500.75, 'TextValue', 1, '2022-01-01', N'UnicodeText', 0x01, '12:34:56', '2022-02-01 14:30:00', 0x01A2B3C4, '<root><element>value</element></root>'),
('02', 'XYZ', N'XYZ', NEWID(), 456, 789.12, 1000.99, 'AnotherText', 0, '2022-02-15', N'UnicodeData', 0x02, '18:45:30', '2022-02-28 09:15:00', 0x02A1B2C3, '<root><element>data</element></root>'),
('03', 'PQR', N'PQR', NEWID(), 789, 456.78, 999.99, 'TextString', 1, '2022-03-10', N'UnicodeString', 0x03, '21:00:15', '2022-03-20 18:00:00', 0x03A3B4C5, '<root><element>content</element></root>')



/*Copia la tabla 'Test' desde la base de datos smcdb1 a smcdb2. 
(Esta consulta selecciona todos los datos de la tabla de origen y los inserta en una nueva tabla en la base de datos de destino. 
La nueva tabla en la base de datos de destino se crea automáticamente con la misma estructura que la tabla de origen.
Hay que tener en cuenta que este método copia solo los datos, no otros elementos como índices, claves primarias, restricciones, etc...)*/
SELECT * INTO smcdb2.dbo.Test from smcdb1.dbo.Test


/*Intenta hacer una query usando un join sobre de la tabla smcdb1.dbo.Test hacia la otra base de datos
smcdb2.dbo.Test has creado previamente Acuérdate que el collation es diferente en ambas bases de datos.

(Utilizar collations diferentes puede afectar al rendimiento de las consultas)*/
SELECT * 
FROM smcdb1.dbo.Test t1
INNER JOIN smcdb2.dbo.Test t2 ON 
    t1.Code COLLATE DATABASE_DEFAULT = t2.Code COLLATE DATABASE_DEFAULT;

SELECT *
FROM smcdb1.dbo.Test t1
INNER JOIN smcdb2.dbo.Test t2 ON 
    t1.Code COLLATE Latin1_General_CS_AS = t2.Code COLLATE Latin1_General_CS_AS;


IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Sales')
BEGIN
    EXEC('CREATE SCHEMA Sales');
END

-- Crear la tabla Countries
CREATE TABLE Countries (
    CountryId INT PRIMARY KEY IDENTITY,
    CountryName NVARCHAR(100) NOT NULL
)

-- Crear la tabla Address
CREATE TABLE Address (
    AddressId INT PRIMARY KEY IDENTITY,
    Street NVARCHAR(255) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    StateProvince NVARCHAR(100),
    PostalCode NVARCHAR(20),
    CountryId INT,
    FOREIGN KEY (CountryId) REFERENCES Countries(CountryId)
)

-- Crear tabla Customers
CREATE TABLE Customers (
    CustomerId INT IDENTITY PRIMARY KEY,
    CustomerName NVARCHAR(255) NOT NULL,
    ContactName NVARCHAR(255),
    AddressId INT,
    FOREIGN KEY (AddressId) REFERENCES Address(AddressId)
)

-- Crear tabla Products
CREATE TABLE Products (
    ProductId INT IDENTITY PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
)

-- Crear tabla VatTypes
CREATE TABLE VatTypes (
    VatTypeId INT PRIMARY KEY,
    Description VARCHAR(255) NOT NULL,
    VatRate DECIMAL(5,2) NOT NULL 
)

-- Crear la tabla Sales.InvoicesHeader
CREATE TABLE [Sales.InvoicesHeader] (
    InvoiceId INT PRIMARY KEY IDENTITY,
    InvoiceDate DATETIME NOT NULL,
    CustomerId INT NOT NULL, 
    AddressId INT,
    TaxBase DECIMAL(10, 2) NOT NULL,
    TotalVat DECIMAL(10, 2) NOT NULL,
    Total DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId),
    FOREIGN KEY (AddressId) REFERENCES Address(AddressId)
)

-- Crear la tabla Sales.InvoicesDetail
CREATE TABLE [Sales.InvoicesDetail] (
    InvoiceId   INT             NOT NULL,
    RowNumber   INT             IDENTITY (1, 1) NOT NULL,
    ProductId   INT             NOT NULL,
    Description VARCHAR (255)   NOT NULL,
    Quantity    DECIMAL (18, 4) NOT NULL,
    UnitPrice   DECIMAL (18, 2) NOT NULL,
    Discount    DECIMAL (5, 2)  DEFAULT ((0)) NULL,
    VatTypeId   INT             NULL,
    TotalLine   DECIMAL(18,2)   NOT NULL,

    PRIMARY KEY CLUSTERED (InvoiceId ASC, RowNumber ASC),
    FOREIGN KEY (InvoiceId) REFERENCES [Sales.InvoicesHeader] (InvoiceId),
    FOREIGN KEY (VatTypeId) REFERENCES dbo.VatTypes (VatTypeId),
    FOREIGN KEY (ProductId) REFERENCES dbo.Products (ProductId)
)


/*Create triggers*/


CREATE TRIGGER trg_UpdateInvoiceTotal
ON [Sales.InvoicesDetail]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE h
    SET h.Total = (SELECT SUM(TotalLine) FROM [Sales.InvoicesDetail] WHERE InvoiceId = h.InvoiceId)
    FROM [Sales.InvoicesHeader] h
END;

ALTER TABLE [Sales.InvoicesDetail] ENABLE TRIGGER [trg_UpdateInvoiceTotal]

CREATE TRIGGER trg_UpdateTotalLineWithVAT
ON [Sales.InvoicesDetail]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [Sales.InvoicesDetail]
    SET TotalLine = inserted.Quantity * inserted.UnitPrice * (1 - inserted.Discount / 100) * (1 + VatTypes.VatRate / 100)
    FROM inserted
    INNER JOIN [Sales.InvoicesDetail] ON [Sales.InvoicesDetail].InvoiceId = inserted.InvoiceId AND [Sales.InvoicesDetail].RowNumber = inserted.RowNumber
    INNER JOIN VatTypes ON [Sales.InvoicesDetail].VatTypeId = VatTypes.VatTypeId;
END;

ALTER TABLE [Sales.InvoicesDetail] ENABLE TRIGGER [trg_UpdateTotalLineWithVAT];



/*BULK INSERT*/

SET IDENTITY_INSERT dbo.Address OFF
SET IDENTITY_INSERT dbo.Countries OFF
SET IDENTITY_INSERT dbo.Customers OFF
SET IDENTITY_INSERT dbo.Products OFF
SET IDENTITY_INSERT [Sales.InvoicesDetail] OFF
SET IDENTITY_INSERT [Sales.InvoicesHeader] OFF


BULK INSERT dbo.Countries
FROM '\tmp\Countries.csv'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2           
);

BULK INSERT dbo.Address
FROM '\tmp\Address.csv'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2           
);
BULK INSERT dbo.Customers
FROM '\tmp\Customers.csv'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2           
);
BULK INSERT dbo.Products
FROM '\tmp\Products.csv'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2           
);

BULK INSERT dbo.VatTypes
FROM '\tmp\VatTypes.csv'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2           
);

BULK INSERT [Sales.InvoicesHeader]
FROM '\tmp\InvoicesHeader.csv'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2           
);

BULK INSERT [Sales.InvoicesDetail]
FROM '\tmp\InvoicesDetail.csv'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2           
);

SET IDENTITY_INSERT Address ON
SET IDENTITY_INSERT Countries ON
SET IDENTITY_INSERT Customers ON
SET IDENTITY_INSERT Products ON
SET IDENTITY_INSERT Sales.InvoicesDetail ON
SET IDENTITY_INSERT Sales.InvoicesHeader ON

/*Consulta*/

ALTER TABLE [Sales.InvoicesHeader]
ADD InvoiceType CHAR(10) DEFAULT 'Invoice'


UPDATE [Sales.InvoicesHeader]
SET InvoiceType = 'Received'
WHERE [Sales.InvoicesHeader].InvoiceDate < '2023-03-03'



SELECT 
    inh.InvoiceType as Type,
    YEAR(inh.InvoiceDate) as Year,
    SUM(inh.Total) as TotalInvoices,
    SUM(ind.TotalLine * vty.VatRate) as TotalVat,
    SUM(ind.Quantity) as Quantity,
    AVG(inh.Total) as AvgTotalInvoice,
    SUM(CASE WHEN (MONTH(inh.invoiceDate) = 1) THEN ind.TotalLine ELSE 0 END) AS January,
    SUM(CASE WHEN (MONTH(inh.invoiceDate) = 2) THEN ind.TotalLine ELSE 0 END) AS Febryary,
    SUM(CASE WHEN (MONTH(inh.invoiceDate) = 3) THEN ind.TotalLine ELSE 0 END) AS March,
    SUM(CASE WHEN (MONTH(inh.invoiceDate) = 4) THEN ind.TotalLine ELSE 0 END) AS April,
    SUM(CASE WHEN (MONTH(inh.invoiceDate) = 5) THEN ind.TotalLine ELSE 0 END) AS May,
    SUM(CASE WHEN (MONTH(inh.invoiceDate) = 6) THEN ind.TotalLine ELSE 0 END) AS June,
    SUM(CASE WHEN (MONTH(inh.invoiceDate) = 7) THEN ind.TotalLine ELSE 0 END) AS July,
    SUM(CASE WHEN (MONTH(inh.invoiceDate) = 8) THEN ind.TotalLine ELSE 0 END) AS August,
    SUM(CASE WHEN (MONTH(inh.invoiceDate) = 9) THEN ind.TotalLine ELSE 0 END) AS September,
    SUM(CASE WHEN (MONTH(inh.invoiceDate) = 10) THEN ind.TotalLine ELSE 0 END) AS October,
    SUM(CASE WHEN (MONTH(inh.invoiceDate) = 11) THEN ind.TotalLine ELSE 0 END) AS November,
    SUM(CASE WHEN (MONTH(inh.invoiceDate) = 12) THEN ind.TotalLine ELSE 0 END) AS December,
    STDEV(ind.TotalLine) as StedevTotalInvoice
FROM [Sales.InvoicesHeader] inh
    INNER JOIN [Sales.InvoicesDetail] ind ON ind.InvoiceId = inh.InvoiceId
    INNER JOIN dbo.VatTypes vty ON ind.VatTypeId = vty.VatTypeId
GROUP BY  inh.InvoiceType, YEAR(inh.InvoiceDate)



SELECT TOP 5 
    cus.CustomerId, 
    cus.CustomerName, 
    SUM(ind.TotalLine) 
FROM [Sales.InvoicesDetail] ind 
    INNER JOIN [Sales.InvoicesHeader] inh ON inh.InvoiceId = ind.InvoiceId 
    INNER JOIN [Customers] cus ON cus.CustomerId = inh.CustomerId 
GROUP BY cus.CustomerId, cus.CustomerName


SELECT
    cou.CountryName,
    SUM(ind.TotalLine) Total
FROM [Sales.InvoicesDetail] ind 
    INNER JOIN [Sales.InvoicesHeader] inh 
        ON inh.InvoiceId = ind.InvoiceId 
            INNER JOIN Customers cus ON cus.CustomerId = inh.CustomerId 
            INNER JOIN Address adr ON adr.AddressId = cus.AddressId
            INNER JOIN Countries cou ON cou.CountryId = adr.CountryId
        GROUP BY cou.CountryId, cou.CountryName
ORDER BY SUM(ind.TotalLine) desc


SELECT 
    SUM(ind.totalLine) Total
FROM [Sales.InvoicesDetail] ind 
    INNER JOIN [Sales.InvoicesHeader] inh 
        ON inh.InvoiceId = ind.InvoiceId
WHERE inh.InvoiceDate BETWEEN DATEADD(MONTH, -3, GETDATE()) AND GETDATE()


ALTER TABLE [dbo].[Sales.InvoicesDetail] DROP CONSTRAINT [FK__Sales.Inv__Invoi__49C3F6B7]
GO



CREATE TRIGGER trg_CheckInvoiceExist
ON [Sales.InvoicesDetail]
AFTER INSERT, UPDATE
AS
BEGIN
    --Decalra una variable para contar el número de registros coincidentes
    DECLARE @invoiceCount INT;

    -- Verificar si el InvoiceId insertado existe en Sales.InvoicesHeader
    SELECT @InvoiceCount = COUNT(*)
    FROM [Sales.[Sales.InvoicesHeader] HASH
    INNER JOIN INSERTED i ON h.InvoiceId = i.InvoiceId

    -- Si el InvoiceId no existe en Sales.InvoicesHeader, lanza un error
    IF @invoiceCount = 0 
    BEGIN
    -- Lanza un error para prevenir la inserción
        THROW 50000, 'No se puede insertar el registro. InvoiceId no existe en Sales.InvoicesHeader.', 16;
    END
END;

CREATE TRIGGER trg_PreventInvoiceHeaderDeletion
ON [Sales.InvoicesHeader]
AFTER DELETE
AS
BEGIN
    -- Declara una variable para contar el número de registros referenciados
    DECLARE @referencedCount INT;

    -- Verifica si los InvoiceId eliminados están siendo referenciados por InvoicesDetail
    SELECT @referencedCount = COUNT(*)
    FROM Sales.InvoicesDetail d
    INNER JOIN DELETED h ON d.InvoiceId = h.InvoiceId;

    -- Si hay registros en InvoicesDetail que referencian los InvoiceId eliminados, lanza un error
    IF @referencedCount > 0
    BEGIN
        -- Lanza un error para prevenir la eliminación
        THROW 50000, 'No se puede eliminar InvoiceHeader. Existen registros en InvoicesDetail que lo referencian.', 16;
    END
END;



ALTER TABLE [Sales.InvoicesHeader] 
    ADD TotalCalculated AS (TaxBase + TotalVat);

SELECT * FROM [Sales.InvoicesHeader];