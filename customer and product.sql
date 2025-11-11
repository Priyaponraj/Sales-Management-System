-- Customers Table
create table customers(
    customer_id varchar(10) PRIMARY KEY,
    customer_name varchar(20),
    city varchar(15),
    country varchar(15)
);

insert into customers values
('C01','Smith','New York','USA'),  
('C02','Lee','Los Angeles','USA'),  
('C03','David', 'London','UK'),   
('C04','Emma','Berlin','Germany'),     
('C05','Johnson','Sydney','Australia'),
('C06','Martin','Toronto','Canada');

-- Products Table
create table products (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(50),
    product_line VARCHAR(50),
    buy_price DECIMAL(10,2),
    msrp DECIMAL(10,2),
    quantity_in_stock INT
);

insert into products values
('P001', '1957 Chevy Pickup', 'Classic Cars', 20.00, 40.00, 100),
('P002', '1965 Aston Martin DB5', 'Classic Cars', 25.00, 50.00, 80),
('P003', '1958 Corvette Limited', 'Classic Cars', 22.00, 45.00, 90),
('P004', '1969 Ford Falcon', 'Vintage Cars', 18.00, 35.00, 70),
('P005', '1972 Alpine Renault 1600s', 'Vintage Cars', 20.00, 38.00, 60),
('P006', 'Harley Davidson Bike', 'Motorcycles', 15.00, 30.00, 50),
('P007', '1961 Jaguar E-Type', 'Classic Cars', 23.00, 48.00, 40);

-- Orders Table
create table orders(
    order_id varchar(10) PRIMARY KEY,
    customer_id varchar(10),
    order_date date,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

insert into orders values
('O001','C02','2025-02-04'),
('O002','C04','2025-02-10'),    
('O003','C02','2025-03-19'), 
('O004','C05','2025-04-27'), 
('O005','C01','2025-05-05'), 
('O006','C06','2025-05-18'), 
('O007','C01','2025-06-01'), 
('O008','C06','2025-06-16');

-- Order Details Table
create table order_details (
    order_id varchar(10),
    product_id varchar(10),
    quantity int,
    price_each decimal(10,2),
    PRIMARY KEY(order_id, product_id),
    FOREIGN KEY(order_id) REFERENCES orders(order_id),
    FOREIGN KEY(product_id) REFERENCES products(product_id)
);

insert into order_details values
('O001', 'P001', 2, 40.00),
('O001', 'P002', 1, 50.00),
('O002', 'P003', 3, 45.00),
('O003', 'P004', 2, 35.00),
('O004', 'P005', 1, 38.00),
('O005', 'P006', 4, 30.00);

-- Select to verify
select * from customers;
select * from products;
select * from orders;
select * from order_details;



-- Find Product Line Generating the Most Revenue

select p.product_line,
sum(od.quantity * od.price_each) as total_Revenue
from order_details od
join products p on od.product_id=p.product_id
group by p.product_line
order by total_Revenue desc
limit 1;

-- Identify Top-Selling Products
select product_name,
sum(od.quantity) as Top_Selling_Products
from order_details od
join products p on od.product_id=p.product_id
group by p.product_name
order by Top_Selling_Products desc;

-- Customers with the Most Orders
select
c.customer_id,
c.customer_name,
COUNT(o.order_id) AS total_orders
from customers c
join orders o ON c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
order by total_orders desc
limit 5;  



select * from products;

-- Products with Low Inventory not work
select product_id,
product_name,
quantity_in_stock  from products
where quantity_in_stock < 60;

-- Find the average order value per customer
select c.customer_name,
    ROUND(AVG(od.quantity * od.price_each), 2) AS average_order_value from customers c
join orders o on
c.customer_id = o.customer_id
join order_details od 
ON o.order_id = od.order_id
group by c.customer_name
order by average_order_value DESC;


-- Find Customers Who Haven’t Placed Any Orders
select
    c.customer_id,
    c.customer_name,
    c.city,
    c.country
from customers c
LEFT JOIN orders o 
ON c.customer_id = o.customer_id
where o.order_id IS NULL;


-- Product with Highest Stock Value
select product_name,
quantity_in_stock * buy_price AS total_stock_value
from products
order by total_stock_value DESC
limit 1;


-- Find the Most Popular Product Line
select
    p.product_line,
    SUM(od.quantity) AS total_sold
from order_details od
JOIN products p ON od.product_id = p.product_id
group by p.product_line
order by total_sold DESC
limit 1;