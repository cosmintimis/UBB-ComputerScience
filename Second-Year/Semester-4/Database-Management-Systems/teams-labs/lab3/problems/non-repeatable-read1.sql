BEGIN TRAN
WAITFOR DELAY '00:00:05'
UPDATE CUSTOMER SET customer_address = 'cluj2'
where customer_name = 'Cosmin'
COMMIT TRAN