USE AdventureWorks2012;

-- a) добавьте в таблицу dbo.Address поле AddressType типа nvarchar размерностью 50 символов;
ALTER TABLE dbo.Address 
ADD AddressType VARCHAR(50) NULL;
GO

-- b) объявите табличную переменную с такой же структурой как dbo.Address и заполните ее данными из dbo.Address. Заполните поле AddressType значениями из Person.AddressType поля Name;
DECLARE @TempTable TABLE
             (
                 AddressID       INT          NOT NULL,
                 AddressLine1    nvarchar(60) not null,
                 AddressLine2    nvarchar(60),
                 City            nvarchar(20) not null,
                 StateProvinceID int          not null,
                 PostalCode      nvarchar(15) not null,
                 ModifiedDate    datetime     not null,
                 AddressType     nvarchar(50)
             );

INSERT INTO @TempTable(AddressID, AddressLine1, AddressLine2, City, StateProvinceID, PostalCode, ModifiedDate, AddressType)
SELECT AddressID,
       AddressLine1,
       AddressLine2,
       City,
       StateProvinceID,
       PostalCode,
       ModifiedDate,
	   (Select Name
			FROM AdventureWorks2012.Person.AddressType
            JOIN AdventureWorks2012.Person.BusinessEntityAddress AS A
            ON AddressType.AddressTypeID = A.AddressTypeID
			WHERE dbo.Address.AddressID = A.AddressID)
FROM dbo.Address;

-- c) обновите поле AddressType в dbo.Address данными из табличной переменной. Также обновите AddressLine2, если значение в поле NULL — обновите поле данными из AddressLine1;
UPDATE dbo.Address
SET dbo.Address.AddressType = [@TempTable].AddressType
FROM @TempTable
WHERE dbo.Address.AddressID = [@TempTable].AddressID;
GO

UPDATE dbo.Address
SET dbo.Address.AddressLine2 = Address.AddressLine1
FROM dbo.Address
WHERE dbo.Address.AddressLine2 is null
GO

-- d) удалите данные из dbo.Address, оставив только по одной строке для каждого AddressType с максимальным AddressID;
DELETE FROM dbo.Address
WHERE AddressID NOT IN (SELECT MAX(AddressID) FROM Address GROUP BY Address.AddressType);
GO

-- e) удалите поле AddressType из таблицы, удалите все созданные ограничения и значения по умолчанию.
ALTER TABLE dbo.Address
DROP COLUMN AddressType
GO

SELECT *
FROM AdventureWorks2012.INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Address';
GO

ALTER TABLE dbo.Address
    DROP CONSTRAINT [PK_Address];
GO

ALTER TABLE dbo.Address
    DROP CONSTRAINT [VLDT_Address_PostalCode];
GO

ALTER TABLE dbo.Address
    DROP CONSTRAINT [DFLT_Address_ModifiedDate];
GO

-- f) удалите таблицу dbo.Address
DROP TABLE dbo.Address;
GO