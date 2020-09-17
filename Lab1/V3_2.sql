USE AdventureWorks2012;
GO

--������� �� ����� ������ �������, �������� ������� ���������� �� ����� �P�.
SELECT DepartmentID, Name FROM HumanResources.Department 
WHERE Name LIKE 'P%';
GO

/*������� �� ����� ������ �����������, � ������� �������� ������ 10,
�� ������ 13 ����� ������� (������� ��� ��������). 
��������� ������� �� ��������� ��������� <, >, =.*/
SELECT BusinessEntityID, JobTitle, Gender, VacationHours, SickLeaveHours FROM HumanResources.Employee
WHERE VacationHours BETWEEN 10 AND 13;
GO

/*������� �� ����� �����������, ������� ������� �� ������ 1-��� ���� (������ ����). 
������������� ��������� �� BusinessEntityID �� �����������. 
������� �� ����� ������ 5 �����, ��������� ������ 3.*/
SELECT BusinessEntityID, JobTitle, Gender, BirthDate, HireDate FROM HumanResources.Employee
WHERE HireDate LIKE '%-07-01'
ORDER BY BusinessEntityID
OFFSET 3 ROWS
FETCH NEXT 5 ROWS ONLY;
GO

