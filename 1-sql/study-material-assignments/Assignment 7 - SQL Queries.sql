--Problem Statement:
--Consider yourself to be Sam and you have been given the below tasks to complete using the Table – STUDIES, SOFTWARE and PROGRAMMER

CREATE DATABASE intellipaat;
USE intellipaat;


--Tasks To Be Performed:
--1. Find out the selling cost average for packages developed in Pascal.

SELECT AVG(SCOST)
FROM SOFTWARE
WHERE DEVELOPIN = 'PASCAL';
--3066.65

--2. Display the names and ages of all programmers.

SELECT PNAME, DOB, DATEDIFF(YEAR, DOB, GETDATE())
FROM PROGRAMMER;

--3. Display the names of those who have done the DAP Course.

SELECT DISTINCT PNAME
FROM STUDIES
WHERE COURSE = 'DAP';

--4. Display the names and date of birth of all programmers born in January.

SELECT PNAME, DOB
FROM PROGRAMMER
WHERE MONTH(DOB) = 1;
--JULIANA	1960-01-31
--REBECCA	1967-01-01

--5. What is the highest number of copies sold by a package?

SELECT MAX(SOLD) AS MAX_COPIES_SOLD
FROM SOFTWARE;
--84

--6. Display lowest course fee.

SELECT MIN(COURSE_FEE) AS MIN_COURSE_FEE
FROM STUDIES;
--4500

--7. How many programmers have done the PGDCA Course?

SELECT COUNT(DISTINCT PNAME) AS PGDCA_COUNT
FROM STUDIES
WHERE COURSE = 'PGDCA';
--3

--8. How much revenue has been earned through sales of packages developed in C?

SELECT SUM(SCOST * SOLD)
FROM SOFTWARE
WHERE DEVELOPIN = 'C';
--185775.00

--9. Display the details of the software developed by Ramesh.

SELECT *
FROM SOFTWARE
WHERE PNAME = 'RAMESH';

--10. How many programmers studied at Sabhari?

SELECT COUNT(DISTINCT PNAME)
FROM STUDIES
WHERE INSTITUTE = 'SABHARI';
--4

--11. Display details of packages whose sales crossed the 2000 mark.

SELECT *, SCOST*SOLD AS SALES
FROM SOFTWARE
WHERE SCOST*SOLD > 2000;

--12. Display the details of packages for which development costs have been recovered.

SELECT *, SCOST*SOLD AS SALES
FROM SOFTWARE
WHERE SCOST*SOLD > DCOST;

--13. What is the cost of the costliest software development in Basic?

SELECT MAX(DCOST)
FROM SOFTWARE
WHERE DEVELOPIN = 'BASIC';

--14. How many packages have been developed in dBase?

SELECT COUNT(DISTINCT TITLE)
FROM SOFTWARE
WHERE DEVELOPIN = 'DBASE';
--2

--15. How many programmers studied in Pragathi?

SELECT COUNT(DISTINCT PNAME)
FROM STUDIES
WHERE INSTITUTE = 'PRAGATHI';
--3

--16. How many programmers paid 5000 to 10000 for their course?

SELECT COUNT(DISTINCT PNAME)
FROM STUDIES
WHERE COURSE_FEE >= 5000
  AND COURSE_FEE <= 10000;
--6

--17. What is the average course fee?

SELECT AVG(COURSE_FEE)
FROM STUDIES;
--11007

--18. Display the details of the programmers knowing C.

SELECT *
FROM PROGRAMMER
WHERE (PROF1 = 'C' OR PROF2 = 'C');

--19. How many programmers know either COBOL or Pascal?

SELECT COUNT(DISTINCT PNAME)
FROM PROGRAMMER
WHERE (PROF1 IN ('COBOL', 'PASCAL') OR PROF2 IN ('COBOL', 'PASCAL'));
--8

--20. How many programmers don’t know Pascal and C?

SELECT COUNT(DISTINCT PNAME)
FROM PROGRAMMER
WHERE (PROF1 NOT IN ('C', 'PASCAL') AND PROF2 NOT IN ('C', 'PASCAL'));
--5

--21. How old is the oldest male programmer?

SELECT DATEDIFF(YEAR, DOB, GETDATE()) AS AGE
FROM PROGRAMMER
WHERE GENDER = 'M'
AND DOB = (SELECT MIN(DOB) FROM PROGRAMMER WHERE GENDER = 'M');
--59

