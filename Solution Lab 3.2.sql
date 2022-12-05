USE sakila;

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT *
FROM inventory;

SELECT *
FROM film;

SELECT *
FROM film
WHERE title = "Hunchback Impossible";

SELECT *
FROM inventory
WHERE film_id = 439;

SELECT COUNT(*) AS "number of copies"
FROM inventory
WHERE film_id =439;

-- OR

SELECT COUNT(*) AS "number of copies"
FROM inventory
WHERE film_id IN
(SELECT film_id 
FROM film
WHERE title = "Hunchback Impossible");

-- 2. List all films whose length is longer than the average of all the films.

SELECT *
FROM film;

SELECT AVG(length)
FROM film;

SELECT DISTINCT title, length 
FROM film 
WHERE length > 
(SELECT AVG(length) 
FROM film)
ORDER BY length DESC;

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT * 
FROM actor;

SELECT * 
FROM film;

SELECT *
FROM film_actor;

SELECT *
FROM film
WHERE title = "Alone Trip";

SELECT first_name, last_name, title
FROM film_actor fa
JOIN film f
ON  f.film_id = fa.film_id
JOIN sakila.actor a
ON a.actor_id = fa.actor_id
WHERE f.title = "Alone Trip";

-- Subquery way: 

SELECT CONCAT(a.first_name, " ", a.last_name) AS "ACTOR NAME"
FROM actor a
WHERE a.actor_id IN
(SELECT fa.actor_id 
FROM film_actor fa 
WHERE film_id IN
(SELECT f.film_id 
FROM film f 
WHERE title = "Alone Trip"));

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT title 
FROM film 
WHERE film_id IN
(SELECT film_id 
FROM film_category 
WHERE category_id IN
(SELECT category_id 
FROM category 
WHERE name = "Family"));

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

SELECT *
FROM customer;

SELECT * 
FROM address;

SELECT *
FROM city;

SELECT *
FROM country;

SELECT *
FROM country
WHERE country = "Canada";

SELECT first_name, last_name, email
FROM country co
JOIN city ci
ON co.country_id = ci.country_id
JOIN address a
ON ci.city_id = a.city_id
JOIN customer cu
ON a.address_id = cu.address_id
WHERE country = "Canada";

-- Subquery way:

SELECT first_name, last_name, email 
FROM customer
WHERE address_id IN
(SELECT address_id 
FROM address 
WHERE city_id IN
(SELECT city_id 
FROM city 
WHERE country_id IN
(SELECT country_id 
FROM country 
WHERE country = "Canada")));

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

SELECT *
FROM film;

SELECT *
FROM film_actor;

SELECT *
FROM actor;

SELECT COUNT(fa.actor_id) AS "number of films performed", a.*
FROM film_actor fa
JOIN actor a
ON fa.actor_id = a.actor_id
GROUP BY fa.actor_id
ORDER BY COUNT(fa.actor_id) DESC;

SELECT fa.film_id
FROM film_actor fa
WHERE fa.actor_id = 107;

SELECT title 
FROM film f
JOIN film_actor fa
ON f.film_id = fa.film_id
JOIN actor a
ON a.actor_id = fa.actor_id
WHERE fa.actor_id = 107;

-- Subquery way:

SELECT title 
FROM film 
WHERE film_id IN
(SELECT film_id 
FROM film_actor 
WHERE actor_id IN
(SELECT actor_id 
FROM film_actor
WHERE film_actor.actor_id = 107));

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

SELECT *
FROM rental;

SELECT *
FROM payment; 

SELECT *
FROM customer;

SELECT SUM(amount), customer_id
FROM payment
GROUP BY customer_id
ORDER BY SUM(amount)DESC; -- the most profitable customer is 526 id. 

SELECT DISTINCT title
FROM film f
JOIN inventory i
ON f.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id
JOIN customer c
ON r.customer_id = c.customer_id
WHERE c.customer_id = 526
ORDER BY title ASC;

-- Subquery way:

SELECT title
FROM film
WHERE film_id IN
(SELECT film_id
FROM inventory
WHERE inventory_id IN
(SELECT DISTINCT inventory_id
FROM rental r
WHERE customer_id LIKE
(SELECT customer_id
FROM payment
GROUP BY customer_id
ORDER BY  SUM(amount) DESC
LIMIT 1)))
ORDER BY title ASC;

-- 8. Customers who spent more than the average payments.

SELECT *
FROM payment;

SELECT customer_id, SUM(amount) AS "Total Amount"
FROM payment 
GROUP BY customer_id 
HAVING SUM(amount) >
(SELECT AVG(total) 
FROM (SELECT SUM(amount) AS total 
FROM payment 
GROUP BY customer_id) AS sum1)
ORDER BY SUM(amount) DESC;

-- OR

SELECT SUM(amount) AS Total, customer_id
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > SUM(amount)/COUNT(customer_id)
ORDER BY SUM(amount) DESC;

-- I was trying to build the code without the sunqueries but i am not able to find a way of calculating the AVG of the sum of amounts without the subquery. 



