-- Exercise 1:
-- Goal: Here we use users table to pull a list of user email addresses. 
-- Edit the query to pull email addresses, but only for non-deleted users.

SELECT email_address

FROM dsv1069.users

WHERE deleted_at is NULL;

-- Exercise 2:
-- Goal: Use the items table to count the number of items for sale in each category

SELECT category,
  COUNT(id) AS item_count

FROM dsv1069.items

GROUP BY category

ORDER BY item_count ASC;

-- Exercise 3:
--Goal: Select all of the columns from the result when you JOIN the users 
-- table to the orders table

SELECT *

FROM dsv1069.users u

JOIN dsv1069.orders o 
  ON u.id = o.user_id
  
ORDER BY u.id ASC;

-- Exercise 4:
--Goal: Check out the query below. This is not the right way to count the 
-- number of viewed_item events. Determine what is wrong and correct the error.

SELECT COUNT(DISTINCT event_id) AS events

FROM dsv1069.events

WHERE event_name = 'view_item';

-- Exercise 5:
--Goal:Compute the number of items in the items table which have been 
-- ordered. The query below runs, but it isn’t right. Determine what is 
-- wrong and correct the error or start from scratch.

SELECT COUNT(DISTINCT o.item_id) AS item_count

FROM dsv1069.orders o;

-- Exercise 6:
--Goal: For each user figure out IF a user has ordered something, and
-- when their first purchase was. The query below doesn’t return info 
-- for any of the users who haven’t ordered anything.

SELECT users.id as user_id,
  MIN(orders.paid_at) AS min_paid_at
  
FROM dsv1069.users

LEFT JOIN dsv1069.orders
  ON users.id = orders.user_id
  
GROUP BY users.id

ORDER BY min_paid_at DESC;

-- Exercise 7:
--Goal: Figure out what percent of users have ever viewed the user 
-- profile page, but this query isn’t right. Check to make sure the
-- number of users adds up, and if not, fix the query.

SELECT (
		CASE 
			WHEN first_view IS NULL
				THEN false
			ELSE true
			END
		) AS has_viewed_profile_page,
	COUNT(user_id) AS users

-- creates first_profile_views table
FROM (
	SELECT users.id AS user_id,
		MIN(event_time) AS first_view
	
	FROM dsv1069.users
	
	LEFT JOIN dsv1069.events
		ON events.user_id = users.id
		AND event_name = 'view_user_profile'
	
	GROUP BY users.id
	) first_profile_views

GROUP BY has_viewed_profile_page;

