BEGIN TRAN
WAITFOR DELAY '00:00:04'
INSERT INTO Customer (customer_name, customer_address, phone_number, email_address)
        VALUES ('customer1', 'test1', '0000000000', 'test1@gmail.ro');
COMMIT TRAN