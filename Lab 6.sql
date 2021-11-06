--- Task 1
--- a
SELECT *
FROM dealer cross join client;

--- b
SELECT d.name, c.name, c.city, c.priority, s.id as sell_number, s.date, s.amount
FROM dealer as d
         inner join client as c ON d.id = c.dealer_id
         inner join sell as s ON c.id = s.client_id
ORDER BY d.id;

--- c
SELECT d.name, c.name, city
from dealer as d inner join client as c ON d.location = c.city;

--- d
SELECT s.id, amount, name, city
FROM sell as s
inner join client ON amount >= 100 AND amount <= 500 AND s.client_id = client.id
ORDER BY amount;

--- e
SELECT d.id, d.name
FROM client right join dealer as d ON d.id = client.dealer_id;

--- f
SELECT c.name, city, d.name, charge
FROM client c inner join dealer d ON c.dealer_id = d.id;

--- g
SELECT c.name, city, d.name, charge
FROM client c inner join dealer d ON c.dealer_id = d.id AND charge > 0.12;

--- h
SELECT c.name, city, s.id, s.date, amount, d.name, charge
FROM client c
    left join dealer d ON c.dealer_id = d.id
    left join sell s ON c.id = s.client_id;

--- i
SELECT c.name,c.city,c.priority,d.name,s.id,s.date,s.amount
FROM client c
         RIGHT OUTER JOIN dealer d ON d.id = c.dealer_id
         LEFT OUTER JOIN sell s ON s.client_id = c.id
WHERE s.amount >= 2000 AND c.priority is NOT NULL;

--- Task 2
--- a
create view day_info as
    select date,count(distinct client_id), avg(amount), sum(amount)
    from sell group by date;

select * from day_info;

--- b
CREATE VIEW each_date_sum AS
SELECT s.date, s.amount from sell s
ORDER BY s.amount desc limit 5;

--- c
CREATE VIEW dealers_sale AS
SELECT dealer_id, count(dealer_id), AVG(amount), SUM(amount)
from sell
group by dealer_id
ORDER BY dealer_id;

--- d
CREATE VIEW earned AS
SELECT location, sum(total)
FROM (SELECT d.location, SUM(amount) * d.charge as total
      FROM sell inner join dealer d on sell.dealer_id = d.id
      group by d.location, d.charge) q
group by location
having location = q.location;

--- e
create view city_dealer as
SELECT location, count(sell.id), sum(amount), avg(amount)
from sell inner join dealer on sell.dealer_id = dealer.id
GROUP BY location;

--- f
create view each_city as
SELECT city, count(city), sum(amount), avg(amount)
from client inner join sell s on client.id = s.client_id
GROUP BY city;

--- g
create view cities
as select c.city, sum(s.amount * (d.charge + 1)) as totalexpense, sum(s.amount) as totalamount from client c
join sell s on c.id = s.client_id
join dealer d on s.dealer_id = d.id and c.city = d.location
group by c.city;