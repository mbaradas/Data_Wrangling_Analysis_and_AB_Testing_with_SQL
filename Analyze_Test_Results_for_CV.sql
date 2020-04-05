-- Analyze Test Results for CV
-- Use the order_binary metric from the previous exercise
-- For the proportion metric order binary compute the following:
-- The count of users per treatment group for test_id = 7
-- The count of usrs with orders per treatment group

SELECT test_assignment,
       COUNT(user_id) AS users,
       SUM(order_binary) AS users_with_orders
FROM
  (SELECT assignments.user_id,
          assignments.test_id,
          assignments.test_assignment,
          MAX(CASE
                  WHEN orders.created_at > assignments.event_time THEN 1
                  ELSE 0
              END) AS order_binary
   FROM
     (SELECT event_id,
             event_time,
             user_id,
             MAX(CASE
                     WHEN parameter_name = 'test_id' THEN CAST(parameter_value AS INT)
                     ELSE NULL
                 END) AS test_id,
             MAX(CASE
                     WHEN parameter_name = 'test_assignment' THEN CAST(parameter_value AS INT)
                     ELSE NULL
                 END) AS test_assignment
      FROM dsv1069.events
      GROUP BY event_id,
               event_time,
               user_id
      ORDER BY event_id) assignments
   LEFT OUTER JOIN dsv1069.orders
     ON assignments.user_id = orders.user_id
   GROUP BY assignments.user_id,
            assignments.test_id,
            assignments.test_assignment) user_level
WHERE test_id = 7
GROUP BY test_assignment;
