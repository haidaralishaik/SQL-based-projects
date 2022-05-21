-- parking maintanance


-- Question 1: How many rows of data are in the table?


SELECT *
FROM parks;


SELECT COUNT(*) as TotalRows
FROM parks;
--answer 59
-- Question 2: Which Ward had the most number of requests?
-- Here we will make a new temporary column call TotalCalls that COUNT all the rows per ward
-- I am using 'as TotalRequests' to name the new column

SELECT ward, COUNT(*) as TotalRequests
FROM parks
GROUP BY ward
ORDER BY TotalRequests DESC;
--answer: ward 3 with 12 rquests



-- Question 3: How many requests were for Snow Removal?

SELECT SubType, COUNT(*) as SnowRequests
FROM parks
WHERE SubType = 'Snow Removal'
GROUP BY SubType;

--answer: 27 requests for snow removal
-- Question 4: How many total requests were received for service on the street called 'SEMINOLE' ?

select Street, count(*) as TotalRequests
from parks
where Street = 'SEMINOLE'
group by Street;

--answer:2 requests
