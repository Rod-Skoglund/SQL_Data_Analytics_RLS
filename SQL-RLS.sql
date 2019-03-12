#*******************************************************************************
# Make the sakila database the current database for all the following commands
#*******************************************************************************
USE sakila;

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#                             SECTION 1
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

#*******************************************************************************
# 1a. Display the first and last names of all actors from the table `actor`.
#*******************************************************************************
SELECT first_name, last_name FROM actor;

#*******************************************************************************
# 1b. Display the first and last name of each actor in a single column in 
#     upper case letters. Name the column `Actor Name`.
#*******************************************************************************
SELECT CONCAT(UPPER(first_name), ' ', UPPER(last_name)) 
  AS 'Actor Name' FROM actor;

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#                             SECTION 2
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

#*******************************************************************************
# 2a. You need to find the ID number, first name, and last name of an actor, of 
#     whom you know only the first name, "Joe." What is one query would you use 
#     to obtain this information?
#*******************************************************************************
SELECT actor_id, first_name, last_name FROM actor
  WHERE first_name = 'Joe';

#*******************************************************************************
# 2b. Find all actors whose last name contain the letters `GEN`:
#*******************************************************************************
SELECT * FROM actor
  WHERE last_name LIKE '%GEN%';

#*******************************************************************************
# 2c. Find all actors whose last names contain the letters `LI`. This time, 
#     order the rows by last name and first name, in that order:
#*******************************************************************************
SELECT * FROM actor 
  WHERE last_name LIKE '%LI%' 
  ORDER BY `last_name`,`first_name` ASC;

#*******************************************************************************
# 2d. Using `IN`, display the `country_id` and `country` columns of the 
#     following countries: Afghanistan, Bangladesh, and China:
#*******************************************************************************
SELECT country_id, country
  FROM country 
  WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#                             SECTION 3
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

#*******************************************************************************
# 3a. You want to keep a description of each actor. You don't think you will be 
#     performing queries on a description, so create a column in the table 
#     `actor` named `description` and use the data type 'BLOB` (Make sure to 
#     research the type `BLOB`, as the difference between it and `VARCHAR` are 
#     significant).
#*******************************************************************************
ALTER TABLE actor
  ADD COLUMN description BLOB NULL;


#*******************************************************************************
# 3b. Very quickly you realize that entering descriptions for each actor is too 
#     much effort. Delete the `description` column.
#*******************************************************************************
ALTER TABLE actor
  DROP COLUMN description;

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#                             SECTION 4
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

#*******************************************************************************
# 4a. List the last names of actors, as well as how many actors have that last 
#     name.
#*******************************************************************************
SELECT last_name, COUNT(last_name) AS 'Count'
  FROM actor
  GROUP BY last_name;

#*******************************************************************************
# 4b. List last names of actors and the number of actors who have that last 
#     name, but only for names that are shared by at least two actors
#*******************************************************************************
SELECT last_name, COUNT(last_name) as 'Num' FROM actor
  GROUP BY last_name
  HAVING Num >= 2;
  
#*******************************************************************************
# 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table 
#     as `GROUCHO WILLIAMS`. Write a query to fix the record.
#*******************************************************************************
UPDATE actor
  SET first_name = 'HARPO'
  WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
  
#*******************************************************************************
# 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out 
#     that `GROUCHO` was the correct name after all! In a single query, if the 
#     first name of the actor is currently `HARPO`, change it to `GROUCHO`.
#*******************************************************************************
UPDATE actor
  SET first_name = 'GROUCHO'
  WHERE first_name = 'HARPO';
  
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#                             SECTION 5
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

#*******************************************************************************
# 5a. You cannot locate the schema of the `address` table. Which query would you 
#     use to re-create it?
# 
#  * Hint: [https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html]
#          (https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html)
#*******************************************************************************
SHOW CREATE TABLE address;

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#                             SECTION 6
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

#*******************************************************************************
# 6a. Use `JOIN` to display the first and last names, as well as the address, 
#     of each staff member. Use the tables `staff` and `address`:
#*******************************************************************************
SELECT staff.first_name, staff.last_name, address.address FROM staff 
  INNER JOIN address ON staff.address_id = address.address_id;

#*******************************************************************************
# 6b. Use `JOIN` to display the total amount rung up by each staff member in 
#     August of 2005. Use tables `staff` and `payment`.
#*******************************************************************************
SELECT staff.first_name, staff.last_name, SUM(payment.amount) AS 'Total' 
  FROM staff INNER JOIN payment ON staff.staff_id = payment.staff_id
  WHERE payment.payment_date LIKE '2005-08%'
  GROUP BY staff.last_name;

#*******************************************************************************
# 6c. List each film and the number of actors who are listed for that film. Use 
#     tables `film_actor` and `film`. Use inner join.
#*******************************************************************************
SELECT film.film_id, film.title, COUNT(film_actor.actor_id) AS 'Number of Actors' 
  FROM film INNER JOIN film_actor ON film.film_id = film_actor.film_id
  GROUP BY film.film_id;

#*******************************************************************************
# 6d. How many copies of the film `Hunchback Impossible` exist in the inventory 
#     system?
#*******************************************************************************
SELECT film.film_id, film.title, COUNT(inventory.inventory_id) AS 'Number of Copies' 
  FROM film INNER JOIN inventory ON film.film_id = inventory.film_id
  WHERE film.title = 'Hunchback Impossible';
  
