Create table customer (
    customer_id int  NOT NULL PRIMARY KEY ,
    full_name text NOT NULL ,
    country varchar(50) NOT NULL ,
    city varchar(50) NOT NULL ,
    street text NOT NULL ,
    city_id int REFERENCES cities
);

Create table customer_mobile_numbers (
    customer_id int REFERENCES customer ,
    mobile_number varchar(50) NOT NULL ,
    PRIMARY KEY(customer_id , mobile_number)
);

Create table orders (
    order_id int  NOT NULL PRIMARY KEY ,
    customer_id int REFERENCES customer ,
    store_id varchar NOT NULL REFERENCES stores ,
    total_sum double precision NOT NULL check (total_sum > 0) ,
    date Date ,
    is_paid bool NOT NULL
);

Create table frequent_customer (
    customer_id int REFERENCES customer PRIMARY KEY ,
    credit_card_number varchar(16) NOT NULL ,
    discount_card_number varchar(16) NOT NULL
);

Create table infrequent_customer (
    customer_id int REFERENCES customer PRIMARY KEY ,
    credit_card_number varchar(16) NOT NULL
);

Create table products (
    product_id varchar  NOT NULL PRIMARY KEY ,
    name text UNIQUE NOT NULL ,
    UPS_code varchar ,
    description text ,
    brand_id int NOT NULL REFERENCES brands ,
    size varchar NOT NULL ,
    price double precision NOT NULL check (price > 0) ,
    discount_price int NOT NULL check (discount_price > 0) ,
    quantity int NOT NULL
);

Create table product_types (
    product_id varchar  NOT NULL PRIMARY KEY REFERENCES products,
    name varchar NOT NULL ,
    brand_id int REFERENCES  brands,
    product_category text NOT NULL
);
Create table brands (
    brand_id int UNIQUE NOT NULL PRIMARY KEY ,
    brand_name varchar NOT NULL
);

Create table vendors (
    vendor_id varchar(10) NOT NULL PRIMARY KEY ,
    vendor_name varchar NOT NULL ,
    vendor_address varchar(255) NOT NULL ,
    vendor_country varchar NOT NULL ,
    vendor_city varchar(255) NOT NULL ,
    vendor_zip varchar(10) NOT NULL
);
Create table vendors_item (
    vendorItem_id varchar(10) NOT NULL ,
    vendorProduct_name varchar NOT NULL ,
    product_id varchar NOT NULL REFERENCES products ,
    vendorProduct_price varchar NOT NULL ,
    FOREIGN KEY (vendorItem_id ) REFERENCES vendors (vendor_id)
);

Create table cities (
    city_id int NOT NULL PRIMARY KEY,
    name varchar NOT NULL
);

Create table stores (
    store_id varchar NOT NULL PRIMARY KEY ,
    store_name varchar NOT NULL ,
    store_city varchar NOT NULL ,
    city_id int NOT NULL REFERENCES  cities ,
    store_street text NOT NULL ,
    store_zip text NOT NULL ,
    start_hour varchar NOT NULL ,
    end_hour varchar NOT NULL
);

Create table order_details (
    order_id int  NOT NULL  REFERENCES orders,
    product_id varchar NOT NULL REFERENCES products,
    quantity int NOT NULL ,
    story_id int NOT NULL ,
    PRIMARY KEY(order_id, product_id)
);

Create table selling (
    id int NOT NULL PRIMARY KEY ,
    is_paid bool NOT NULL ,
    store_id varchar REFERENCES stores ,
    vendor_id varchar(10) REFERENCES vendors
);

Create table selling_details (
    id int NOT NULL ,
    product_id varchar REFERENCES products ,
    selling_id int ,
    amount int NOT NULL ,
    FOREIGN KEY (selling_id) REFERENCES selling(id)
);

Create table warehouse (
    id int NOT NULL ,
    store_id varchar NOT NULL  REFERENCES stores,
    product_id varchar NOT NULL REFERENCES products,
    name varchar NOT NULL ,
    amount int NOT NULL
);

