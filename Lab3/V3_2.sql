/*
a) выполните код, созданный во втором задании второй лабораторной работы. 
Добавьте в таблицу dbo.Address поля CountryRegionCode NVARCHAR(3) и TaxRate SMALLMONEY. 
Также создайте в таблице вычисляемое поле DiffMin, считающее разницу между значением в поле TaxRate 
и минимальной налоговой ставкой 5.00.
*/
ALTER TABLE dbo.Address 
ADD CountryRegionCode NVARCHAR(3), 
	TaxRate SMALLMONEY, 
	DiffMin as TaxRate - 5.00;
GO

/*
b) создайте временную таблицу #Address, с первичным ключом по полю AddressID.
Временная таблица должна включать все поля таблицы dbo.Address за исключением поля DiffMin.
*/
CREATE TABLE #Address
(
    AddressID           INT          NOT NULL,
    AddressLine1        nvarchar(60) not null,
    AddressLine2        nvarchar(60),
    City                nvarchar(30) not null,
    StateProvinceID     int          not null,
    PostalCode          nvarchar(15) not null,
    ModifiedDate        datetime     not null,
    [CountryRegionCode] nvarchar(3),
    [TaxRate]           SMALLMONEY
);
GO

ALTER TABLE #Address
	ADD CONSTRAINT PK_Address_AddressID 
	PRIMARY KEY ([AddressID]);
GO

/*
c) заполните временную таблицу данными из dbo.Address. 
Поле CountryRegionCode заполните значениями из таблицы Person.StateProvince. 
Поле TaxRate заполните значениями из таблицы Sales.SalesTaxRate. 
Выберите только те записи, где TaxRate > 5. 
Выборку данных для вставки в табличную переменную осуществите в Common Table Expression (CTE).
*/
WITH [ADDRESS_TABLE] AS (SELECT AddressID,
                      AddressLine1,
                      AddressLine2,
                      City,
                      dbo.Address.StateProvinceID,
                      PostalCode,
                      dbo.Address.ModifiedDate,
                      SP.CountryRegionCode,
                      STR.TaxRate
               FROM dbo.Address
                        JOIN AdventureWorks2012.Person.StateProvince as SP
                             ON dbo.Address.StateProvinceID = SP.StateProvinceID
                        JOIN AdventureWorks2012.Sales.SalesTaxRate as STR ON SP.StateProvinceID = STR.StateProvinceID
               WHERE STR.TaxRate > 5
)
INSERT
INTO #Address (AddressID, AddressLine1, AddressLine2, City, StateProvinceID, PostalCode, ModifiedDate,
                   CountryRegionCode, TaxRate)
SELECT AddressID,
       AddressLine1,
       AddressLine2,
       City,
       StateProvinceID,
       PostalCode,
       ModifiedDate,
       CountryRegionCode,
       TaxRate
FROM [ADDRESS_TABLE];
GO

/*
d) удалите из таблицы dbo.Address одну строку (где StateProvinceID = 36)
*/
DELETE FROM dbo.Address
	WHERE [StateProvinceID] = 36;
GO

/*
e) напишите Merge выражение, использующее dbo.Address как target, а временную таблицу как source. 
Для связи target и source используйте AddressID. Обновите поля CountryRegionCode и TaxRate, 
если запись присутствует в source и target. Если строка присутствует во временной таблице, 
но не существует в target, добавьте строку в dbo.Address. Если в dbo.Address присутствует такая строка, 
которой не существует во временной таблице, удалите строку из dbo.Address.
*/
MERGE INTO dbo.Address AS base
USING #Address AS source
ON base.AddressID = source.AddressID
WHEN MATCHED THEN
    UPDATE
    SET CountryRegionCode = source.CountryRegionCode,
        TaxRate           = source.TaxRate
WHEN NOT MATCHED BY TARGET THEN
    INSERT (AddressID,
            AddressLine1,
            AddressLine2,
            City,
            StateProvinceID,
            PostalCode,
            ModifiedDate,
            CountryRegionCode,
            TaxRate)
    VALUES (source.AddressID,
            source.AddressLine1,
            source.AddressLine2,
            source.City,
            source.StateProvinceID,
            source.PostalCode,
            source.ModifiedDate,
            source.CountryRegionCode,
            source.TaxRate)
WHEN NOT MATCHED BY SOURCE THEN DELETE;
GO