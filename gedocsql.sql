CREATE DATABASE Asci
USE Asci
USE MASTER
DROP DATABASE Asci

IF NOT EXISTS (SELECT object_id, type FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.KundInfo') AND type IN (N'U'))
CREATE TABLE KundInfo
	(
	KID int NOT NULL IDENTITY (1,1),
	ForetagsNamn varchar(50) NOT NULL,
	Adress varchar(50) NOT NULL,
		CONSTRAINT PK_KundInfo_KID PRIMARY KEY (KID)
	);

IF NOT EXISTS (SELECT object_id, type FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.[Status]') AND type IN (N'U'))
CREATE TABLE [Status]
	(
	[StatusID] int NOT NULL,
	Value varchar(50) NOT NULL,
		CONSTRAINT PK_Status_StatusID PRIMARY KEY(StatusID),
	);

	
IF NOT EXISTS (SELECT object_id, type FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Bestallningar') AND type IN (N'U'))
CREATE TABLE Bestallningar
	(
	BID int NOT NULL IDENTITY (1,1),
	KID int NOT NULL,	
	Datum date NOT NULL,
	ArbetsPeriod date NOT NULL,
		CONSTRAINT PK_Bestallningar_BID PRIMARY KEY (BID),
		CONSTRAINT FK_KundInfon_KID FOREIGN KEY (KID) REFERENCES KundInfo(KID),
			
	);	

IF NOT EXISTS (SELECT object_id, type FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Fakturor') AND type IN (N'U'))
CREATE TABLE Fakturor
	(
	FID int NOT NULL IDENTITY (1,1),
	BID int NOT NULL,
	Datum date NOT NULL,
	SubTotal money NOT NULL,
	[StatusID] int NOT NULL,
	ArbetsTimmar int NOT NULL,
	OCRNummer int NOT NULL,
		CONSTRAINT PK_Fakturor_FID PRIMARY KEY (FID),
		CONSTRAINT FK_Fakturor_StatusID FOREIGN KEY (StatusID) REFERENCES [Status](StatusID),
		CONSTRAINT FK_Bestallningar_FID FOREIGN KEY (BID) REFERENCES Bestallningar(BID),	
	);


GO

CREATE VIEW dbo.vPresentation
AS
SELECT K.ForetagsNamn
	, K.Adress
	, F.FID
	, F.ArbetsTimmar
	, F.Datum
	, F.SubTotal
	, BE.ArbetsPeriod
	, S.Value
FROM  Bestallningar AS BE
	INNER JOIN KundInfo AS K ON K.KID = BE.KID
	INNER JOIN Fakturor F ON F.BID = BE.BID
	INNER JOIN [Status] AS S ON F.StatusID = S.StatusID
GO


DECLARE @KID int 
	, @FID int
	, @BID int
	, @StatusID int
	INSERT INTO dbo.[Status](StatusID, Value)
		VALUES (0, 'Ej betald'),
				(1, 'Betald'),
				(2, 'Forsenad')

SET @StatusID = SCOPE_IDENTITY();

	INSERT INTO dbo.KundInfo(ForetagsNamn, Adress)
		VALUES ('Asci', 'AsciLand, AsciStreet, 666 66')
SET @KID = SCOPE_IDENTITY();

	INSERT INTO dbo.Bestallningar (KID, Datum, ArbetsPeriod)
		VALUES (@KID, GetDate(), GetDate())
SET @BID = SCOPE_IDENTITY();

INSERT INTO dbo.Fakturor(Datum, SubTotal, OCRNummer, ArbetsTimmar, StatusID, BID)
		VALUES ( GetDate(), '10999',666999, '66', 0, @BID)
SET @FID = SCOPE_IDENTITY();
----------------------------------------
	INSERT INTO dbo.KundInfo(ForetagsNamn, Adress)
		VALUES ('Tobbe-Bobbe', 'TobbeLand, TobsiStreet, 666 99')
SET @KID = SCOPE_IDENTITY();

	INSERT INTO dbo.Bestallningar (KID, Datum, ArbetsPeriod)
		VALUES (@KID, GetDate(), GetDate())
SET @BID = SCOPE_IDENTITY();

	INSERT INTO dbo.Fakturor( Datum, SubTotal, OCRNummer, ArbetsTimmar, StatusID, BID)
		VALUES ( GetDate(), '1999',666000, '666', 0, @BID)
SET @FID = SCOPE_IDENTITY();
------------------------------------
	INSERT INTO dbo.KundInfo(ForetagsNamn, Adress)
		VALUES ('Gedoc', 'GedocLand, GedocStreet, 000 66')
SET @KID = SCOPE_IDENTITY();

	INSERT INTO dbo.Bestallningar (KID, Datum, ArbetsPeriod)
		VALUES (@KID, GetDate(), GetDate())
SET @BID = SCOPE_IDENTITY();

INSERT INTO dbo.Fakturor( Datum, SubTotal, OCRNummer, ArbetsTimmar, StatusID, BID)
		VALUES ( GetDate(), '109',000999, '00', 0, @BID)
SET @FID = SCOPE_IDENTITY();