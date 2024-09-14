
USE INTELLIPAAT;

--1) What is the Highest Number of copies sold by a Package?

SELECT MAX(SOLD) AS MOST_COPIES_SOLD
FROM SOFTWARE;

--2) Display lowest course Fee.

SELECT MIN(COURSE_FEE) AS LEAST_COURSE_FEES
FROM STUDIES;

--3) How old is the Oldest Male Programmer.

SELECT MAX(DATEDIFF(YEAR, DOB, GETDATE())) AS OLDEST_AGE
FROM PROGRAMMER
WHERE GENDER = 'M';

--4) What is the AVG age of Female Programmers?

SELECT AVG(DATEDIFF(YEAR, DOB, GETDATE())) AS AVG_AGE_FEMALE
FROM PROGRAMMER
WHERE GENDER = 'F';

--5) Calculate the Experience in Years for each Programmer and Display with their names in Descending order.

SELECT PNAME, DATEDIFF(YEAR, DOJ, GETDATE()) AS EXP_YRS
FROM PROGRAMMER
ORDER BY 2 DESC;

--6) How many programmers have done the PGDCA Course?

SELECT COUNT(DISTINCT PNAME)
FROM STUDIES
WHERE COURSE = 'PGDCA';

--7) How much revenue has been earned thru sales of Packages Developed in C.

SELECT SUM(SOLD * SCOST) AS REVENUE
FROM SOFTWARE
WHERE DEVELOPIN = 'C';

--8) How many Programmers Studied at Sabhari?

SELECT COUNT(DISTINCT PNAME)
FROM STUDIES
WHERE INSTITUTE = 'SABHARI';

--9) How many Packages Developed in DBASE?

SELECT COUNT(DISTINCT TITLE)
FROM SOFTWARE
WHERE DEVELOPIN = 'DBASE';

--10) How many programmers studied in Pragathi?

SELECT COUNT(DISTINCT PNAME)
FROM STUDIES
WHERE INSTITUTE = 'PRAGATHI';

--11) How many Programmers Paid 5000 to 10000 for their course?

SELECT COUNT(DISTINCT PNAME)
FROM STUDIES
WHERE COURSE_FEE BETWEEN 5000 AND 10000;

--12) How many Programmers know either COBOL or PASCAL?

SELECT COUNT(DISTINCT PNAME)
FROM PROGRAMMER
WHERE (PROF1 IN ('COBOL', 'PASCAL') OR PROF2 IN ('COBOL', 'PASCAL'));

--13) How many Female Programmers are there?

SELECT COUNT(DISTINCT PNAME)
FROM PROGRAMMER
WHERE GENDER = 'F';

--14) What is the AVG Salary?

SELECT AVG(SALARY)
FROM PROGRAMMER;

--15) How many people draw salary 2000 to 4000?

SELECT COUNT(DISTINCT PNAME)
FROM PROGRAMMER
WHERE SALARY BETWEEN 2000 AND 4000;

--16) Display the sales cost of the packages Developed by each Programmer Language wise

SELECT PNAME, DEVELOPIN, SCOST
FROM SOFTWARE
ORDER BY 1,2;

--17) Display the details of the software developed by the male students of Sabhari.

SELECT A.*
FROM SOFTWARE A
JOIN STUDIES B
  ON A.PNAME = B.PNAME
JOIN PROGRAMMER C
  ON A.PNAME = C.PNAME
WHERE C.GENDER = 'M'
  AND B.INSTITUTE = 'SABHARI';

--18) Who is the oldest Female Programmer who joined in 1992?

SELECT TOP 1 PNAME
FROM PROGRAMMER
WHERE YEAR(DOJ) = 1992
  AND GENDER = 'F'
ORDER BY DOB;

--19) Who is the youngest male Programmer born in 1965?

SELECT TOP 1 PNAME
FROM PROGRAMMER
WHERE YEAR(DOB) = 1965
  AND GENDER = 'M'
ORDER BY DOB DESC;

--20) Which Package has the lowest selling cost?

SELECT TOP 1 TITLE
FROM SOFTWARE
ORDER BY SCOST;

--21) Which Female Programmer earning more than 3000 does not know C, C++, ORACLE or DBASE?

SELECT *
FROM PROGRAMMER
WHERE GENDER = 'F'
  AND PROF1 NOT IN ('C', 'C++', 'ORACLE', 'DBASE') 
  AND PROF2 NOT IN ('C', 'C++', 'ORACLE', 'DBASE') ;

--22) Who is the Youngest Programmer knowing DBASE?

SELECT TOP 1 PNAME
FROM PROGRAMMER
WHERE (PROF1 = 'DBASE' OR PROF2 = 'DBASE')
ORDER BY DOB DESC

--23) Which Language is known by only one Programmer?

SELECT PROF1, COUNT(DISTINCT PNAME) AS PROGRAMMER_COUNT
FROM (
	SELECT PNAME, PROF1
	FROM PROGRAMMER
	UNION ALL
	SELECT PNAME, PROF2
	FROM PROGRAMMER
	) A
GROUP BY PROF1
HAVING COUNT(DISTINCT PNAME) = 1;

--24) Who is the most experienced male programmer knowing PASCAL?

SELECT TOP 1 PNAME
FROM PROGRAMMER
WHERE (PROF1 = 'PASCAL' OR PROF2 = 'PASCAL')
AND GENDER = 'M'
ORDER BY DOJ;

--25) Who is the least experienced Programmer?

SELECT TOP 1 PNAME
FROM PROGRAMMER
ORDER BY DOJ DESC;

--26) Display the Number of Packages in Each Language for which Development Cost is less than 1000.

SELECT DEVELOPIN, COUNT(*)
FROM SOFTWARE
WHERE DCOST < 1000
GROUP BY DEVELOPIN;

--27) Display Highest, Lowest and Average Salaries for those earning more than 2000.

SELECT MAX(SALARY) AS MAX_SALARY, MIN(SALARY) AS MIN_SALARY, AVG(SALARY) AS AVG_SALARY
FROM PROGRAMMER
WHERE SALARY > 2000;


