/* Case Study no.1 */
SELECT o.OrderDate, 
		DATEPART(yy,o.OrderDate) as year, 
		DATEPART(mm,o.OrderDate) as month, 
		p.ProductName, 
		cs.CategoryName, 
		s.CompanyName as Supplier, 
		c.CompanyName as Buyer,  
		od.Quantity, 
		(od.UnitPrice*od.Quantity) - (od.UnitPrice*od.Quantity*od.Discount) as total_discounted_price
FROM [Order Details] as od
JOIN Products as p
	on od.ProductID = p.ProductID 
JOIN Orders as o 
	on od.OrderID = o.OrderID
JOIN Suppliers as s
	on s.SupplierID = p.SupplierID
JOIN Categories as cs
	on cs.CategoryID = p.CategoryID
JOIN Customers as c
	on c.CustomerID = o.CustomerID
WHERE ProductName IN (
	SELECT	TOP 5 p.ProductName
	FROM [Order Details] as od
	JOIN Products as p
		on od.ProductID = p.ProductID 
	JOIN Orders as o 
		on od.OrderID = o.OrderID
	GROUP BY p.ProductName
	ORDER BY round(sum((od.UnitPrice*od.Quantity) - (od.UnitPrice*od.Quantity*od.Discount)),2) DESC
						)


/* Case Study no.2*/
SELECT o.OrderDate, 
	   c.CompanyName as Buyer,  
	   sum(od.Quantity) as Quantity, 
	   Round(sum((od.UnitPrice*od.Quantity) - (od.UnitPrice*od.Quantity*od.Discount)),2) as total_discounted_price
FROM [Order Details] as od
JOIN Orders as o 
	on od.OrderID = o.OrderID
JOIN Customers as c
	on c.CustomerID = o.CustomerID
GROUP BY o.OrderDate, c.CompanyName
ORDER BY o.OrderDate



/* Case Study no.3*/
SELECT  e.FirstName, 
		e.LastName, 
		o.OrderDate,
		o.OrderID,
		e.Country,
		c.CompanyName as buyer,
		p.ProductName,
		(od.UnitPrice*od.Quantity) - (od.UnitPrice*od.Quantity*od.Discount) as total_discounted_price
FROM [Order Details] as od
JOIN Products as p
	on od.ProductID = p.ProductID 
JOIN Orders as o 
	on od.OrderID = o.OrderID
JOIN Suppliers as s
	on s.SupplierID = p.SupplierID
JOIN Employees as e
	on e.EmployeeID = o.EmployeeID
JOIN Customers as c
	on c.CustomerID = o.CustomerID
WHERE DATEPART (yy,o.OrderDate) = '1997' AND e.Title = 'Sales Representative'


