/* If NOT EXISTS(
    SELECT name 
    FROM sys.databases 
    where name = N'OnlineFoodDelivery'
) CREATE DATABASE [OnlineFoodDelivery];

*/
CREATE TABLE Customer(
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    customer_address VARCHAR(200),
    phone_number VARCHAR(20) NOT NULL,
    email_address VARCHAR(50)
)


CREATE TABLE Voucher(
    voucher_id INT PRIMARY KEY,
    code VARCHAR(20) UNIQUE,
    voucher_description VARCHAR(200),
    voucher_expiry_date DATETIME,
    discount_value SMALLMONEY,
    customer_id INT FOREIGN KEY REFERENCES Customer(customer_id)

);



CREATE TABLE DeliveryDriver(
    delivery_driver_id INT PRIMARY KEY,
    delivery_driver_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20),
    photo_url VARCHAR(100)
);

CREATE TABLE DriverRating(
    driver_rating_id INT PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES Customer(customer_id),
    delivery_driver_id INT FOREIGN KEY REFERENCES DeliveryDriver(delivery_driver_id),
    rating DECIMAL(2,1) check (rating >= 0 and rating <= 5),
    comment VARCHAR(500),
    driver_rating_date DATETIME
);

CREATE TABLE Restaurant(
    restaurant_id INT PRIMARY KEY,
    restaurant_name VARCHAR(50) NOT NUll,
    restaurant_description VARCHAR(500),
    phone_number VARCHAR(20),
    restaurant_hours VARCHAR(100),
    restaurant_address VARCHAR(200)
);

CREATE TABLE RestaurantReview(
    restaurant_review_id INT PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES Customer(customer_id),
    restaurant_id INT FOREIGN KEY REFERENCES Restaurant(restaurant_id),
    rating DECIMAL(2,1) check (rating >= 0 and rating <= 5),
    comment VARCHAR(500),
    driver_rating_date DATETIME
);

CREATE TABLE FoodCategory(
    food_category_id INT PRIMARY KEY,
    food_category_name VARCHAR(50) NOT NULL
);

CREATE TABLE MenuItem(
    menu_item_id INT PRIMARY KEY,
    menu_item_name VARCHAR(50) NOT NULL,
    menu_item_description VARCHAR(500),
    price MONEY,
    food_category_id INT FOREIGN KEY REFERENCES FoodCategory(food_category_id),
    restaurant_id INT FOREIGN KEY REFERENCES Restaurant(restaurant_id)
);

CREATE TABLE CustomerOrder( 
    customer_order_id INT PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES Customer(customer_id),
    restaurant_id INT FOREIGN KEY REFERENCES Restaurant(restaurant_id),
    delivery_driver_id INT FOREIGN KEY REFERENCES DeliveryDriver(delivery_driver_id),
    customer_order_date DATETIME,
    total_price MONEY,
    payment_method VARCHAR(20)
);

CREATE TABLE OrderItem(
    order_item_id INT PRIMARY KEY,
    customer_order_id INT FOREIGN KEY REFERENCES CustomerOrder(customer_order_id),
    menu_item_id INT FOREIGN KEY REFERENCES MenuItem(menu_item_id),
    quantity TINYINT,
    subtotal MONEY
);