--22. What is the average age of female programmers?

SELECT AVG(DATEDIFF(YEAR, DOB, GETDATE())) AS AVG_F_AGE
FROM PROGRAMMER
WHERE GENDER = 'F';
--56

--23. Calculate the experience in years for each programmer and display with their names in descending order.

SELECT PNAME, DATEDIFF(YEAR, DOJ, GETDATE()) AS EXPERIENCE_YRS
FROM PROGRAMMER
ORDER BY EXPERIENCE_YRS DESC;

--24. Who are the programmers who celebrate their birthdays during the current month?

SELECT PNAME
FROM PROGRAMMER
WHERE MONTH(DOB) = MONTH(GETDATE());
--QADIR

--25. How many female programmers are there?

SELECT COUNT(DISTINCT PNAME)
FROM PROGRAMMER
WHERE GENDER = 'F';
--7

--26. What are the languages studied by male programmers?

SELECT PROF1 FROM PROGRAMMER WHERE GENDER = 'M'
UNION
SELECT PROF2 FROM PROGRAMMER WHERE GENDER = 'M';

--27. What is the average salary?

SELECT AVG(SALARY) AS AVG_SALARY
FROM PROGRAMMER;
--3169

--28. How many people draw a salary between 2000 to 4000?

SELECT COUNT(DISTINCT PNAME)
FROM PROGRAMMER
WHERE SALARY BETWEEN 2000 AND 4000;
--12

--29. Display the details of those who don’t know Clipper, COBOL or Pascal.

SELECT COUNT(DISTINCT PNAME)
FROM PROGRAMMER
WHERE (PROF1 NOT IN ('CLIPPER', 'COBOL', 'PASCAL') AND PROF2 NOT IN ('CLIPPER', 'COBOL', 'PASCAL') );
--5

--30. Display the cost of packages developed by each programmer.

SELECT PNAME, SUM(DCOST) AS DCOST
FROM SOFTWARE
GROUP BY PNAME ORDER BY 1;

--31. Display the sales value of the packages developed by each programmer.

SELECT PNAME, SUM(SCOST*SOLD) AS SALES
FROM SOFTWARE
GROUP BY PNAME ORDER BY 1;

--32. Display the number of packages sold by each programmer.

SELECT PNAME, SUM(SOLD) AS SOLD
FROM SOFTWARE
GROUP BY PNAME ORDER BY 1;

--33. Display the sales cost of the packages developed by each programmer language wise.

SELECT PNAME, DEVELOPIN, SUM(SCOST) AS SCOST
FROM SOFTWARE
GROUP BY PNAME, DEVELOPIN
ORDER BY PNAME, DEVELOPIN;

--34. Display each language name with the average development cost, average selling cost and average price per copy.

SELECT DEVELOPIN, AVG(DCOST) AS AVG_DCOST, AVG(SCOST*SOLD) AS AVG_SCOST, AVG(SCOST) AS AVG__PRC_PER_COPOY 
FROM SOFTWARE
GROUP BY DEVELOPIN
ORDER BY DEVELOPIN;

--35. Display each programmer’s name and the costliest and cheapest packages developed by him or her.

SELECT CHEAP.PNAME, CHEAP.TITLE AS CHEAPEST_TITLE, COSTLY.TITLE AS COSTLIEST_TITLE
FROM
(SELECT *
FROM (
	SELECT PNAME, TITLE, RANK() OVER (PARTITION BY PNAME ORDER BY DCOST) AS CHEAPEST
	FROM SOFTWARE
	) A
WHERE CHEAPEST = 1) CHEAP
INNER JOIN 
(SELECT *
FROM (
	SELECT PNAME, TITLE, RANK() OVER (PARTITION BY PNAME ORDER BY DCOST DESC) AS COSTLIEST
	FROM SOFTWARE
	) B
WHERE COSTLIEST = 1) COSTLY
ON CHEAP.PNAME = COSTLY.PNAME;

--36. Display each institute’s name with the number of courses and the average cost per course.

SELECT INSTITUTE, COUNT(DISTINCT COURSE) AS COURSE_COUNT, AVG(COURSE_FEE) AS AVG_COURSE_FEE
FROM STUDIES
GROUP BY INSTITUTE
ORDER BY INSTITUTE;

--37. Display each institute’s name with the number of students.

