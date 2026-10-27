INSERT INTO Customer(customer_id, customer_name,customer_address,phone_number,email_address)
VALUES
(1, 'Timis Cosmin', 'Cluj-Napoca, Cluj, Str. Dunarii 20b', '0744194061', 'timis.cosmin@gmail.com'),
(2, 'Timis Alexandru', 'Cluj-Napoca, Cluj, Str. Bucuresti 5b', '0744179070', 'timis.alexandru@gmail.com'),
(3, 'Hojda Sebastian', 'Cluj-Napoca, Cluj, Str. Observatorului 146', '0744194142', 'hojda.sebastian@gmail.com'),
(4, 'Horj Gabriel', 'Cluj-Napoca, Cluj, Str. Arad 3', '0748121343', 'horj.gabriell@gmail.com'),
(5, 'Mihali Grigore', 'Cluj-Napoca, Cluj, Str. Galati 14', '0747924115', 'mihali.grigore@gmail.com'),
(6, 'Mihali Alexandra', 'Borsa, MM, Str. Vasile Alecsandri 14', '0748924155', 'mihali.alexandra@gmail.com');

INSERT INTO Restaurant (restaurant_id, restaurant_name, restaurant_description, phone_number, restaurant_hours, restaurant_address)
VALUES
(1, 'Ciao New York', 'Experience the flavors of New York in the heart of Cluj-Napoca', '0744123456', '10:00 AM - 10:00 PM', 'Cluj-Napoca, Cluj, Str. Eroilor 15'),
(2, 'Tokyo Japanese Restaurant', 'Embark on a culinary journey with authentic Japanese dishes', '0744987654', '11:30 AM - 9:00 PM', 'Cluj-Napoca, Cluj, Str. Memorandumului 8'),
(3, 'GARLIC bites and tales', 'Delight your senses with a unique blend of garlic-infused dishes', '0744556677', '12:00 PM - 8:30 PM', 'Cluj-Napoca, Cluj, Str. Horea 22'),
(4, 'Eggcetera', 'Discover a variety of egg-inspired dishes in a trendy urban setting', '0744332211', '9:00 AM - 11:00 PM', 'Cluj-Napoca, Cluj, Str. Universitatii 5'),
(5, 'Sage Bistro', 'Savor the richness of Mediterranean cuisine with a modern twist', '0744789652', '1:00 PM - 10:30 PM', 'Cluj-Napoca, Cluj, Str. Napoca 12');

INSERT INTO DeliveryDriver (delivery_driver_id, delivery_driver_name, phone_number, photo_url)
VALUES
(1, 'Pasca Iulian', '0755123456', 'https://example.com/pasca-iulian.jpg'),
(2, 'Danci Stefan', '0755987654', 'https://example.com/danci-stefan.jpg'),
(3, 'Stetco Vasile', '0755456677', 'https://example.com/stetco-vasile.jpg'),
(4, 'Roman Marian', '0755432211', 'https://example.com/roman-marian.jpg'),
(5, 'Timis Ilie', '0755789652', 'https://example.com/timis-ilie.jpg');

INSERT INTO FoodCategory (food_category_id, food_category_name)
VALUES
(1, 'Appetizers'),
(2, 'Main Course'),
(3, 'Desserts'),
(4, 'Beverages'),
(5, 'Vegetarian');

