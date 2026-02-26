/*1667. Fix Names in a Table*/
SELECT
    user_id,
    UPPER(SUBSTRING(name, 1, 1)) + LOWER(SUBSTRING(name, 2, LEN(name) - 1)) AS name
FROM Users
ORDER BY user_id;
-------------------------------------------------------------------------------------------
/*1527. Patients With a Condition*/
SELECT patient_id, patient_name, conditions
FROM Patients
WHERE 
      conditions LIKE 'DIAB1%'         
   OR conditions LIKE '% DIAB1%'   
--------------------------------------------------------------------------------------------
/*196. Delete Duplicate Emails*/
WITH CTE AS (
    SELECT 
        id,
        email,
        ROW_NUMBER() OVER (PARTITION BY email ORDER BY id) AS rn
    FROM Person
)
DELETE FROM CTE
WHERE rn > 1;
--------------------------------------------------------------------------------------------
/*176. Second Highest Salary*/
SELECT
    sell_date,
    COUNT(*) AS num_sold,
    STRING_AGG(product, ',') WITHIN GROUP (ORDER BY product) AS products
FROM (
    SELECT DISTINCT sell_date, product
    FROM Activities
) AS t
GROUP BY sell_date
ORDER BY sell_date;
--------------------------------------------------------------------------------------------
/*1327. List the Products Ordered in a Period*/
SELECT 
    p.product_name,
    SUM(o.unit) AS unit
FROM Orders o
JOIN Products p
    ON o.product_id = p.product_id
WHERE o.order_date >= '2020-02-01' 
  AND o.order_date < '2020-03-01'
GROUP BY p.product_name
HAVING SUM(o.unit) >= 100;
--------------------------------------------------------------------------------------------
/*1517. Find Users With Valid E-Mails*/
SELECT user_id, name, mail
FROM Users
WHERE mail LIKE '[A-Za-z]%@leetcode.com'
  AND mail NOT LIKE '%[^A-Za-z0-9_.-]%@leetcode.com'
  AND mail COLLATE Latin1_General_BIN LIKE '%@leetcode.com';