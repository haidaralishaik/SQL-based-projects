SELECT COUNT(HouseholdId) FROM Customers
--1) The total number of houseold IDs are 189559

SELECT COUNT(OrderId) FROM Orders WHERE State = 'FL' AND  YEAR(OrderDate) = 2015
--2) The total number of orders in florida in the year 2015 are 1700

--3:
SELECT SUM(NumUnits),Channel
FROM Orders
INNER JOIN Campaigns
ON Orders.CampaignId = Campaigns.CampaignId GROUP BY Channel;

SELECT COUNT(PaymentType),Gender
FROM Customers
INNER JOIN Orders
ON Customers.CustomerId = Orders.CustomerId WHERE PaymentType = 'VI' GROUP BY Gender;
--4: Men use visa card the most to place order with a count as 37325.

SELECT SUM(TotPop) FROM ZipCensus WHERE ZIPName = 'Detroit MI' 

--5 The total population of Detroit MI is 708594

--6
SELECT Top(5) SUM(NumUnits) as NumUnits,SUM(TotalPrice) as TotalPrice,City FROM Orders GROUP BY City ORDER BY NumUnits DESC

--7
SELECT 
 SUM(CASE WHEN MONTH(OrderDate) in (1,2,3,4,5,6,7,8,9,10,11,12) THEN 1 ELSE 0 END) as Orders,
       SUM(CASE WHEN MONTH(OrderDate) in (12,1,2)  THEN 1 ELSE 0 END) as Winter,
       SUM(CASE WHEN MONTH(OrderDate) in (3,4,5)  THEN 1 ELSE 0 END) as Spring,
       SUM(CASE WHEN MONTH(OrderDate) in (6,7,8)  THEN 1 ELSE 0 END) as Summer,
       SUM(CASE WHEN MONTH(OrderDate) in (9,10,11)  THEN 1 ELSE 0 END) as Autumn FROM Orders





