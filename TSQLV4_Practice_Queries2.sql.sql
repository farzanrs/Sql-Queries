


drop table dbo.orders
CREATE TABLE dbo.orders (
    orderid INT PRIMARY KEY,
    orderdate DATE,
    empid INT,
    custid CHAR(1),
    qty INT
);
INSERT INTO dbo.orders (orderid, orderdate, empid, custid, qty) VALUES
(10001, '2014-12-24', 2, 'A', 12),
(10005, '2014-12-24', 1, 'B', 20),
(10006, '2015-01-18', 1, 'C', 14),
(20001, '2015-02-12', 2, 'B', 12),
(20002, '2016-02-16', 1, 'C', 20),
(30001, '2014-08-02', 3, 'A', 10),
(30003, '2016-04-18', 2, 'B', 15),
(30004, '2014-04-18', 3, 'C', 22),
(30007, '2016-09-07', 3, 'D', 30),
(40001, '2015-01-09', 2, 'A', 40),
(40005, '2016-02-12', 3, 'A', 10);


--1
SELECT 
    custid, 
    qty,
    RANK() OVER (PARTITION BY custid ORDER BY qty DESC) AS SalesRank,
    DENSE_RANK() OVER (PARTITION BY custid ORDER BY qty DESC) AS DenseSalesRank
FROM 
    dbo.orders;


--2 
SELECT DISTINCT 
    val, 
    DENSE_RANK() OVER(ORDER BY val) AS rownum
FROM Sales.OrderValues;


--3

SELECT 
    custid, 
    orderid, 
    qty,
    -- اختلاف مقدار فعلی با مقدار قبلی
    qty - LAG(qty) OVER (PARTITION BY custid ORDER BY orderid) AS diffprev,
    
    -- اختلاف مقدار فعلی با مقدار بعدی
    qty - LEAD(qty) OVER (PARTITION BY custid ORDER BY orderid) AS diffnext
FROM 
    dbo.orders;


--4 
SELECT 
    empid, 
    [2014] AS cnt2014, 
    [2015] AS cnt2015, 
    [2016] AS cnt2016
FROM (
    -- این بخش داده‌ها را آماده می‌کند تا سال‌ها به عنوان ستون شناخته شوند
    SELECT 
        empid, 
        YEAR(orderdate) AS orderYear
    FROM dbo.orders
) AS SourceTable
PIVOT (
    -- تابعی که برای شمارش استفاده می‌شود و ستونی که باید چرخانده شود
    COUNT(orderYear) 
    FOR orderYear IN ([2014], [2015], [2016])
) AS PivotTable;


