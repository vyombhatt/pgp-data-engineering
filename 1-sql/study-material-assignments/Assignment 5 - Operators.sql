--Problem Statement:
--You have successfully cleared your fourth semester. In the fifth semester you will work with clauses and SET operators.

CREATE DATABASE intellipaat;

USE intellipaat;

--Tasks To Be Performed:
--1. Arrange the ‘Orders’ dataset in decreasing order of amount

SELECT *
FROM Orders
ORDER BY amount DESC;


--2. Create a table with the name ‘Employee_details1’ consisting of these columns: ‘Emp_id’, ‘Emp_name’, ‘Emp_salary’. 
--Create another table with the name ‘Employee_details2’ consisting of the same columns as the first table.

CREATE TABLE Employee_details1 (
Emp_id INT NOT NULL PRIMARY KEY,
Emp_name VARCHAR(100),
Emp_salary INT);

CREATE TABLE Employee_details2 (
Emp_id INT NOT NULL PRIMARY KEY,
Emp_name VARCHAR(100),
Emp_salary INT);


--3. Apply the UNION operator on these two tables

SELECT * FROM Employee_details1
UNION
SELECT * FROM Employee_details2;

--4. Apply the INTERSECT operator on these two tables

SELECT * FROM Employee_details1
INTERSECT
SELECT * FROM Employee_details2;


-- 5. Apply the EXCEPT operator on these two tables

SELECT * FROM Employee_details1
EXCEPT
SELECT * FROM Employee_details2;
