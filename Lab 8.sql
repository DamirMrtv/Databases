----1a----
CREATE OR REPLACE FUNCTION increment(val integer) RETURNS integer AS
$$
BEGIN
    RETURN val + 1;
end;
$$
    LANGUAGE plpgsql;

SELECT increment(5);
----1b----
CREATE FUNCTION sum(val1 numeric, val2 numeric) RETURNS integer AS
$$
BEGIN
    RETURN val1 + val2;
end;
$$
    LANGUAGE plpgsql;

SELECT sum(5,6);
----1c----
CREATE FUNCTION even(val numeric) RETURNS bool AS
$$
BEGIN
    RETURN val % 2 = 0;
end;
$$
    LANGUAGE plpgsql;

SELECT even(13);

----1d----
CREATE FUNCTION check_password(p text) RETURNS bool AS
$$
BEGIN
    RETURN textlen(p) >= 8;
end;
$$
    LANGUAGE plpgsql;

SELECT check_password('Dm)5572242');

----1e----
CREATE FUNCTION e(val numeric, OUT val1 numeric, OUT val2 numeric) AS
$$
BEGIN
    val1 := val + 10;
    val2 := val * 10;
end;
$$
    LANGUAGE plpgsql;

SELECT * FROM e(50);

----2----
CREATE table test(
    id int,
    name varchar(50),
    money int,
    birth_date timestamp,
    age interval
);
CREATE table test_audit(
    id int,
    name varchar(50),
    changed timestamp
);
INSERT INTO test VALUES (1, 'Damir', 5000, '2003-01-03 00:00:00');
INSERT INTO test VALUES (2, 'Asyl', 20000, '2001-09-24 00:00:00');
INSERT INTO test VALUES (3, 'Leila', 50100, '2000-11-27 00:00:00');


---2a---
CREATE FUNCTION t_stamp() RETURNS trigger AS
$$
BEGIN
    IF NEW <> OLD THEN
        INSERT INTO test_audit VALUES (old.id, old.name, now());
    END IF;
    RETURN new;
end;
$$
    LANGUAGE plpgsql;

CREATE trigger last_change
    BEFORE UPDATE on test
    FOR EACH ROW EXECUTE PROCEDURE t_stamp();

UPDATE test SET money = 5000 WHERE id = 2;
UPDATE test SET money = 2000 WHERE id = 3;

SELECT * FROM test_audit;

---2b---
CREATE OR REPLACE FUNCTION a() RETURNS trigger AS
$$
BEGIN
    UPDATE test SET age = age('2021-12-01', birth_date) WHERE id = new.id;
    RETURN new;
end;
$$
    LANGUAGE plpgsql;

CREATE trigger age_add
    AFTER INSERT on test
    FOR EACH ROW EXECUTE PROCEDURE a();

---2c---
CREATE table item(
    id int,
    name text,
    price numeric
);
CREATE OR REPLACE FUNCTION tax() RETURNS trigger AS
$$
BEGIN
    UPDATE item SET price = price * 1.12 WHERE id = new.id;
    RETURN new;
end;
$$
    LANGUAGE plpgsql;

CREATE trigger tax_add
    AFTER INSERT ON item
    FOR EACH ROW EXECUTE PROCEDURE tax();

INSERT INTO item VALUES (1, 'nokia', 2000);
INSERT INTO item VALUES (2, 'oppo', 1578);
INSERT INTO item VALUES (3, 'apple', 9000);

----2e----
CREATE table user1(
    id int,
    name text,
    password varchar(50),
    check_num numeric
);
CREATE table user_audit(
    id int,
    name text,
    valid_pass bool,
    val1 numeric,
    val2 numeric
);

CREATE OR REPLACE FUNCTION DandE() RETURNS trigger AS
$$
BEGIN
    IF check_password(new.password) THEN
        INSERT INTO user_audit VALUES (new.id, new.name, true, (e(new.check_num)).val1, (e(new.check_num)).val2);
    ELSIF NOT check_password(new.password) THEN
        INSERT INTO user_audit VALUES (new.id, new.name, false, NULL, NULL);
    end if;
    RETURN new;
end;
$$
    LANGUAGE plpgsql;

