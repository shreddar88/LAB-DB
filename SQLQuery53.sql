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
	YearOfDeath datetime NULL,
	[Language] varchar(50) NOT NULL,
	CONSTRAINT PK_Book_BookID PRIMARY KEY(BookID),
	CONSTRAINT FK_Book_AuthorID FOREIGN KEY(AuthorID) REFERENCES Author(AuthorID)
);

IF NOT EXISTS (SELECT object_id, type FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Status') AND type IN (N'U'))
CREATE TABLE [Status]
(
	StatusID int NOT NULL,
	Value varchar(50) NOT NULL
	CONSTRAINT PK_Status_StutusID PRIMARY KEY(StatusID)
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
	LoanDate datetime NOT NULL,
	ReturnDate datetime NOT NULL,
	CONSTRAINT PK_Loan_LoanID PRIMARY KEY(LoanID),
	CONSTRAINT FK_Loan_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customer (CustomerID),
	CONSTRAINT FK_Loan_CopyID FOREIGN KEY(CopyID) REFERENCES Copy (CopyID)
);

DECLARE @StatusID int
	INSERT INTO dbo.[Status] ([StatusID], [Value])
		VALUES (0, 'Available'),
				 (1, 'Rented Out'),
				 (2, 'Delayed')
SET @StatusID = SCOPE_IDENTITY();


DECLARE @AuthorID int
	INSERT INTO dbo.Author (FirstName,LastName,YearOfBirth,YearOfDeath,[Language],[Country]) 
		VALUES('Mattias','Thander','1957','2015', 'French', 'Sweden'); 
SET @AuthorID = SCOPE_IDENTITY();

DECLARE @CustomerID int
	INSERT INTO dbo.Customer (FirstName, LastName, TelephoneNumber, Email, Gender, BirthYear)
		VALUES ('Gedoc', 'Sintset', '0722636431', 'as@hotmail.com', 'Male', '1988')
SET @CustomerID = SCOPE_IDENTITY();

DECLARE @BookID int
	INSERT INTO dbo.Book(AuthorID, Name, PublishedYear, YearOfDeath, [Language])
		VALUES (@AuthorID, 'Alkemisten', '1989', '2029', 'Swedish')
SET @BookID = SCOPE_IDENTITY(); 



DECLARE @CopyID int
	INSERT INTO dbo.[Copy] (StatusID, BookID ,PurchaseCost,PurchaseYear) 
		VALUES (0, @BookID, '5000', '2007') 
SET @CopyID = SCOPE_IDENTITY();

DECLARE @LoanID int
	INSERT INTO dbo.Loan (CustomerID, CopyID, LoanDate, ReturnDate)
		VALUES (@CustomerID, @CopyID, '2015-03-10','2015-03-24')
SET @LoanID = SCOPE_IDENTITY();

SELECT *
	
FROM Author AS A
	INNER JOIN Book AS B ON B.AuthorID = A.AuthorID 
	INNER JOIN Copy AS CO ON B.BookID = CO.BookID
	INNER JOIN Loan AS L ON CO.CopyID = L.CopyID
	INNER JOIN Customer AS C ON C.CustomerID = L.CustomerID
	INNER JOIN [Status] AS S ON S.StatusID = CO.StatusID


--USE master
--DROP DATABASE MyLibrary;
--CREATE DATABASE MyLibrary;