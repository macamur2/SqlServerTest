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

BULK INSERT Sales.InvoicesHeader
FROM '\tmp\InvoicesHeader.csv'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2           
);

BULK INSERT Sales.InvoicesDetail
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