INSERT INTO MenuItem (menu_item_id, menu_item_name, menu_item_description, price, food_category_id, restaurant_id)
VALUES
(1, 'Margherita Pizza', 'Classic pizza with tomato sauce, mozzarella, and basil', 25, 2, 1),
(2, 'Sushi Platter', 'Assorted sushi rolls with soy sauce and wasabi', 48.50, 2, 2),
(3, 'Garlic Butter Shrimp', 'Sauteed shrimp in garlic butter sauce', 16.75, 1, 3),
(4, 'Vegetarian Pasta Primavera', 'Pasta with fresh vegetables and marinara sauce', 38, 5, 4),
(5, 'Chocolate Fondue', 'Assorted fruits dipped in rich chocolate sauce', 25, 3, 5),
(6, 'Chicken Alfredo', 'Creamy Alfredo sauce with grilled chicken over fettuccine', 34.50, 2, 4),
(7, 'Caesar Salad', 'Crisp romaine lettuce, croutons, and parmesan cheese with Caesar dressing', 29.25, 5, 1),
(8, 'Mango Tango Smoothie', 'Refreshing smoothie with mango, banana, and orange juice', 17.99, 4, 2),
(9, 'BBQ Bacon Burger', 'Juicy beef patty with bacon, BBQ sauce, and cheddar cheese', 55.75, 2, 3),
(10, 'Tiramisu', 'Classic Italian dessert with layers of coffee-soaked ladyfingers and mascarpone', 36, 3, 5);


INSERT INTO MenuItem (menu_item_id, menu_item_name, menu_item_description, price, food_category_id, restaurant_id)
VALUES
(11, 'Diavola Pizza', 'Classic pizza with tomato sauce, mozzarella, and basil', 33, 2, 6);

INSERT INTO CustomerOrder (customer_order_id, customer_id, restaurant_id, delivery_driver_id, customer_order_date, total_price, payment_method)
VALUES
(1, 1, 1, 1, '2023-11-15 12:30:00', 50, 'Credit Card'),
(2, 2, 3, 2, '2023-11-16 18:45:00', 72, 'Cash'),
(3, 3, 2, 3, '2023-11-17 20:15:00', 83, 'Credit Card'),
(4, 4, 4, 4, '2023-11-18 19:00:00', 76, 'Cash'),
(5, 5, 5, 5, '2023-11-19 14:45:00', 50, 'Credit Card'),
(6, 1, 1, 1, '2023-11-15 19:30:00', 29.25, 'Credit Card'),
(7, 1, 5, 2, '2023-11-15 18:30:00', 36, 'Credit Card');


INSERT INTO OrderItem (order_item_id, customer_order_id, menu_item_id, quantity, subtotal)
VALUES
(1, 1, 1, 2, 50),
(2, 2, 10, 2, 72), 
(3, 3, 2, 1, 48.50), 
(4, 3, 6, 1, 34.50),
(5, 4, 4, 2, 76), 
(6, 5, 5, 2, 50),
(7, 6, 7, 1, 29.50),
(8, 7, 10, 1, 36);

UPDATE Customer
SET phone_number = '0747854220'
where customer_name LIKE 'Timis Cosmin'


UPDATE MenuItem
SET price = 21
where price < 20


UPDATE CustomerOrder
SET delivery_driver_id = 1
WHERE customer_id = 5 AND restaurant_id = 5


DELETE from DeliveryDriver 
where delivery_driver_id NOT IN (SELECT delivery_driver_id
from CustomerOrder)

DELETE from Customer
where customer_address NOT LIKE 'Cluj-Napoca%'

SELECT * From Customer
SELECT * From DeliveryDriver

-- a. 2 queries with the union operation; use UNION [ALL] and OR;

SELECT customer_name as name
FROM  Customer
WHERE customer_address LIKE 'Cluj-Napoca%' OR  customer_address LIKE 'Borsa%'
UNION
SELECT restaurant_name
from Restaurant
where restaurant_address LIKE 'Cluj-Napoca%' OR  restaurant_address LIKE 'Borsa%'

SELECT menu_item_name as name
from MenuItem
where restaurant_id in (SELECT restaurant_id
from Restaurant
where restaurant_address LIKE 'Cluj-Napoca%' OR  restaurant_address LIKE 'Borsa%')
UNION ALL
SELECT restaurant_name
from Restaurant
where restaurant_address LIKE 'Cluj-Napoca%' OR  restaurant_address LIKE 'Borsa%'



