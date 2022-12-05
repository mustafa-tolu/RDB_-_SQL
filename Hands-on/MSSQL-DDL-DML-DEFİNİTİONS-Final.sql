--Key Terms
--DDL: abbreviation for data definition language
--DML: abbreviation for data manipulation language
--SEQUEL: acronym for Structured English Query Language; designed to manipulate and retrieve data stored in IBM’s quasi-relational database management system, System R
--Structured Query Language(SQL): a database language designed for managing data held in a relational database management system

--Data Definition Language (DDL)
--Perform basic data management chores (add, delete and modify)

--SHOW DATABASES
EXEC sp_databases

--SHOW DATABASES
SELECT name FROM sys.databases

--SHOW DATABASES not in SYSTEM
SELECT name FROM master.dbo.sysdatabases 
WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb');
GO

--CREATE DATABASE
--The major SQL DDL statements are. CREATE DATABASE
CREATE DATABASE new_db;
GO

USE new_db;
GO

--CREATE TABLE
--Table name is the name of the database table such as departments. Each field in the CREATE TABLE has three parts: ColumnName, Data type, Optional Column Constraint, Table Constraint
CREATE TABLE departments(
	id BIGINT NOT NULL IDENTITY(1,1),
	name VARCHAR(20) NULL,
	dept_name VARCHAR(20) NULL,
	seniority VARCHAR(20) NULL,
	graduation VARCHAR(20) NULL,
	salary BIGINT NULL,
	hire_date DATE NULL,
    
	CONSTRAINT pk_1 PRIMARY KEY (id)
);
GO

--SEE KEYs in TABLE
EXECUTE sp_helpindex departments;
GO

--RENAME
--select * from departments;
USE new_db;

/*-SYNTAX
EXEC sp_rename 
	@objname = N'index_name', 
	@newname = N'new_index_name',   
	@objtype = N'INDEX';

-- Return the current Primary Key, Foreign Key and Check constraints for the departments table.  
SELECT	name, type_desc
		,SCHEMA_NAME(schema_id) AS schema_name		
FROM	sys.objects  
WHERE	parent_object_id = (OBJECT_ID('departments'))   
		AND type IN ('C','F', 'PK'); 
*/

--RENAME Table Name
EXEC sp_rename 'departments', 'departments2';
EXEC sp_rename 'departments2', 'departments';

--RENAME Column
EXEC sp_rename 'departments.dept_name', 'dept_name2', 'COLUMN';  
EXEC sp_rename 'departments.dept_name2', 'dept_name', 'COLUMN';  

--RENAME Index
USE new_db;
EXEC sp_rename 'departments.pk_1', 'pk_id', 'INDEX'
EXEC sp_rename 'departments.pk_id', 'pk_1', 'INDEX' 

-- Rename the primary key constraint.
-- Rename a check constraint.
-- Rename a foreign key constraint.  
EXEC sp_rename 'departments.pk_1', 'pk_id'
EXEC sp_rename 'departments.pk_id', 'pk_1'
GO

--ALTER TABLE
--ALTER TABLE allows columns to be removed.
--You can use ALTER TABLE statements to add and drop constraints.

--ALTER TABLE tablo_adi
--{ADD{COLUMN alan alan_tipi [(boyut)][NOT NULL][CONSTRAINT indeks]
--CONSTRAINT coklu_indeks}
--DROP{COLUMN alan | CONSTRAINT constraint_adi}
--}

--ALTER ADD CONSTRAINT
ALTER TABLE departments
ADD 
CONSTRAINT unique_id_constraint 
UNIQUE (id);

--ALTER DROP CONSTRAINT
ALTER TABLE departments
DROP CONSTRAINT unique_id_constraint;

--ALTER ADD COLUMN
ALTER TABLE departments
ADD seniority2 VARCHAR(20) NULL;

--ALTER COLUMN CHANGE DATA STRUCTURE
ALTER TABLE departments
ALTER COLUMN seniority2 VARCHAR(50) NOT NULL;

--ALTER DROP COLUMN
ALTER TABLE departments
DROP COLUMN seniority2;

/*
--DROP TABLE
--The DROP TABLE will remove a table from the database. Make sure you have the correct database selected.
DROP TABLE departments;
--OR
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS #create_salary;
DROP TABLE IF EXISTS #into_salary;
DROP VIEW IF EXISTS view_salary;

--DROP DATABASE
--The DROP DATABASE command is used to delete an existing SQL database.
USE [master];
EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'new_db'
ALTER DATABASE [new_db] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
DROP DATABASE IF EXISTS [new_db]
*/
GO


--Data Manipulation Language (DML)
--SELECT – to query data in the database
--INSERT – to insert data into a table
--UPDATE – to update data in a table
--DELETE – to delete data from a table
GO

