--Uppgift 4.0
BACKUP DATABASE AdventureWorks2012
TO DISK = 'C:\BackUp\AW_BU.bak'

--Uppgift 4.1
SELECT LastName
FROM Person.Person
BEGIN TRAN 
UPDATE Person.Person
SET LastName = 'Hult'
ROLLBACK TRAN
SELECT @@TRANCOUNT AS ActiveTransactions


--Uppgift 4.2
CREATE
TABLE [dbo].[TempCustomers]
(
[ContactID] [int] NULL,
[FirstName] [nvarchar](50) NULL,
[LastName] [nvarchar](50) NULL,
[City] [nvarchar](30) NULL,
[StateProvince] [nvarchar](50) NULL
)
GO
INSERT INTO dbo.TempCustomers 
VALUES (1, 'Kalen', 'Delaney'),
		(2, 'Herrman', 'Karlsson', 'Vislanda', 'Kronoberg')


INSERT INTO dbo.TempCustomers (ContactID, FirstName, LastName, City) 
VALUES (3, 'Tora', 'Eriksson', 'Guldsmedshyttan'),
		(4, 'Charlie', 'Carpenter', 'Tappström');

SELECT ContactID
	, FirstName
	, LastName
	, City
	, StateProvince
FROM dbo.TempCustomers
 
 --Uppgift 4.3
SELECT *
FROM Production.Product

INSERT INTO Production.Product (Name, ProductNumber, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice, DaysToManufacture, SellStartDate)
VALUES ('Racing Gizmo', 'Az-6660', 500, 375, 1000, 10000, 2, GETDATE())

--Uppgift 4.4
INSERT INTO dbo.TempCustomers (ContactID, FirstName, LastName, City, StateProvince)

SELECT P.BusinessEntityID
	, P.FirstName
	, P.LastName
	, PA.City 
	, SP.Name AS StateProvince
FROM Person.Person AS P
	JOIN Person.BusinessEntity AS BE ON P.BusinessEntityID=BE.BusinessEntityID
	JOIN Person.BusinessEntityAddress AS BEA ON BE.BusinessEntityID = BEA.BusinessEntityID
	JOIN Person.Address PA ON BEA.AddressID=PA.AddressID
	JOIN Person.StateProvince AS SP ON PA.StateProvinceID = SP.StateProvinceID

--Uppgift 4.5
--Töm tabellen
--och töm buffer och cache
TRUNCATE TABLE dbo.TempCustomers
GO
DBCC DROPCLEANBUFFERS
DBCC FREEPROCCACHE
GO
--Lägg till data och mät tiden
DECLARE @Start DATETIME2, @Stop DATETIME2
SELECT @Start = SYSDATETIME()
INSERT INTO dbo.TempCustomers
	(ContactID, FirstName, LastName)
SELECT BusinessEntityID, FirstName, LastName
FROM Person.Person
SELECT @Stop = SYSDATETIME()
SELECT DATEDIFF(ms,@Start,@Stop) as MilliSeconds
--Tom (cold) cache 126 ms
--Fylld (warm) cache 107 ms
--Tom (cold) cache 280 ms
--Fylld (warm) cache 266 ms

CREATE UNIQUE CLUSTERED INDEX [Unique_Clustered]
ON [dbo].[TempCustomers]
( [ContactID] ASC )
GO
CREATE NONCLUSTERED INDEX [NonClustered_LName]
ON [dbo].[TempCustomers]
( [LastName] ASC )
GO
CREATE NONCLUSTERED INDEX [NonClustered_FName]
ON [dbo].[TempCustomers]
( [FirstName] ASC )

--Uppgift 4.6
SELECT BusinessEntityID
	, PersonType
	, FirstName
	, LastName
	, Title
	, EmailPromotion
INTO #TempTab
FROM Person.Person
WHERE LastName IN ('Achong', 'Acevedo')

SELECT * FROM #TempTab

INSERT INTO Person.Person
	 (BusinessEntityID, PersonType, FirstName, LastName, Title, EmailPromotion)
SELECT BusinessEntityID, PersonType, FirstName, LastName, Title, EmailPromotion
FROM #TempTab

--DEL 2
UPDATE #TempTab
SET BusinessEntityID = 
	(
	SELECT MAX(P.BusinessEntityID) + 1
	FROM Person.Person AS P
	)

INSERT INTO Person.Person
	 (BusinessEntityID, PersonType, FirstName, LastName, Title, EmailPromotion)
SELECT BusinessEntityID, PersonType, FirstName, LastName, Title, EmailPromotion
FROM #TempTab

--DEL 3
INSERT INTO Person.BusinessEntity
VALUES (DEFAULT, DEFAULT)
-- Körde den två gånger och försökte sedan köra insert uttrycket ovan igen men får
-- då felmeddelandet "violation of primary key" ???

DROP TABLE #TempTab

SELECT FirstName, BusinessEntityID, ModifiedDate --Inget nytt pga ovanstående..
FROM Person.Person 
WHERE ModifiedDate > '2015-03-10'

--Uppgift 4.7
UPDATE Person.Person
SET FirstName = 'Gurra', LastName = 'Tjong'
WHERE BusinessEntityID IN
	(
	SELECT BusinessEntityID
	FROM Person.Person
	WHERE LastName IN ('Achong', 'Acevedo')
	)
--SELECT FirstName
--	, LastName
--FROM Person.Person
--WHERE FirstName = 'Gurra' AND LastName = 'Tjong'

--Uppgift 4.8
SELECT PP.Name
	, PP.ListPrice * 1.1 AS NotOnSale
FROM Production.Product AS PP
	INNER JOIN Production.ProductSubcategory AS PS ON PS.ProductSubcategoryID = PP.ProductSubcategoryID
WHERE PS.Name = 'Gloves'

--Uppgift 4.9
DELETE FROM TempCustomers
WHERE LastName = 'Smith'

SELECT LastName
FROM TempCustomers
WHERE LastName LIKE 'SM%'
