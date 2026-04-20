CREATE DATABASE Retail_Sales_Analysis;

USE Retail_Sales_Analysis;

CREATE TABLE Customers (
	customer_id INT PRIMARY KEY,
    name VARCHAR(50) ,
    city VARCHAR(50) 
);

CREATE TABLE Products (
	product_id INT PRIMARY KEY,
    name VARCHAR(50),
	category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE orders(
	order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE order_items(
		order_id INT,
        product_id INT,
        quantity INT,
        FOREIGN KEY (order_id) REFERENCES orders(order_id),
		FOREIGN KEY (product_id) REFERENCES Products(product_id)
);


INSERT INTO Customers (customer_id,name,city)
values
(1,"abhi","hyderabad"),
(2,"shiva","hyderabad"),
(3,"manoj","chennai"),
(4,"rithvik","pune"),
(5,"joy","delhi");

SELECT * FROM Customers;

INSERT INTO Products(product_id,name,category,price)
VALUES
(101,"laptop","electronics",50000.00),
(102,"phone","electronics",25000.00),
(103,"dress","cloths",1500.00),
(104,"water bottle","kitchen appliences",250.00),
(105,"head phones","electronics",2000.00);

SELECT * FROM Products;

INSERT INTO orders (order_id,customer_id,order_date)
VALUES
(1001,1,"2026-03-31"),
(1002,2,"2026-01-02"),
(1003,3,"2026-02-14"),
(1004,4,"2026-04-05"),
(1005,5,"2026-03-26");

SELECT * FROM orders;

INSERT INTO order_items (order_id,product_id,quantity)
VALUES
(1001,101,1),
(1002,102,1),
(1003,103,1),
(1004,104,1),
(1005,105,1);

SELECT * FROM order_items;


-- Find top-selling products-- 

SELECT A.name,SUM(A.price * B.quantity) AS TOP_SELLING FROM Products AS A JOIN order_items AS B ON A.product_id = B.product_id GROUP BY A.name ORDER BY TOP_SELLING DESC;

-- Identify most valuable customers-- 
SELECT C.name AS name,OI.product_id AS product_id,SUM(OI.quantity * P.price) AS Amount_spent
FROM Customers C
JOIN Orders O ON C.customer_id = O.customer_id
JOIN order_items OI ON O.order_id = OI.order_id
JOIN Products P ON OI.product_id = P.product_id
GROUP BY C.name, OI.product_id ORDER BY Amount_spent DESC;

-- Monthly revenue calculation-- 
SELECT DATE_FORMAT(A.order_date, '%Y-%m') AS month, SUM(C.price * B.quantity) AS Revenue FROM orders AS A JOIN order_items AS B ON A.order_id = B.order_id 
JOIN Products AS C ON C.product_id = B.product_id GROUP BY month;


-- Category-wise sales analysis-- 
SELECT A.category AS CATEGORY ,SUM(A.price * B.quantity) AS TOTAL_VALUE FROM Products AS A JOIN order_items AS B ON A.product_id = B.product_id GROUP BY A.category;

-- Detect inactive customers
SELECT A.name FROM Customers AS A LEFT JOIN Orders AS B ON A.customer_id = B.customer_id WHERE B.order_id IS NULL;