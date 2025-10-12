Select *
from RestaurantReview

drop TABLE RestaurantReview

/*
modify restaurantReview table to contain a multicolumn primary key
*/
CREATE TABLE RestaurantReview
(
    customer_id INT FOREIGN KEY REFERENCES Customer(customer_id) NOT NULL,
    restaurant_id INT FOREIGN KEY REFERENCES Restaurant(restaurant_id) NOT NULL,
    rating DECIMAL(2,1) check (rating >= 0 and rating <= 5),
    comment VARCHAR(500),
    restaurant_review_date DATETIME NOT NULL UNIQUE,
    PRIMARY KEY(customer_id, restaurant_id, restaurant_review_date)

);

Select *
from Customer
select *
from Voucher
select *
from RestaurantReview


go
create or alter view firstView
as
    select *
    from Customer
go
select *
from firstView

go
create or alter view secondView
as
    select DISTINCT C.customer_name, C.customer_address, C.phone_number, C.email_address
    from Customer C inner join Voucher V on C.customer_id = V.customer_id
go

create or alter view thirdView
as
    select C.customer_id, C.customer_name, count(*) as NumberOfReviews
    from RestaurantReview R
        inner join Customer C on C.customer_id = R.customer_id
    group by C.customer_id, C.customer_name
go


create or alter procedure executeView
    (@name varchar(100))
as
begin
    declare @sql varchar(250) = 'select * from ' + @name
    exec(@sql)
end

exec executeView thirdView

insert into Tables
    (Name)
VALUES
    ('Customer'),
    ('Voucher'),
    ('RestaurantReview')

select *
from Tables

insert into Views
    (Name)
VALUES
    ('firstView'),
    ('secondView'),
    ('thirdView')

insert into Tests
    (Name)
VALUES
    ('Test1');

Select *
from Tests

DBCC CHECKIDENT ('Tests', RESEED, 0)

delete from Tests

insert into TestViews
VALUES
    (1, 1),
    (1, 2),
    (1, 3)

select *
from TestViews
delete from TestViews
insert into TestTables
VALUES
    (1, 1, 100, 3),
    (1, 2, 100, 2),
    (1, 3, 100, 1);

select *
from TestTables
delete from TestTables


go
CREATE OR ALTER PROCEDURE deleteAllRows
    @TableName NVARCHAR(128)
AS
BEGIN
    DECLARE @script NVARCHAR(MAX)

    IF EXISTS (SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME = @TableName)
    BEGIN
        SET @script = 'DELETE FROM ' + QUOTENAME(@TableName)

        EXEC sp_executesql @script
    END
    ELSE
    BEGIN
        RAISERROR('Table does not exist.', 10, 1)
    END
END




go
CREATE OR ALTER PROCEDURE insertTestData
    @TableName NVARCHAR(255),
    @NumberOfRows INT
AS
BEGIN
    DECLARE @Columns NVARCHAR(MAX);
    DECLARE @Values NVARCHAR(MAX);
    DECLARE @Sql NVARCHAR(MAX);
    DECLARE @Counter INT = 1;

    DECLARE @colName VARCHAR
    (100);
    DECLARE @colDatatype VARCHAR
    (100);

    DECLARE @DynamicSQL NVARCHAR(MAX);
    DECLARE @DynamicResult NVARCHAR(MAX);
    DECLARE @ForeignKeyTable VARCHAR(100);

    DECLARE curDatatype cursor
    FOR SELECT column_name, data_type
    FROM information_schema.columns
    WHERE table_name=@TableName
    ORDER BY ORDINAL_POSITION;

    WHILE @Counter <= @NumberOfRows
    BEGIN

        OPEN curDatatype;

        SET @Columns = '';
        SET @Values = '';

        FETCH NEXT FROM curDatatype INTO @colName, @colDatatype;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @ForeignKeyTable = (SELECT
                KCU2.TABLE_NAME
            FROM
                INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS RC
                JOIN
                INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU1
                ON RC.CONSTRAINT_NAME = KCU1.CONSTRAINT_NAME
                JOIN
                INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU2
                ON RC.UNIQUE_CONSTRAINT_NAME = KCU2.CONSTRAINT_NAME
            WHERE 
                                        KCU1.TABLE_NAME = @TableName
                AND KCU1.COLUMN_NAME = @colName);

            SET @DynamicResult = '';
            IF @ForeignKeyTable != ''
                BEGIN
                SET @DynamicSQL = '
        SET @DynamicResult += (SELECT TOP 1 ' + QUOTENAME(@colName) + ' 
                               FROM ' + QUOTENAME(@ForeignKeyTable) + ');';
                EXEC sp_executesql @DynamicSQL, N'@DynamicResult NVARCHAR(MAX) OUTPUT', @DynamicResult OUTPUT;
            END


            SET @Columns = @Columns + @colName + ', ';
            SET @Values = @Values +
                    CASE 
                        WHEN @colDatatype IN ('int', 'smallmoney', 'tinyint', 'mediumint') THEN
                        CASE
                            WHEN @ForeignKeyTable != '' THEN @DynamicResult
                            ELSE CAST(@Counter AS NVARCHAR(MAX))
                        END  
                        WHEN @colDatatype = 'varchar' THEN '''' + LEFT(CAST(NEWID() AS NVARCHAR(MAX)), 20) + ''''
                        WHEN @colDatatype = 'datetime' THEN '''' + CONVERT(NVARCHAR(MAX), DATEADD(DAY, ABS(CHECKSUM(NEWID())) % (DATEDIFF(DAY, '1753-01-01', '9999-12-31') + 1), '1753-01-01'), 120) + ''''
                        WHEN @colDatatype = 'decimal' THEN CAST(@Counter % 5 + 1 AS NVARCHAR(MAX))
                        ELSE NULL
                    END + ', ';

            FETCH NEXT FROM curDatatype INTO @colName, @colDatatype;
        END

        CLOSE curDatatype;

        SET @Columns = LEFT(@Columns, LEN(@Columns) - 1);
        SET @Values = LEFT(@Values, LEN(@Values) - 1);

        SET @Sql = 'INSERT INTO ' + @TableName + ' (' + @Columns + ') ' + 'SELECT ' + @Values;

        -- PRINT(@Sql)

        EXEC sp_executesql @Sql;

        SET @Counter = @Counter + 1;
    END

    DEALLOCATE curDatatype
