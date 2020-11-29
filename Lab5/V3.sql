
-- Task 1
CREATE FUNCTION Purchasing.GetOrdersSum
	(
		@id INT
	) 
RETURNS MONEY
AS
BEGIN
	RETURN
		(
			SELECT 
				SUM(Purchasing.PurchaseOrderDetail.LineTotal)
				FROM Purchasing.PurchaseOrderDetail
				WHERE PurchaseOrderDetail.PurchaseOrderID = @id
		);
END;
GO

PRINT Purchasing.GetOrdersSum(1);
GO

-- Task 2
CREATE FUNCTION Sales.GetTopOrdersInfo
	(
		@id INT,
		@count INT
	)
RETURNS TABLE
AS
RETURN
	(
		SELECT TOP(@count) *
		FROM Sales.SalesOrderHeader
		WHERE CustomerID = @id AND SubTotal IS NOT NULL
		ORDER BY TotalDue DESC
	);
GO

-- Task 3
SELECT * FROM Sales.Customer CROSS APPLY Sales.GetTopOrdersInfo(CustomerID, 1);
GO

SELECT * FROM Sales.Customer OUTER APPLY Sales.GetTopOrdersInfo(CustomerID, 1);
GO

-- Task 4
DROP FUNCTION Sales.GetTopOrdersInfo;
GO

CREATE FUNCTION Sales.GetTopOrdersInfo
	(
		@id INT,
		@count INT
	)
RETURNS @topOrders TABLE
	(
		SalesOrderID INT NOT NULL,
		RevisionNumber TINYINT NOT NULL,
		OrderDate DATETIME NOT NULL,
		DueDate DATETIME NOT NULL,
		ShipDate DATETIME NULL,
		Status TINYINT NOT NULL,
		OnlineOrderFlag dbo.Flag NOT NULL,
		SalesOrderNumber NVARCHAR(23),
		PurchaseOrderNumber dbo.OrderNumber NULL,
		AccountNumber dbo.AccountNumber NULL,
		CustomerID INT NOT NULL,
		SalesPersonID INT NULL,
		TerritoryID INT NULL,
		BillToAddressID INT NOT NULL,
		ShipToAddressID INT NOT NULL,
		ShipMethodID INT NOT NULL,
		CreditCardID INT NULL,
		CreditCardApprovalCode VARCHAR(15) NULL,
		CurrencyRateID INT NULL,
		SubTotal MONEY NOT NULL ,
		TaxAmt MONEY NOT NULL,
		Freight MONEY NOT NULL,
		TotalDue INT NOT NULL,
		Comment NVARCHAR(128) NULL,
		rowguid UNIQUEIDENTIFIER ROWGUIDCOL  NOT NULL,
		ModifiedDate DATETIME NOT NULL
	)
AS
BEGIN
	INSERT INTO @topOrders
		SELECT TOP(@count) *
		FROM Sales.SalesOrderHeader
		WHERE CustomerID = @id
		ORDER BY TotalDue DESC
	RETURN
END;
GO