Insert into customer(customer_id, full_name, country, city, street, city_id )
VALUES  (1,'Muratov Damir','Казахстан' , 'Алматы' , 'Розыбакиева 247' , 2  ),
        (2,'Kaci Bloom', 'Казахстан', 'Алматы' , 'Макатаева 36',2),
        (3, 'Arlo Finney', 'Казахстан' ,'Алматы', 'Розыбакиева 230',2 ),
        (4, 'Luca Reynolds','Казахстан','Алматы' , 'Сейфулина 60', 2 ),
        (5, 'Antonina Hurst','Казахстан' , 'Алматы','Жарокова 1',2 ),
        (6, 'Lachlan Rich','Казахстан', 'Алматы' , 'Ауэзова 46',2),
        (7, 'Myah Navarro' , 'Казахстан','Алматы' , 'Ауэзова 63',2 ),
        (8, 'Nichola Huber','Казахстан','Алматы', 'Манаса 64', 2),
        (9, 'Kamil Cook','Казахстан', 'Алматы' ,'Тимирязвеа 69',2),
        (10, 'Gianluca Bryan','Казахстан', 'Алматы' ,'Байзакова 137',2 ),
        (11, 'Cecily Melia','Казахстан', 'Алматы' ,'Габдуллина 76',2);

Insert into customer_mobile_numbers(customer_id, mobile_number)
VALUES (1,87021302703),
       (2,87778053526),
       (3,87477903275),
       (4,87069725214),
       (5,87853317080),
       (6,87476030106),
       (7,87470535431),
       (8,87632228095),
       (9,87477382239),
       (10,87077505175),
       (11,87060624898);

Insert into frequent_customer(customer_id, credit_card_number, discount_card_number)
VALUES (1,4086588837686669,333575),
       (3,4116141206207248,578903),
       (4,5203993079846580,883945),
       (8,4588737251226097,790453),
       (11,5495647930216063,432908);

INSERT INTO infrequent_customer(customer_id, credit_card_number)
VALUES (2,4545802115486337),
       (5,4063125410818679),
       (6,4543881883347741),
       (7,4095204434579203),
       (9,5370012154856831),
       (10,4539458828297533);

INSERT INTO brands(brand_id, brand_name)
VALUES (1,'Coca-Cola'),
       (2,'Lays'),
       (3,'Snickers'),
       (4,'Простоквашино'),
       (5,'Milka');

INSERT INTO product_types(product_id, name, brand_id, product_category)
VALUES (1,'Cola',1,'Soda'),
       (2,'Lays',2,'Potato chips'),
       (3,'Snickers',3,'chocolate bar'),
       (4,'Простоквашино',4,'milk,cottage cheese,sour cream'),
       (5,'Milka',5,'chocolate bars,biscuits,candies');

Insert into products (product_id, name, UPS_code, description, brand_id, "size", price, discount_price, quantity)
VALUES (1,'Cola1',72527273070,'Безалкогольный газированный напиток',1,'1л',300,279,100),
       (2,'Cola2',75493273070,'Безалкогольный газированный напиток',1,'0.5л',190,179,100),
       (3,'Cola3',79033273070,'Безалкогольный газированный напиток',1,'2л',430,399,100),
       (4,'Cola4',79403273070,'Безалкогольный газированный напиток',1,'1.5л',370,349,100),
       (5,'Lays Сметана и лук',78932071921,'Картофельные чипсы',2,'85г',300,269,70),
       (6,'Lays Сыр1',89403863782,'Картофельные чипсы',2,'85г',300,269,70),
       (7,'Lays Сметана и зелень1',78390273801,'Картофельные чипсы',2,'85г',300,269,70),
       (8,'Lays Сметана и лук1',78332071921,'Картофельные чипсы',2,'140г',450,399,70),
       (9,'Lays Сыр',90232071921,'Картофельные чипсы',2,'140г',450,399,70),
       (10,'Lays Сметана и зелень',78390273801,'Картофельные чипсы',2,'140г',450,399,70),
       (11,'Lays Краб1',93232071921,'Картофельные чипсы',2,'85г',300,269,70),
       (12,'Lays Краб',78332071921,'Картофельные чипсы',2,'140г',450,399,70),
       (13,'Snickers1',93820467182,'шоколадный батончик с жареным арахисом, карамелью и нугой, покрытый сверху молочным шоколадом.',3,'50г',180,159,100),
       (14,'Snickers2',67820467182,'шоколадный батончик с жареным арахисом, карамелью и нугой, покрытый сверху молочным шоколадом.',3,'80г',250,229,100),
       (15,'Snickers3',95820467182,'шоколадный батончик с жареным арахисом, карамелью и нугой, покрытый сверху молочным шоколадом.',3,'120г',500,439,100),
       (16,'Простоквашино молоко1',74938274228,'жидкий продукт питания',4,'1л',300,289,80),
       (17,'Простоквашино молоко2',74938274228,'жидкий продукт питания',4,'2л',500,479,80),
       (18,'Простоквашино творог1',83902640275,'кисломолочный продукт, результат сквашивания коровьего молока',4,'150г',400,359,100),
       (19,'Простоквашино творог2',83902640275,'кисломолочный продукт, результат сквашивания коровьего молока',4,'300г',600,559,100),
       (20,'Простоквашино сметана',61291539261,'Густой жидкий кисломолочный продукт белого цвета, получаемый из сливок и закваски',4,'500г',600,579,100),
       (21,'Milka шоколад плитка',49032446752,'кондитерское изделие, которое изготавливают из какао-продуктов и сахара.',5,'180г',400,379,100),
       (22,'Milka печенье',89302756823,'Печенье Milka с кусочками молочного шоколада',5,'300г',700,599,100),
       (23,'Milka конфеты',68302749264,'Конфеты Milka из молочного шоколада с молочной начинкой',5,'110г',500,479,100);

