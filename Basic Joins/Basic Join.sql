/*1378. Replace Employee ID With The Unique Identifier*/

SELECT eu.unique_id, e.name
FROM Employees e
LEFT JOIN EmployeeUNI eu
    ON e.id = eu.id;

/*1068. Product Sales Analysis I*/
SELECT p.product_name, s.year, s.price
FROM Sales s
JOIN Product p
    ON s.product_id = p.product_id;

/*1581. Customer Who Visited but Did Not Make Any Transactions*/
SELECT v.customer_id,
       COUNT(*) AS count_no_trans
FROM Visits v
LEFT JOIN Transactions t
    ON v.visit_id = t.visit_id
WHERE t.transaction_id IS NULL
GROUP BY v.customer_id;

/*197. Rising Temperature*/
SELECT w1.id
FROM Weather w1
JOIN Weather w2
  ON w1.recordDate = DATEADD(DAY, 1, w2.recordDate)
WHERE w1.temperature > w2.temperature;

/*1661. Average Time of Process per Machine*/
SELECT 
    s.machine_id,
    ROUND(AVG(e.timestamp - s.timestamp), 3) AS processing_time
FROM Activity s
JOIN Activity e
  ON s.machine_id = e.machine_id
 AND s.process_id = e.process_id
WHERE s.activity_type = 'start' 
  AND e.activity_type = 'end'
GROUP BY s.machine_id;

/*577. Employee Bonus*/
SELECT e.name, b.bonus
FROM Employee e
LEFT JOIN Bonus b
  ON e.empId = b.empId
WHERE b.bonus < 1000 OR b.bonus IS NULL;

/*1280. Students and Examinations*/
SELECT 
    s.student_id,
    s.student_name,
    sub.subject_name,
    COUNT(e.subject_name) AS attended_exams
FROM Students s
CROSS JOIN Subjects sub
LEFT JOIN Examinations e
  ON s.student_id = e.student_id
 AND sub.subject_name = e.subject_name
GROUP BY s.student_id, s.student_name, sub.subject_name
ORDER BY s.student_id, sub.subject_name;

/*570. Managers with at Least 5 Direct Reports*/
SELECT e.name
FROM Employee e
JOIN Employee r
  ON e.id = r.managerId
GROUP BY e.id, e.name
HAVING COUNT(r.id) >= 5;

/*1934. Confirmation Rate*/
SELECT 
    s.user_id,
    ROUND(
        ISNULL(
            SUM(CASE WHEN c.action = 'confirmed' THEN 1 ELSE 0 END) * 1.0 
            / NULLIF(COUNT(c.user_id), 0)
        , 0)
    , 2) AS confirmation_rate
FROM Signups s
LEFT JOIN Confirmations c
    ON s.user_id = c.user_id
GROUP BY s.user_id;

