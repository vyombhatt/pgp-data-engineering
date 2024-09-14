
USE INTELLIPAAT;

--1. How many Programmers Don’t know PASCAL and C

SELECT COUNT(DISTINCT PNAME)
FROM PROGRAMMER
WHERE PROF1 != 'PASCAL' 
  AND PROF2 != 'C'
  AND PROF1 != 'C' 
  AND PROF2 != 'PASCAL';

--2. Display the details of those who don’t know Clipper, COBOL or PASCAL.

SELECT *
FROM PROGRAMMER
WHERE PROF1 NOT IN ('CLIPPER', 'COBOL', 'PASCAL')
  AND PROF2 NOT IN ('CLIPPER', 'COBOL', 'PASCAL');

--3. Display each language name with AVG Development Cost, AVG Selling Cost and AVG Price per Copy.

SELECT DEVELOPIN, AVG(DCOST) AS AVG_DCOST, AVG(SCOST) AS AVG_SCOST, SUM(SCOST * SOLD)/NULLIF(SUM(SOLD),0) AS AVG_PRC_PER_COPY
FROM SOFTWARE
GROUP BY DEVELOPIN;

--4. List the programmer names (from the programmer table) and No. Of Packages each has developed.

SELECT A.PNAME, COUNT(B.TITLE) AS NO_OF_PACKAGES
FROM PROGRAMMER A
INNER JOIN SOFTWARE B
  ON A.PNAME = B.PNAME
GROUP BY A.PNAME;

--5. List each PROFIT with the number of Programmers having that PROF and the number of the packages in that PROF.

WITH
PROF AS (
	SELECT PNAME, PROF1
	FROM PROGRAMMER
	UNION 
	SELECT PNAME, PROF2
	FROM PROGRAMMER
	)
SELECT A.PROF1, COUNT(DISTINCT A.PNAME) AS NO_OF_PROGRAMMERS, COUNT(DISTINCT B.PNAME) AS NO_OF_PACKAGES
FROM PROF A
JOIN SOFTWARE B
  ON A.PROF1 = B.DEVELOPIN
  GROUP BY A.PROF1;

--6. How many packages are developed by the most experienced programmer form BDPS.

WITH
EXP_PNAME AS (
	SELECT TOP 1 B.PNAME 
	FROM STUDIES A
	INNER JOIN PROGRAMMER B
	  ON A.PNAME = B.PNAME
	WHERE A.INSTITUTE = 'BDPS'
	ORDER BY DOJ 
	)
SELECT COUNT(*)
FROM SOFTWARE A
INNER JOIN EXP_PNAME B
  ON A.PNAME = B.PNAME;

--7. How many packages were developed by the female programmers earning more than the highest paid male programmer?

WITH 
MAX_SAL AS (
	SELECT MAX(SALARY) AS SALARY
	FROM PROGRAMMER
	WHERE GENDER = 'M'
	)
SELECT COUNT(B.TITLE)
FROM PROGRAMMER A
INNER JOIN SOFTWARE B
  ON A.PNAME = B.PNAME
INNER JOIN MAX_SAL C
  ON A.SALARY > C.SALARY
WHERE A.GENDER = 'F';

--8. How much does the person who developed the highest selling package earn and what course did HE/SHE undergo.

WITH 
HIGH_PCKG AS (
	SELECT TOP 1 PNAME
	FROM SOFTWARE
	ORDER BY SOLD DESC
	)
SELECT A.PNAME, SALARY, COURSE
FROM HIGH_PCKG A
INNER JOIN STUDIES B
  ON A.PNAME = B.PNAME
INNER JOIN PROGRAMMER C
  ON A.PNAME = C.PNAME;

--9. In which institute did the person who developed the costliest package study?

WITH 
HIGH_PCKG AS (
	SELECT TOP 1 PNAME
	FROM SOFTWARE
	ORDER BY DCOST DESC
	)
SELECT A.PNAME, INSTITUTE
FROM HIGH_PCKG A
INNER JOIN STUDIES B
  ON A.PNAME = B.PNAME;

--10. Display the names of the programmers who have not developed any packages.

SELECT A.PNAME
FROM PROGRAMMER A
LEFT JOIN STUDIES B
  ON A.PNAME = B.PNAME
WHERE B.PNAME IS NULL;

--11. Display the details of the software that has developed in the language which is neither the first nor the second proficiency

SELECT A.*, B.*
FROM SOFTWARE A
INNER JOIN PROGRAMMER B
  ON A.PNAME = B.PNAME
WHERE A.DEVELOPIN != PROF1 AND A.DEVELOPIN != PROF2;

--12. Display the details of the software Developed by the male programmers Born before 1965 and female programmers born after 1975

