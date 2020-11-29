-- Task 1
DECLARE @xml XML;

SET @xml = (
    SELECT 
		Person.BusinessEntityID AS ID, 
		Person.FirstName, 
		Person.LastName
    FROM Person.Person AS Person
    FOR XML PATH ('Person'), ROOT ('Persons'));


-- Task 2
CREATE TABLE #PersonsTable
(
    BusinessEntityID INT NOT NULL,
    FirstName NVARCHAR(20),
    LastName NVARCHAR(20)
)

INSERT #PersonsTable
SELECT 
	BusinessEntityID = node.value('(./ID)[1]', 'INT'),
	FirstName = node.value('(./FirstName)[1]', 'NVARCHAR(20)'),
	LastName = node.value('(./LastName)[1]','NVARCHAR(20)')
FROM @xml.nodes('/Persons/Person') XML(node);
GO