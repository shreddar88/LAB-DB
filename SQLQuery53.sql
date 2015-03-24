--LAB 3
GO
USE MyLibrary;
GO

IF NOT EXISTS (SELECT object_id, type FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Author') AND type IN (N'U'))
CREATE TABLE Author
(
	AuthorID int NOT NULL IDENTITY(1,1),
	FirstName varchar(50) NOT NULL,
	LastName varchar(50) NOT NULL,
	YearOfBirth date NOT NULL,
	YearOfDeath date NULL,
	[Language] varchar(50) NOT NULL,
	Country varchar(50) NOT NULL,
		CONSTRAINT PK_Author_AuthorID PRIMARY KEY (AuthorID)
);

IF NOT EXISTS (SELECT object_id, type FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Customer') AND type IN (N'U'))
CREATE TABLE Customer
(
	CustomerID int NOT NULL IDENTITY(1,1),
	FirstName varchar(50) NOT NULL,
	LastName varchar(50) NOT NULL,
	TelephoneNumber int NULL,
	Email varchar(50) NOT NULL,
	Gender varchar(50) NOT NULL,
	BirthYear date NOT NULL,
		CONSTRAINT PK_Customer_CustomerID PRIMARY KEY(CustomerID),
);

IF NOT EXISTS (SELECT object_id, type FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Book') AND type IN (N'U'))
CREATE TABLE Book
(
	BookID int NOT NULL IDENTITY(1,1),
	AuthorID int NOT NULL,
	Name varchar(50) NOT NULL,
	PublishedYear date NOT NULL,
	[Language] varchar(50) NOT NULL,
		CONSTRAINT PK_Book_BookID PRIMARY KEY(BookID),
		CONSTRAINT FK_Book_AuthorID FOREIGN KEY(AuthorID) REFERENCES Author(AuthorID)
);

IF NOT EXISTS (SELECT object_id, type FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Status') AND type IN (N'U'))
CREATE TABLE [Status]
(
	StatusID int NOT NULL,
	Value varchar(50) NOT NULL
		CONSTRAINT PK_Status_StatusID PRIMARY KEY(StatusID)
);

IF NOT EXISTS (SELECT object_id, type FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Copy') AND type IN (N'U'))
CREATE TABLE [Copy]
(
	CopyID int NOT NULL IDENTITY(1,1),
	StatusID int NOT NULL
		CONSTRAINT DF_Copy_StatusID DEFAULT 0,
	BookID int NOT NULL,
	PurchaseCost money NULL,
	PurchaseYear date NOT NULL
		CONSTRAINT PK_Copy_CopyID PRIMARY KEY(CopyID)
		CONSTRAINT FK_Copy_StatusID FOREIGN KEY(StatusID) REFERENCES [Status] (StatusID),
		CONSTRAINT FK_Copy_BookID FOREIGN KEY (BookID) REFERENCES Book (BookID)
);

IF NOT EXISTS (SELECT object_id, type FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Loan') AND type IN (N'U'))
CREATE TABLE Loan
(
	LoanID int NOT NULL IDENTITY(1,1),
	CustomerID int NOT NULL,
	CopyID int NOT NULL,
	LoanDate datetime NULL
		CONSTRAINT DF_Loan_LoanDate DEFAULT GetDate(),
	ReturnDate datetime NULL
		CONSTRAINT DF_Loan_ReturnDate DEFAULT DATEADD(DAY,14,GetDate()),
		CONSTRAINT PK_Loan_LoanID PRIMARY KEY(LoanID),
		CONSTRAINT FK_Loan_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customer (CustomerID),
		CONSTRAINT FK_Loan_CopyID FOREIGN KEY(CopyID) REFERENCES Copy (CopyID)	
);

DECLARE @StatusID int
	, @LoanID int
	, @AuthorID int
	, @CustomerID int
	, @BookID int
	, @CopyID int
	INSERT INTO dbo.[Status] ([StatusID], [Value])
		VALUES (0, 'Available'),
				 (1, 'Rented Out'),
				 (2, 'Delayed')
SET @StatusID = SCOPE_IDENTITY();

	INSERT INTO dbo.Author (FirstName,LastName,YearOfBirth,YearOfDeath,[Language],[Country]) 
		VALUES('Mattias','Thander','1957', NULL, 'French', 'Sweden')
		
SET @AuthorID = SCOPE_IDENTITY();

	INSERT INTO dbo.Book(AuthorID, Name, PublishedYear, [Language])
		VALUES (@AuthorID, 'Alkemisten', '1989', 'Swedish')
			
SET @BookID = SCOPE_IDENTITY(); 

	INSERT INTO dbo.Copy (StatusID, BookID ,PurchaseCost,PurchaseYear) 
		VALUES (0, @BookID, '5000', GetDate()) 
			,(0, @BookID, '5000', GetDate()) 
			,(0, @BookID, '5000', GetDate()) 
			
SET @CopyID = SCOPE_IDENTITY();

INSERT INTO dbo.Customer (FirstName, LastName, TelephoneNumber, Email, Gender, BirthYear)
		VALUES ('Gedoc', 'Sintset', '0722636431', 'as@hotmail.com', 'Male', '1988')

SET @CustomerID = SCOPE_IDENTITY();

	INSERT INTO dbo.Loan (CustomerID, CopyID)
		VALUES (@CustomerID, @CopyID)
		
SET @LoanID = SCOPE_IDENTITY();
-----------------------------------------

INSERT INTO dbo.Customer (FirstName, LastName, TelephoneNumber, Email, Gender, BirthYear)
		VALUES ('Asgeir', 'Sverrisson', '0729999999', 'as@gmail.com', 'Male', '1990')

SET @CustomerID = SCOPE_IDENTITY();
	INSERT INTO dbo.Author (FirstName,LastName,YearOfBirth,YearOfDeath,[Language],[Country]) 
		VALUES('Göran','Persson','1927', NULL, 'Swedish', 'German')
		
SET @AuthorID = SCOPE_IDENTITY();

INSERT INTO dbo.Book(AuthorID, Name, PublishedYear, [Language])
		VALUES (@AuthorID, 'Politik', '1999', 'Swedish')
			
SET @BookID = SCOPE_IDENTITY(); 

	INSERT INTO dbo.Copy (StatusID, BookID ,PurchaseCost,PurchaseYear) 
		VALUES (0, @BookID, '200', GetDate()) 
		,(0, @BookID, '200', GetDate()) 
		,(0, @BookID, '200', GetDate()) 
			
SET @CopyID = SCOPE_IDENTITY();

INSERT INTO dbo.Loan (CustomerID, CopyID)
		VALUES (@CustomerID, @CopyID)
		
SET @LoanID = SCOPE_IDENTITY();

SELECT * FROM Author
SELECT * FROM Book
SELECT * FROM Copy
SELECT * FROM Loan
SELECT * FROM Customer
	
SELECT *
FROM Author AS A
	INNER JOIN Book AS B ON B.AuthorID = A.AuthorID 
	INNER JOIN Copy AS CO ON B.BookID = CO.BookID
	INNER JOIN Loan AS L ON CO.CopyID = L.CopyID
	INNER JOIN Customer AS C ON C.CustomerID = L.CustomerID
	INNER JOIN [Status] AS S ON S.StatusID = CO.StatusID


--sätt alla lånade böcker till status rented out
UPDATE dbo.Copy
SET StatusID = 1
FROM dbo.Copy AS C
	INNER JOIN dbo.Loan AS L ON L.CopyID = C.CopyID
WHERE L.LoanDate IS NOT NULL

---- View med vilka kunder som har lånade böcker
GO
IF object_id(N'dbo.vCustWithBooks', 'V') IS NOT NULL
DROP VIEW dbo.vCustWithBooks
GO 

CREATE VIEW dbo.vCustWithBooks
AS
SELECT C.FirstName + ' ' + C.LastName AS Customer
	, B.Name AS BookTitle
	, L.ReturnDate
FROM Customer AS C
	INNER JOIN Loan AS L ON L.CustomerID = C.CustomerID
	INNER JOIN Copy AS CO ON CO.CopyID = L.CopyID
	INNER JOIN Book AS B ON B.BookID = CO.BookID

--View med antal kopior tillgängliga
GO 
IF object_id(N'dbo.vNumberOfCopAvail', 'V') IS NOT NULL
DROP VIEW dbo.vNumberOfCopAvail;
GO

CREATE VIEW dbo.vNumberOfCopAvail
AS
SELECT B.Name AS BookTitle, COUNT(CO.CopyID) AS NRAvail
FROM Book AS B
	INNER JOIN Copy AS CO ON CO.BookID = B.BookID
	INNER JOIN [Status] AS S ON S.StatusID = CO.StatusID
WHERE CO.StatusID = 0
GROUP BY B.Name


--USE master
--DROP DATABASE MyLibrary;
--CREATE DATABASE MyLibrary;
--USE MyLibrary