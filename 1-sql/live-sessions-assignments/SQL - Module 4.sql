
USE INTELLIPAAT;

--1. What is the cost of the costliest software development in Basic?

SELECT MAX(DCOST) AS COSTLIEST_SOFTWARE
FROM SOFTWARE
WHERE DEVELOPIN = 'BASIC';

--2. Display details of Packages whose sales crossed the 2000 Mark.

SELECT *, SOLD * SCOST AS SALES
FROM SOFTWARE
WHERE SOLD * SCOST > 2000;

--3. Who are the Programmers who celebrate their Birthdays during the Current Month?

SELECT PNAME
FROM PROGRAMMER
WHERE MONTH(DOB) = MONTH(GETDATE());

--4. Display the Cost of Package Developed By each Programmer.

SELECT PNAME, SUM(DCOST) AS TOTAL_COST
FROM SOFTWARE
GROUP BY PNAME;

--5. Display the sales values of the Packages Developed by each Programmer.

SELECT PNAME, SUM(SOLD * SCOST) AS TOTAL_SALES
FROM SOFTWARE
GROUP BY PNAME;

--6. Display the Number of Packages sold by Each Programmer.

SELECT PNAME, SUM(SOLD) AS NO_OF_PKG_SOLD
FROM SOFTWARE
GROUP BY PNAME;

--7. Display each programmer’s name, costliest and cheapest Packages Developed by him or her.


WITH
COSTLIEST AS (
	SELECT PNAME, TITLE, RANK() OVER (PARTITION BY PNAME ORDER BY DCOST DESC) AS RNK
	FROM SOFTWARE
	),
CHEAPEST AS (
	SELECT PNAME, TITLE, RANK() OVER (PARTITION BY PNAME ORDER BY DCOST) AS RNK
	FROM SOFTWARE
	)
SELECT A.PNAME, A.TITLE AS COSTLIEST_PACGKAGE, B.TITLE AS CHEAPEST_PACKAGE
FROM COSTLIEST A
INNER JOIN CHEAPEST B
  ON A.PNAME = B.PNAME
WHERE A.RNK = 1
  AND B.RNK = 1;

--8. Display each institute name with the number of Courses, Average Cost per Course.

SELECT INSTITUTE, COUNT(COURSE) AS NO_OF_COURSES, AVG(COURSE_FEE) AS AVG_COST_PER_COURSE
FROM STUDIES
GROUP BY INSTITUTE;

--9. Display each institute Name with Number of Students.

SELECT INSTITUTE, COUNT(DISTINCT PNAME) AS NO_OF_STUDENTS
FROM STUDIES
GROUP BY INSTITUTE;

--10. List the programmers (form the software table) and the institutes they studied.

SELECT DISTINCT A.PNAME, B.INSTITUTE
FROM SOFTWARE A
INNER JOIN STUDIES B
  ON A.PNAME = B.PNAME;

--11. How many packages were developed by students, who studied in institute that charge the lowest course fee?

WITH
CHEAPEST_INSTITUTE AS (
	SELECT TOP 1 INSTITUTE
	FROM STUDIES
	ORDER BY COURSE_FEE
	)
SELECT COUNT(*) AS PCKGS_DEVELOPED
FROM STUDIES A
INNER JOIN CHEAPEST_INSTITUTE B
  ON A.INSTITUTE = B.INSTITUTE
INNER JOIN SOFTWARE C
  ON A.PNAME = C.PNAME
;

--12. What is the AVG salary for those whose software sales is more than 50,000/-.

WITH
SOFT_SALES AS (
	SELECT PNAME
	FROM SOFTWARE
	WHERE SCOST * SOLD > 50000
	)
SELECT AVG(A.SALARY) AS AVG_SALARY
FROM PROGRAMMER A
INNER JOIN SOFT_SALES B
  ON A.PNAME = B.PNAME;

--13. Which language listed in prof1, prof2 has not been used to develop any package.

