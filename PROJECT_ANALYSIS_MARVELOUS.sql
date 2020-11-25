USE mavenmovies;

-- QUESTION 1
-- We will need a list of all staff members including their first names and last names, email addresses and
-- the store identification number of where they work.
SELECT 
    first_name, last_name, email, store_id
FROM
    staff
ORDER BY first_name ASC;

-- QUESTION 2
-- We will need seperate count of inventory items held at each of your two stores
SELECT 
    store_id, COUNT(inventory_id) AS InventoryCount
FROM
    inventory
GROUP BY store_id
ORDER BY store_id;

-- QUESTION 3
-- We will need a count of active customers for each of your stores. Seperately, please.
SELECT 
    store_id, COUNT(customer_id) AS ActiveCustomerCount
FROM
    customer
WHERE
    active = 1
GROUP BY store_id
ORDER BY store_id;


-- QUESTION 4
-- In order to assess the liability of a data breach, we would need you to provide a count of all customers 
-- email addresses stored on the database
SELECT 
    COUNT(email) AS EmailAddressCount
FROM
    customer;


-- QUESTION 5
-- We are interested in how diverse your film offering is as a means of understanding how likely you are to 
-- keep customers engaged in the future. Please provide a count of unique film titles you have in inventory 
-- at each store and then provide a count of unque categories of films you provide.
SELECT 
    COUNT(film_id) AS UniqueFilmCount,
    NULL AS category_id,
    NULL AS UniqueCategoryCount
FROM
    film_category 
UNION SELECT 
    NULL AS film_id, category_id, COUNT(category_id)
FROM
    film_category
GROUP BY category_id;


-- QUESTION 6
-- We would like to understand the replacement cost of your films. Please provide the replacement cost for 
-- the film that is least expensive to replace,  the most expensive to replace and the average of all films 
-- you carry.
SELECT 
    MIN(replacement_cost) LeastExpensiveCost,
    MAX(replacement_cost) MostExpensiveCost,
    ROUND(AVG(replacement_cost), 2) AverageCost
FROM
    film;

-- QUESTION 7
-- We are interested in having you put payment monitoring systems and maximum payment processing restrictions 
-- in place in order to minimize the future risk of fraud by your staff. Please provide average payment you
--  process, as well the maximum you have processed. 
SELECT 
    ROUND(AVG(amount), 2) AveragePayment,
    MAX(amount) MaximumPayment
FROM
    payment;

-- QUESTION 8
-- We would like to better understand what your customer base looks like. Please provide a list of all
-- customer all identification values, with a count of rentals they have made all-time, with your highest 
-- volume customers at he top of the list
SELECT 
    customer_id, COUNT(rental_id) RentalCount
FROM
    rental
GROUP BY customer_id
ORDER BY COUNT(rental_id) desc;

USE mavenmovies;

-- QUESTION 1
-- My partner and I want to come by each of the stores in person and meet the managers. Please, send over the
-- managers' names at each store, with the full address of each property (street address, district, city and 
-- country please)
SELECT 
    S1.store_id,
    CONCAT(S1.first_name, ' ', S1.last_name) ManagerName,
    A.address Street,
    A.district, C1.city, C2.country
FROM
    staff S1
        JOIN
    store S2 ON S1.store_id = S2.store_id
        JOIN
    address A ON S2.address_id = A.address_id
        JOIN
    city C1 ON A.city_id = C1.city_id
        JOIN
    country C2 ON C1.country_id = C2.country_id;

-- QUESTION 2
-- I would like to get a better understanding of all the inventory that would come along with the business. 
-- Please pull together a list of each inventory item you have stocked, including the store_id number, 
-- the inventory_id, the name of the film, the film's rating, it's rental rate and replacement cost.
SELECT 
    I.store_id,
    I.inventory_id,
    F.title,
    F.rating,
    F.rental_rate,
    F.replacement_cost
FROM
    inventory I
        JOIN
    film F ON I.film_id = F.film_id;
-- GROUP BY F.title
-- ORDER BY F.title ASC;

-- QUESTION 3
-- From the same list of films you just pulled, please roll that data up and provide a summary level overview
-- of your inventory. We would like to know how many inventory items you have with each rating at each store.
SELECT 
    I.store_id,
   count(I.inventory_id) InventoryCount,
    F.rating Rating
