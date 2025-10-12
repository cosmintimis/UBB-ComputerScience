select * from DriverRating
select * from Customer
select * from DeliveryDriver


ALTER TABLE Customer
ADD customer_code INT UNIQUE;

ALTER TABLE DeliveryDriver
ADD delivery_driver_code INT;

exec deleteAllRows Customer
exec deleteAllRows DeliveryDriver
exec deleteAllRows DriverRating

exec insertTestData Customer, 1000
exec insertTestData DeliveryDriver, 1000
exec insertTestData DriverRating, 1000

exec sp_helpindex Customer
exec sp_helpindex DeliveryDriver
exec sp_helpindex DriverRating


--- a) 


select * from Customer --- clustered index scan (retrives all rows)

select * from Customer where customer_id < 100 -- clustered index seek (retrieves selective rows)

select customer_code from Customer -- nonclustered index scan;

select customer_code from Customer where customer_code < 100 -- nonclustered index seek;

select customer_name from Customer where customer_code = 2 --- key lookup + uncl index seek;

--- b)

select delivery_driver_name, phone_number, delivery_driver_code from DeliveryDriver where delivery_driver_code = 10 -- cl index scan: estimated cpu cost -> 0.001257 without index
                                                                                                                    -- uncl index seek: estimated cpu cost -> 0.0001581 with index 0.0001581

create nonclustered index deliveryDriverCodeIndex on DeliveryDriver(delivery_driver_code) INCLUDE(delivery_driver_name, phone_number)
drop index deliveryDriverCodeIndex on DeliveryDriver


--- c)

go
create or alter view view1
AS
    select COUNT(*) as NumberOfRatings
    from Customer C inner join DriverRating DR on C.customer_id = DR.customer_id
    where DR.rating = 2
    GROUP BY DR.customer_id
go

select * from view1

create index driverRatingIndex on DriverRating(rating) INCLUDE (customer_id)
drop index driverRatingIndex on DriverRating

-- without new creating index: 0.00402467
-- with new creating index: 0.00314467

exec sp_helpindex DriverRating