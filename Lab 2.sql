---Task 1

/*
     a)Data Definition Language (DDL) is a group of data definition operators.
       With their help, we determine the structure of the database and work with the objects of this database.
       The important DDL commands are: 1)CREATE, 2)ALTER, 3)DROP

     b)Data Manipulation Language (DML) is a group of operators for data manipulation.
       With their help, we can add, change, delete and unload data from the database.
       Important DML commands: 1)INSERT, 2)UPDATE, 3)DELETE, 4)SELECT
 */




---Task 2

CREATE table customers (
    id int UNIQUE NOT NULL PRIMARY KEY ,
    full_name varchar(50) NOT NULL ,
    timestamp timestamp NOT NULL,
    delivery_address text NOT NULL
);

CREATE table orders (
    code int UNIQUE NOT NULL PRIMARY KEY ,
    customer_id int REFERENCES customers,
    total_sum double precision NOT NULL CHECK ( total_sum > 0 ),
    is_paid bool NOT NULL
);

CREATE table products(
    id varchar UNIQUE NOT NULL PRIMARY KEY ,
    name varchar UNIQUE NOT NULL ,
    description text ,
    price double precision NOT NULL CHECK ( price > 0 )
);

CREATE table order_items(
    order_code int UNIQUE NOT NULL REFERENCES orders,
    product_id varchar UNIQUE NOT NULL REFERENCES products,
    quantity int NOT NULL CHECK ( quantity > 0 ),
    PRIMARY KEY (order_code, product_id)
);

---Task 3

CREATE table students(
    id int UNIQUE NOT NULL,
    full_name varchar(50) UNIQUE NOT NULL ,
    age int NOT NULL ,
    birth_date date NOT NULL ,
    gender varchar NOT NULL,
    average_grade double precision NOT NULL ,
    info_self text NOT NULL ,
    need_dorm bool NOT NULL,
    add_info text
);

CREATE table instructors(
    id int UNIQUE NOT NULL,
    full_name varchar(50) UNIQUE NOT NULL,
    languages varchar NOT NULL,
    work_exp interval,
    remote_lessons bool NOT NULL
);

CREATE table lesson_participants(
    lesson_title text NOT NULL ,
    instructor text NOT NULL ,
    students text NOT NULL,
    room int NOT NULL
);

---Task 4

INSERT INTO customers (id, full_name, timestamp, delivery_address) VALUES (1,'Muratov Damir', '2021-09-19 18:39:15','Jeltoqsan-13');
INSERT INTO orders values(1,1,1000,true);
INSERT INTO products values(1,'Iphone','hi-tech trend smartphones',1000);
INSERT INTO order_items values(1,1,3);

UPDATE customers SET timestamp = '2021-09-23 18:00:00' WHERE id=1;
UPDATE orders SET total_sum=1700 where customer_id=1;
UPDATE products SET price=1500 where name='Iphone';
UPDATE order_items SET quantity=5 where order_code=1;

DELETE FROM customers WHERE id=1;
DELETE FROM orders WHERE code=1;
DELETE FROM products WHERE name='Iphone';
DELETE FROM order_items WHERE order_code=1;