SELECT INSTITUTE, COUNT(DISTINCT PNAME) AS STUDENT_COUNT
FROM STUDIES
GROUP BY INSTITUTE
ORDER BY INSTITUTE;

--38. Display names of male and female programmers along with their gender.

SELECT DISTINCT PNAME, GENDER
FROM PROGRAMMER
ORDER BY GENDER, PNAME;

--39. Display the name of programmers and their packages.

SELECT DISTINCT PNAME, TITLE
FROM SOFTWARE
ORDER BY PNAME, TITLE;

--40. Display the number of packages in each language except C and C++.

SELECT DEVELOPIN, COUNT(DISTINCT TITLE) AS NUMBER_OF_PACKAGES, SUM(SOLD) AS TOTAL_COPIES
FROM SOFTWARE
WHERE DEVELOPIN NOT IN ('C', 'CPP')
GROUP BY DEVELOPIN
ORDER BY DEVELOPIN;

--41. Display the number of packages in each language for which development cost is less than 1000.

SELECT DEVELOPIN, COUNT(DISTINCT TITLE) AS NUMBER_OF_PACKAGES, SUM(SOLD) AS TOTAL_COPIES
FROM SOFTWARE
WHERE DCOST < 1000
GROUP BY DEVELOPIN
ORDER BY DEVELOPIN;

--42. Display the average difference between SCOST and DCOST for each package.

SELECT AVG(ABS(DCOST - SCOST))
FROM SOFTWARE;
--13820.32

--43. Display the total SCOST, DCOST and the amount to be recovered for each programmer whose cost has not yet been recovered.

SELECT *, CASE WHEN DCOST - SCOST < 0 THEN 0 ELSE DCOST - SCOST END AS AMOUNT_TO_BE_RECOVERED
FROM (
	SELECT PNAME, SUM(SCOST) AS SCOST, SUM(DCOST) AS DCOST
	FROM SOFTWARE
	GROUP BY PNAME
	) A
ORDER BY PNAME;

--44. Display the highest, lowest and average salaries for those earning more than 2000.

SELECT MAX(SALARY) AS MAX_SALARY, MIN(SALARY) AS MIN_SALARY, AVG(SALARY) AS AVG_SALARY
FROM PROGRAMMER
WHERE SALARY > 2000;

--45. Who is the highest paid C programmer?

SELECT PNAME
FROM PROGRAMMER
WHERE (PROF1 = 'C' OR PROF2 = 'C')
AND SALARY = (SELECT MAX(SALARY) FROM PROGRAMMER WHERE (PROF1 = 'C' OR PROF2 = 'C'));

--46. Who is the highest paid female COBOL programmer?

SELECT PNAME
FROM PROGRAMMER
WHERE (PROF1 = 'COBOL' OR PROF2 = 'COBOL')
AND GENDER = 'F'
AND SALARY = (SELECT MAX(SALARY) FROM PROGRAMMER WHERE (PROF1 = 'COBOL' OR PROF2 = 'COBOL') AND GENDER = 'F');

--47. Display the names of the highest paid programmers for each language.

SELECT TBL2.PROF1, TBL1.PNAME
FROM
(SELECT PNAME, PROF1, SALARY FROM PROGRAMMER
UNION
SELECT PNAME, PROF2, SALARY FROM PROGRAMMER) TBL1
JOIN 
(SELECT PROF1, MAX(SALARY) AS MAX_SAL
FROM (
	SELECT PNAME, PROF1, SALARY FROM PROGRAMMER
	UNION
	SELECT PNAME, PROF2, SALARY FROM PROGRAMMER) A
GROUP BY PROF1) TBL2
ON TBL1.PROF1 = TBL2.PROF1 AND TBL1.SALARY = TBL2.MAX_SAL
ORDER BY 1,2;

--48. Who is the least experienced programmer?

SELECT * 
FROM PROGRAMMER
WHERE DATEDIFF(DAY, DOJ, GETDATE()) = (SELECT MIN(DATEDIFF(DAY, DOJ, GETDATE())) FROM PROGRAMMER);

--49. Who is the most experienced male programmer knowing PASCAL?

SELECT * 
FROM PROGRAMMER
WHERE GENDER = 'M'
  AND (PROF1 = 'PASCAL' OR PROF2 = 'PASCAL')
  AND DATEDIFF(DAY, DOJ, GETDATE()) = (SELECT MIN(DATEDIFF(DAY, DOJ, GETDATE())) 
										FROM PROGRAMMER
										WHERE GENDER = 'M'
										AND (PROF1 = 'PASCAL' OR PROF2 = 'PASCAL'));

