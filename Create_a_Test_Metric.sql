-- Create a Test Metric
-- Exercise 1:
-- Using the table from Exercise 4.3 and compute a metric that measures
-- whether a user created an order after their test assignment
 -- Requirements: Even if a user had zero orders, we should have a row
-- that counts their number of orders as zero
-- If the user is not in the experiment they should not be included

SELECT test_events.test_id,
       test_events.test_assignment,
       test_events.user_id,
       MAX(CASE
               WHEN orders.created_at > test_events.event_time THEN 1
               ELSE 0
           END) AS orders_after_assignment_binary
FROM
  ( SELECT event_id,
           event_time,
           user_id, -- platform,
 MAX(CASE
         WHEN parameter_name = 'test_id' THEN CAST(parameter_value AS INT)
         ELSE NULL
     END) AS test_id,
 MAX(CASE
         WHEN parameter_name = 'test_assignment' THEN CAST(parameter_value AS INT)
         ELSE NULL
     END) AS test_assignment
   FROM dsv1069.events
   WHERE event_name = 'test_assignment'
   GROUP BY event_id,
            event_time,
            user_id ) test_events
LEFT JOIN dsv1069.orders
  ON orders.user_id = test_events.user_id
GROUP BY test_events.test_id,
         test_events.test_assignment,
         test_events.user_id;
		 
-- Exercise 2:
-- Using the table from the previous exercise, add the following metrics
-- 1) the number of orders/invoices
-- 2) the number of items/line-items ordered
-- 3) the total revenue from the order after treatment

SELECT test_events.test_id,
       test_events.test_assignment,
       test_events.user_id,
       COUNT(DISTINCT (CASE
                           WHEN orders.created_at > test_events.event_time THEN invoice_id
                           ELSE NULL
                       END)) AS orders_after_assignment,
       COUNT(DISTINCT (CASE
                           WHEN orders.created_at > test_events.event_time THEN line_item_id
                           ELSE NULL
                       END)) AS items_after_assignment,
       SUM((CASE
                WHEN orders.created_at > test_events.event_time THEN price
                ELSE 0
            END)) AS total_revenue
FROM
  (SELECT event_id,
          event_time,
          user_id, -- platform,
 MAX(CASE
         WHEN parameter_name = 'test_id' THEN CAST(parameter_value AS INT)
         ELSE NULL
     END) AS test_id,
 MAX(CASE
         WHEN parameter_name = 'test_assignment' THEN CAST(parameter_value AS INT)
         ELSE NULL
     END) AS test_assignment
   FROM dsv1069.events
   WHERE event_name = 'test_assignment'
   GROUP BY event_id,
            event_time,
            user_id ) test_events
LEFT JOIN dsv1069.orders
  ON orders.user_id = test_events.user_id
GROUP BY test_events.test_id,
         test_events.test_assignment,
         test_events.user_id;