CREATE trigger dande
    AFTER INSERT ON user1
    FOR EACH ROW EXECUTE PROCEDURE DandE();

INSERT INTO user1 VALUES (1, 'Damir', 'hisvkn', 50);
INSERT INTO user1 VALUES (2, 'Asyl', 'codppc', 10);
INSERT INTO user1 VALUES (3, 'Leila', 'vosvps', 1000);


---4---
DROP table task4;
CREATE table task4(
    id int PRIMARY KEY,
    name varchar,
    date_of_birth date,
    age int,
    salary int,
    workexperince int,
    discount int
);
INSERT INTO task4 VALUES (1, 'Damir', '2003-01-03', 18, 100000, 3, 0);
INSERT INTO task4 VALUES (2, 'Asyl', '2001-09-24', 20, 120000, 5, 0);
INSERT INTO task4 VALUES (3, 'Leila', '2000-11-27', 21, 1900000, 12, 0);

SELECT 5/2;
----4a---
CREATE OR REPLACE PROCEDURE accounting(id12 int, exp int) AS
$$
BEGIN
    UPDATE task4 SET salary = salary * (exp / 2) * 1.1 WHERE id = id12 AND exp >= 2;
    UPDATE task4 SET discount = discount + 10 WHERE id = id12 AND exp >= 2;
    UPDATE task4 SET discount = discount + 1 WHERE id = id12 AND exp >= 5;
end;
$$
    LANGUAGE plpgsql;

SELECT * FROM task4;

call accounting(1,3);
call accounting(2,5);
call accounting(3,12);
----4b----

CREATE OR REPLACE PROCEDURE accounting2(id12 int, exp int) AS
$$
BEGIN
    UPDATE task4 SET salary = salary * 1.15 WHERE id = id12 AND age >= 40;
    UPDATE task4 SET salary = salary * 1.15 AND discount = 20 WHERE id = id12 AND workexperince >= 8;
end;
$$
    LANGUAGE plpgsql;
SELECT * FROM task4;

call accounting2(1,3);
call accounting2(2,5);
call accounting2(3,12);

-----5----
CREATE schema cd;

CREATE table members(
    memid int PRIMARY KEY,
    surname varchar(200),
    firstname varchar(200),
    address varchar(300),
    zipcode int,
    telephone varchar(20),
    recommendedby int REFERENCES members(memid),
    joindate timestamp
);

CREATE table facilities(
    faceid int PRIMARY KEY,
    name varchar(100),
    membercost numeric,
    guestcost numeric,
    initialoutlay numeric,
    monthlymaintenance numeric
);

CREATE table booking(
    faceid int PRIMARY KEY REFERENCES facilities,
    memid int REFERENCES members,
    starttime timestamp,
    slots int
);

with recursive recommenders(recommender, member) as (
    select recommendedby, memid from cd.members
    union all
    select mems.recommendedby, recs.member from recommenders recs inner join cd.members mems on mems.memid = recs.recommender
)
select recs.member member, recs.recommender, mems.firstname, mems.surname
from recommenders recs inner join cd.members mems on recs.recommender = mems.memid where recs.member = 12 or recs.member = 22
order by recs.member asc, recs.recommender desc;


