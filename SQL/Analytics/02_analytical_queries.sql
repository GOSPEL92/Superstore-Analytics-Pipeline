--02_analytical_queries.sql

-- Analytical Queries


--1. Top 10 Customers by Sales, this Shows who your most valuable customers are.
SELECT TOP 10 
       c.customer_id,
       c.customer_name,
       SUM(od.sales) AS TotalSales
FROM Orders o
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY TotalSales DESC;


--2. Top 10 Products by Profit, this Highlights which products drive profitability.
SELECT TOP 10 
       p.product_id,
       p.product_name,
       SUM(od.profit) AS TotalProfit
FROM OrderDetails od
JOIN Products p ON od.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY TotalProfit DESC;


--3. Sales by Region Over Time, this Lets you see trends and compare regions.
SELECT r.region_name,
       YEAR(o.order_date) AS Year,
       MONTH(o.order_date) AS Month,
       SUM(od.sales) AS MonthlySales
FROM Orders o
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Regions r ON c.region_name = r.region_name
GROUP BY r.region_name, YEAR(o.order_date), MONTH(o.order_date)
ORDER BY Year, Month, r.region_name;

-- Which product category drives the most sales?

SELECT 
    p.category,
    p.subcategory,
    SUM(o.sales) AS total_sales,
    SUM(o.profit) AS total_profit
FROM Products p
JOIN OrderDetails o
    ON p.product_id = o.product_id
GROUP BY p.category, p.subcategory
ORDER BY total_profit DESC;

-- Average shipping delay
SELECT 
    c.region_name,
    AVG(DATEDIFF(day, o.order_date, o.ship_date)) AS avg_shipping_delay
FROM Orders o
JOIN Customers c
    ON o.customer_id = c.customer_id
GROUP BY c.region_name
ORDER BY avg_shipping_delay DESC;

--Highest Profit Margins
SELECT 
    p.product_name,
    SUM(o.sales) AS total_sales,
    SUM(o.profit) AS total_profit,
    (SUM(o.profit) * 1.0 / SUM(o.sales)) AS profit_margin
FROM Products p
JOIN OrderDetails o
    ON p.product_id = o.product_id
GROUP BY p.product_name
HAVING SUM(o.sales) > 0
ORDER BY profit_margin DESC;
