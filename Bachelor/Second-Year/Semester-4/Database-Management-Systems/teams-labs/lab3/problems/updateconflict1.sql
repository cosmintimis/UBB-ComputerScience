BEGIN TRAN
SELECT * from Customer
WAITFOR delay '00:00:10'
UPDATE CUSTOMER SET customer_address = 'dunarii222' where customer_name = 'razvan'
COMMIT TRAN