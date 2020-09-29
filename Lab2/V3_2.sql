/*
Cоздайте таблицу dbo.Address с такой же структурой как Person.Address, 
кроме полей geography, uniqueidentifier, не включа€ индексы, ограничени€ и триггеры
*/
CREATE TABLE dbo.Address
(
    AddressID        INT			NOT NULL,
    AddressLine1     nvarchar(60)	not null,
    AddressLine2     nvarchar(60),
    City             nvarchar(30)	not null,
    StateProvinceID  int			not null,
    PostalCode       nvarchar(15)	not null,
    ModifiedDate     datetime		not null
)
GO

/* 
»спользу€ инструкцию ALTER TABLE, создайте дл€ таблицы dbo.Address 
составной первичный ключ из полей StateProvinceID и PostalCode
*/
ALTER TABLE dbo.Address
ADD CONSTRAINT PK_Address Primary Key (PostalCode, StateProvinceID);
GO

/*
»спользу€ инструкцию ALTER TABLE, создайте дл€ таблицы dbo.Address 
ограничение дл€ пол€ PostalCode, запрещающее заполнение этого пол€ буквами
*/
ALTER TABLE dbo.Address
ADD CONSTRAINT VLDT_Address_PostalCode CHECK (LOWER(PostalCode) NOT LIKE '%[a-z]%');
GO

/*
»спользу€ инструкцию ALTER TABLE, создайте дл€ таблицы dbo.Address ограничение 
DEFAULT дл€ пол€ ModifiedDate, задайте значение по умолчанию текущую дату и врем€
*/
ALTER TABLE dbo.Address
ADD CONSTRAINT DFLT_Address_ModifiedDate DEFAULT GETDATE() FOR ModifiedDate;
GO

/*
«аполните новую таблицу данными из Person.Address. ¬ыберите дл€ вставки только те адреса, 
где значение пол€ CountryRegionCode = СUSТ из таблицы StateProvince. “акже исключите данные, 
где PostalCode содержит буквы. ƒл€ группы данных из полей StateProvinceID и PostalCode выберите 
только строки с максимальным AddressID (это можно осуществить с помощью оконных функций)
*/
INSERT INTO dbo.Address
(AddressID,
 AddressLine1,
 AddressLine2,
 City,
 StateProvinceID,
 PostalCode,
 ModifiedDate)
SELECT PA.AddressID,
       PA.AddressLine1,
       PA.AddressLine2,
       PA.City,
       PA.StateProvinceID,
       PA.PostalCode,
       PA.ModifiedDate
FROM (
		SELECT AddressID,
			MAX(AddressID) OVER ( PARTITION BY PostalCode, Address.StateProvinceID) AS MaxAddressId,
			Address.AddressLine1,
			Address.AddressLine2,
			Address.City,
			Address.StateProvinceID,
			PostalCode,
			Address.ModifiedDate
		FROM AdventureWorks2012.Person.Address) PA
INNER JOIN AdventureWorks2012.Person.StateProvince AS StPr 
ON PA.StateProvinceID = StPr.StateProvinceID
AND StPr.CountryRegionCode = 'US' 
AND (LOWER(PA.PostalCode) NOT LIKE '%[a-z]%') 
AND MaxAddressId = AddressID;
GO

/*
”меньшите размер пол€ City на NVARCHAR(20)
*/
ALTER TABLE Address
    ALTER COLUMN City NVARCHAR(20);
GO