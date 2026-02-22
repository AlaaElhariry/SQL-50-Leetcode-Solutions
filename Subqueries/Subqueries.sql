
/*1978. Employees Whose Manager Left the Company*/
SELECT employee_id
FROM Employees
WHERE salary < 30000
  AND manager_id NOT IN (SELECT employee_id FROM Employees)
ORDER BY employee_id;

/*626. Exchange Seats */
SELECT 
    CASE 
        WHEN id % 2 = 1 AND id + 1 <= (SELECT MAX(id) FROM Seat) THEN id + 1
        WHEN id % 2 = 0 THEN id - 1
        ELSE id
    END AS id,
    student
FROM Seat
ORDER BY id;

/*1341. Movie Rating */

SELECT name AS results
FROM (
    SELECT TOP 1 u.name
    FROM MovieRating mr
    JOIN Users u ON mr.user_id = u.user_id
    GROUP BY u.name
    ORDER BY COUNT(*) DESC, u.name ASC
) AS UserSubquery

UNION ALL

SELECT title AS results
FROM (
    SELECT TOP 1 m.title
    FROM MovieRating mr
    JOIN Movies m ON mr.movie_id = m.movie_id
    WHERE mr.created_at >= '2020-02-01' AND mr.created_at <= '2020-02-29'
    GROUP BY m.title
    ORDER BY AVG(CAST(rating AS FLOAT)) DESC, m.title ASC
) AS MovieSubquery;

/*1321. Restaurant Growth */
WITH DailyTotals AS (
    SELECT 
        visited_on, 
        SUM(amount) AS daily_amount
    FROM Customer
    GROUP BY visited_on
),
MovingStats AS (
    SELECT 
        visited_on,
        SUM(daily_amount) OVER (
            ORDER BY visited_on 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS amount,
        ROUND(AVG(CAST(daily_amount AS FLOAT)) OVER (
            ORDER BY visited_on 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ), 2) AS average_amount,
        ROW_NUMBER() OVER (ORDER BY visited_on) AS day_num
    FROM DailyTotals
)
SELECT 
    visited_on, 
    amount, 
    average_amount
FROM MovingStats
WHERE day_num >= 7
ORDER BY visited_on;

/*602. Friend Requests II: Who Has the Most Friends */
SELECT TOP 1 WITH TIES 
    id, 
    COUNT(*) AS num
FROM (
    SELECT requester_id AS id FROM RequestAccepted
    UNION ALL

    SELECT accepter_id AS id FROM RequestAccepted
) AS AllFriends
GROUP BY id
ORDER BY num DESC;

/*585. Investments in 2016 */
WITH PolicyStats AS (
    SELECT 
        tiv_2016,
        COUNT(*) OVER(PARTITION BY tiv_2015) AS count_tiv_2015,
        COUNT(*) OVER(PARTITION BY lat, lon) AS count_location
    FROM Insurance
)
SELECT 
    CAST(SUM(tiv_2016) AS DECIMAL(18, 2)) AS tiv_2016
FROM PolicyStats
WHERE count_tiv_2015 > 1 
  AND count_location = 1; 

/*185. Department Top Three Salaries */  
WITH SalaryRanking AS (
    SELECT 
        d.name AS Department,
        e.name AS Employee,
        e.salary AS Salary,

        DENSE_RANK() OVER (
            PARTITION BY e.departmentId 
            ORDER BY e.salary DESC
        ) AS rnk
    FROM Employee e
    JOIN Department d ON e.departmentId = d.id
)
SELECT 
    Department, 
    Employee, 
    Salary
FROM SalaryRanking
WHERE rnk <= 3;