#*******************************************************************************
# 6e. Using the tables `payment` and `customer` and the `JOIN` command, list 
#     the total paid by each customer. List the customers alphabetically by 
#     last name:
#
#     ![Total amount paid](Images/total_payment.png)
#*******************************************************************************
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS 'Total Amount Paid' 
  FROM payment INNER JOIN customer ON payment.customer_id = customer.customer_id
  GROUP BY payment.customer_id
  ORDER BY customer.last_name;
  
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#                             SECTION 7
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

#*******************************************************************************
# 7a. The music of Queen and Kris Kristofferson have seen an unlikely 
#     resurgence. As an unintended consequence, films starting with the letters 
#     `K` and `Q` have also soared in popularity. Use subqueries to display the 
#     titles of movies starting with the letters `K` and `Q` whose language is 
#     English.
#*******************************************************************************
SELECT film.title, language.name 
  FROM film INNER JOIN language ON film.language_id = language.language_id
  WHERE (film.title LIKE 'K%' OR film.title LIKE 'Q%') 
  AND (SELECT film.language_id WHERE film.language_id = 1);


#*******************************************************************************
# 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
#*******************************************************************************
SELECT film.title, actor.first_name, actor.last_name 
  FROM film 
  INNER JOIN film_actor ON film.film_id = film_actor.film_id
  INNER JOIN actor ON actor.actor_id = film_actor.actor_id
  WHERE (SELECT film_actor.actor_id WHERE film_actor.film_id = 17);

#*******************************************************************************
# 7c. You want to run an email marketing campaign in Canada, for which you will 
#     need the names and email addresses of all Canadian customers. Use joins 
#     to retrieve this information.
#*******************************************************************************
SELECT country.country, customer.first_name, customer.last_name, customer.email
  FROM customer 
  INNER JOIN address ON customer.address_id = address.address_id
  INNER JOIN city ON address.city_id = city.city_id
  INNER JOIN country ON city.country_id = country.country_id
  WHERE (SELECT city.country_id WHERE city.country_id = 20);

#*******************************************************************************
# 7d. Sales have been lagging among young families, and you wish to target all 
#     family movies for a promotion. Identify all movies categorized as 
#     _family_ films.
#*******************************************************************************
SELECT film.film_id, film.title, category.name 
  FROM film 
  INNER JOIN film_category ON film.film_id = film_category.film_id
  INNER JOIN category ON film_category.category_id = category.category_id
  WHERE film_category.category_id = 
    (SELECT category_id FROM category WHERE category.name = 'Family');

#*******************************************************************************
# 7e. Display the most frequently rented movies in descending order.
#*******************************************************************************
SELECT film.film_id, film.title, COUNT(rental.inventory_id) AS 'Number of Rentals'
  FROM film
  INNER JOIN inventory ON film.film_id = inventory.film_id
  INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
  GROUP BY film.title 
  ORDER BY COUNT(rental.inventory_id) DESC;

#*******************************************************************************
# 7f. Write a query to display how much business, in dollars, each store 
#     brought in.
#*******************************************************************************
SELECT inventory.store_id, SUM(payment.amount) AS 'Total Income'
  FROM payment
  INNER JOIN rental ON payment.rental_id = rental.rental_id
  INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
  GROUP BY inventory.store_id; 

#*******************************************************************************
# 7g. Write a query to display for each store its store ID, city, and country.
#*******************************************************************************
SELECT store.store_id, city.city, country.country
  FROM store
  INNER JOIN address ON store.address_id = address.address_id
  INNER JOIN city ON address.city_id = city.city_id
  INNER JOIN country ON city.country_id = country.country_id
  WHERE store.store_id = 1 OR store.store_id = 2; 

#*******************************************************************************
# 7h. List the top five genres in gross revenue in descending order. 
#     (**Hint**: you may need to use the following tables: category, 
#     film_category, inventory, payment, and rental.)
#*******************************************************************************
SELECT category.name AS 'Genre', SUM(payment.amount) AS 'Gross Revenue'
  FROM payment
  INNER JOIN rental ON payment.rental_id = rental.rental_id
  INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
  INNER JOIN film_category ON inventory.film_id = film_category.film_id
  INNER JOIN category ON film_category.category_id = category.category_id
  GROUP BY category.name
  ORDER BY SUM(payment.amount) DESC
  LIMIT 5;

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#                             SECTION 8
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

#*******************************************************************************
# 8a. In your new role as an executive, you would like to have an easy way of 
#     viewing the Top five genres by gross revenue. Use the solution from the 
#     problem above to create a view. If you haven't solved 7h, you can 
#     substitute another query to create a view.
#*******************************************************************************
CREATE VIEW top_five_genres as 
(
  SELECT category.name AS 'Genre', SUM(payment.amount) AS 'Gross Revenue'
	FROM payment
	INNER JOIN rental ON payment.rental_id = rental.rental_id
	INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
	INNER JOIN film_category ON inventory.film_id = film_category.film_id
	INNER JOIN category ON film_category.category_id = category.category_id
	GROUP BY category.name
	ORDER BY SUM(payment.amount) DESC
	LIMIT 5
);
  
#*******************************************************************************
# 8b. How would you display the view that you created in 8a?
#*******************************************************************************
SELECT * FROM top_five_genres;

#*******************************************************************************
# 8c. You find that you no longer need the view `top_five_genres`. Write a 
#     query to delete it.
#*******************************************************************************
DROP VIEW top_five_genres;

  
