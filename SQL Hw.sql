use sakila;

-- select first name and last name from actor
select first_name,last_name
from actor
-- display first and last name in one column upper case with a column name Actor name
SELECT UPPER(CONCAT(first_name, ', ', last_name)) AS 'Actor Name' FROM actor;
-- display actor id , first name,last name wher actor id is joe

SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'Joe';

-- where last name is gen
SELECT actor_id, first_name, last_name FROM actor WHERE last_name like '%GEN%';

-- find last name with li
 SELECT actor_id, first_name, last_name FROM actor WHERE last_name like '%LI%'
  ORDER BY last_name, first_name;
  
  -- Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
  SELECT country_id, country FROM country 
  WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
  
   -- Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
   ALTER TABLE actor ADD COLUMN middle_name VARCHAR(45) NOT NULL AFTER first_name;
   
   -- You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
   ALTER TABLE actor CHANGE COLUMN middle_name middle_name BLOB NOT NULL;
   
   -- Now delete the middle_name column.
   ALTER TABLE actor DROP COLUMN middle_name;
   
   -- List the last names of actors, as well as how many actors have that last name.
   SELECT last_name, COUNT(last_name) FROM actor GROUP BY last_name;
   
   --  List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
 SELECT last_name, COUNT(last_name) as ln_count FROM actor GROUP BY last_name HAVING ln_count >=2;
 
 -- Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
  UPDATE actor SET first_name = 'HARPO' WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS'; 
  
  --  Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
  UPDATE actor SET first_name = 'GROUCHO' WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS'; 	
  
  -- You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE actor;

-- Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
  SELECT s.first_name, s.last_name, a.address 
  FROM staff s
  JOIN address a
  ON (s.address_id = a.address_id);
  
  -- Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
  SELECT s.staff_id, s.first_name, s.last_name, SUM(p.amount), P.payment_date 
  FROM payment p
  JOIN staff s
  USING (staff_id)
  WHERE payment_date between str_to_date('2005-08-01','%Y-%m-%d') AND str_to_date('2005-08-31','%Y-%m-%d')
  GROUP BY s.staff_id;
  
  --  List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
  SELECT f.film_id, f.title, COUNT(fa.actor_id)
  FROM film f
  INNER JOIN film_actor fa
  ON (f.film_id = fa.film_id)
  GROUP BY fa.film_id;
  
  -- How many copies of the film Hunchback Impossible exist in the inventory system?
  SELECT f.film_id, f.title, COUNT(i.film_id)
  FROM inventory i
  JOIN film f
  USING (film_id)
  WHERE f.title = UPPER('Hunchback Impossible')
  GROUP BY i.film_id;
  
  -- Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
  SELECT c.customer_id, c.first_name, c.last_name, sum(p.amount) as 'Total Amount Paid'
  FROM payment p
  JOIN customer c
  USING (customer_id)
  GROUP BY p.customer_id
  ORDER BY c.last_name;
  
  -- The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English. 
   SELECT f.film_id, f.title
  FROM film f
  WHERE (title LIKE 'K%' OR title LIKE 'Q%')
  AND language_id IN
  (
  SELECT language_id
  FROM language
  WHERE name = 'English'
  );
  
  -- Use subqueries to display all actors who appear in the film Alone Trip.
  SELECT a.actor_id, a.first_name, a.last_name
  FROM actor a
  WHERE a.actor_id IN 
  (
  	SELECT fa.actor_id
  	FROM film_actor fa
  	WHERE fa.film_id IN
  	(
  		SELECT f.film_id
  		FROM film f
  		WHERE f.title = 'Alone Trip'
  	)
  )ORDER BY a.first_name;

-- You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
  SELECT cu.customer_id, cu.first_name, cu.last_name, cu.email, co.country  
  FROM customer cu
  JOIN address a USING(address_id)
  JOIN city c ON (a.city_id = c.city_id)
  JOIN country co ON (c.country_id = co.country_id)
  AND co.country = 'Canada';
  
  -- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
  SELECT f.title, c.name
  FROM film f
  JOIN film_category fc USING (film_id)
  JOIN category c USING (category_id)
  WHERE c.name = 'Family';

-- Display the most frequently rented movies in descending order.
  SELECT f.film_id, f.title, COUNT(r.customer_id) AS rental_count
  FROM rental r
  JOIN inventory i USING (inventory_id) 
  JOIN film f USING (film_id)
  GROUP BY f.film_id
  ORDER BY rental_count DESC;
  
  -- Write a query to display how much business, in dollars, each store brought in.
  SELECT s.store_id, sum(p.amount) as 'Business(in $)'
  FROM store s
  JOIN payment p ON (p.staff_id = s.manager_staff_id)
  GROUP BY p.staff_id;
  
  -- Write a query to display for each store its store ID, city, and country.
  SELECT s.store_id, c.city, co.country
  FROM store s
  JOIN address a USING(address_id)
  JOIN city c USING(city_id)
  JOIN country co USING(country_id);
  
  -- List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
  SELECT ca.name AS Genre, SUM(p.amount) AS Revenue
  FROM category ca
  JOIN film_category fc USING(category_id)
  JOIN inventory i USING(film_id)
  JOIN rental r USING(inventory_id)
  JOIN payment p USING(rental_id)
  GROUP BY ca.category_id
  ORDER BY Revenue DESC LIMIT 5;
  
  -- In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
  CREATE VIEW top_five_genres AS 
  SELECT ca.name AS Genre, SUM(p.amount) AS Revenue
  FROM category ca
  JOIN film_category fc USING(category_id)
  JOIN inventory i USING(film_id)
  JOIN rental r USING(inventory_id)
  JOIN payment p USING(rental_id)
  GROUP BY ca.category_id
  ORDER BY Revenue DESC LIMIT 5;
  
  -- How would you display the view that you created in 8a?
  SHOW CREATE VIEW top_five_genres;
  SELECT * FROM top_five_genres;
  
  -- You find that you no longer need the view top_five_genres. Write a query to delete it.
  DROP VIEW top_five_genres;