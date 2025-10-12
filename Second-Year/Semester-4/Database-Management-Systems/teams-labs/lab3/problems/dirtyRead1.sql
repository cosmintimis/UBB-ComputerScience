-- Dirty Reads
-- T1: update + delay + rollback
-- T2: select + delay + select

BEGIN TRAN
UPDATE Customer SET customer_address='test'
where customer_id = 10
WAITFOR DELAY '00:00:10'
ROLLBACK TRAN