--50. Which language is known by only one programmer?

SELECT PROF1, COUNT(*) AS CNT
FROM (
	SELECT PNAME, PROF1 FROM PROGRAMMER
	UNION
	SELECT PNAME, PROF2 FROM PROGRAMMER) A
GROUP BY PROF1
HAVING COUNT(*) = 1;

--51. Who is the above programmer referred in 50?


--52. Who is the youngest programmer knowing dBase?

SELECT PNAME
FROM PROGRAMMER
WHERE (PROF1 = 'DBASE' OR PROF2 = 'DBASE')
  AND DATEDIFF(DAY, DOB, GETDATE()) = (SELECT MIN(DATEDIFF(DAY, DOB, GETDATE())) 
										FROM PROGRAMMER
										WHERE (PROF1 = 'DBASE' OR PROF2 = 'DBASE'));

--53. Which female programmer earning more than 3000 does not know C, C++, Oracle or dBase?

SELECT *
FROM PROGRAMMER
WHERE GENDER = 'F'
  AND SALARY > 3000
  AND PROF1 NOT IN ('C', 'CPP', 'ORACLE', 'DBASE')
  AND PROF2 NOT IN ('C', 'CPP', 'ORACLE', 'DBASE');

--54. Which institute has the most number of students?

SELECT DISTINCT A.INSTITUTE
FROM STUDIES A
INNER JOIN 
(SELECT TOP 1 INSTITUTE, COUNT(DISTINCT PNAME) AS CNT
FROM STUDIES
GROUP BY INSTITUTE
ORDER BY 2 DESC) B
ON A.INSTITUTE = B.INSTITUTE;
--SABHARI

--55. What is the costliest course?

SELECT DISTINCT A.COURSE
FROM STUDIES A
INNER JOIN 
(SELECT TOP 1 COURSE, MAX(COURSE_FEE) AS COURSE_FEE
FROM STUDIES
GROUP BY COURSE
ORDER BY 2 DESC) B
ON A.COURSE = B.COURSE;
--DCA

--56. Which course has been done by the most number of students?

SELECT DISTINCT A.COURSE
FROM STUDIES A
INNER JOIN 
(SELECT TOP 1 COURSE, COUNT(DISTINCT PNAME) AS CNT
FROM STUDIES
GROUP BY COURSE
ORDER BY 2 DESC) B
ON A.COURSE = B.COURSE;
--DCA

--57. Which institute conducts the costliest course?

SELECT DISTINCT A.INSTITUTE
FROM STUDIES A
INNER JOIN 
(SELECT TOP 1 INSTITUTE, MAX(COURSE_FEE) AS MAX_FEE
FROM STUDIES
GROUP BY INSTITUTE
ORDER BY 2 DESC) B
ON A.INSTITUTE = B.INSTITUTE;
--BDPS

--58. Display the name of the institute and the course which has below average course fee.

SELECT INSTITUTE, COURSE
FROM STUDIES
WHERE COURSE_FEE < (SELECT AVG(COURSE_FEE) FROM STUDIES);

--59. Display the names of the courses whose fees are within 1000 (+ or -) of the average fee.

SELECT COURSE
FROM STUDIES
WHERE COURSE_FEE < (SELECT AVG(COURSE_FEE) FROM STUDIES) + 1000
  AND COURSE_FEE > (SELECT AVG(COURSE_FEE) FROM STUDIES) - 1000;

--60. Which package has the highest development cost?

SELECT DISTINCT A.TITLE
FROM SOFTWARE A
INNER JOIN 
(SELECT TOP 1 TITLE, MAX(DCOST) AS DCOST
FROM SOFTWARE
GROUP BY TITLE
ORDER BY 2 DESC) B
ON A.TITLE = B.TITLE;
--FINANCIAL ACCT.

--61. Which course has below average number of students?

SELECT COURSE
FROM (
SELECT COURSE, COUNT(DISTINCT PNAME) CNT
FROM STUDIES
GROUP BY COURSE) A
WHERE CNT <= (SELECT AVG(CNT)
				FROM (
				SELECT COURSE, COUNT(DISTINCT PNAME) CNT
				FROM STUDIES
				GROUP BY COURSE) B)
