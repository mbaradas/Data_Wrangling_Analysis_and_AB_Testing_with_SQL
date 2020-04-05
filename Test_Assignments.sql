-- Test Assignments
-- Exercise 1:
-- Figure out how many tests we have running right now

SELECT DISTINCT parameter_value AS test_id
FROM dsv1069.events
WHERE event_name = 'test_assignment'
  AND parameter_name = 'test_id';
  
-- Exercise 2:
-- Check for potential problems with test assignments.
-- For example Make sure there is no data obviously missing
-- (This is an open ended question)

SELECT parameter_value AS test_id,
       DATE(event_time) AS day,
       COUNT(*) AS event_rows
FROM dsv1069.events
WHERE event_name = 'test_assignment'
  AND parameter_name = 'test_id'
GROUP BY parameter_value,
         DATE(event_time);
		 
-- Exercise 3:
-- Write a query that returns a table of assignment events.
-- Please include all of the relevant parameters as columns
-- (Hint: A previous exercise as a template)

SELECT event_id,
       event_time,
       user_id,
       platform,
       MAX(CASE
               WHEN parameter_name = 'test_id' THEN CAST(parameter_value AS INT)
               ELSE NULL
           END) AS test_id,
       MAX(CASE
               WHEN parameter_name = 'test_assignment' THEN parameter_value
               ELSE NULL
           END) AS test_assignment
FROM dsv1069.events
WHERE event_name = 'test_assignment'
GROUP BY event_id,
         event_time,
         user_id,
         platform
ORDER BY event_id

-- Exercise 4:
-- Check for potential assignment problems with test_id 5.
-- Specifically, make sure users are assigned only one treatment group.

SELECT test_id,
       user_id,
       COUNT(DISTINCT test_assignment) AS assignments
FROM
  (SELECT event_id,
          event_time,
          user_id,
          platform,
          MAX(CASE
                  WHEN parameter_name = 'test_id' THEN CAST(parameter_value AS INT)
                  ELSE NULL
              END) AS test_id,
          MAX(CASE
                  WHEN parameter_name = 'test_assignment' THEN parameter_value
                  ELSE NULL
              END) AS test_assignment
   FROM dsv1069.events
   WHERE event_name = 'test_assignment'
   GROUP BY event_id,
            event_time,
            user_id,
            platform
   ORDER BY event_id) test_events
GROUP BY test_id,
         user_id
ORDER BY assignments DESC;

