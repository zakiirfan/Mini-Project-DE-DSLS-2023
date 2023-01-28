/* Soal no.1 */
SELECT DATEPART (yyyy,OrderDate) as year, DATEPART (month,OrderDate) as month, COUNT (CustomerID) as jumlah_customer
FROM Orders
WHERE DATEPART (yyyy,OrderDate) = 1997
GROUP BY DATEPART (yyyy,OrderDate), DATEPART (month,OrderDate)

/* Soal no.2 */
SELECT FirstName, LastName
FROM Employees
WHERE Title = 'Sales Representative'

/* Soal no.3 */
SELECT TOP (5) p.ProductName, SUM(od.Quantity) as jml_order
FROM [Order Details] as od
JOIN Products as p
	on od.ProductID = p.ProductID 
JOIN Orders as o 
	on od.OrderID = o.OrderID
WHERE DATEPART (yy,o.OrderDate) = 1997 and DATEPART (month,o.OrderDate) = 1
GROUP BY p.ProductName
ORDER BY jml_order DESC

/* Soal no.4 */
SELECT c.CompanyName
FROM Orders as o
JOIN Customers as c
	on o.CustomerID = c.CustomerID
JOIN [Order Details] as od
	on o.OrderID = od.OrderID
JOIN Products as p
	on od.ProductID= p.ProductID
WHERE DATEPART (yy,o.OrderDate) = 1997 
	and DATEPART (month,o.OrderDate) = 6
	and p.ProductName = 'Chai'


/* Soal no.5 */
SELECT COUNT(OrderID) as order_count, 'category' = 
	CASE	
		WHEN UnitPrice*Quantity <= 100 THEN 'x<=100'
		WHEN UnitPrice*Quantity > 100 AND UnitPrice*Quantity <250 THEN '100<x<250'
		WHEN UnitPrice*Quantity > 250 AND UnitPrice*Quantity <500 THEN '250<x<500'
		ELSE 'x>500'
	END
FROM [Order Details]
GROUP BY 
	CASE	
		WHEN UnitPrice*Quantity <= 100 THEN 'x<=100'
		WHEN UnitPrice*Quantity > 100 AND UnitPrice*Quantity <250 THEN '100<x<250'
		WHEN UnitPrice*Quantity > 250 AND UnitPrice*Quantity <500 THEN '250<x<500'
		ELSE 'x>500'
	END
ORDER BY order_count DESC


/* Soal no.6 */
SELECT DISTINCT (c.CompanyName)
FROM Orders as o
JOIN Customers as c
	on o.CustomerID = c.CustomerID
JOIN [Order Details] as od
	on o.OrderID = od.OrderID
WHERE od.UnitPrice*od.Quantity >500 and DATEPART (yy,o.OrderDate) = 1997
GROUP BY c.CompanyName


/* Soal no.7 */
WITH rkn as (
	SELECT p.ProductName, SUM(od.Quantity) as sales, DATEPART(month,o.OrderDate) as bulan,
	ROW_NUMBER() OVER (PARTITION BY DATEPART(month,o.OrderDate) ORDER BY SUM (od.Quantity) DESC ) as ranking
	FROM [Order Details] as od
	JOIN Products as p
		on od.ProductID = p.ProductID 
	JOIN Orders as o 
		on od.OrderID = o.OrderID
	WHERE DATEPART (yy,o.OrderDate) = 1997
	GROUP BY p.ProductName, od.Quantity, DATEPART(month,o.OrderDate)
	)
SELECT ProductName, sales, bulan, ranking
FROM rkn
WHERE ranking <=5


/* Soal no.8 */
CREATE VIEW view_order_detail AS
SELECT od.OrderID, od.ProductID,p.ProductName, od.UnitPrice, od.Quantity, od.Discount,
	   od.UnitPrice - od.Discount as discounted_price,
	    od.UnitPrice*od.Quantity as total_price,
	   (od.UnitPrice*od.Quantity) - (od.UnitPrice*od.Quantity*od.Discount)  as total_discounted_price
FROM [Order Details] as od
JOIN Products as p
	on od.ProductID = p.ProductID 
JOIN Orders as o 
	on od.OrderID = o.OrderID


/* Soal no.9 */
USE [Northwind]
GO
/****** Object:  StoredProcedure [dbo].[Invoice]    Script Date: 21/01/2023 19:11:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Invoice]
@CustomerID nchar(5) 
AS
SELECT c.CustomerID, c.CompanyName, o.OrderID, o.OrderDate, o.RequiredDate, o.ShippedDate 
FROM Orders as o
JOIN Customers as c
	on c.CustomerID = o.CustomerID
WHERE c.CustomerID = @CustomerID

EXEC Invoice @CustomerID = 'BLAUS'