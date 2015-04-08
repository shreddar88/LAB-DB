CREATE DATABASE Asci
USE Asci
USE MASTER
DROP DATABASE Asci

IF NOT EXISTS (SELECT object_id, type FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.KundInfo') AND type IN (N'U'))

CREATE TABLE KundInfo
	(
	KID int NOT NULL IDENTITY (1,1),
	FöretagsNamn varchar(50) NOT NULL,
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

IF NOT EXISTS (SELECT object_id, type FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Fakturor') AND type IN (N'U'))
CREATE TABLE Fakturor
	(
	FID int NOT NULL IDENTITY (1,1),
	KID int NOT NULL,
	Datum date NOT NULL,
	SubTotal money NOT NULL,
	ArbetsTimmar int NOT NULL,
	OCRNummer int NOT NULL,
	[StatusID] int NOT NULL
		CONSTRAINT PK_Fakturor_FID PRIMARY KEY (FID),
		CONSTRAINT FK_Fakturor_KID FOREIGN KEY (KID) REFERENCES KundInfo(KID),
		CONSTRAINT FK_Fakturor_StatusID FOREIGN KEY (StatusID) REFERENCES [Status](StatusID)
	);


IF NOT EXISTS (SELECT object_id, type FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Beställningar') AND type IN (N'U'))
CREATE TABLE Beställningar
	(
	BID int NOT NULL IDENTITY (1,1),
	KID int NOT NULL,
	FID int NOT NULL,
	Datum date NOT NULL,
	ArbetsPeriod date NOT NULL,
		CONSTRAINT PK_Beställningar_BID PRIMARY KEY (BID),
		CONSTRAINT FK_KundInfon_KID FOREIGN KEY (KID) REFERENCES KundInfo(KID),
		CONSTRAINT FK_Fakturor_FID FOREIGN KEY (FID) REFERENCES Fakturor(FID)
	);

SELECT * 
FROM KundInfo AS K
	INNER JOIN Fakturor AS F ON F.KID = K.KID
	INNER JOIN Beställningar AS BE ON BE.KID = K.KID
	INNER JOIN [Status] AS S ON S.StatusID = F.StatusID

DECLARE @KID int 
	, @FID int
	, @BID int

	INSERT INTO dbo.[Status](StatusID, Value)
		VALUES (0, 'Ej betald'),
				(1, 'Betald'),
				(2, 'Försenad')

	INSERT INTO dbo.KundInfo(FöretagsNamn, Adress)
		VALUES ('Asci', 'AsciLand, AsciStreet, 666 66')
SET @KID = SCOPE_IDENTITY();

	INSERT INTO dbo.Fakturor(KID, Datum, SubTotal, OCRNummer, ArbetsTimmar, StatusID)
		VALUES (@KID, GetDate(), '10999',666999, '66', 0)
SET @FID = SCOPE_IDENTITY();


	INSERT INTO dbo.Beställningar (KID, FID, Datum, ArbetsPeriod)
		VALUES (@KID, @FID, GetDate(), GetDate())
SET @BID = SCOPE_IDENTITY();
