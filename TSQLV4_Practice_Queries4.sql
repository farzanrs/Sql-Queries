ALTER PROCEDURE sp_LockCustomers
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

    BEGIN TRANSACTION;
        -- استفاده از XLOCK برای گرفتن قفل انحصاری
        SELECT *  FROM Sales.Customers WITH (XLOCK);
        WAITFOR DELAY '00:00:30'; 
    COMMIT TRANSACTION;
END;
go

CREATE PROCEDURE sp_GetLastCommittedOrders
AS
BEGIN
    -- تنظیم لول ایزولاسیون روی SNAPSHOT 
    -- این لول باعث می‌شود آخرین نسخه Commit شده (صحیح) را ببینیم
    SET TRANSACTION ISOLATION LEVEL SNAPSHOT;

    BEGIN TRANSACTION;
        SELECT * FROM Sales.Orders;
    COMMIT TRANSACTION;
END;


