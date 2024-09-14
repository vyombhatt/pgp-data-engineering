--Problem Statement:
--You have successfully cleared the second semester. In your third semester you will work with joins and update statements.

create database intellipaat;

use intellipaat;

--Tasks To Be Performed:
--1. Create an ‘Orders’ table which comprises of these columns: ‘order_id’, ‘order_date’, ‘amount’, ‘customer_id’.

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
order_id INT UNIQUE NOT NULL,
order_date DATE,
amount INT,
customer_id INT);


--2. Insert 5 new records.

INSERT INTO Orders VALUES
(1, '2023-08-01', 150, 1),
(2, '2023-08-02', 100, 2),
(3, '2023-08-03', 90, 3),
(4, '2023-08-03', 200, 3),
(5, '2023-08-04', 250, 5);


--3. Make an inner join on ‘Customer’ and ‘Orders’ tables on the ‘customer_id’ column.

SELECT a.*, b.*
FROM Customer a
INNER JOIN Orders b
  ON a.customer_id = b.customer_id;

--4. Make left and right joins on ‘Customer’ and ‘Orders’ tables on the ‘customer_id’ column.

--Left Join
SELECT a.*, b.*
FROM Customer a
LEFT JOIN Orders b
  ON a.customer_id = b.customer_id;

--Right Join
SELECT a.*, b.*
FROM Customer a
RIGHT JOIN Orders b
  ON a.customer_id = b.customer_id;


--5. Make a full outer join on ‘Customer’ and ‘Orders’ table on the ‘customer_id’ column.

SELECT a.*, b.*
FROM Customer a
FULL JOIN Orders b
  ON a.customer_id = b.customer_id;


--6. Update the ‘Orders’ table and set the amount to be 100 where ‘customer_id’ is 3.

UPDATE Orders
SET amount = 300
WHERE customer_id = 3;

