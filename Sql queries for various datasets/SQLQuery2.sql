

Question 1
-- COUNT(*) returns the number of rows in an entity. An example of using



SELECT COUNT(*) as numzip
FROM ZipCensus

--Now we add the 'stab' column and GROUP BY stab to create a table of ZipCodes by State
SELECT stab, COUNT(*) as numzip
FROM ZipCensus
GROUP BY stab


--We want to know how many ZipCodes are in the State of California (CA)


select stab, count(*) as numzip
from ZipCensus
where stab='CA'
group by stab




 How many Zipcodes are in California?
--1763
----------------------------------------------------------------------------

Question 2: Write a query to show which OrderID has the highest TotalPrice paid for CampaignId 2178?

with order_campaign_CTE
as(
select distinct(OrderId), sum(TotalPrice) as total from orders o
where o.CampaignId=2178
group by OrderId)
select * from order_campaign_CTE
having total=max(total)






----------------------------------------------------------------------------

--we can add up total columns, get the average, the max value or min value with:
--SUM, AVG, MAX, or MIN
--EXAMPLE:
--SELECT SUM(column1) (for my reference)
--FROM TABLE1


Question 3: Write a query to show the total number of units sold in the OrderLines Table?
select sum(NumUnits)as numsold from orderlines


--435384


----------------------------------------------------------------------------

Question 4: Write a query to determine how much total revenue (money) was earned for selling Product ID 11053?
You will need a GROUP BY statement in this query.

select ProductId, sum(NumUnits*TotalPrice) as totalMoney from orderlines
where ProductId=11053
group by ProductId


--28843.04




----------------------------------------------------------------------------

Question 5: The average TotalPrice of each order was just less than $48. You can see that result by executing the query below:

SELECT AVG(TotalPrice)
FROM OrderLines

-- write a query to Append a new column called OrderSize that creates an indicator variable of 'Low' for products below $48, and 'High' for all other products 
-- for each row in the OrderLineId table.
-- Hint, use a CASE statement

Select *, (case when totalPrice <48 then 'Low' else 'High' end) as OrderSize
from OrderLines




----------------------------------------------------------------------------

Question 6 Execute this CROSS JOIN Query:

SELECT c.Channel, p.IsInStock
FROM Campaigns AS c
CROSS JOIN Products AS p

--How many rows are returned?
965560

--Look at the Campaigns and Products tables. Explain the math and why the number of rows were returned in the CROSS JOIN

select * from Campaigns
select * from products
--the row multiplied(239*4040=965560)
--what happened?
SELECT *
FROM Campaigns AS c
CROSS JOIN Products AS p

-- each row of the campaigns table is joined to each row of the proucts table
----------------------------------------------------------------------------

--JOINS 

Question 7 - Inner Joins


SELECT *
FROM Customers AS l
INNER JOIN Orders AS r
on l.CustomerId=r.CustomerId;

-- We lost some rows from Orders table. 
-- This is the trouble with Inner Joins.

SELECT CustomerId, COUNT(CustomerId) as NumCustomers
FROM orders
GROUP BY CustomerId
ORDER BY NumCustomers DESC;

-- Look at the first line in your results. Explain what could be the problem with the data:

-- empty cells are taken as 0, which means there are 3424 missing cells in the CustomerId column



----------------------------------------------------------------------------

Question 8: Write a query to LEFT JOIN the Customers Table to the Orders Table and display all columns
--select * from Customers
--select * from Orders

select * from Customers c
left join
Orders o
on c.CustomerId=o.CustomerId




----------------------------------------------------------------------------

Question 9: Write a query to RIGHT JOIN Orderlines to Products Table

--select * from OrderLines
--select * from Products

select * from OrderLines ol
right join
Products p
on ol.ProductId=p.ProductId



----------------------------------------------------------------------------


Question 10: Write a query for Full Outer Join Orders table to ZipCensus Table. Your result should only include the following columns:
zcta5, ZipCode, OrderId, and OrderDate.
Note: ZipCode is called zcta5 in the ZipCensus table.

--select * from ZipCensus


select zcta5, ZipCode, OrderId, OrderDate from Orders o
full outer join
zipcensus z
on o.ZipCode=z.zcta5



Scroll through the results. Are there any Nulls? Explain in one to two sentences why there would be nulls.





Question 11: How do the number of purchases vary by month for different payment types in the Year 2015?

SELECT PaymentType,
       SUM(CASE WHEN MONTH(OrderDate) = 1 THEN 1 ELSE 0 END) as Jan,
       SUM(CASE WHEN MONTH(OrderDate) = 2 THEN 1 ELSE 0 END) as Feb,
       SUM(CASE WHEN MONTH(OrderDate) = 3 THEN 1 ELSE 0 END) as Mar,
       SUM(CASE WHEN MONTH(OrderDate) = 4 THEN 1 ELSE 0 END) as Apr,
       SUM(CASE WHEN MONTH(OrderDate) = 5 THEN 1 ELSE 0 END) as May,
       SUM(CASE WHEN MONTH(OrderDate) = 6 THEN 1 ELSE 0 END) as Jun,
       SUM(CASE WHEN MONTH(OrderDate) = 7 THEN 1 ELSE 0 END) as Jul,
       SUM(CASE WHEN MONTH(OrderDate) = 8 THEN 1 ELSE 0 END) as Aug,
       SUM(CASE WHEN MONTH(OrderDate) = 9 THEN 1 ELSE 0 END) as Sep,
       SUM(CASE WHEN MONTH(OrderDate) = 10 THEN 1 ELSE 0 END) as Oct,
       SUM(CASE WHEN MONTH(OrderDate) = 11 THEN 1 ELSE 0 END) as Nov,
       SUM(CASE WHEN MONTH(OrderDate) = 12 THEN 1 ELSE 0 END) as Dec
FROM  Orders o
WHERE YEAR(OrderDate) = 2015
GROUP BY PaymentType
ORDER BY PaymentType

what does ?? indicate
select paymentType from Orders
where PaymentType not in ('VI', 'MC','OC','DB','AE')
--gives ?? in paymentType (used instead of leaving an empty cell empty)
