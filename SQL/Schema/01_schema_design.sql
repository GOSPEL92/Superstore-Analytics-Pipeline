-- 01_schema_design.sql
-- I Creates normalized tables for Customers, Orders, Products
-- 1. Create Regions table
CREATE TABLE Regions (
    region_name VARCHAR(100) PRIMARY KEY
);

INSERT INTO Regions (region_name)
SELECT DISTINCT region
FROM superstore_clean;

--2.create Customers table
CREATE TABLE Customers (
    customer_id VARCHAR(20) PRIMARY KEY,   -- LS-172304 style IDs
    customer_name VARCHAR(150) NOT NULL,
    segment VARCHAR(50),
    region_name VARCHAR(100),
    FOREIGN KEY (region_name) REFERENCES Regions(region_name)
);

-- Insert Customers table

INSERT INTO Customers (customer_id, customer_name, segment, region_name)
SELECT 
    customer_id,
    MAX(customer_name) AS customer_name,
    MAX(segment) AS segment,
    MAX(region) AS region_name
FROM superstore_clean
GROUP BY customer_id;

--3. Create Products Table (deduplicated by product_id):
CREATE TABLE Products (
    product_id VARCHAR(20) PRIMARY KEY,    -- OFF-PA-10002005 style IDs
    product_name VARCHAR(200) NOT NULL,
    category VARCHAR(100),
    subcategory VARCHAR(100)
);

INSERT INTO Products (product_id, product_name, category, subcategory)
SELECT product_id,
       MAX(product_name) AS product_name,
       MAX(category) AS category,
       MAX([sub_category]) AS subcategory   -- use brackets for hyphenated column
FROM superstore_clean
GROUP BY product_id;

DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS Orders;

--4. create Orders Tables
--Create Orders (Header Table)
CREATE TABLE Orders (
    order_id VARCHAR(20) PRIMARY KEY,
    order_date DATE NOT NULL,
    ship_date DATE NOT NULL,
    customer_id VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Orders (order_id, order_date, ship_date, customer_id)
SELECT order_id,
       MAX(order_date) AS order_date,
       MAX(ship_date) AS ship_date,
       MAX(customer_id) AS customer_id
FROM superstore_clean
GROUP BY order_id;

--5. Create OrderDetails (Line Items Table)
CREATE TABLE OrderDetails (
    order_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id VARCHAR(20),
    product_id VARCHAR(20),
    sales DECIMAL(10,2),
    profit DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(5,2),
    shipping_cost DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO OrderDetails (order_id, product_id, sales, profit, quantity, discount, shipping_cost)
SELECT order_id, product_id, sales, profit, quantity, discount, shipping_cost
FROM superstore_clean;


--6. Verification Query 0f schame table
SELECT TOP 20 
       o.order_id,
       o.order_date,
       c.customer_id,
       c.customer_name,
       r.region_name,
       od.product_id,
       p.product_name,
       od.quantity,
       od.sales,
       od.profit
FROM Orders o
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Products p ON od.product_id = p.product_id
JOIN Regions r ON c.region_name = r.region_name
ORDER BY o.order_date;

--7. Verification & Row Counts of schame tables
SELECT 'Regions' AS TableName, COUNT(*) AS TotalRows FROM Regions
UNION ALL
SELECT 'Customers', COUNT(*) FROM Customers
UNION ALL
SELECT 'Products', COUNT(*) FROM Products
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders
UNION ALL
SELECT 'OrderDetails', COUNT(*) FROM OrderDetails;
