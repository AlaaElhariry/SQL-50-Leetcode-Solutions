/*2356. Number of Unique Subjects Taught by Each Teacher */
SELECT 
    teacher_id,
    COUNT(DISTINCT subject_id) AS cnt
FROM Teacher
GROUP BY teacher_id;
/*1141. User Activity for the Past 30 Days I */
SELECT
    activity_date AS day,
    COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date BETWEEN DATEADD(DAY, -29, '2019-07-27') AND '2019-07-27'
GROUP BY activity_date
ORDER BY activity_date;
/*1070. Product Sales Analysis III*/
SELECT
    s.product_id,
    s.year AS first_year,
    s.quantity,
    s.price
FROM Sales s
JOIN (
    SELECT product_id, MIN(year) AS first_year
    FROM Sales
    GROUP BY product_id
) AS first_sales
ON s.product_id = first_sales.product_id
   AND s.year = first_sales.first_year;

/*596. Classes With at Least 5 Students */ 
SELECT 
    class
FROM Courses
GROUP BY class
HAVING COUNT(student) >= 5;

/*1729. Find Followers Count */
SELECT
    user_id,
    COUNT(follower_id) AS followers_count
FROM Followers
GROUP BY user_id
ORDER BY user_id ASC;

/*619. Biggest Single Number */
SELECT MAX(num) AS num
FROM (
    SELECT num
    FROM MyNumbers
    GROUP BY num
    HAVING COUNT(*) = 1
) AS single_numbers;

/*1045. Customers Who Bought All Products*/
SELECT customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(*) FROM Product);