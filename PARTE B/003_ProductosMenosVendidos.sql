-- Suma la cantidad total de los productos actuales y archivados agrupados por producto y ordenados de mayor a menor
  SELECT 
    ProductID,
    ProductName,
    ProductNumber,
    SUM(Quantity) AS [QuantityTotal]
  FROM 
  ( 
  SELECT 
    trh.ProductID,
    pro.Name AS [ProductName],
    pro.ProductNumber,
    trh.Quantity
  FROM 
    Production.TransactionHistory trh
  JOIN Production.Product pro ON pro.ProductID = trh.ProductID   
    UNION ALL
  SELECT
    tra.ProductID,
    pro.Name AS [ProductName],
    pro.ProductNumber,
    tra.Quantity
    FROM 
    Production.TransactionHistoryArchive tra
JOIN Production.Product pro ON pro.ProductID = tra.ProductID   
  ) AS CombinedData
    GROUP BY ProductID, ProductName, ProductNumber
    ORDER BY QuantityTotal DESC
