/*1757. Recyclable and Low Fat Products*/
select product_id
from Products
where low_fats='y'and recyclable='y';

/*584. Find Customer Referee*/
SELECT name
from Customer
WHERE referee_id != 2 OR referee_id IS NULL;

/*595. Big Countries*/
SELECT name,population,area
From World
WHERE area >=3000000 OR population>=25000000;

/*1148. Article Views I*/
SELECT DISTINCT author_id AS id
FROM Views
WHERE author_id = viewer_id
ORDER BY id;

/*1683. Invalid Tweets*/
SELECT tweet_id
FROM Tweets
WHERE LEN(content) > 15;