INSERT INTO cities (city_id, name)
VALUES (2,'Алматы');

INSERT INTO stores (store_id, store_name, store_city, city_id, store_street, store_zip, start_hour, end_hour)
VALUES (1,'Magnum','Алматы',2,'Толе би 285',050016,'10:00','22:00'),
       (2,'Small','Алматы',2,'Жарокова 281',050018,'10:00','22:00'),
       (3,'Galmart','Алматы',2,'Розыбакиева 263',050010,'10:00','22:00'),
       (4,'Светофор','Алматы',2,'Рыскулова 103',050017,'10:00','22:00'),
       (5,'TOIMART','Алматы',2,'Розыбакиева 4',050019,'10:00','22:00');

INSERT INTO orders (order_id, customer_id, store_id, total_sum, date, is_paid)
VALUES (1,1,1,1200,'2021-12-03',True),
       (2,2,2,750,'2021-12-01',True),
       (3,3,3,800,'2021-12-04',True),
       (4,4,4,1000,'2021-12-02',True),
       (5,5,5,1500,'2021-10-08',True),
       (6,6,1,600,'2021-12-01',True),
       (7,7,2,1000,'2021-12-02',True),
       (8,8,3,1100,'2021-12-03',True),
       (9,9,4,1000,'2021-12-04',True),
       (10,10,5,500,'2021-12-04',True),
       (11,11,1,1000,'2021-12-01',True),
       (12,1,1,1000,'2021-12-01',True),
       (13,2,4,500,'2021-12-02',True),
       (14,3,5,1000,'2021-12-03',True),
       (15,4,1,700,'2021-12-02',True),
       (16,5,2,600,'2021-12-04',True),
       (17,6,5,800,'2021-12-01',True),
       (18,7,3,1000,'2021-12-03',True),
       (19,8,4,900,'2021-12-03',True),
       (20,9,3,700,'2021-12-02',True),
       (21,10,2,1000,'2021-12-01',True),
       (22,11,4,1000,'2021-12-04',True),
       (23,5,1,1500,'2021-12-04',True),
       (24,6,4,2000,'2021-12-01',True),
       (25,7,5,2000,'2021-12-02',True),
       (26,8,4,2500,'2021-12-01',True),
       (27,9,3,3000,'2021-12-01',True),
       (28,10,1,1000,'2021-12-02',True),
       (29,11,5,3000,'2021-12-01',True),
       (30,6,4,1000,'2021-12-01',True);

