CREATE TABLE DatabaseVersion
(
    current_version int PRIMARY KEY DEFAULT 0 
);
INSERT INTO DatabaseVersion(current_version) VALUES(0);

CREATE TABLE TestTable
(
    id INT unique not null,
    full_name VARCHAR(255),
    date_of_birth DATE,
    email VARCHAR(255),
    account_balance DECIMAL(10, 2)
);

CREATE TABLE TestTable2
(
    id INT PRIMARY KEY,
    test_table_id INT
);

-- a. modify the type of a column;

GO
CREATE PROCEDURE changeColumnType
AS
BEGIN
    ALTER TABLE TestTable ALTER COLUMN date_of_birth DATETIME;
END

GO
CREATE PROCEDURE revertColumnType
AS
BEGIN
    ALTER TABLE TestTable ALTER COLUMN date_of_birth DATE;
END

GO
EXEC changeColumnType
GO
EXEC revertColumnType

-- b. add / remove a column;

GO
CREATE PROCEDURE addColumn
AS
BEGIN
    ALTER TABLE TestTable ADD adress VARCHAR(100);
END

GO
CREATE PROCEDURE removeColumn
AS
BEGIN
    ALTER TABLE TestTable DROP COLUMN adress;
END

GO
EXEC addColumn
GO
EXEC removeColumn


-- c. add / remove a DEFAULT constraint;

GO
CREATE PROCEDURE addDefaultConstraint
AS
BEGIN
    ALTER TABLE TestTable ADD CONSTRAINT df_account_balance DEFAULT 0.00 FOR account_balance;
END

GO
CREATE PROCEDURE removeDefaultConstraint
AS
BEGIN
    ALTER TABLE TestTable DROP CONSTRAINT df_account_balance;
END

GO
EXEC addDefaultConstraint
GO
EXEC removeDefaultConstraint


-- d. add / remove a primary key;
GO
CREATE PROCEDURE addPrimaryKey
AS 
BEGIN
    ALTER TABLE TestTable ADD CONSTRAINT pk_id PRIMARY KEY (id);
END

GO
CREATE PROCEDURE removePrimaryKey
AS 
BEGIN
    ALTER TABLE TestTable DROP CONSTRAINT pk_id;
END

GO
EXEC addPrimaryKey
GO
EXEC removePrimaryKey

-- e. add / remove a candidate key;

GO
CREATE PROC addCandidateKey
AS
BEGIN
    ALTER TABLE TestTable ALTER COLUMN full_name VARCHAR(255) NOT NULL;
    ALTER TABLE TestTable ADD CONSTRAINT uc_full_name UNIQUE (full_name);
END

GO
CREATE PROC removeCandidateKey
AS
BEGIN
    ALTER TABLE TestTable DROP CONSTRAINT uc_full_name;
    ALTER TABLE TestTable ALTER COLUMN full_name VARCHAR(255);
END

GO
EXEC addCandidateKey
GO
EXEC removeCandidateKey

-- f. add / remove a foreign key;

GO
CREATE PROC addForeignKey
AS
BEGIN
    ALTER TABLE TestTable2 ADD CONSTRAINT fk_test_table_id FOREIGN KEY(test_table_id) REFERENCES TestTable(id);
END

GO
CREATE PROC removeForeignKey
AS
BEGIN
    ALTER TABLE TestTable2 DROP CONSTRAINT fk_test_table_id;
END

GO
EXEC addForeignKey
GO
EXEC removeForeignKey

-- g. create / drop a table.

GO
CREATE PROC createTable
AS
BEGIN
CREATE TABLE Voucher(
    voucher_id INT PRIMARY KEY,
    code VARCHAR(20) UNIQUE,
    voucher_description VARCHAR(200),
    voucher_expiry_date DATETIME,
    discount_value SMALLMONEY,
    customer_id INT FOREIGN KEY REFERENCES Customer(customer_id)
);
END

GO
CREATE PROC dropTable
AS
BEGIN
    DROP TABLE Voucher;
END

GO
EXEC createTable
GO
EXEC dropTable

GO
CREATE PROCEDURE switchVersion
    (@desiredVersion INT)
AS
BEGIN
    DECLARE @currentVersion INT;
    DECLARE @sql NVARCHAR(100);
    SELECT @currentVersion = current_version
    FROM DatabaseVersion;

    WHILE @currentVersion < @desiredVersion
    BEGIN
        SET @currentVersion = @currentVersion + 1;

        SET @sql = 
            CASE 
                WHEN @currentVersion = 1 THEN 'EXEC changeColumnType;'
                WHEN @currentVersion = 2 THEN 'EXEC addColumn;'
                WHEN @currentVersion = 3 THEN 'EXEC addDefaultConstraint;'
                WHEN @currentVersion = 4 THEN 'EXEC addPrimaryKey;'
                WHEN @currentVersion = 5 THEN 'EXEC addCandidateKey;'
                WHEN @currentVersion = 6 THEN 'EXEC addForeignKey;'
                WHEN @currentVersion = 7 THEN 'EXEC createTable;'
            END;

        EXEC sp_executesql @sql;
    END;

    WHILE @currentVersion > @desiredVersion
    BEGIN
        
        SET @sql = 
            CASE 
                WHEN @currentVersion = 1 THEN 'EXEC revertColumnType;'
                WHEN @currentVersion = 2 THEN 'EXEC removeColumn;'
                WHEN @currentVersion = 3 THEN 'EXEC removeDefaultConstraint;'
                WHEN @currentVersion = 4 THEN 'EXEC removePrimaryKey;'
                WHEN @currentVersion = 5 THEN 'EXEC removeCandidateKey;'
                WHEN @currentVersion = 6 THEN 'EXEC removeForeignKey;'
                WHEN @currentVersion = 7 THEN 'EXEC dropTable;'
            END;

        EXEC sp_executesql @sql;

        SET @currentVersion = @currentVersion - 1;
    END;
    UPDATE DatabaseVersion
    SET current_version = @currentVersion
END;

DROP PROC switchVersion

GO
EXEC switchVersion 1;

GO 
EXEC switchVersion 7;

GO
EXEC switchVersion 2;

GO
EXEC switchVersion 0;