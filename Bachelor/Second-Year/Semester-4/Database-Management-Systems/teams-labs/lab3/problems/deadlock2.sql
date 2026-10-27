
begin TRAN
update Restaurant set restaurant_name = 'restaurant2' where restaurant_id = 4
waitfor delay '00:00:10'
update Customer set customer_name='razvan' where customer_id = 10
commit tran