INSERT INTO members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate) VALUES
(0, 'GUEST', 'GUEST', 'GUEST', 0, '(000) 000-0000', NULL, '2012-07-01 00:00:00'),
(1, 'Smith', 'Darren', '8 Bloomsbury Close, Boston', 4321, '555-555-5555', NULL, '2012-07-02 12:02:05'),
(2, 'Smith', 'Tracy', '8 Bloomsbury Close, New York', 4321, '555-555-5555', NULL, '2012-07-02 12:08:23'),
(3, 'Rownam', 'Tim', '23 Highway Way, Boston', 23423, '(844) 693-0723', NULL, '2012-07-03 09:32:15'),
(4, 'Joplette', 'Janice', '20 Crossing Road, New York', 234, '(833) 942-4710', 1, '2012-07-03 10:25:05'),
(5, 'Butters', 'Gerald', '1065 Huntingdon Avenue, Boston', 56754, '(844) 078-4130', 1, '2012-07-09 10:44:09'),
(6, 'Tracy', 'Burton', '3 Tunisia Drive, Boston', 45678, '(822) 354-9973', NULL, '2012-07-15 08:52:55'),
(7, 'Dare', 'Nancy', '6 Hunting Lodge Way, Boston', 10383, '(833) 776-4001', 4, '2012-07-25 08:59:12'),
(8, 'Boothe', 'Tim', '3 Bloomsbury Close, Reading, 00234', 234, '(811) 433-2547', 3, '2012-07-25 16:02:35'),
(9, 'Stibbons', 'Ponder', '5 Dragons Way, Winchester', 87630, '(833) 160-3900', 6, '2012-07-25 17:09:05'),
(10, 'Owen', 'Charles', '52 Cheshire Grove, Winchester, 28563', 28563, '(855) 542-5251', 1, '2012-08-03 19:42:37'),
(11, 'Jones', 'David', '976 Gnats Close, Reading', 33862, '(844) 536-8036', 4, '2012-08-06 16:32:55'),
(12, 'Baker', 'Anne', '55 Powdery Street, Boston', 80743, '844-076-5141', 9, '2012-08-10 14:23:22'),
(13, 'Farrell', 'Jemima', '103 Firth Avenue, North Reading', 57392, '(855) 016-0163', NULL, '2012-08-10 14:28:01'),
(14, 'Smith', 'Jack', '252 Binkington Way, Boston', 69302, '(822) 163-3254', 1, '2012-08-10 16:22:05'),
(15, 'Bader', 'Florence', '264 Ursula Drive, Westford', 84923, '(833) 499-3527', 9, '2012-08-10 17:52:03'),
(16, 'Baker', 'Timothy', '329 James Street, Reading', 58393, '833-941-0824', 13, '2012-08-15 10:34:25'),
(17, 'Pinker', 'David', '5 Impreza Road, Boston', 65332, '811 409-6734', 13, '2012-08-16 11:32:47'),
(20, 'Genting', 'Matthew', '4 Nunnington Place, Wingfield, Boston', 52365, '(811) 972-1377', 5, '2012-08-19 14:55:55'),
(21, 'Mackenzie', 'Anna', '64 Perkington Lane, Reading', 64577, '(822) 661-2898', 1, '2012-08-26 09:32:05'),
(22, 'Coplin', 'Joan', '85 Bard Street, Bloomington, Boston', 43533, '(822) 499-2232', 16, '2012-08-29 08:32:41'),
(24, 'Sarwin', 'Ramnaresh', '12 Bullington Lane, Boston', 65464, '(822) 413-1470', 15, '2012-09-01 08:44:42'),
(26, 'Jones', 'Douglas', '976 Gnats Close, Reading', 11986, '844 536-8036', 11, '2012-09-02 18:43:05'),
(27, 'Rumney', 'Henrietta', '3 Burkington Plaza, Boston', 78533, '(822) 989-8876', 20, '2012-09-05 08:42:35'),
(28, 'Farrell', 'David', '437 Granite Farm Road, Westford', 43532, '(855) 755-9876', NULL, '2012-09-15 08:22:05'),
(29, 'Worthington-Smyth', 'Henry', '55 Jagbi Way, North Reading', 97676, '(855) 894-3758', 2, '2012-09-17 12:27:15'),
(30, 'Purview', 'Millicent', '641 Drudgery Close, Burnington, Boston', 34232, '(855) 941-9786', 2, '2012-09-18 19:04:01'),
(33, 'Tupperware', 'Hyacinth', '33 Cheerful Plaza, Drake Road, Westford', 68666, '(822) 665-5327', NULL, '2012-09-18 19:32:05'),
(35, 'Hunt', 'John', '5 Bullington Lane, Boston', 54333, '(899) 720-6978', 30, '2012-09-19 11:32:45'),
(36, 'Crumpet', 'Erica', 'Crimson Road, North Reading', 75655, '(811) 732-4816', 2, '2012-09-22 08:36:38'),
(37, 'Smith', 'Darren', '3 Funktown, Denzington, Boston', 66796, '(822) 577-3541', NULL, '2012-09-26 18:08:45');