;

--62. Which package has the lowest selling cost?

SELECT DISTINCT A.TITLE
FROM SOFTWARE A
INNER JOIN 
(SELECT TOP 1 TITLE, MIN(SCOST) AS DCOST
FROM SOFTWARE
GROUP BY TITLE
ORDER BY 2) B
ON A.TITLE = B.TITLE;
--README

--63. Who developed the package that has sold the least number of copies?

SELECT DISTINCT PNAME
FROM SOFTWARE A
INNER JOIN 
(SELECT TOP 1 TITLE, MIN(SOLD) AS SOLD
FROM SOFTWARE
GROUP BY TITLE
ORDER BY 2) B
ON A.TITLE = B.TITLE;
--JULIANA

--64. Which language has been used to develop the package which has the highest sales amount?

SELECT DISTINCT DEVELOPIN
FROM SOFTWARE A
INNER JOIN 
(SELECT TOP 1 TITLE, MAX(SCOST * SOLD) AS SALES
FROM SOFTWARE
GROUP BY TITLE
ORDER BY 2 DESC) B
ON A.TITLE = B.TITLE;
--C

--65. How many copies of the package that has the least difference between development and selling cost were sold?

SELECT SOLD
FROM SOFTWARE
WHERE ABS(SCOST-DCOST) = (SELECT MIN(ABS(SCOST - DCOST)) FROM SOFTWARE);
--6

--66. Which is the costliest package developed in Pascal?

SELECT TITLE
FROM SOFTWARE
WHERE DEVELOPIN = 'PASCAL'
AND DCOST = (SELECT MAX(DCOST) FROM SOFTWARE WHERE DEVELOPIN = 'PASCAL') ;
--HOSPITAL MGMT.

--67. Which language was used to develop the most number of packages?

SELECT TOP 1 DEVELOPIN
FROM (
SELECT DEVELOPIN, COUNT(DISTINCT TITLE) AS CNT
	FROM SOFTWARE
	GROUP BY DEVELOPIN) A
ORDER BY CNT DESC	;
--C

--68. Which programmer has developed the highest number of packages?

SELECT TOP 1 PNAME
FROM (
SELECT PNAME, COUNT(DISTINCT TITLE) AS CNT
	FROM SOFTWARE
	GROUP BY PNAME) A
ORDER BY CNT DESC	;
--MARY

--69. Who is the author of the costliest package?

SELECT TOP 1 PNAME
FROM (
SELECT PNAME, MAX(DCOST) AS DCOST
	FROM SOFTWARE
	GROUP BY PNAME) A
ORDER BY DCOST DESC	;
--MARY

--70. Display the names of the packages which have sold less than the average number of copies.

SELECT TITLE
FROM (
SELECT TITLE, SUM(SOLD) AS TOTAL_SOLD
FROM SOFTWARE
GROUP BY TITLE) A
WHERE A.TOTAL_SOLD <= (SELECT AVG(SOLD) FROM SOFTWARE)

--71. Who are the authors of the packages which have recovered more than double the development cost?

SELECT DISTINCT PNAME
FROM SOFTWARE
WHERE (SCOST*SOLD) - DCOST > DCOST;

--72. Display the programmer names and the cheapest packages developed by them in each language.

SELECT B.PNAME, B.DEVELOPIN, A.TITLE
FROM SOFTWARE A
INNER JOIN
(SELECT PNAME, DEVELOPIN, MIN(DCOST) AS DCOST 
FROM SOFTWARE
GROUP BY PNAME, DEVELOPIN) B
ON A.PNAME = B.PNAME AND A.DCOST = B.DCOST;


--73. Display the language used by each programmer to develop the highest selling and lowest selling package.

WITH 
HIGHEST AS (SELECT PNAME, TITLE, RANK() OVER (PARTITION BY PNAME ORDER BY SOLD DESC) AS DESC_RANK
	FROM SOFTWARE),
LOWEST AS (SELECT PNAME, TITLE, RANK() OVER (PARTITION BY PNAME ORDER BY SOLD) AS ASC_RANK
	FROM SOFTWARE)
SELECT DISTINCT A.PNAME, B.TITLE AS HIGHEST_SELLING, C.TITLE AS LOWEST_SELLING
FROM SOFTWARE A
LEFT JOIN HIGHEST B
  ON A.PNAME = B.PNAME
