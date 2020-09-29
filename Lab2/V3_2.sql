/*
C������� ������� dbo.Address � ����� �� ���������� ��� Person.Address, 
����� ����� geography, uniqueidentifier, �� ������� �������, ����������� � ��������
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
��������� ���������� ALTER TABLE, �������� ��� ������� dbo.Address 
��������� ��������� ���� �� ����� StateProvinceID � PostalCode
*/
ALTER TABLE dbo.Address
ADD CONSTRAINT PK_Address Primary Key (PostalCode, StateProvinceID);
GO

/*
��������� ���������� ALTER TABLE, �������� ��� ������� dbo.Address 
����������� ��� ���� PostalCode, ����������� ���������� ����� ���� �������
*/
ALTER TABLE dbo.Address
ADD CONSTRAINT VLDT_Address_PostalCode CHECK (LOWER(PostalCode) NOT LIKE '%[a-z]%');
GO

/*
��������� ���������� ALTER TABLE, �������� ��� ������� dbo.Address ����������� 
DEFAULT ��� ���� ModifiedDate, ������� �������� �� ��������� ������� ���� � �����
*/
ALTER TABLE dbo.Address
ADD CONSTRAINT DFLT_Address_ModifiedDate DEFAULT GETDATE() FOR ModifiedDate;
GO

/*
��������� ����� ������� ������� �� Person.Address. �������� ��� ������� ������ �� ������, 
��� �������� ���� CountryRegionCode = �US� �� ������� StateProvince. ����� ��������� ������, 
��� PostalCode �������� �����. ��� ������ ������ �� ����� StateProvinceID � PostalCode �������� 
������ ������ � ������������ AddressID (��� ����� ����������� � ������� ������� �������)
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
��������� ������ ���� City �� NVARCHAR(20)
*/
ALTER TABLE Address
    ALTER COLUMN City NVARCHAR(20);
GO