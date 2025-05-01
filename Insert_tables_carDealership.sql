CREATE DATABASE CarDealership;
GO

USE [CarDealership];


--run when you insert customers table
EXEC sp_rename 'Customers', 'Customers_Old';
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Phone BIGINT,
    Email VARCHAR(100)
);

INSERT INTO Customers (FirstName, LastName, Phone, Email)
SELECT FirstName, LastName, Phone, Email FROM Customers_Old;

DROP TABLE Customers_Old;

Select * FROM Customers;
----------------------------------------------------------------------------------------------


--run this after the makes table is inserted------
EXEC sp_rename 'dbo.makes', 'Makes_Old';

CREATE TABLE Makes (
    MakeID INT IDENTITY(1,1) PRIMARY KEY,
    MakeName VARCHAR(100) NOT NULL
);

INSERT INTO Makes (MakeName)
SELECT MakeName FROM Makes_Old;

DROP TABLE Makes_Old;
--------------------------------------------------------------------------------------done with makes

--run this for Models-------------------------------
EXEC sp_rename 'dbo.Models', 'Models_Old';

CREATE TABLE Models (
    ModelID INT IDENTITY(1,1) PRIMARY KEY,
    MakeID INT NOT NULL,
    ModelName VARCHAR(100) NOT NULL UNIQUE,
    CONSTRAINT FK_Models_Makes FOREIGN KEY (MakeID) REFERENCES Makes(MakeID)
);

INSERT INTO Models (MakeID, ModelName)
SELECT MakeID, ModelName FROM Models_Old;

DROP TABLE Models_Old;

SELECT * FROM Models;

----------------------------------------------------------------------
--salesperson------------------------------------------------

EXEC sp_rename 'dbo.SalesPerson', 'SalesPeople_Old';

CREATE TABLE SalesPerson (
    SalesPersonID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Position VARCHAR(100) NOT NULL,
    Commission DECIMAL(5, 2) NOT NULL
);

INSERT INTO SalesPerson (FirstName, LastName, Position, Commission)
SELECT FirstName, LastName, Position, Commission FROM SalesPeople_Old;


DROP TABLE SalesPeople_Old;

SELECT * FROM SalesPerson;

-----------------------------------------------------------------------------

--Cars---------------------------------------------------------------

EXEC sp_rename 'dbo.Cars', 'Cars_Old';

CREATE TABLE Cars (
    CarID INT IDENTITY(1,1) PRIMARY KEY,
    ModelID INT NOT NULL,
    CarName VARCHAR(100) NOT NULL,
    VIN VARCHAR(17) NOT NULL UNIQUE,
    PurchasePrice DECIMAL(10, 2) NOT NULL,
    ListPrice DECIMAL(10, 2) NOT NULL,
    CONSTRAINT FK_Cars_Models FOREIGN KEY (ModelID) REFERENCES Models(ModelID)
);

INSERT INTO Cars (ModelID, CarName, VIN, PurchasePrice, ListPrice)
SELECT ModelID, CarName, VIN, PurchasePrice, ListPrice FROM Cars_Old;

DROP TABLE Cars_Old;

SELECT * FROM Cars;

----------------------------------------------------

--SaleLine---------------------------------------

EXEC sp_rename 'dbo.SaleLine', 'SaleLine_Old';


CREATE TABLE SaleLine (
    OrderLineID INT IDENTITY(1,1) PRIMARY KEY,
    SalesID INT NOT NULL,
    CarID INT NOT NULL UNIQUE, -- one car should only be sold once
	SellPrice DECIMAL(10, 2) NOT NULL,
    CONSTRAINT FK_SaleLine_Cars FOREIGN KEY (CarID) REFERENCES Cars(CarID)
);

INSERT INTO SaleLine (SalesID, CarID, SellPrice)
SELECT SalesID, CarID, SellPrice FROM SaleLine_Old;

DROP TABLE SaleLine_Old;

SELECT * FROM SaleLine;
------------------------------------------------------------

--Sale----------------------------------------------------

EXEC sp_rename 'dbo.Sale', 'Sale_Old';

CREATE TABLE Sale (
    SalesID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    SalesPersonID INT NOT NULL,
    SaleDate DATE NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (SalesPersonID) REFERENCES SalesPerson(SalesPersonID)
);

INSERT INTO Sale (CustomerID, SalesPersonID, SaleDate)
SELECT CustomerID, SalesPersonID, SaleDate FROM Sale_Old;

DROP TABLE Sale_Old;

SELECT * FROM Sale;

---------------------------------------------------------

--go back and add FK constraint to SaleLine
ALTER TABLE SaleLine
ADD CONSTRAINT FK_SaleLine_Sale
FOREIGN KEY (SalesID)
REFERENCES Sale(SaleID);

----------------------------------------


