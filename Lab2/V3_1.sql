--Вывести на экран название отдела, где работает каждый сотрудник в настоящий момент.
SELECT HumanResources.Employee.BusinessEntityID, JobTitle, HumanResources.Department.DepartmentID, Name
FROM HumanResources.EmployeeDepartmentHistory
INNER JOIN HumanResources.Employee
ON HumanResources.Employee.BusinessEntityID = HumanResources.EmployeeDepartmentHistory.BusinessEntityID
AND HumanResources.EmployeeDepartmentHistory.EndDate is NULL
INNER JOIN HumanResources.Department
ON HumanResources.Department.DepartmentID = HumanResources.EmployeeDepartmentHistory.DepartmentID
GO

--Вывести на экран количество сотрудников в каждом отделе
SELECT HumanResources.Department.DepartmentID, Name, EmpCount=COUNT(*)
FROM HumanResources.Department
INNER JOIN HumanResources.EmployeeDepartmentHistory
ON HumanResources.EmployeeDepartmentHistory.DepartmentID = HumanResources.Department.DepartmentID
GROUP BY HumanResources.Department.DepartmentID, Name
GO

--Вывести на экран отчет истории изменения почасовых ставок как показано в примере
SELECT JobTitle, Rate, RateChangeDate, 
	   Report=CONCAT('The rate for ', JobTitle, ' was set to ', Rate, ' at ', FORMAT(CAST(RateChangeDate AS DATE), 'dd MMM yyyy '))
FROM HumanResources.Employee
INNER JOIN HumanResources.EmployeePayHistory
ON HumanResources.Employee.BusinessEntityID = HumanResources.EmployeePayHistory.BusinessEntityID;
GO