-- b. 2 queries with the intersection operation; use INTERSECT and IN;

select customer_name
from Customer
where customer_address LIKE 'Cluj-Napoca%'
INTERSECT
select customer_name
from Customer
where customer_id in (select c.customer_id from Customer c INNER JOIN CustomerOrder co on c.customer_id = co.customer_id where NOT total_price <= 75) 


select delivery_driver_name
from DeliveryDriver
INTERSECT
select delivery_driver_name
from DeliveryDriver
where delivery_driver_id in (select delivery_driver_id from CustomerOrder where restaurant_id in (select restaurant_id from Restaurant where restaurant_address LIKE 'Cluj-Napoca%'))


-- c. 2 queries with the difference operation; use EXCEPT and NOT IN;

SELECT customer_name
FROM Customer
EXCEPT
SELECT customer_name
FROM Customer
WHERE customer_id NOT IN (SELECT customer_id FROM CustomerOrder WHERE total_price <= 75);

SELECT menu_item_name
from MenuItem
EXCEPT
SELECT menu_item_name
FROM MenuItem
Where menu_item_id NOT IN (SELECT oi.menu_item_id from OrderItem oi INNER JOIN CustomerOrder co on oi.customer_order_id = co.customer_id where co.payment_method LIKE 'CASH' )


-- d. 4 queries with INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL JOIN (one query per operator); one query will join at least 3 tables, while another one will join at least two many-to-many relationships;

select delivery_driver_name
from DeliveryDriver
where delivery_driver_id in
(SELECT DISTINCT delivery_driver_id
from CustomerOrder co INNER JOIN OrderItem oi on co.customer_order_id = oi.customer_order_id INNER JOIN MenuItem mi on mi.menu_item_id = oi.menu_item_id where mi.food_category_id in (
    select food_category_id
    from FoodCategory
    where food_category_name LIKE 'Main Course' or food_category_name LIKE 'Dessert'
))

SELECT mi.menu_item_name, oi.quantity
FROM MenuItem mi LEFT JOIN OrderItem oi on mi.menu_item_id = oi.menu_item_id 

SELECT co.customer_order_date, dd.delivery_driver_name
FROM CustomerOrder co RIGHT JOIN DeliveryDriver dd on co.delivery_driver_id = dd.delivery_driver_id

SELECT 
    c.customer_name, 
    mi.menu_item_name, oi.quantity,
    co.payment_method ,r.restaurant_name
FROM 
    Customer c
FULL JOIN 
    CustomerOrder co ON c.customer_id = co.customer_id
FULL JOIN 
    OrderItem oi ON co.customer_order_id = oi.customer_order_id
FULL JOIN 
    MenuItem mi ON oi.menu_item_id = mi.menu_item_id
FULL JOIN 
    Restaurant r ON mi.restaurant_id = r.restaurant_id;

--e. 2 queries with the IN operator and a subquery in the WHERE clause; in at least one case, the subquery must include a subquery in its own WHERE clause;

SELECT DISTINCT food_category_name
from FoodCategory
where food_category_id in (select food_category_id from MenuItem where price < 25)

select customer_name
from Customer
where customer_id in (select customer_id from CustomerOrder where payment_method LIKE 'Credit Card%' and customer_id in (select customer_id from OrderItem where quantity > 1))

-- f. 2 queries with the EXISTS operator and a subquery in the WHERE clause;

select c.customer_name
from Customer c 
where exists (
    select co.customer_id from CustomerOrder co where co.customer_id = c.customer_id and co.customer_order_date <= '2023-11-16 22:00:00'
)

select dd.delivery_driver_name
from DeliveryDriver dd
where exists(
    select co.delivery_driver_id
    from CustomerOrder co where co.delivery_driver_id = dd.delivery_driver_id
)

--g. 2 queries with a subquery in the FROM clause;     

