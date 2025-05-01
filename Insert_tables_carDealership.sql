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