LEFT JOIN LOWEST C
  ON A.PNAME = C.PNAME
WHERE B.DESC_RANK = 1
  AND C.ASC_RANK = 1
;

--74. Who is the youngest male programmer born in 1965?

SELECT TOP 1 PNAME
FROM PROGRAMMER
WHERE GENDER = 'M'
  AND YEAR(DOB) = 1965
ORDER BY DOB DESC;
--PATTRICK

--75. Who is the oldest female programmer who joined in 1992?

SELECT TOP 1 PNAME
FROM PROGRAMMER
WHERE GENDER = 'F'
  AND YEAR(DOJ) = 1992
ORDER BY DOB;
--VIJAYA

--76. In which year was the most number of programmers born?

SELECT TOP 1 YR 
FROM
(SELECT YEAR(DOB) AS YR, COUNT(*) AS CNT
FROM PROGRAMMER
GROUP BY YEAR(DOB)) A
ORDER BY CNT DESC;
--1965

--77. In which month did the most number of programmers join?

SELECT TOP 1 MNTH 
FROM
(SELECT MONTH(DOJ) AS MNTH, COUNT(*) AS CNT
FROM PROGRAMMER
GROUP BY MONTH(DOJ)) A
ORDER BY CNT DESC;
--4

--78. In which language are most of the programmer’s proficient?

SELECT TOP 1 PROF1 
FROM (
	SELECT PROF1, COUNT(DISTINCT PNAME) AS P_COUNT
	FROM
	(
	SELECT PNAME, PROF1 FROM PROGRAMMER
	UNION ALL 
	SELECT PNAME, PROF2 FROM PROGRAMMER) A
	GROUP BY PROF1) B
ORDER BY P_COUNT DESC;
--C

--79. Who are the male programmers earning below the average salary of female programmers?

SELECT DISTINCT PNAME
FROM PROGRAMMER
WHERE SALARY < (SELECT AVG(SALARY) FROM PROGRAMMER WHERE GENDER = 'F');

--80. Who are the female programmers earning more than the highest paid male programmer?

SELECT DISTINCT PNAME
FROM PROGRAMMER
WHERE SALARY < (SELECT MAX(SALARY) FROM PROGRAMMER WHERE GENDER = 'M')
AND GENDER = 'F';

--81. Which language has been stated as the proficiency by most of the programmers?

SELECT TOP 1 PROF1 
FROM (
	SELECT PROF1, COUNT(*) AS P_COUNT
	FROM
	(
	SELECT PNAME, PROF1 FROM PROGRAMMER
	UNION ALL 
	SELECT PNAME, PROF2 FROM PROGRAMMER) A
	GROUP BY PROF1) B
ORDER BY P_COUNT DESC;
--C

--82. Display the details of those who are drawing the same salary.

SELECT A.SALARY, A.*, B.*
FROM PROGRAMMER A
JOIN PROGRAMMER B
  ON A.SALARY = B.SALARY
WHERE A.PNAME != B.PNAME;

--83. Display the details of the software developed by the male programmers earning more than 3000.

SELECT A.*
FROM SOFTWARE A
JOIN PROGRAMMER B
  ON A.PNAME = B.PNAME
WHERE B.GENDER = 'M'
  AND B.SALARY > 3000;

--84. Display the details of the packages developed in Pascal by the female programmers.

SELECT A.*
FROM SOFTWARE A
JOIN PROGRAMMER B
  ON A.PNAME = B.PNAME
WHERE B.GENDER = 'F';

--85. Display the details of the programmers who joined before 1990.

SELECT *
FROM PROGRAMMER
WHERE YEAR(DOJ) < 1990;

--86. Display the details of the software developed in C by the female programmers at Pragathi.

SELECT A.*
FROM SOFTWARE A
INNER JOIN STUDIES B
  ON A.PNAME = B.PNAME
INNER JOIN PROGRAMMER C
  ON A.PNAME = C.PNAME
WHERE C.GENDER = 'F'
  AND A.DEVELOPIN = 'C'
  AND B.INSTITUTE = 'PRAGATHI';

--87. Display the number of packages, number of copies sold and sales value of each programmer institute wise.

SELECT B.INSTITUTE, A.PNAME, COUNT(DISTINCT A.TITLE) AS NO_OF_PACKAGES, SUM(A.SOLD) AS NO_OF_COPIES, SUM(A.SCOST*A.SOLD) AS SALES
FROM SOFTWARE A
JOIN STUDIES B
  ON A.PNAME = B.PNAME