INSERT INTO order_details (order_id, product_id, quantity,story_id)
VALUES (1,5,3,1),
       (2,4,2,2),
       (3,3,2,3),
       (4,7,2,4),
       (5,8,3,5),
       (6,1,6,1),
       (7,21,2,2),
       (8,23,3,3),
       (9,3,6,4),
       (10,21,1,5),
       (11,9,2,1),
       (12,17,3,1),
       (13,15,4,2),
       (14,19,2,3),
       (15,18,5,5),
       (16,6,1,4),
       (17,9,3,1),
       (18,1,4,2),
       (19,21,3,1),
       (20,4,5,4),
       (21,7,4,2),
       (22,12,4,3),
       (23,20,1,1),
       (24,2,9,2),
       (25,10,3,6),
       (26,11,3,5),
       (27,13,3,1),
       (28,14,5,3),
       (29,16,5,4),
       (30,22,3,1);



INSERT INTO vendors (vendor_id, vendor_name, vendor_address, vendor_country, vendor_city, vendor_zip)
VALUES (1,'Abay','Розыбакиева','Казахстан','Алматы',005010);

INSERT INTO vendors_item (vendorItem_id, vendorProduct_name, product_id, vendorProduct_price)
VALUES (1,'Lays',2,300-350),
       (1,'Cola',1,250-300),
       (1,'Snickers',3,130-200),
       (1,'Простоквашино',4,250-400),
       (1,'Milka',5,300-400);

INSERT INTO selling (id, is_paid, store_id, vendor_id)
VALUES (1,True,1,1),
       (2,True,2,1),
       (3,True,3,1),
       (4,True,4,1),
       (5,True,5,1);

INSERT INTO selling_details (id, product_id, selling_id, amount)
VALUES (1,1,1,200),
       (2,2,2,200),
       (3,3,3,300),
       (4,4,4,400),
       (5,5,5,300);

INSERT INTO warehouse (id, store_id, product_id, name, amount)
VALUES (1,1,1,'Cклад1',200),
       (2,2,2,'Склад2',200),
       (3,3,3,'Склад3',300),
       (4,4,4,'Склад4',400),
       (5,5,5,'Склад5',300);





---What are the 20 top-selling products at each store?

SELECT order_details.product_id,order_details.story_id,SUM(order_details.quantity),products.name
FROM order_details , products WHERE story_id = 1 AND order_details.product_id = products.product_id
GROUP BY order_details.product_id, products.name,order_details.story_id ORDER BY SUM(order_details.quantity) DESC LIMIT 20;

SELECT order_details.product_id,order_details.story_id,SUM(order_details.quantity),products.name
FROM order_details , products WHERE story_id = 2 AND order_details.product_id = products.product_id
GROUP BY order_details.product_id, products.name,order_details.story_id ORDER BY SUM(order_details.quantity) DESC LIMIT 20;

SELECT order_details.product_id,order_details.story_id,SUM(order_details.quantity),products.name
FROM order_details , products WHERE story_id = 3 AND order_details.product_id = products.product_id
GROUP BY order_details.product_id, products.name,order_details.story_id ORDER BY SUM(order_details.quantity) DESC LIMIT 20;

SELECT order_details.product_id,order_details.story_id,SUM(order_details.quantity),products.name
FROM order_details , products WHERE story_id = 4 AND order_details.product_id = products.product_id
GROUP BY order_details.product_id, products.name,order_details.story_id ORDER BY SUM(order_details.quantity) DESC LIMIT 20;

SELECT order_details.product_id,order_details.story_id,SUM(order_details.quantity),products.name
FROM order_details , products WHERE story_id = 5 AND order_details.product_id = products.product_id
GROUP BY order_details.product_id, products.name,order_details.story_id ORDER BY SUM(order_details.quantity) DESC LIMIT 20;

---What are the 20 top-selling products in each state?

SELECT order_details.product_id,SUM(order_details.quantity),products.name
FROM order_details , products WHERE order_details.product_id = products.product_id
GROUP BY order_details.product_id, products.name ORDER BY SUM(order_details.quantity) DESC LIMIT 20;

---What are the 5 stores with the most sales so far this year?
SELECT order_details.story_id,SUM(order_details.quantity)
FROM order_details GROUP BY  order_details.story_id ORDER BY SUM(order_details.quantity) DESC LIMIT 5;

---What are the top 3 types of product that customers buy in addition to milk?
SELECT products.name FROM products
WHERE products.name in (SELECT pr.name FROM products pr INNER JOIN order_details
                            ON order_details.product_id = products.product_id
                    WHERE pr.name != 'Простоквашино молоко1' and pr.name != 'Простоквашино молоко2')  LIMIT 3;