--SELECT DISTINCT item(s)
--FROM table(s)
--WHERE predicate
--GROUP BY field(s)
--ORDER BY fields;

--SELECT * FROM	departments;
GO

--INSERT
--INSERT [INTO] Table_name | view name [column_list]
--DEFAULT VALUES | values_list | select statementSET 
--USE IDENTITY_INSERT because of id-IDENTITY
SET IDENTITY_INSERT departments ON;
INSERT departments (id, name, dept_name, seniority, graduation, salary, hire_date)
VALUES
(10238,	'Eric'	   ,'Economics'	       ,'Experienced'	,'MSc' ,72000	,'2019-12-01'),
(13378,	'Karl'	   ,'Music'	       ,'Candidate'	,'BSc' ,42000	,'2022-01-01'),
(23493,	'Jason'	   ,'Philosophy'       ,'Candidate'	,'MSc' ,45000	,'2022-01-01'),
(30766,	'Jack'     ,'Economics'	       ,'Experienced'	,'BSc' ,68000	,'2020-06-04'),
(36299,	'Jane'	   ,'Computer Science' ,'Senior'	,'PhD' ,91000	,'2018-05-15'),
(40284,	'Mary'	   ,'Psychology'       ,'Experienced'	,'MSc' ,78000	,'2019-10-22'),
(43087,	'Brian'	   ,'Physics'	       ,'Senior'	,'PhD' ,93000	,'2017-08-18'),
(53695,	'Richard'  ,'Philosophy'       ,'Candidate'	,'PhD' ,54000	,'2021-12-17'),
(58248,	'Joseph'   ,'Political Science','Experienced'	,'BSc' ,58000	,'2021-09-25'),
(63172,	'David'	   ,'Art History'      ,'Experienced'	,'BSc' ,65000	,'2021-03-11'),
(64378,	'Elvis'	   ,'Physics'	       ,'Senior'	,'MSc' ,87000	,'2018-11-23'),
(96945,	'John'	   ,'Computer Science' ,'Experienced'	,'MSc' ,80000	,'2019-04-20'),
(99231,	'Santosh'  ,'Computer Science' ,'Experienced'	,'BSc' ,74000	,'2020-05-07');
SET IDENTITY_INSERT departments OFF;
GO

--To allow an insert with a specific identity value, the IDENTITY_INSERT option should be used.
--You can't alter the existing columns for identity.
--You have 2 options,
--Create a new table with identity & drop the existing table
--Create a new column with identity & drop the existing column
SET IDENTITY_INSERT departments ON;
INSERT departments (id, name, dept_name, seniority, graduation, salary, hire_date)
VALUES (44552,	'Edmond' ,'Economics'	,'Candidate','BSc' ,60000	,'2021-12-04')
SET IDENTITY_INSERT departments OFF;
GO

--Insert with SELECT
--You should use # for creating a temporary table.
CREATE TABLE #create_salary (
id		BIGINT NOT NULL,
name	VARCHAR (40) NULL,
salary	BIGINT NULL
);

--ADDING SAMPLE QUERY VALUES
INSERT	#create_salary
SELECT	id, name, salary 
FROM	departments;
GO

--Or you can use the SELECT ... INTO ... FROM statement as follow:
--CREATE TABLE AND ADDING
SELECT	id, name, salary 
INTO	#into_salary
FROM	departments;
GO

--Or you can use the VIEW
--CREATE OR ALTER VIEW view_salary as 
SELECT	id, name, salary
FROM	departments;
GO

--CREATE COPY TABLE
SELECT *
INTO departments_copy
FROM departments;
GO

--UPDATE
UPDATE departments
SET name = 'Edward'
WHERE id = 10238;

--SHOW TABLES
SELECT * FROM #create_salary;
SELECT * FROM #into_salary;
SELECT * FROM departments_copy;
GO

/*
--DELETE
--DELETE [FROM] {table_name | view_name }
--[WHERE clause];

--Deleting all rows from a table (Not recommended):
DELETE FROM departments;

--Deleting selected rows:
DELETE FROM departments WHERE id = 10238;
*/
GO

/*
--OPTIONAL
--WITH common_table_expression (Transact-SQL)

--WITH temporaryTable (averageValue) 
--as (
--SELECT avg(Attr1) FROM Table
--)
--SELECT Attr1
--FROM Table, temporaryTable
--WHERE Table.Attr1 > temporaryTable.averageValue;

--RUN ONLY ONE GREEN AND RUN UNDER CERTAIN CONDITION
DROP VIEW IF EXISTS view_salary;
DROP TABLE IF EXISTS #into_salary;

--CREATE OR ALTER VIEW view_salary as 
WITH deprt_temp (customer_id, first_name, last_name, product_name) 
AS (
	SELECT * FROM departments
)
SELECT * INTO #into_salary FROM main_table_temp
--SELECT * FROM deprt_temp
GO
*/