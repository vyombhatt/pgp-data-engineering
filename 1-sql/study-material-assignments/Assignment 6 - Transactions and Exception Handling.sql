--Problem Statement:
--You have successfully cleared your fifth semester. In the final semester you will work with views, transactions and exception handling.
CREATE DATABASE intellipaat;

USE intellipaat;

--Tasks To Be Performed:
--1. Create a view named ‘customer_san_jose’ which comprises of only those customers who are from San Jose

CREATE VIEW San_Jose_Customers AS
SELECT *
FROM Customer
WHERE city = 'San Jose';

SELECT * FROM San_Jose_Customers;

--2. Inside a transaction, update the first name of the customer to Francis where the last name is Jordan:
--a. Rollback the transaction
--b. Set the first name of customer to Alex, where the last name is Jordan

BEGIN
	BEGIN TRANSACTION;
		SAVE TRANSACTION my_touchpoint;
		UPDATE Customer
		SET first_name = 'Francis'
		WHERE last_name = 'Jordan'
		ROLLBACK TRANSACTION my_touchpoint;
		UPDATE Customer
		SET first_name = 'Alex'
		WHERE last_name = 'Jordan'
	COMMIT TRANSACTION
END


--3. Inside a TRY... CATCH block, divide 100 with 0, print the default error message.

BEGIN TRY  
    SELECT 100/0;  
END TRY  
BEGIN CATCH  
    SELECT ERROR_MESSAGE() AS ErrorMessage;  
END CATCH;  


--4. Create a transaction to insert a new record to Orders table and save it.

BEGIN
	BEGIN TRANSACTION;
		INSERT INTO Orders VALUES (6, '2023-08-10', 330, 4);
	COMMIT TRANSACTION;
END

SELECT * FROM Orders;
