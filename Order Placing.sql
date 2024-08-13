--1. Create Tables and Define Relationships
create table customers (customer_id serial primary key,customer_name varchar(25),customer_email varchar(25));
create table orders(order_id serial primary key,customer_id serial references customers(customer_id),order_date date,total_amount real);
create table categories (category_id serial primary key,category_name varchar(25));
create table order_items (order_item_id serial primary key,order_id serial references orders(order_id),product_id serial references products(product_id),quality varchar(20));
create table products (product_id serial primary key,category_id serial references categories(category_id),product_name varchar(25),price real);


alter table order_items drop column quality;
alter table order_items add column quantity int;

--2.Insert Sample Data into All Tables
INSERT INTO customers (customer_id, customer_name , customer_email ) VALUES
(1, 'John Doe', 'john.doe@example.com'),
(2, 'Jane Smith', 'jane.smith@example.com'),
(3, 'Alice Johnson', 'alice.johnson@example.com'),
(4, 'Bob Brown', 'bob.brown@example.com'),
(5, 'Carol Davis', 'carol.davis@example.com'),
(6, 'David Wilson', 'david.wilson@example.com'),
(7, 'Emily Clark', 'emily.clark@example.com'),
(8, 'Frank Harris', 'frank.harris@example.com'),
(9, 'Grace Lewis', 'grace.lewis@example.com'),
(10, 'Hannah Walker', 'hannah.walker@example.com');

INSERT INTO orders (order_id, customer_id, order_date, total_amount)
VALUES
(1, 1, '2024-08-01', 250.00),
(2, 2, '2024-08-02', 150.50),
(3, 3, '2024-08-03', 99.99),
(4, 4, '2024-08-04', 299.90),
(5, 5, '2024-08-05', 189.75),
(6, 6, '2024-08-06', 349.20),
(7, 7, '2024-08-07', 129.45),
(8, 8, '2024-08-08', 89.99),
(9, 9, '2024-08-09', 499.99),
(10, 10, '2024-08-10', 75.00),
(11, 1, '2024-08-11', 400.50),
(12, 2, '2024-08-12', 220.00),
(13, 3, '2024-08-13', 105.25),
(14, 4, '2024-08-14', 215.30),
(15, 5, '2024-08-15', 310.00);

INSERT INTO products (product_id,category_id, product_name, price) VALUES
(1, 1,'Laptop', 999.99),
(2,1, 'Smartphone', 499.99),
(3, 2,'Headphones', 89.99),
(4, 1,'Keyboard', 45.99),
(5, 1,'Mouse', 25.99),
(6, 2,'Monitor', 199.99),
(7, 1,'Printer', 129.99),
(8, 1,'Tablet', 349.99),
(9,1, 'Webcam', 59.99),
(10, 1,'External Hard Drive', 129.99);

INSERT INTO order_items (order_item_id, order_id, product_id,
quantity) VALUES
(1, 1, 1, 1), -- 1 Laptop
(2, 1, 3, 2), -- 2 Headphones
(3, 2, 2, 1), -- 1 Smartphone
(4, 2, 5, 1), -- 1 Mouse
(5, 3, 4, 1), -- 1 Keyboard
(6, 4, 6, 2), -- 2 Monitors
(7, 5, 7, 1), -- 1 Printer
(8, 6, 8, 1), -- 1 Tablet
(9, 7, 9, 1), -- 1 Webcam
(10, 8, 3, 1), -- 1 Headphones
(11, 9, 10, 1), -- 1 External Hard Drive
(12, 10, 2, 1), -- 1 Smartphone
(13, 11, 1, 1), -- 1 Laptop
(14, 12, 6, 1), -- 1 Monitor
(15, 13, 4, 1), -- 1 Keyboard
(16, 14, 8, 1), -- 1 Tablet
(17, 15, 5, 2); -- 2 Mice

INSERT INTO categories (category_id, category_name) VALUES
(1, 'Electronics'),
(2, 'Accessories'),
(3, 'Computers'),
(4, 'Office Supplies'),
(5, 'Mobile Devices');

--3. Retrieve All Orders for a Specific Customer
select o.order_id,o.total_amount,o.order_date from orders o inner join customers c on c.customer_id =o.customer_id where c.customer_name='John Doe' ;

--4.List All Products with Their Categories
select p.product_name,c.category_name from products p inner join categories c on c.category_id =p.category_id ;

--5.Retrieve Order Items and Their Product Details for a Specific Order
select o.order_id,p.product_name,p.product_id,p.price,o.order_date from order_items oi inner join orders o on o.order_id =oi.order_id inner join products p on p.product_id =oi.product_id ;

--6. Find Customers Who Have Placed Orders Above a Certain Amount
select o.order_id,o.total_amount,o.order_date,c.customer_name from orders o inner join customers c on c.customer_id =o.customer_id where o.total_amount>100.0 ;

--7. Get the Total Number of Orders and Total Amount Spent by Each Customer
select count(*),sum(o.total_amount),c.customer_name from orders o inner join customers c on o.customer_id =c.customer_id  group by c.customer_id ;

--8.. List Products and Their Total Sales Amount
select p.product_id,p.product_name, sum(p.price) from order_items oi inner join products p on p.product_id=oi.product_id group by p.product_id ; 

--9.Find the Most Expensive Product in Each Category
select max(p.price),c.category_name from products p inner join categories c on c.category_id =p.category_id group by c.category_id ;

--10.Create an Index on customer_id in the orders Table
create index idx_customer_id on orders(customer_id);

--11.Update Product Prices Based on a Percentage Increase
update products set price =price *1.1;

--12. Delete Orders Older Than a Certain Date
delete from orders where orders.order_date >current_date -interval '3 days';

--13. Create a View to Show Top Selling Products
create view top_products  as select p.product_id ,p.product_name,sum(oi.quantity *  p.price) as total_sales_amount from order_items oi inner join products p on oi.product_id = p.product_id group by p.product_id,p.product_name order by total_sales_amount desc;

--14. Add a New Column to Track Product Stock Quantity
alter table products add column stock_qualntity int;

--15. Use a Full Outer Join to Find Unmatched Records
select * from products p full outer join order_items oi on p.product_id =oi.product_id ;

--16. Retrieve Customers with Orders Placed in the Last 30 Days
select * from customers c join orders o on c.customer_id =o.customer_id where o.order_date >  CURRENT_DATE - INTERVAL '30 days';

--17.Find the Top 5 Products by Total Sales Amount
select p.product_id , p.product_name ,p.price from order_items oi  inner join products p on oi.product_id =p.product_id group by (p.product_id) order by sum(p.price) limit(5) ;

--18. List Categories with No Products
select c.category_id,c.category_name from categories c left join products p on c.category_id =p.category_id where p.product_id =null ;


--19. Get the Average Order Value for Each Customer
select c.customer_id, avg(o.total_amount) from orders o inner join customers c on o.customer_id =c.customer_id group by c.customer_id ;

--20. Identify Customers Who Have Not Ordered Any Products
select c.customer_id,c.customer_name from customers c left join orders o on c.customer_id =o.customer_id where o.order_id =null ;

--21. Create an Index on order_date in the orders Table
create index order_date_ind on orders(order_id);

