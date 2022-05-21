--some examples of subqueries and join

SELECT zc.*
FROM ZipCensus zc
WHERE zc.stab IN (SELECT stab
                  FROM ZipCensus
                  GROUP BY stab
                  HAVING COUNT(*) < 100
                 )








SELECT o.zipcode, count(*) as NumOrders
FROM Orders o
WHERE ZipCode NOT IN (SELECT zcta5 FROM ZipCensus zc)
GROUP BY o.ZipCode



SELECT zc1.stab, zc1.zcta5,
	SUM(CASE WHEN zc1.totpop < zc2.totpop THEN 1
	ELSE 0 END) as numzip
FROM ZipCensus zc1 
JOIN
 ZipCensus zc2
 ON zc1.stab = zc2.stab
GROUP BY zc1.zcta5, zc1.stab



