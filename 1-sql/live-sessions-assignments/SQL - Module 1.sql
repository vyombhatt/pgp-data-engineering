--Problem Statement: Consider yourself to be Sam and you have been given the below tasks to complete using the Table – STUDIES, SOFTWARE & PROGRAMMER.

--create database intellipaat;
use intellipaat;

--1. Find out the selling cost AVG for packages developed in Pascal.

SELECT avg(scost) as avg_selling_cost
FROM software
WHERE developin = 'PASCAL';
--Ans: 3066.65

--2. Display Names, Ages of all Programmers.

SELECT DISTINCT PNAME, DATEDIFF(YEAR, DOB, GETDATE()) AS AGE
FROM PROGRAMMER;

--3. Display the Names of those who have done the DAP Course.

SELECT DISTINCT PNAME
FROM STUDIES
WHERE COURSE = 'DAP';

--4. Display the Names and Date of Births of all Programmers Born in January.

SELECT DISTINCT PNAME, DOB
FROM PROGRAMMER
WHERE MONTH(DOB) = 1;

--5. Display the Details of the Software Developed by Ramesh.

SELECT *
FROM SOFTWARE
WHERE PNAME = 'RAMESH';

--6. Display the Details of Packages for which Development Cost have been recovered.

SELECT *
FROM SOFTWARE
WHERE (SOLD * SCOST) - DCOST > 0;

--7. Display the details of the Programmers Knowing C.

SELECT *
FROM PROGRAMMER
WHERE (PROF1 = 'C' OR PROF2 = 'C');

--8. What are the Languages studied by Male Programmers?

(SELECT PROF1
FROM PROGRAMMER
WHERE GENDER = 'M')
UNION
(SELECT PROF2
FROM PROGRAMMER
WHERE GENDER = 'M');

--9. Display the details of the Programmers who joined before 1990.

SELECT *
FROM PROGRAMMER
WHERE YEAR(DOJ) < 1990;

--10. Who are the authors of the Packages, which have recovered more than double the Development cost?

SELECT DISTINCT PNAME
FROM SOFTWARE
WHERE (SOLD * SCOST) > DCOST * 2;

