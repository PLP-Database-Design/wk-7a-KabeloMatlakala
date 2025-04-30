-- ==========================================================
-- PLP SQL Assignment: Database Design and Normalization
-- Author: Kabelo Peter Matlakala
-- Description: This script demonstrates normalization from 
-- unnormalized form to 1NF and 2NF using SQL tables.
-- ==========================================================

-- ----------------------------------------------------------
-- Step 1: Create the Database and Use It
-- ----------------------------------------------------------
CREATE DATABASE IF NOT EXISTS NormalizationDB;
USE NormalizationDB;

-- ----------------------------------------------------------
-- PART 1: Achieving First Normal Form (1NF)
-- ----------------------------------------------------------
-- The original ProductDetail table contains repeating groups
-- in the 'Products' column. We normalize this by creating 
-- a new table with atomic values (one product per row).
-- ----------------------------------------------------------

-- Drop table if it exists to avoid duplication errors
DROP TABLE IF EXISTS ProductDetail_1NF;

-- Create normalized ProductDetail table (1NF)
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(50)
);

-- Insert data: each product is a separate row
INSERT INTO ProductDetail_1NF VALUES (101, 'John Doe', 'Laptop');
INSERT INTO ProductDetail_1NF VALUES (101, 'John Doe', 'Mouse');
INSERT INTO ProductDetail_1NF VALUES (102, 'Jane Smith', 'Tablet');
INSERT INTO ProductDetail_1NF VALUES (102, 'Jane Smith', 'Keyboard');
INSERT INTO ProductDetail_1NF VALUES (102, 'Jane Smith', 'Mouse');
INSERT INTO ProductDetail_1NF VALUES (103, 'Emily Clark', 'Phone');

-- ----------------------------------------------------------
-- PART 2: Achieving Second Normal Form (2NF)
-- ----------------------------------------------------------
-- We take the 1NF version of OrderDetails and split it into:
-- 1. Orders table: Contains OrderID and CustomerName
-- 2. OrderItems table: Contains OrderID, Product, and Quantity
-- This removes partial dependencies and satisfies 2NF.
-- ----------------------------------------------------------

-- Drop tables if they exist
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;

-- Create Orders table to store OrderID and CustomerName
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Create OrderItems table to store items in each order
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(50),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert data into Orders (no redundancy in customer names)
INSERT INTO Orders VALUES (101, 'John Doe');
INSERT INTO Orders VALUES (102, 'Jane Smith');
INSERT INTO Orders VALUES (103, 'Emily Clark');

-- Insert data into OrderItems (full dependency on OrderID + Product)
INSERT INTO OrderItems VALUES (101, 'Laptop', 2);
INSERT INTO OrderItems VALUES (101, 'Mouse', 1);
INSERT INTO OrderItems VALUES (102, 'Tablet', 3);
INSERT INTO OrderItems VALUES (102, 'Keyboard', 1);
INSERT INTO OrderItems VALUES (102, 'Mouse', 2);
INSERT INTO OrderItems VALUES (103, 'Phone', 1);


-- ----------------------------------------------------------
-- Retrieve Full Order Details with JOIN (2NF Tables)
-- ----------------------------------------------------------
-- This query joins Orders and OrderItems to show:
-- OrderID, CustomerName, Product, and Quantity
-- ----------------------------------------------------------

SELECT 
    o.OrderID,
    o.CustomerName,
    oi.Product,
    oi.Quantity
FROM 
    Orders o
JOIN 
    OrderItems oi ON o.OrderID = oi.OrderID
ORDER BY 
    o.OrderID, oi.Product;

