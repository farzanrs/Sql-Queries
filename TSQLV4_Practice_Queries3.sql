--3
CREATE PROCEDURE sp_GetCustomerSales_Cursor
AS
BEGIN
    SET NOCOUNT ON;

    -- تعریف متغیرها برای ذخیره اطلاعات هر مشتری در هر دور از حلقه
    DECLARE @CustID INT;
    DECLARE @CustName NVARCHAR(100);

    -- 1. تعریف کرسر برای پیمایش لیست تمام مشتریان
    -- ما ID و نام شرکت را می‌گیریم تا در خروجی مشخص باشد هر لیست مربوط به کیست
    DECLARE cust_cursor CURSOR FOR 
    SELECT custid, companyname FROM Sales.Customers;

    -- 2. باز کردن کرسر
    OPEN cust_cursor;

    -- 3. خواندن اولین رکورد
    FETCH NEXT FROM cust_cursor INTO @CustID, @CustName;

    -- 4. حلقه تا زمانی که رکوردی برای خواندن باشد
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- چاپ یک خط جداکننده برای زیبایی خروجی
        PRINT '-------------------------------------------';
        PRINT 'Sales for Customer: ' + @CustName + ' (ID: ' + CAST(@CustID AS VARCHAR) + ')';
        PRINT '-------------------------------------------';

        -- نمایش تمام فروش‌های مربوط به این مشتری خاص
        -- اینجا یک کوئری ساده می‌زنیم تا لیست سفارشات این مشتری چاپ شود
        SELECT orderid, orderdate
        FROM Sales.Orders 
        WHERE custid = @CustID;

        -- اگر این مشتری هیچ خریدی نداشته باشد، لیست خالی نمایش داده می‌شود
        
        -- خواندن رکورد بعدی برای ادامه حلقه
        FETCH NEXT FROM cust_cursor INTO @CustID, @CustName;
    END;

    -- 5. بستن و حذف کرسر از حافظه
    CLOSE cust_cursor;
    DEALLOCATE cust_cursor;
END;

EXEC sp_GetCustomerSales_Cursor;
