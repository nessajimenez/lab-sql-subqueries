USE sakila;
-- 1 Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT 'Hunchback Impossible' AS 'name_of_movie', film_id AS 'movie_id', COUNT(inventory_id) AS 'available'
FROM inventory
WHERE inventory.film_id IN (SELECT film_id FROM film WHERE title= 'Hunchback Impossible')
GROUP BY film_id;

-- 2 List all films whose length is longer than the average length of all the films in the Sakila database.
Select film.title AS 'movie', film.length AS 'run_time'
FROM film
WHERE film.length > (SELECT AVG(film.length)
FROM film);

-- 3 Use a subquery to display all actors who appear in the film "Alone Trip".

SELECT CONCAT(actor.first_name, ' ', actor.last_name) AS 'Actor_from _Alone_Trip'
FROM actor
WHERE actor_id IN (
						SELECT actor_id 
                        FROM film_actor 
                        WHERE film_id IN(
										SELECT film_id FROM film WHERE title = 'Alone Trip') 
						);


-- 4 Sales have been lagging among young families, and you want to target family movies for a promotion. 
-- Identify all movies categorized as family films.

SELECT film.title AS 'Family Films'
FROM film
WHERE film_id IN(
				SELECT film_id
				FROM film_category
				WHERE category_id IN(
							SELECT category_id
							FROM category
							WHERE name = 'Family')
            );

-- 5 Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT CONCAT(first_name,' ',last_name) AS 'customer_full_name', email AS 'customer_email'
FROM customer
WHERE address_id IN( 
					SELECT address_id FROM address WHERE city_id IN ( 
																	SELECT city_id FROM city WHERE country_id IN (
																													SELECT country_id FROM country WHERE country = 'Canada')
																	));  

-- 6 Determine which films were starred by the most prolific actor in the Sakila database. 
                    
SELECT title
FROM film
WHERE film_id IN(
SELECT film_id
FROM film_actor
WHERE actor_id = (
    SELECT actor_id
    FROM film_actor
    GROUP BY actor_id
    ORDER BY COUNT(film_id) DESC
    LIMIT 1
));

-- 7 Find the films rented by the most profitable customer in the Sakila database. 
-- You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.
SELECT title
FROM film
WHERE film_id IN(
				SELECT film_id
				From inventory
				WHERE inventory_id IN(
									SELECT rental_id
									FROM rental
									WHERE customer_id =(            
														SELECT customer_id
														FROM ( 
															SELECT customer_id, SUM(amount) AS 'total_amount'
															FROM payment
															GROUP BY customer_id
															ORDER BY SUM(amount) DESC
															limit 1) as subquery)));

-- 8 Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. 
-- You can use subqueries to accomplish this.

SELECT customer_id, total_amount
FROM (
    SELECT customer_id, SUM(amount) AS total_amount
    FROM payment
    GROUP BY customer_id
) AS customer_payments
WHERE total_amount > (
    SELECT MAX(total_amount)
    FROM (
        SELECT SUM(amount) AS total_amount
        FROM payment
        GROUP BY customer_id
    ) AS subquery
);