SELECT A.*
FROM SOFTWARE A
INNER JOIN PROGRAMMER B
  ON A.PNAME = B.PNAME
WHERE (B.GENDER = 'M' AND YEAR (B.DOB) < 1965)
  OR (B.GENDER = 'F' AND YEAR (B.DOB) > 1975);

--13. Display the number of packages, No. of Copies Sold and sales value of each programmer institute wise.

SELECT B.INSTITUTE, COUNT(A.TITLE) AS NO_OF_PACKAGES, SUM(SOLD) AS COPIES_SOLD, SUM(SCOST * SOLD) AS SALES
FROM SOFTWARE A
INNER JOIN STUDIES B
  ON A.PNAME = B.PNAME
  GROUP BY INSTITUTE;

--14. Display the details of the Software Developed by the Male Programmers Earning More than 3000/

SELECT A.*
FROM SOFTWARE A
INNER JOIN PROGRAMMER B
  ON A.PNAME = B.PNAME
WHERE B.GENDER = 'M'
  AND B.SALARY > 3000;

--15. Who are the Female Programmers earning more than the Highest Paid male?

SELECT PNAME
FROM PROGRAMMER
WHERE SALARY > (SELECT MAX(SALARY) FROM PROGRAMMER WHERE GENDER = 'M')
  AND GENDER = 'F';

--16. Who are the male programmers earning below the AVG salary of Female Programmers?

SELECT PNAME
FROM PROGRAMMER
WHERE SALARY < (SELECT AVG(SALARY) FROM PROGRAMMER WHERE GENDER = 'F')
  AND GENDER = 'M';

--17. Display the language used by each programmer to develop the Highest Selling and Lowest-selling package.

WITH
HIGHEST_SELLING AS (
	SELECT PNAME, DEVELOPIN, RANK() OVER (PARTITION BY PNAME ORDER BY SOLD DESC) AS RNK
	FROM SOFTWARE
	),
LOWEST_SELLING AS (
	SELECT PNAME, DEVELOPIN, RANK() OVER (PARTITION BY PNAME ORDER BY SOLD) AS RNK
	FROM SOFTWARE
	)
SELECT A.PNAME, A.DEVELOPIN AS HIGHEST_SELLING, B.DEVELOPIN AS LOWEST_SELLING
FROM HIGHEST_SELLING A
INNER JOIN LOWEST_SELLING B
  ON A.PNAME = B.PNAME
WHERE A.RNK = 1
  AND B.RNK = 1;

--18. Display the names of the packages, which have sold less than the AVG number of copies.

SELECT TITLE
FROM SOFTWARE
WHERE SOLD < (SELECT AVG(SOLD) FROM SOFTWARE);

--19. Which is the costliest package developed in PASCAL.

SELECT TOP 1 TITLE
FROM SOFTWARE
WHERE DEVELOPIN = 'PASCAL'
ORDER BY DCOST DESC;

--20. How many copies of the package that has the least difference between development and selling cost were sold

SELECT TOP 1 SOLD
FROM (SELECT *, ABS(DCOST - SCOST) AS DIFF
	FROM SOFTWARE
	) A
ORDER BY DIFF ;

--21. Which language has been used to develop the package, which has the highest sales amount?

SELECT TOP 1 DEVELOPIN
FROM SOFTWARE
ORDER BY (SOLD * SCOST) DESC;

--22. Who Developed the Package that has sold the least number of copies?

SELECT TOP 1 PNAME
FROM SOFTWARE
ORDER BY SOLD ;

--23. Display the names of the courses whose fees are within 1000 (+ or -) of the Average Fee

WITH 
AVG_FEE_TBL AS (
	SELECT AVG(COURSE_FEE) AVG_FEE
	FROM STUDIES
	)
SELECT DISTINCT A.COURSE
FROM STUDIES A
INNER JOIN AVG_FEE_TBL B
	ON A.COURSE_FEE BETWEEN B.AVG_FEE - 1000 AND B.AVG_FEE + 1000;

--24. Display the name of the Institute and Course, which has below AVG course fee.

WITH 
AVG_FEE_TBL AS (
	SELECT AVG(COURSE_FEE) AVG_FEE
	FROM STUDIES
	)
SELECT DISTINCT A.INSTITUTE, A.COURSE
FROM STUDIES A
INNER JOIN AVG_FEE_TBL B
	ON A.COURSE_FEE < B.AVG_FEE
ORDER BY 1,2;


--25. Which Institute conducts costliest course.

SELECT TOP 1 INSTITUTE
FROM STUDIES
ORDER BY COURSE_FEE DESC;

--26. What is the Costliest course?

SELECT TOP 1 COURSE
FROM STUDIES
ORDER BY COURSE_FEE DESC;
