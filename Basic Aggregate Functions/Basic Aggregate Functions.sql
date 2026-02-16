/*620. Not Boring Movies*/
SELECT *
FROM Cinema
WHERE id % 2 = 1
  AND description <> 'boring'
ORDER BY rating DESC;

/*1251. Average Selling Price*/
SELECT 
    p.product_id,
    ISNULL(
        ROUND(
            SUM(u.units * p.price) * 1.0 / NULLIF(SUM(u.units), 0), 
            2
        ), 
        0
    ) AS average_price
FROM Prices p
LEFT JOIN UnitsSold u
    ON p.product_id = u.product_id
    AND u.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY p.product_id;

/*1075. Project Employees I*/
SELECT 
    p.project_id,
    ROUND(AVG(CAST(e.experience_years AS decimal(10,2))), 2) AS average_years
FROM Project p
JOIN Employee e
    ON p.employee_id = e.employee_id
GROUP BY p.project_id;

/*1633. Percentage of Users Attended a Contest*/
WITH TotalUsers AS (
    SELECT COUNT(*) AS total_users
    FROM Users
)
SELECT 
    r.contest_id,
    ROUND(100.0 * COUNT(DISTINCT r.user_id) / t.total_users, 2) AS percentage
FROM Register r
CROSS JOIN TotalUsers t
GROUP BY r.contest_id, t.total_users
ORDER BY percentage DESC, contest_id ASC;

/*1211. Queries Quality and Percentage*/
SELECT
    query_name,
    ROUND(AVG(CAST(rating AS FLOAT) / position), 2) AS quality,
    ROUND(100.0 * SUM(CASE WHEN rating < 3 THEN 1 ELSE 0 END) / COUNT(*), 2) AS poor_query_percentage
FROM Queries
GROUP BY query_name;

/*1193. Monthly Transactions I*/
SELECT
    FORMAT(trans_date, 'yyyy-MM') AS month,
    country,
    COUNT(*) AS trans_count,
    SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY
    FORMAT(trans_date, 'yyyy-MM'),
    country
ORDER BY
    month, country;

/*1174. Immediate Food Delivery II*/
WITH FirstOrders AS (
    SELECT
        customer_id,
        customer_pref_delivery_date,
        order_date,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date ASC) AS rn
    FROM Delivery
)
SELECT 
    ROUND(
        100.0 * SUM(CASE WHEN customer_pref_delivery_date = order_date THEN 1 ELSE 0 END) 
        / COUNT(*), 
        2
    ) AS immediate_percentage
FROM FirstOrders
WHERE rn = 1;

/*550. Game Play Analysis IV*/

SELECT 
    ROUND(
        CAST(SUM(CASE WHEN a_next.player_id IS NOT NULL THEN 1 ELSE 0 END) AS DECIMAL(5,2)) 
        / COUNT(*), 2
    ) AS fraction
FROM (
    SELECT player_id, MIN(event_date) AS first_date
    FROM Activity
    GROUP BY player_id
) AS first_login
LEFT JOIN Activity AS a_next
    ON first_login.player_id = a_next.player_id
    AND a_next.event_date = DATEADD(DAY, 1, first_login.first_date);