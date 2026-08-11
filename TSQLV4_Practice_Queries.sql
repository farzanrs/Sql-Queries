--1
/* ?? ???? word  ????? ???? ??? ???  */

--1
USE TSQLV4;
GO

SELECT orderid, orderdate, custid, empid,
  DATEFROMPARTS(YEAR(orderdate), 12, 31) AS endofyear
FROM Sales.Orders
WHERE orderdate <> DATEFROMPARTS(YEAR(orderdate), 12, 31);

--2.1
USE TSQLV4;
GO

SELECT empid, MAX(orderdate) AS LastOrderDate
FROM Sales.Orders
GROUP BY empid;

--2.2
USE TSQLV4;
GO
SELECT O.orderid, O.orderdate, O.empid, O.custid
FROM Sales.Orders AS O
INNER JOIN (
    -- ??? ??? ???? Derived Table ??? ?? ????? ????? ?? ??????? ?? ???????
    SELECT empid, MAX(orderdate) AS MaxDate
    FROM Sales.Orders
    GROUP BY empid
) AS LastOrders ON O.empid = LastOrders.empid 
               AND O.orderdate = LastOrders.MaxDate;

--3-1
USE TSQLV4;
GO

SELECT 
    custid, 
    orderid, 
    orderdate,
    ROW_NUMBER() OVER(PARTITION BY custid ORDER BY orderdate, orderid) AS RowNum
FROM Sales.Orders;
go

--3-2
WITH CustomerOrderRanks AS ( 
    SELECT custid, orderid, orderdate,
    ROW_NUMBER() OVER(PARTITION BY custid ORDER BY orderdate, orderid) AS RowNum
    FROM Sales.Orders
)
SELECT * 
FROM CustomerOrderRanks
WHERE RowNum BETWEEN 11 AND 20;
go

-- 4 (Optional, Advanced)

--5-1
USE TSQLV4;
GO
CREATE VIEW Sales.VEmpOrders AS
SELECT 
    O.empid, 
    YEAR(O.orderdate) AS orderyear, 
    SUM(OD.qty) AS TotalQty
FROM Sales.Orders AS O
INNER JOIN Sales.OrderDetails AS OD ON O.orderid = OD.orderid
GROUP BY O.empid, YEAR(O.orderdate);
GO

-- ???? ??? ???? ??? (???????? ?? ?? ???? ???? ?????? ???):
SELECT * FROM Sales.VEmpOrders ORDER BY empid, orderyear;
go

--6-1
USE TSQLV4;
GO
CREATE FUNCTION Production.TopProducts (@n INT, @supid INT)
RETURNS TABLE
AS
RETURN 
(
    SELECT TOP (@n) 
        productid, 
        productname, 
        unitprice
    FROM Production.Products
    WHERE supplierid = @supid
    ORDER BY unitprice DESC
);

SELECT * FROM Production.TopProducts(5, 2);
GO

--6-2
USE TSQLV4;
GO
SELECT 
    S.supplierid, 
    S.companyname, 
    P.productid, 
    P.productname, 
    P.UnitPrice
FROM Production.Suppliers AS S
CROSS APPLY Production.TopProducts(2, S.supplierid) AS P;

DROP VIEW IF EXISTS Sales.VEmpOrders;
DROP FUNCTION IF EXISTS Production.TopProducts;



