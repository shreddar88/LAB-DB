--LAB 1
--Uppgift 1.1
USE Adventureworks2012;

SELECT ProductId
	, Name
	, Color
	, ListPrice
FROM Production.Product

--Uppgift 1.2
SELECT ProductId
	, Name
	, Color
	, ListPrice 
FROM Production.Product
WHERE ListPrice < 0

--Uppgift 1.3
SELECT ProductId
	, Name
	, Color
	, ListPrice 
FROM Production.Product
WHERE Color IS NULL

--Uppgift 1.4
SELECT ProductId
	, Name
	, Color
	, ListPrice 
FROM Production.Product
WHERE Color IS NOT NULL

--uppgift 1.5
SELECT ProductId
	, Name
	, Color
	, ListPrice 
FROM Production.Product
WHERE Color IS NOT NULL AND ListPrice < 0

--uppgift 1.6
SELECT Name + Color AS 'Name and Color'
FROM Production.Product
WHERE Color IS NOT NULL

--uppgift 1.7
SELECT 'NAME: ' + Name + ' -- ' + 'COLOR: ' + Color AS 'Name and Color'
FROM Production.Product
WHERE Color IS NOT NULL 

--Uppgift 1.8
SELECT ProductId
	, Name
FROM Production.Product 
WHERE ProductID BETWEEN 400 AND 500

--Uppgift 1.9
SELECT ProductId
	, Name
	, Color
FROM Production.Product
WHERE Color = 'Black' OR Color = 'Blue'

--Uppgift 1.10
SELECT Name
	, ListPrice
FROM Production.Product
WHERE Name LIKE 'S%'

--Uppgift 1.11
SELECT Name
	, ListPrice
FROM Production.Product
WHERE Name LIKE 'S%' OR Name LIKE 'A%'

--Uppgift 1.12
SELECT Name
	, ListPrice
FROM Production.Product
WHERE Name LIKE 'SPO[K}%' 

--Uppgift 1.13
SELECT DISTINCT Color
FROM Production.Product
WHERE Color IS NOT NULL

--Uppgift 1.14
SELECT ProductSubcategoryID
	, Color
FROM Production.Product
WHERE Color IS NOT NULL
		AND ProductSubcategoryID IS NOT NULL
ORDER BY ProductSubcategoryID ASC
		, Color DESC

--Uppgift 1.15
SELECT ProductSubCategoryID
	, LEFT([Name],35) AS [Name]
	, Color
	, ListPrice
FROM Production.Product
WHERE Color IN ('Red','Black')
AND ListPrice BETWEEN 1000 AND 2000
AND ProductSubCategoryID = 1
ORDER BY ProductID

--Uppgift 1.16
SELECT Name
	, ISNULL(Color, 'Unknown') AS 'Color'
	, ListPrice
FROM Production.Product

--Uppgift 2.1
SELECT COUNT(*)
FROM Production.Product

--Uppgift 2.2
SELECT COUNT(ProductSubcategoryID)
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL

--Uppgift 2.3
SELECT COUNT(P.ProductSubcategoryID) AS 'NrOfArt'
FROM Production.Product AS P
GROUP BY P.ProductSubcategoryID

--Uppgift 2.4 A
SELECT COUNT(*) - COUNT(ProductSubcategoryID)
FROM Production.Product

--Uppgift 2.4 B
SELECT COUNT(*)
FROM Production.Product AS P
WHERE P.ProductSubcategoryID IS NULL

--Uppgift 2.5
SELECT ProductID
	,	 SUM(Quantity) AS Quantity
FROM Production.ProductInventory
GROUP BY ProductID

--Uppgift 2.6
SELECT ProductID
	,	 SUM(Quantity) AS Quantity
FROM Production.ProductInventory
WHERE LocationID = 40  
GROUP BY ProductID
HAVING SUM(Quantity) < 100

--Uppgift 2.7
SELECT ProductID
	,	 SUM(Quantity) AS Quantity
	, Shelf
FROM Production.ProductInventory
WHERE LocationID = 40  
GROUP BY ProductID, Shelf
HAVING SUM(Quantity) < 100

--Uppgift 2.8
SELECT AVG(Quantity)
FROM Production.ProductInventory
WHERE LocationID = 10

--Uppgift 2.9
SELECT ROW_NUMBER() OVER (ORDER BY Name) AS Produkt
,Name
FROM Production.ProductCategory

