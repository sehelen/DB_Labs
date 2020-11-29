CREATE PROCEDURE Production.AveragePriceInCategory
(
	@ProductClass NVARCHAR(300)
) 
AS
	DECLARE @query NVARCHAR(MAX);
BEGIN
	SET @query = '
        SELECT Name, ' + @ProductClass + '
        FROM (
            SELECT ListPrice, Class, Subcategory.Name 
			FROM Production.Product AS Product
            JOIN Production.ProductSubcategory AS Subcategory
            ON Product.ProductSubcategoryID = Subcategory.ProductSubcategoryID
        ) AS SourceTable
        PIVOT 
		(AVG(ListPrice) 
		FOR SourceTable.Class 
		IN(' + @ProductClass + ')) AS PivotTable';

    EXEC(@query)
END;


EXECUTE Production.AveragePriceInCategory '[H],[L],[M]';
GO