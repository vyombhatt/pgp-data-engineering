--Problem Statement:
--You have successfully cleared your third semester. In the fourth semester you will work with inbuilt functions and user-defined functions.

create database intellipaat;

use intellipaat;

--Tasks To Be Performed:
--1. Use the inbuilt functions and find the minimum, maximum and average amount from the orders table

SELECT MIN(amount) as min_amount, MAX(amount) as max_amount, AVG(amount) as avg_amount
FROM Orders;


--2. Create a user-defined function which will multiply the given number with 10

CREATE FUNCTION mul_by_10 (@inp_val INT)
RETURNS INT AS
BEGIN
	RETURN (@inp_val * 10)
END;

SELECT dbo.mul_by_10(10);


--3. Use the case statement to check if 100 is less than 200, greater than 200 or equal to 200 and print the corresponding value.

SELECT CASE WHEN 100 < 200 THEN '100 < 200'
			WHEN 100 > 200 THEN '100 > 200'
			WHEN 100 = 200 THEN '100 = 200' END;


--4. Using a case statement, find the status of the amount. Set the status of the amount as high amount, low amount or medium amount based upon the condition.

SELECT *, CASE WHEN amount < 100 THEN 'Low' WHEN amount > 200 THEN 'High' ELSE 'Medium' END as amount_status
FROM Orders;


--5. Create a user-defined function, to fetch the amount greater than then given input.

CREATE FUNCTION get_greater_amt (@inp_val INT)
RETURNS TABLE AS
RETURN
	SELECT *
	FROM Orders
	WHERE amount > @inp_val;

SELECT *
FROM dbo.get_greater_amt(120);