--Uppgift 3.1 
SELECT CR.Name AS Country
	, SP.Name AS [State]
FROM Person.CountryRegion AS CR
	INNER JOIN Person.StateProvince AS SP ON CR.CountryRegionCode = SP.CountryRegionCode

--Uppgift 3.2
SELECT CR.Name AS Country
	, SP.Name AS [State]
FROM Person.CountryRegion AS CR 
	INNER JOIN Person.StateProvince AS SP ON CR.CountryRegionCode = SP.CountryRegionCode
WHERE CR.Name IN ('Germany', 'Canada')
ORDER BY CR.Name, SP.Name

--Uppgift 3.3
SELECT SOH.SalesOrderID
	, SOH.OrderDate
	, SOH.SalesPersonID
	, SP.BusinessEntityID
	, SP.Bonus
	, SP.SalesYTD
FROM Sales.SalesOrderHeader AS SOH
	INNER JOIN Sales.SalesPerson AS SP ON SOH.TerritoryID = SP.TerritoryID

--Uppgift 3.4
SELECT SOH.SalesOrderID
	, SOH.OrderDate
	, SP.Bonus
	, SP.SalesYTD
	, HR.Jobtitle
FROM Sales.SalesOrderHeader AS SOH
	INNER JOIN Sales.SalesPerson AS SP ON SOH.TerritoryID = SP.TerritoryID
	INNER JOIN HumanResources.Employee AS HR ON SP.TerritoryID = HR.BusinessEntityID

--Uppgift 3.5
SELECT SOH.SalesOrderID
	, SOH.OrderDate
	, SP.Bonus
	, P.FirstName
	, P.LastName
FROM Sales.SalesOrderHeader AS SOH
	INNER JOIN Sales.SalesPerson AS SP ON SOH.TerritoryID = SP.TerritoryID
	INNER JOIN HumanResources.Employee AS HR ON SP.TerritoryID = HR.BusinessEntityID
	INNER JOIN Person.Person AS P ON SP.TerritoryID = P.BusinessEntityID

--Uppgift 3.6
SELECT SOH.SalesOrderID
	, SOH.OrderDate
	, SP.Bonus
	, P.FirstName
	, P.LastName
FROM Sales.SalesOrderHeader AS SOH
	INNER JOIN Sales.SalesPerson AS SP ON SOH.TerritoryID = SP.TerritoryID
	INNER JOIN Person.Person AS P ON SP.TerritoryID = P.BusinessEntityID

--Uppgift 3.7
SELECT SOH.SalesOrderID
	, SOH.OrderDate
	, P.FirstName
	, P.LastName
FROM Sales.SalesOrderHeader AS SOH
	INNER JOIN Person.Person AS P ON SOH.SalesPersonID = P.BusinessEntityID

--Uppgift 3.8
SELECT SOH.SalesOrderID
	, SOH.OrderDate
	, P.FirstName + ' ' + P.LastName AS 'SalesPerson'
	, SOD.ProductID
	, SOD.OrderQty
FROM Sales.SalesOrderHeader AS SOH
	INNER JOIN Person.Person AS P ON SOH.SalesPersonID = P.BusinessEntityID
	INNER JOIN Sales.SalesOrderDetail AS SOD ON SOH.SalesOrderID = SOD.SalesOrderID
ORDER BY OrderDate, SalesOrderID

--Uppgift 3.9
SELECT SOH.SalesOrderID
	, SOH.OrderDate
	, P.FirstName + ' ' + P.LastName AS 'SalesPerson'
	, PP.Name
	, SOD.OrderQty
FROM Sales.SalesOrderHeader AS SOH
	INNER JOIN Person.Person AS P ON SOH.SalesPersonID = P.BusinessEntityID
	INNER JOIN Sales.SalesOrderDetail AS SOD ON SOH.SalesOrderID = SOD.SalesOrderID
	INNER JOIN Production.Product AS PP ON SOD.ProductID = PP.ProductID
ORDER BY OrderDate, SalesOrderID

--Uppgift 3.10
SELECT SOH.SalesOrderID
	, SOH.OrderDate
	, P.FirstName + ' ' + P.LastName AS 'SalesPerson'
	, PP.Name
	, SOD.OrderQty