WITH
LANG AS (
	SELECT PROF1 FROM PROGRAMMER
	UNION
	SELECT PROF2 FROM PROGRAMMER
	)
SELECT A.PROF1
FROM LANG A
LEFT JOIN SOFTWARE B
  ON A.PROF1 = B.DEVELOPIN
WHERE B.DEVELOPIN IS NULL;

--14. Display the total sales value of the software, institute wise.

SELECT A.INSTITUTE, SUM(B.SOLD * B.SCOST) AS SALES
FROM STUDIES A
INNER JOIN SOFTWARE B
  ON A.PNAME = B.PNAME
GROUP BY A.INSTITUTE;

--15. Display the details of the Software Developed in C By female programmers of Pragathi.

SELECT B.*
FROM STUDIES A
INNER JOIN SOFTWARE B
  ON A.PNAME = B.PNAME 
INNER JOIN PROGRAMMER C
  ON A.PNAME = C.PNAME
WHERE B.DEVELOPIN = 'C'
  AND C.GENDER = 'F'
  AND A.INSTITUTE = 'PRAGATHI';

--16. Display the details of the packages developed in Pascal by the Female Programmers.

SELECT B.*
FROM PROGRAMMER A
INNER JOIN SOFTWARE B
  ON A.PNAME = B.PNAME 
WHERE B.DEVELOPIN = 'PASCAL'
  AND A.GENDER = 'F';

--17. Which language has been stated as the proficiency by most of the Programmers?


SELECT TOP 1 PROF1, COUNT(DISTINCT PNAME) AS PROGRAMMER_COUNT
FROM
	(SELECT PNAME, PROF1 FROM PROGRAMMER
	UNION ALL
	SELECT PNAME, PROF2 FROM PROGRAMMER) A
GROUP BY PROF1
ORDER BY 2 DESC;

--18. Who is the Author of the Costliest Package?

SELECT TOP 1 PNAME
FROM SOFTWARE
ORDER BY DCOST DESC;

--19. Which package has the Highest Development cost?

SELECT TOP 1 TITLE
FROM SOFTWARE
ORDER BY DCOST DESC;

--20. Who is the Highest Paid Female COBOL Programmer?

SELECT TOP 1 PNAME
FROM PROGRAMMER
WHERE (PROF1 = 'COBOL' OR PROF2 = 'COBOL')
  AND GENDER = 'F'
ORDER BY SALARY DESC;

--21. Display the Name of Programmers and Their Packages.

SELECT A.PNAME, B.TITLE
FROM PROGRAMMER A
LEFT JOIN SOFTWARE B
  ON A.PNAME = B.PNAME
ORDER BY 1,2;

--22. Display the Number of Packages in Each Language Except C and C++.

SELECT DEVELOPIN, COUNT(*) AS NO_OF_PACKAGES
FROM SOFTWARE
WHERE DEVELOPIN NOT IN ('C','CPP')
GROUP BY DEVELOPIN
ORDER BY DEVELOPIN;

--23. Display AVG Difference between SCOST, DCOST for Each Package.

SELECT AVG(DCOST - SCOST)
FROM SOFTWARE;

--24. Display the total SCOST, DCOST and amount to Be Recovered for each Programmer for Those Whose Cost has not yet been Recovered.

SELECT *, DCOST - (SOLD * SCOST) AMT_TO_BE_RECOVERED
FROM SOFTWARE
WHERE DCOST - (SOLD * SCOST) > 0;

--25. Who is the Highest Paid C Programmers?

SELECT TOP 1 PNAME
FROM PROGRAMMER
WHERE (PROF1 = 'C' OR PROF2 = 'C')
ORDER BY SALARY DESC;

--26. Who is the Highest Paid Female COBOL Programmer?

SELECT TOP 1 PNAME
FROM PROGRAMMER
WHERE (PROF1 = 'COBOL' OR PROF2 = 'COBOL')
  AND GENDER = 'F'
ORDER BY SALARY DESC;
