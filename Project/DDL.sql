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