FROM Sales.SalesOrderHeader AS SOH
	INNER JOIN Person.Person AS P ON SOH.SalesPersonID = P.BusinessEntityID
	INNER JOIN Sales.SalesOrderDetail AS SOD ON SOH.SalesOrderID = SOD.SalesOrderID
	INNER JOIN Production.Product AS PP ON SOD.ProductID = PP.ProductID
WHERE SOH.SubTotal < 100000  AND DATEPART(year, SOH.OrderDate) = 2004
ORDER BY OrderDate, SalesOrderID

--Uppgift 3.11
SELECT CR.Name AS CountryName
	, SP.Name AS ProvinceName
FROM Person.CountryRegion AS CR
	LEFT JOIN Person.StateProvince AS SP ON CR.CountryRegionCode = SP.CountryRegionCode
ORDER BY CountryName, ProvinceName

--Uppgift 3.12
SELECT C.CustomerID
	, SOH.SalesOrderID
FROM  Sales.Customer AS C
	LEFT JOIN Sales.SalesOrderHeader AS SOH ON C.CustomerID = SOH.CustomerID
WHERE SOH.SalesOrderID IS NULL
ORDER BY CustomerID 

--Uppgift 3.13
SELECT PP.Name AS 'ProductName'
	, PM.Name AS 'ModelName'
FROM  Production.Product AS PP
	FULL JOIN Production.ProductModel AS PM ON PP.ProductModelID = PM.ProductModelID
WHERE PP.Name IS NULL OR PM.Name IS NULL

--Uppgift 3.14 DEL 1
SELECT P.FirstName + ' ' + P.LastName AS FullName
	, SP.BusinessEntityID
FROM Sales.SalesPerson AS SP
	INNER JOIN HumanResources.Employee AS HR ON HR.BusinessEntityID = SP.BusinessEntityID
	INNER JOIN Person.Person AS P ON P.BusinessEntityID = HR.BusinessEntityID

--Uppgift 3.14 DEL 2
SELECT P.FirstName + ' ' + P.LastName AS FullName
	, COUNT(SOH.SalesPersonID) AS 'NoOfOrders'
	, SUM(SOH.SubTotal) AS 'TotalSum'
FROM Sales.SalesPerson AS SP
	INNER JOIN HumanResources.Employee AS HR ON HR.BusinessEntityID = SP.BusinessEntityID
	INNER JOIN Person.Person AS P ON P.BusinessEntityID = HR.BusinessEntityID
	INNER JOIN Sales.SalesOrderHeader AS SOH ON SP.BusinessEntityID = SOH.SalesPersonID
GROUP BY SOH.SalesPersonID, P.FirstName + ' ' + P.LastName

--Uppgift 3.15
SELECT ST.Name AS Region
	, DATEPART(year, SOH.OrderDate) AS Year
	, SUM(SOH.SubTotal) AS SumTotal
FROM Sales.SalesOrderHeader AS SOH
	INNER JOIN Sales.SalesTerritory AS ST ON SOH.TerritoryID = ST.TerritoryID
GROUP BY DATEPART(year, SOH.OrderDate), ST.Name
ORDER BY ST.Name
	, DATEPART(year,OrderDate) 
	
--Uppgift 3.16 
SELECT P.FirstName + ' ' + P.LastName AS FullName
	, COUNT(HRH.DepartmentID) AS NrOfDep
FROM Person.Person AS P
	INNER JOIN HumanResources.Employee AS HR ON P.BusinessEntityID = HR.BusinessEntityID
	INNER JOIN HumanResources.EmployeeDepartmentHistory AS HRH ON P.BusinessEntityID = HRH.BusinessEntityID
GROUP BY P.FirstName + ' ' + P.LastName
HAVING COUNT(HRH.DepartmentID) > 1

--Uppgift 3.17
SELECT 'MAX' AS 'Max/Min/Avg'
	, MAX(SOH.Subtotal) AS SubTotal	
FROM Sales.SalesOrderHeader AS SOH
UNION 
SELECT  'MIN'
	, MIN(SOH.SubTotal)
FROM Sales.SalesOrderHeader AS SOH
UNION
SELECT 'Medel'
	, AVG(SOH.SubTotal)
FROM Sales.SalesOrderHeader AS SOH

--Uppgift 3.18
SELECT TOP (10) ListPrice
	, Name
FROM Production.Product
ORDER BY ListPrice DESC

--Uppgift 3.19
SELECT TOP (1) PERCENT DaysToManufacture
	 , Name
	, ListPrice
FROM Production.Product
ORDER BY DaysToManufacture DESC


