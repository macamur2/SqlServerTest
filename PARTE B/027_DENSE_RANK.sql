/*La función NTILE() es una función que ayuda a dividir los datos en partes iguales o 'casi' iguales llamadas "grupos".
Por ejemplo, podemos usarlo para dividir los datos en 4 partes (Cuantiles), 10 partes (deciles), o cualquier número que queramos. Quién está en el top 25% o quién está en el 50%...
Es una buena manera de analizar los datos de forma más organizada.

EN el ejemplo vamos a agrupar a los vendedores en 3 grupos según las ventas totales del año.
Ordenamos también a los vendedores de mayor a menor por el número de ventas totales, quienes más ventas tengan estarán en el grupo 1*/

SELECT 
    BusinessEntityID,
    SalesYTD,
    NTILE(3) OVER (ORDER BY SalesYTD DESC) AS SalesGroup
FROM 
    Sales.SalesPerson
WHERE 
    SalesYTD IS NOT NULL;
