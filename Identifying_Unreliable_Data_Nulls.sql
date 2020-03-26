-- Identifying Unreliable Data + Nulls
-- Exercise 1: Using any methods you like determine if you can 
-- you trust this events table.

-- review the columns in the table
-- SELECT * 
-- FROM dsv1069.events_201701
-- LIMIT 5;
-- event_id
-- event_time
-- user_id
-- event_name
-- platform
-- parameter_name
-- parameter_value


-- count the number of records
-- SELECT COUNT(*)
-- FROM dsv1069.events_201701
-- LIMIT 5;
-- returns 7,301 records

-- GROUP BY check
-- SELECT event_name,
--   COUNT(*)
-- FROM dsv1069.events_201701 
-- GROUP BY event_name;
-- event_name	count
-- test_assignment	3112
-- view_user_profile	197
-- view_item	3992

SELECT date(event_time) AS date,
  COUNT(*)
FROM dsv1069.events_201701
GROUP BY date(event_time);


-- NULL check
-- SELECT COUNT(*)
-- FROM dsv1069.events_201701
-- WHERE event_time IS NULL
--   OR user_id  IS NULL
--   OR event_name IS NULL
--   OR platform IS NULL
--   OR parameter_name IS NULL
--   OR parameter_value IS NULL;
  
-- MIN/MAX/AVG check
-- SELECT MIN(Stars) AS min_val,
-- 	MAX(Stars) AS max_val,
-- 	AVG(Stars) AS avg_val
-- FROM review;

-- Exercise 2:
-- Using any methods you like, determine if you can you trust this 
-- events table. (HINT: When did we start recording events on mobile)

-- get columns
-- SELECT *
-- FROM dsv1069.events_ex2
-- LIMIT 5;
-- event_id
-- event_time
-- user_id
-- event_name
-- platform
-- parameter_name
-- parameter_value


-- SELECT platform,
--   COUNT(*)
-- FROM dsv1069.events_ex2
-- GROUP BY platform;

-- SELECT platform,
--   MIN(event_time) AS first_event_time
-- FROM dsv1069.events_ex2
-- GROUP BY platform;

-- SELECT DATE(event_time) AS date,
--   COUNT(*)
-- FROM dsv1069.events_ex2
-- GROUP BY DATE(event_time);

-- SELECT DATE(event_time) AS date,
--   event_name,
--   COUNT(*)
-- FROM dsv1069.events_ex2
-- GROUP BY DATE(event_time),
--   event_name;
  
SELECT DATE(event_time) AS date,
  platform,
  COUNT(*)
FROM dsv1069.events_ex2
GROUP BY DATE(event_time),
  platform;
  
  
-- Exercise 3: Imagine that you need to count item views by day. You found this table
-- item_views_by_category_temp - should you use it to answer your questiuon?

-- get columns
-- SELECT *
-- FROM dsv1069.item_views_by_category_temp
-- category
-- users
-- view_events

-- SELECT SUM(view_events) AS event_count
-- FROM dsv1069.item_views_by_category_temp;

SELECT COUNT(DISTINCT event_id) AS event_count
FROM dsv1069.events
WHERE event_name = 'view_item';

-- Exercise 4: 
-- Using any methods you like, decide if this table is ready to be 
-- used as a source of truth.


-- get columns
-- SELECT *
-- FROM dsv1069.events;
-- event_id
-- event_time
-- user_id
-- event_name
-- platform
-- parameter_name
-- parameter_value

-- SELECT DATE(event_time) AS date,
--   COUNT(*) AS row_count,
--   COUNT(event_id) AS event_count,
--   COUNT(user_id) AS user_count
-- FROM dsv1069.events
-- GROUP BY date;
  
SELECT DATE(event_time) AS date,
  platform,
  COUNT(user_id) AS users
  
FROM dsv1069.events

GROUP BY date,
  platform;



-- Exercise 5: 
-- Is this the right way to join orders to users? Is this the right way this join.

-- get columns
-- SELECT *
-- FROM dsv1069.orders
-- LIMIT 100;
-- invoice_id
-- line_item_id
-- user_id
-- item_id
-- item_name
-- item_category
-- price
-- created_at
-- paid_at

-- get columns
-- SELECT *
-- FROM dsv1069.users
-- LIMIT 100;
-- created_at
-- deleted_at
-- email_address
-- first_name
-- id
-- last_name
-- merged_at
-- parent_user_id

SELECT COUNT(*)
FROM dsv1069.orders
  JOIN dsv1069.users
  ON orders.user_id = COALESCE(users.parent_user_id, user_id)
