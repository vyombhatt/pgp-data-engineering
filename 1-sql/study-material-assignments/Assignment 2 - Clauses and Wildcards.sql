--Problem Statement:
--You have successfully cleared the first semester. In your second semester you will learn how to create tables, work with WHERE clause and basicoperators.

create database intellipaat;

use intellipaat;
--Tasks To Be Performed:
--1. Create a customer table which comprises of these columns: ‘customer_id’, ‘first_name’, ‘last_name’, ‘email’, ‘address’, ‘city’,’state’,’zip’

CREATE TABLE customer (
customer_id INT UNIQUE NOT NULL,
first_name VARCHAR(100),
last_name VARCHAR(100),
email VARCHAR(100),
address VARCHAR(100),
city VARCHAR(100),
state VARCHAR(100),
zip VARCHAR(20));


--2. Insert 5 new records into the table

INSERT INTO customer VALUES
(1, 'Rijul', 'Kaul', 'rk123@yahoo.com', 'Indiranagar', 'Bengaluru', 'Karnataka', '560038'),
(2, 'Abhijith', 'KP', 'akp123@gmail.com', 'Indiranagar', 'Bengaluru', 'Karnataka', '560038'),
(3, 'Madhuri', 'Shastry', 'ms123@yahoo.com', 'C V Raman', 'Bengaluru', 'Karnataka', '560093'),
(4, 'Siva', 'Prasath', 'sp123@gmail.com', 'Kurla', 'Mumbai', 'Maharashtra', '400070'),
(5, 'Gary', 'Hill', 'gh123@gmail.com', 'New Town', 'San Jose', 'California', '94088');


--3. Select only the ‘first_name’ and ‘last_name’ columns from the customer table

SELECT first_name, last_name
FROM customer;

--4. Select those records where ‘first_name’ starts with “G” and city is ‘San Jose’.

SELECT *
FROM customer
WHERE first_name like 'G%'
  AND city = 'San Jose';


--5. Select those records where Email has only ‘gmail’.

SELECT *
FROM customer
WHERE email LIKE '%gmail%';


--6. Select those records where the ‘last_name’ doesn't end with “A”.

SELECT *
FROM customer
WHERE UPPER(last_name) NOT LIKE '%A';