END;


select *
from INFORMATION_SCHEMA.COLUMNS

select *
from INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS

select *
from INFORMATION_SCHEMA.KEY_COLUMN_USAGE

select *
from Customer
select *
from Voucher
select *
from RestaurantReview

select *
from Restaurant

exec insertTestData Customer,2

exec insertTestData Voucher, 100

exec insertTestData RestaurantReview, 20

exec deleteAllRows Customer
exec deleteAllRows Voucher
exec deleteAllRows RestaurantReview

select *
from Tests

select *
from TestTables


GO
create or alter procedure deletingData
    @testId INT
as
BEGIN

    declare deleteCursor CURSOR FOR
    select T.Name
    from TestTables TT inner join Tables T on TT.TableID = T.TableID
    where TT.TestID = @testId
    order by TT.[Position] ASC

    DECLARE @tableName VARCHAR(100);
    DECLARE @DynamicSQL NVARCHAR(MAX);

    open deleteCursor;

    fetch deleteCursor into @tableName

    while @@FETCH_STATUS = 0
	begin
        SET @DynamicSQL = 'exec deleteAllRows ' + QUOTENAME(@tableName);
        exec sp_executesql @DynamicSQL;
        fetch deleteCursor into @tableName
    end

    close deleteCursor
    DEALLOCATE deleteCursor

END;

exec deletingData 1


GO
create or alter procedure insertingData
    @testId INT,
    @testRunId INT
as
BEGIN

    declare insertCursor CURSOR FOR
    select T.Name, TT.NoOfRows, TT.TableID
    from TestTables TT inner join Tables T on TT.TableID = T.TableID
    where TT.TestID = @testId
    order by TT.[Position] DESC

    DECLARE @tableName VARCHAR(100);
    DECLARE @noOfRows INT;
    DECLARE @tableId INT;
    DECLARE @DynamicSQL NVARCHAR(MAX);

    open insertCursor;

    fetch insertCursor into @tableName, @noOfRows, @tableId;

    while @@FETCH_STATUS = 0
	begin
        SET @DynamicSQL = 'exec insertTestData ' + QUOTENAME(@tableName) + ', ' + CAST(@noOfRows as nvarchar(max));

        declare @startTime datetime = GETDATE();

        exec sp_executesql @DynamicSQL;

        declare @endTime datetime = GETDATE();

        insert into TestRunTables
            (TestRunID, TableID, StartAt, EndAt)
        values
            (@testRunId, @tableId, @startTime, @endTime)

        fetch insertCursor into @tableName, @noOfRows, @tableId;
    end

    close insertCursor
    DEALLOCATE insertCursor

END;

exec insertingData 1, 1

GO
create or alter procedure evaluatingViews
    @testId INT,
    @testRunId INT
as
BEGIN

    declare evaluatingCursor CURSOR FOR
    select V.Name, V.ViewID
    from Views V INNER JOIN TestViews TV on V.ViewID = TV.ViewID
    where TV.TestID = @testId
    DECLARE @viewName VARCHAR(100);
    DECLARE @viewId INT;
    DECLARE @DynamicSQL NVARCHAR(MAX);

    open evaluatingCursor;

    fetch evaluatingCursor into @viewName, @viewId;

    while @@FETCH_STATUS = 0
	begin
        SET @DynamicSQL = 'select * from ' + QUOTENAME(@viewName);

        declare @startTime datetime = GETDATE();

        exec sp_executesql @DynamicSQL;

        declare @endTime datetime = GETDATE();

        insert into TestRunViews
            (TestRunID, ViewID, StartAt, EndAt)
        values
            (@testRunId, @viewId, @startTime, @endTime);

        fetch evaluatingCursor into @viewName, @viewId;
    end

    close evaluatingCursor
    DEALLOCATE evaluatingCursor

END;

go
create or alter procedure runTest
    @TestId INT
as
begin

    DECLARE @count INT = (SELECT COUNT(*)
    FROM Tests T
    WHERE T.TestID = @TestId )

    IF @count < 1
    BEGIN
        RAISERROR('Invalid test id !', 10, 1);
        RETURN;
    END

    declare @testName VARCHAR(100) = (select T.Name
    from Tests T
    where T.TestID = @TestId)
    insert into TestRuns
        (startAt)
    values(getdate())
    declare @testRunId int = SCOPE_IDENTITY()
    exec deletingData @TestId
    exec insertingData @TestId, @testRunId
    exec evaluatingViews @TestId, @testRunId

    update TestRuns set Description =  @testName +  ' --> delete && insert && view', EndAt = GETDATE() where TestRunID = @testRunId

    select *
    from TestRunTables
    select *
    from TestRunViews
    select *
    from TestRuns
end

exec runTest 1

select *
from Tests
select *
from Views
select *
from Tables

select *
from TestViews
select *
from TestTables

delete from TestRuns
delete from TestRunViews
delete from TestRunTables


DBCC CHECKIDENT ('TestRuns', RESEED, 0)