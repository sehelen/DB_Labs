CREATE DATABASE LENA_SELIUN;

USE LENA_SELIUN;
GO

CREATE SCHEMA sales;
GO

CREATE SCHEMA persons;
GO

CREATE TABLE sales.Orders (OrderNum INT NULL);
GO

BACKUP DATABASE LENA_SELIUN TO DISK = 'D:\3-������\4 ����\DB\DB_Labs\Lab1\LENA_SELIUN.bak';
USE master;
DROP DATABASE LENA_SELIUN;
GO

RESTORE DATABASE LENA_SELIUN FROM DISK = 'D:\3-������\4 ����\DB\DB_Labs\Lab1\LENA_SELIUN.bak';
GO
