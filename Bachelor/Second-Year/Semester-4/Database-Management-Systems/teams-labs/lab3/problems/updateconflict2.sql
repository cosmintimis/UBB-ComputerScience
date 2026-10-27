
SET TRAN ISOLATION LEVEL SNAPSHOT
BEGIN TRAN
WAITFOR delay '00:00:10'
UPDATE CUSTOMER SET customer_address = 'dunarii1' where customer_name = 'razvan'
WAITFOR delay '00:00:10'
COMMIT TRAN