GROUP BY B.INSTITUTE, A.PNAME
ORDER BY 1,2;

--88. Display the details of the software developed in dBase by male programmers who belong to the institute in which the most number of programmers studied.

WITH
TBL_INSTITUTE AS 
	(SELECT INSTITUTE, COUNT(*) AS CNT
	 FROM STUDIES
	 GROUP BY INSTITUTE)
SELECT A.*
FROM SOFTWARE A
JOIN PROGRAMMER B
  ON A.PNAME = B.PNAME
JOIN STUDIES C
  ON A.PNAME = C.PNAME
WHERE B.GENDER = 'M'
  AND A.DEVELOPIN = 'DBASE'
  AND C.INSTITUTE = (SELECT TOP 1 INSTITUTE FROM TBL_INSTITUTE ORDER BY CNT DESC)

--89. Display the details of the software developed by the male programmers born before 1965 and female programmers born after 1975.

(SELECT A.*
FROM SOFTWARE A
JOIN PROGRAMMER B
  ON A.PNAME = B.PNAME
WHERE B.GENDER = 'M'
  AND YEAR(B.DOB) < 1965)
UNION
(SELECT A.*
FROM SOFTWARE A
JOIN PROGRAMMER B
  ON A.PNAME = B.PNAME
WHERE B.GENDER = 'F'
  AND YEAR(B.DOB) > 1975)

--90. Display the details of the software that has been developed in the language which is neither the first nor the second proficiency of the programmers.

SELECT *
FROM (
	SELECT A.*, CASE WHEN A.DEVELOPIN = B.PROF1 OR A.DEVELOPIN = B.PROF2 THEN 1 ELSE 0 END AS MATCH
	FROM SOFTWARE A
	JOIN PROGRAMMER B
	  ON A.PNAME = B.PNAME
	  ) A
WHERE MATCH != 1;

--91. Display the details of the software developed by the male students at Sabhari.

SELECT A.*
FROM SOFTWARE A
JOIN STUDIES B
  ON A.PNAME = B.PNAME
JOIN PROGRAMMER C
  ON A.PNAME = C.PNAME
WHERE B.INSTITUTE = 'SABHARI'
  AND C.GENDER = 'M';

--92. Display the names of the programmers who have not developed any packages.

SELECT A.PNAME
FROM PROGRAMMER A
LEFT JOIN SOFTWARE B
  ON A.PNAME = B.PNAME
WHERE B.PNAME IS NULL;

--93. What is the total cost of the software developed by the programmers of Apple?

SELECT SUM(DCOST) AS TOTAL_COST
FROM SOFTWARE A
JOIN STUDIES B
  ON A.PNAME = B.PNAME
WHERE B.INSTITUTE = 'APPLE';
--6100

--94. Who are the programmers who joined on the same day?

SELECT A.PNAME, B.PNAME, A.DOJ 
FROM PROGRAMMER A
JOIN PROGRAMMER B
  ON A.DOJ = B.DOJ AND A.PNAME != B.PNAME;

--95. Who are the programmers who have the same Prof2?

SELECT DISTINCT A.PNAME, B.PNAME, A.PROF2
FROM PROGRAMMER A
JOIN PROGRAMMER B
  ON A.PROF2 = B.PROF2 AND A.PNAME != B.PNAME
ORDER BY 1,2

--96. Display the total sales value of the software institute wise.

SELECT A.INSTITUTE, SUM(B.SCOST*B.SOLD) AS TOTAL_SALES
FROM STUDIES A
JOIN SOFTWARE B
  ON A.PNAME = B.PNAME
GROUP BY A.INSTITUTE
ORDER BY 1;

--97. In which institute does the person who developed the costliest package study?

SELECT A.PNAME, INSTITUTE
FROM STUDIES A
JOIN
	(SELECT PNAME 
	FROM 
	(SELECT PNAME, DCOST, RANK() OVER (ORDER BY DCOST DESC) AS RNK
	FROM SOFTWARE) SFT
	WHERE RNK = 1) B
  ON A.PNAME = B.PNAME;


--98. Which language listed in Prof1, Prof2 has not been used to develop any package?

