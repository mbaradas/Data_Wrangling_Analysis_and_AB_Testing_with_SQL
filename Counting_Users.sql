-- Counting Users
-- Exercise 1: 
-- We’ll be using the users table to answer the question 
-- “How many new users are added each day?“. 
-- Start by making sure you understand the columns in the table

-- SELECT *
-- FROM dsv1069.users;
-- created_at
-- deleted_at
-- email_address
-- first_name
-- id
-- last_name
-- merged_at
-- parent_user_id

-- understand what is going on with the merged at id
-- SELECT id,
--   parent_user_id,
--   merged_at
-- FROM dsv1069.users
-- ORDER BY parent_user_id ASC;

SELECT DATE(created_at) AS day,
  COUNT(*) AS users
FROM dsv1069.users
GROUP BY day
ORDER BY day ASC;

-- Exercise 2: 
-- WIthout worrying about deleted user or merged users, 
-- count the number of users added each day.

-- columns
-- created_at
-- deleted_at
-- email_address
-- first_name
-- id
-- last_name
-- merged_at
-- parent_user_id

-- SELECT COUNT(id) as num_users
-- FROM dsv1069.users;
-- returns 117,178 users

SELECT DATE(created_at) AS day,
  COUNT(id) as num_users
FROM dsv1069.users
GROUP BY day
ORDER BY day ASC;

-- Exercise 3: 
-- Consider the following query. Is this the right way to count 
-- merged or deleted users? 
-- If all of our users were deleted tomorrow what would the result look like?


-- columns
-- created_at
-- deleted_at
-- email_address
-- first_name
-- id
-- last_name
-- merged_at
-- parent_user_id

-- SELECT COUNT(id) as num_users
-- FROM dsv1069.users;
-- returns 117,178 users

-- SELECT DATE(created_at) AS date_created,
--   COUNT(id) as num_users
-- FROM dsv1069.users
-- GROUP BY date_created
-- ORDER BY date_created ASC;

SELECT DATE(created_at) AS day,
  COUNT(*) AS users
FROM dsv1069.users
WHERE deleted_at IS NULL
  AND (id <> parent_user_id OR parent_user_id IS NULL)
GROUP BY day;

-- Exercise 4: 
-- Count the number of users deleted each day. Then count the number of users
-- removed due to merging in a similar way.



-- columns
-- created_at
-- deleted_at
-- email_address
-- first_name
-- id
-- last_name
-- merged_at
-- parent_user_id

-- SELECT COUNT(id) as num_users
-- FROM dsv1069.users;
-- returns 117,178 users

-- SELECT DATE(created_at) AS date_created,
--   COUNT(id) as num_users
-- FROM dsv1069.users
-- GROUP BY date_created
-- ORDER BY date_created ASC;

-- SELECT COUNT(*) AS users
-- FROM dsv1069.users
-- WHERE deleted_at IS NOT NULL
-- returns 2,888 users

SELECT DATE(created_at) AS day,
  COUNT(*) AS users
FROM dsv1069.users
WHERE deleted_at IS NOT NULL
GROUP BY day;

-- Exercise 5: 
-- Use the pieces you’ve built as subtables and create a table that has a column for
-- the date, the number of users created, the number of users deleted and 
-- the number of users merged that day.

-- columns
-- created_at
-- deleted_at
-- email_address
-- first_name
-- id
-- last_name
-- merged_at
-- parent_user_id

SELECT new.day,
  new.new_added_users,
  COALESCE(deleted.deleted_users, 0) AS deleted_users,
  COALESCE(merged.merged_users, 0) AS merged_users,
  (new.new_added_users - COALESCE(deleted.deleted_users, 0) - COALESCE(merged.merged_users, 0)) 
    AS net_added_users
FROM (SELECT DATE(created_at) AS day,
    COUNT(*) AS new_added_users
  FROM dsv1069.users
  GROUP BY day) new
LEFT JOIN 
  (SELECT DATE(created_at) AS day,
    COUNT(*) AS deleted_users
  FROM dsv1069.users
  WHERE deleted_at IS NOT NULL
  GROUP BY day) deleted
  ON deleted.day = new.day
LEFT JOIN 
  (SELECT DATE(merged_at) AS day,
    COUNT(*) AS merged_users
  FROM dsv1069.users
  WHERE id <> parent_user_id
  AND parent_user_id IS NOT NULL
  GROUP BY day) merged
ON merged.day = new.day


















