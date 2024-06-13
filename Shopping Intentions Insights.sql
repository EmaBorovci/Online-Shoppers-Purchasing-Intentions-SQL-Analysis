SELECT * FROM ShoppingIntentions..OnlineShoppersIntention;

--Counting the number of Total Visitors during the summer
SELECT Month, VisitorType, COUNT (*) AS TotalVisitors
FROM ShoppingIntentions..OnlineShoppersIntention
WHERE Month IN ('June', 'Jul', 'Aug')
GROUP BY Month, VisitorType;


--DIfference of PageValues from Returning and New Visitor to optimize the page by differentiating them
SELECT 'Returning_Visitor' AS VisitorType, AVG(PageValues) AS AvgPageValues
FROM ShoppingIntentions..OnlineShoppersIntention
WHERE VisitorType = 'Returning_Visitor'
UNION
SELECT 'New_Visitor' AS VisitorType, AVG(PageValues) AS AvgPageValues
FROM ShoppingIntentions..OnlineShoppersIntention
WHERE VisitorType = 'New_Visitor';


-- Calculating bounce rate and exit rate for each webpage
WITH BounceExitRates AS (
    SELECT Browser,
        AVG(CASE WHEN BounceRates = 0 THEN NULL ELSE BounceRates END) AS AvgBounceRate,
        AVG(CASE WHEN ExitRates = 0 THEN NULL ELSE ExitRates END) AS AvgExitRate
    FROM ShoppingIntentions..OnlineShoppersIntention
    GROUP BY Browser
)
SELECT * FROM BounceExitRates
ORDER BY Browser ASC;


--Showing the data of visitors that completed transactions 
SELECT VisitorType, ProductRelated_Duration, PageValues, Month, Revenue
FROM ShoppingIntentions..OnlineShoppersIntention
WHERE Revenue = 1;


--Counting the average of Product Related DUration and comparing it to before a completed transaction
SELECT AVG(ProductRelated_Duration) AS Avg_ProductRelated_Duration,
       AVG(PageValues) AS AvgPageValues,
       AVG(ProductRelated_Duration)/AVG(PageValues) AS DurationToPageValueRatio
FROM ShoppingIntentions..OnlineShoppersIntention
WHERE Revenue = 1;

-- Analyze monthly revenue trends and see what month has more revenue
SELECT MONTH, SUM(CAST(Revenue AS int)) AS TotalRevenue
FROM ShoppingIntentions..OnlineShoppersIntention
GROUP BY MONTH
ORDER BY TotalRevenue DESC;


-- Calculate the total duration spent on all types of pages
SELECT VisitorType, 
       SUM(Administrative_Duration) AS TotalAdministrative_Duration,
	   SUM(Informational_Duration) AS TotalInformational_Duration,
	   SUM(ProductRelated_Duration) AS ProductRelated_Duration,
       SUM(Administrative_Duration) + SUM(Informational_Duration) + SUM(ProductRelated_Duration) AS TotalDuration
FROM ShoppingIntentions..OnlineShoppersIntention
GROUP BY VisitorType;