SELECT DISTINCT A.PROF1
FROM
	(SELECT PROF1 FROM PROGRAMMER
	UNION
	SELECT PROF2 FROM PROGRAMMER) A
LEFT JOIN SOFTWARE B
  ON A.PROF1= B.DEVELOPIN
WHERE B.PNAME IS NULL;


--99. How much does the person who developed the highest selling package earn and what course did he/she undergo?

SELECT A.PNAME, B.COURSE, C.SALARY
FROM 
	(SELECT TOP 1 PNAME, SOLD, RANK() OVER (ORDER BY SOLD DESC) AS RNK
	FROM SOFTWARE) A
JOIN STUDIES B
  ON A.PNAME = B.PNAME
JOIN PROGRAMMER C
  ON A.PNAME = C.PNAME;

--100. What is the average salary for those whose software sales is more than 50,000?

SELECT AVG(A.SALARY)
FROM PROGRAMMER A
JOIN 
	(SELECT PNAME, SUM(SCOST * SOLD) AS SALES
	 FROM SOFTWARE
	 GROUP BY PNAME) B
  ON A.PNAME = B.PNAME
WHERE B.SALES > 50000;

--101. How many packages were developed by students who studied in institutes that charge the lowest course fee?

SELECT COUNT(A.TITLE)
FROM SOFTWARE A
JOIN (
	SELECT DISTINCT PNAME, COURSE, INSTITUTE, COURSE_FEE, RANK() OVER (PARTITION BY COURSE ORDER BY COURSE_FEE) AS RNK
	FROM STUDIES
	) B
ON A.PNAME = B.PNAME
WHERE B.RNK = 1

--102. How many packages were developed by the person who developed the cheapest package? Where did he/she study?

SELECT COUNT(*)
FROM SOFTWARE A
JOIN 
	(SELECT *
	FROM SOFTWARE
	WHERE DCOST = (SELECT MIN(DCOST) FROM SOFTWARE)) B
ON A.PNAME = B.PNAME
-- 1 PACKAGE

SELECT A.INSTITUTE
FROM STUDIES A
JOIN 
	(SELECT *
	FROM SOFTWARE
	WHERE DCOST = (SELECT MIN(DCOST) FROM SOFTWARE)) B
ON A.PNAME = B.PNAME
--BDPS

--103. How many packages were developed by female programmers earning more than the highest paid male programmer?

SELECT COUNT(B.TITLE)
FROM 
	(SELECT *
	FROM PROGRAMMER
	WHERE GENDER = 'F'
	AND SALARY > (SELECT MAX(SALARY) FROM PROGRAMMER WHERE GENDER = 'M')) A
INNER JOIN SOFTWARE B
  ON A.PNAME = B.PNAME;
  --7

--104. How many packages are developed by the most experienced programmers from BDPS?

WITH
BDPS_EXP AS
	(SELECT A.*, RANK() OVER (ORDER BY DOJ) AS RNK
	FROM STUDIES A
	JOIN PROGRAMMER B
	  ON A.PNAME = B.PNAME
	WHERE INSTITUTE = 'BDPS')
SELECT COUNT(B.TITLE)
FROM BDPS_EXP A
INNER JOIN SOFTWARE B
  ON A.PNAME = B.PNAME
WHERE A.RNK = 1;
--1

--105. List the programmers (from the software table) and the institutes they studied at.

SELECT DISTINCT A.PNAME, B.INSTITUTE
FROM SOFTWARE A
JOIN STUDIES B
  ON A.PNAME = B.PNAME;

--106. List each PROF with the number of programmers having that PROF and the number of the packages in that PROF.

SELECT PROF1, COUNT(DISTINCT A.PNAME) AS NO_OF_PROGRAMMERS, COUNT(B.TITLE) AS NO_OF_PACKAGES
FROM (
	SELECT PNAME, PROF1 FROM PROGRAMMER
	UNION
	SELECT PNAME, PROF2 FROM PROGRAMMER
	) A
JOIN SOFTWARE B
  ON A.PNAME = B.PNAME
GROUP BY PROF1
ORDER BY 1;

--107. List the programmer names (from the programmer table) and the number of packages each has developed.

SELECT A.PNAME, COUNT(DISTINCT TITLE) AS NO_OF_PACKAGES
FROM PROGRAMMER A
JOIN SOFTWARE B
  ON A.PNAME = B.PNAME
GROUP BY A.PNAME
ORDER BY 1;


