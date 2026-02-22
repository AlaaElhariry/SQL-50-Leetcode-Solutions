/*1731. The Number of Employees Which Report to Each Employee */
SELECT 
    m.employee_id,
    m.name,
    COUNT(e.employee_id) AS reports_count,
    ROUND(AVG(CAST(e.age AS FLOAT)), 0) AS average_age
FROM Employees m
JOIN Employees e
    ON e.reports_to = m.employee_id
GROUP BY m.employee_id, m.name
ORDER BY m.employee_id;

/*1789. Primary Department for Each Employee */
WITH ranked AS (
    SELECT 
        employee_id,
        department_id,
        ROW_NUMBER() OVER (
            PARTITION BY employee_id 
            ORDER BY CASE WHEN primary_flag = 'Y' THEN 1 ELSE 2 END
        ) AS rn
    FROM Employee
)
SELECT employee_id, department_id
FROM ranked
WHERE rn = 1;

/*610. Triangle Judgement */
SELECT
    x,
    y,
    z,
    CASE 
        WHEN x + y > z AND x + z > y AND y + z > x THEN 'Yes'
        ELSE 'No'
    END AS triangle
FROM Triangle;

/*180. Consecutive Numbers */
SELECT DISTINCT num AS ConsecutiveNums
FROM (
    SELECT 
        num,
        LEAD(num, 1) OVER (ORDER BY id) AS next1,
        LEAD(num, 2) OVER (ORDER BY id) AS next2
    FROM Logs
) AS t
WHERE num = next1 AND num = next2;

/*1164. Product Price at a Given Date */
SELECT 
    p.product_id,
    COALESCE(
        (
            SELECT TOP 1 new_price
            FROM Products AS pr
            WHERE pr.product_id = p.product_id
              AND pr.change_date <= '2019-08-16'
            ORDER BY pr.change_date DESC
        ), 10
    ) AS price
FROM (SELECT DISTINCT product_id FROM Products) AS p;

/*1204. Last Person to Fit in the Bus */
WITH cte AS (
    SELECT
        person_name,
        SUM(weight) OVER (ORDER BY turn) AS running_weight
    FROM Queue
)
SELECT TOP 1 person_name
FROM cte
WHERE running_weight <= 1000
ORDER BY running_weight DESC;

/*1907. Count Salary Categories */
WITH categories AS (
    SELECT 'Low Salary' AS category
    UNION ALL
    SELECT 'Average Salary'
    UNION ALL
    SELECT 'High Salary'
),
counts AS (
    SELECT
        CASE
            WHEN income < 20000 THEN 'Low Salary'
            WHEN income BETWEEN 20000 AND 50000 THEN 'Average Salary'
            WHEN income > 50000 THEN 'High Salary'
        END AS category,
        COUNT(*) AS accounts_count
    FROM Accounts
    GROUP BY
        CASE
            WHEN income < 20000 THEN 'Low Salary'
            WHEN income BETWEEN 20000 AND 50000 THEN 'Average Salary'
            WHEN income > 50000 THEN 'High Salary'
        END
)
SELECT 
    c.category,
    COALESCE(cnt.accounts_count, 0) AS accounts_count
FROM categories c
LEFT JOIN counts cnt
    ON c.category = cnt.category;