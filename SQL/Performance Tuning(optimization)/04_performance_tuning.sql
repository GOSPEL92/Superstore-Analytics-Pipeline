--04_performance_tuning.sql

--Performance Tuning(optimization)

-- Index to speed up joins between Orders and OrderDetails

CREATE INDEX idx_OrderDetails_OrderId ON OrderDetails(order_id);

-- Index to speed up joins between OrderDetails and Products

CREATE INDEX idx_OrderDetails_ProductId ON OrderDetails(product_id);

-- Index to speed up queries filtering by region
CREATE INDEX idx_Customers_RegionName ON Customers(region_name);


--Run  with execution plan enabled

--1. Top 10 Customers by Sales, Shows who your most valuable customers are.
SELECT TOP 10 
       c.customer_id,
       c.customer_name,
       SUM(od.sales) AS TotalSales
FROM Orders o
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY TotalSales DESC;