FROM
    inventory I
        JOIN
    film F ON I.film_id = F.film_id
GROUP BY I.store_id, F.rating
ORDER BY I.store_id ASC;

-- QUESTION 4
-- Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to
-- see how big of a hit it will be if a certain category of film became unpopular at a certain store.
-- We would like to see the number of films, as well average replacement cost, and total replacemen cost 
-- sliced by store and film category
SELECT 
    I.store_id,
    C.name CategoryName,
    COUNT(I.inventory_id) FilmCount,
    AVG(F.replacement_cost) AverageReplacementCost,
    SUM(F.replacement_cost) TotalReplacementcost
FROM
    inventory I
        JOIN
    film F ON I.film_id = F.film_id
        JOIN
    film_category FC ON F.film_id = FC.film_id
        JOIN
    category C ON FC.category_id = C.category_id
GROUP BY I.store_id , C.category_id
ORDER BY I.store_id;

-- QUESTION 5
-- We want to make sure you folks have a good handle on who your customers are. Please provide a list of
-- all customer names, which store they go to, whether or not are currently active, and their full 
-- addresses – street address, city, and country. 
SELECT 
    CONCAT(C.first_name, ' ', C.last_name) CustomerName,
    C.store_id,
    C.active,
    A.address Street,
    A.district, C1.city, C2.country
FROM
    customer C
       JOIN
    address A ON C.address_id = A.address_id
        JOIN
    city C1 ON A.city_id = C1.city_id
        JOIN
    country C2 ON C1.country_id = C2.country_id
    order by CustomerName;


-- QUESTION 6
-- We would like to understand how much your customers are spending with you, and also know who your most
-- valuable customers are. Please pull together a list of customer names, their total lifetime rentals, and the
-- sum of all payments you have collected from them. It would be great to see this ordered on total lifetime 
-- value, with the most valuable customers at top of list.
 
SELECT 
    C.first_name,
    C.last_name,
    count(P.rental_id) TotalRental,
    SUM(P.amount) Paymentsum
FROM
    payment P
        JOIN
    customer C ON P.customer_id = C.customer_id
GROUP BY P.customer_id
ORDER BY TotalRental DESC;

-- QUESTION 7
-- My partner and I would like to get know your board of advisors any current investors. Could you 
-- please provide a list of advisor and investor names in one table? Could you note whether they are an 
-- investor or an advisor, and for the investors, it would be good to include which company they work with.
SELECT 
    I.first_name,
    I.last_name,
    COALESCE('Investor') AS Role,
    I.company_name AS CompanyName
FROM
    investor I 
UNION ALL SELECT 
    A.first_name,
    A.last_name,
    COALESCE('Advisor') AS Role,
    NULL AS CompanyName
FROM
    advisor A;
# ORDER BY role , first_name ASC;

-- QUESTION 8
-- We're interested in how well you have covered the most- awarded actors. Of all the actors with three types 
-- of awards, for what % of them do we carry a film? And how about actors with two types awards? Same
-- questions. Finally, how about actors with just one award? 
(SELECT 
    *
FROM
    actor_award
WHERE
    awards LIKE('%Emmy%Oscar%Tony%')) 
    union (SELECT 
    *
FROM
    actor_award
WHERE
    awards NOT LIKE ('%Emmy%Oscar%Tony%')
        AND awards NOT LIKE ('Oscar')
        AND awards NOT LIKE ('Tony')
        AND awards NOT LIKE ('Emmy'))
    union (SELECT 
    *
FROM
    actor_award
WHERE
    awards LIKE ('Oscar')
       or awards LIKE ('Tony')
        or awards  LIKE ('Emmy'));
        
        
 select  ((count(N1.A1)/count(N2.actor_id)) * 100) from (SELECT 
    actor_id AS A1
FROM
    actor_award
WHERE
    awards LIKE ('Oscar')
       or awards LIKE ('Tony')
        or awards  LIKE ('Emmy')) N1  join (select * from film_actor FA join (SELECT 
    actor_id AS A2
FROM
    actor_award
WHERE
    awards LIKE ('Oscar')
       or awards LIKE ('Tony')
        or awards  LIKE ('Emmy')) B on B.A2 = FA.actor_id) N2;
        