select *
from (
    select menu_item_name as item_name, price * 2 as double_price
    from MenuItem
    where price <= 30
) NewMenuItem   


select c.customer_name, AddingTips.price_with_tips
from(
    select total_price * 1.1 as price_with_tips, customer_id
    from CustomerOrder
) AddingTips inner JOIN Customer c on AddingTips.customer_id = c.customer_id

SELECT TOP 3 customer_id, COUNT(customer_order_id) AS order_count
FROM CustomerOrder
GROUP BY customer_id
HAVING COUNT(customer_order_id) > 1
ORDER BY order_count DESC;


SELECT TOP 3 restaurant_id, AVG(total_price) * 1.1 AS avg_total_price_with_tips
FROM CustomerOrder
GROUP BY restaurant_id
ORDER BY avg_total_price_with_tips DESC


SELECT c.customer_id
FROM Customer c
INNER JOIN CustomerOrder co ON c.customer_id = co.customer_id
GROUP BY c.customer_id
HAVING AVG(co.total_price) > (SELECT AVG(total_price) FROM CustomerOrder);


SELECT c.customer_id
FROM Customer c
INNER JOIN CustomerOrder co ON c.customer_id = co.customer_id
INNER JOIN OrderItem oi ON co.customer_order_id = oi.customer_order_id
GROUP BY c.customer_id
HAVING COUNT(DISTINCT oi.menu_item_id) > (
    SELECT AVG(menu_items_avg)
    FROM (
        SELECT COUNT(DISTINCT oi_inner.menu_item_id) AS menu_items_avg
        FROM OrderItem oi_inner
        GROUP BY oi_inner.customer_order_id
    ) AS subquery
);

SELECT delivery_driver_name
FROM DeliveryDriver
WHERE delivery_driver_id = ANY (
    SELECT delivery_driver_id
    FROM CustomerOrder
    WHERE total_price > 55
);

SELECT delivery_driver_name
FROM DeliveryDriver
WHERE delivery_driver_id IN (
    SELECT delivery_driver_id
    FROM CustomerOrder
    WHERE total_price > 55
);

SELECT customer_name
from Customer
where customer_id = ANY (
    select customer_id
    from CustomerOrder
    where payment_method LIKE 'Cash'
);

SELECT customer_name
from Customer
where customer_id NOT IN (
    select customer_id
    from CustomerOrder
    where payment_method LIKE 'Credit Card%'
);


SELECT r.restaurant_name
FROM Restaurant r
WHERE 30 < ALL (
    SELECT mi.price
    FROM MenuItem mi
    WHERE mi.restaurant_id = r.restaurant_id
);

SELECT restaurant_name
FROM Restaurant r
WHERE (
    SELECT MIN(mi.price)
    FROM MenuItem mi
    WHERE mi.restaurant_id = r.restaurant_id
) > 30;

SELECT mi.menu_item_name
from MenuItem mi
where mi.menu_item_id in (select oi.menu_item_id from OrderItem oi ) and 1 < ALL
(
    select oi.quantity
    from OrderItem oi 
    where oi.menu_item_id = mi.menu_item_id
)

SELECT mi.menu_item_name
from MenuItem mi
where 1 <
(
    select MIN(oi.quantity)
    from OrderItem oi 
    where oi.menu_item_id = mi.menu_item_id
)
/*SELECT customer_order_id, customer_id, restaurant_id, delivery_driver_id, customer_order_date, total_price, payment_method
FROM CustomerOrder co
WHERE 1 = ALL (
    SELECT CASE WHEN COUNT(DISTINCT fc.food_category_id) = 2 THEN 1 ELSE 0 END
    FROM OrderItem oi
    JOIN MenuItem mi ON oi.menu_item_id = mi.menu_item_id
    JOIN FoodCategory fc ON mi.food_category_id = fc.food_category_id
    WHERE co.customer_order_id = oi.customer_order_id
);*/