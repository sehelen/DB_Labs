USE AdventureWorks2012;
GO

--Вывести на экран список отделов, названия которых начинаются на букву ‘P’.
SELECT DepartmentID, Name FROM HumanResources.Department 
WHERE Name LIKE 'P%';
GO

/*Вывести на экран список сотрудников, у которых осталось больше 10,
но меньше 13 часов отпуска (включая эти значения). 
Выполните задание не используя операторы <, >, =.*/
SELECT BusinessEntityID, JobTitle, Gender, VacationHours, SickLeaveHours FROM HumanResources.Employee
WHERE VacationHours BETWEEN 10 AND 13;
GO

/*Вывести на экран сотрудников, которых приняли на работу 1-ого июля (любого года). 
Отсортировать результат по BusinessEntityID по возрастанию. 
Вывести на экран только 5 строк, пропустив первые 3.*/
SELECT BusinessEntityID, JobTitle, Gender, BirthDate, HireDate FROM HumanResources.Employee
WHERE HireDate LIKE '%-07-01'
ORDER BY BusinessEntityID
OFFSET 3 ROWS
FETCH NEXT 5 ROWS ONLY;
GO

