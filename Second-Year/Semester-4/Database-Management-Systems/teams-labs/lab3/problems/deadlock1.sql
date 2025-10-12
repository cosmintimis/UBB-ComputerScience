begin TRAN
update Customer set customer_name='razvan' where customer_id = 10
waitfor delay '00:00:10'
update Restaurant set restaurant_name = 'restaurant2' where restaurant_id = 4
commit tran