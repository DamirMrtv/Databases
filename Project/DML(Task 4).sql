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
WHERE products.name in (SELECT pr.name FROM products pr
                        INNER JOIN order_details ON order_details.product_id = products.product_id
                    WHERE pr.name != 'Простоквашино молоко1' and pr.name != 'Простоквашино молоко2')  LIMIT 3;