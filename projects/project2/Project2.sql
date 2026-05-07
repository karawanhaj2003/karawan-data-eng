-- Targil 1

With YearlyProfits as (
	select year(si.InvoiceDate) as tax_year, COUNT(DISTINCT MONTH(si.InvoiceDate)) as months, Sum(so.UnitPrice * so.Quantity) as profit
	from sales.Invoices si
	join sales.OrderLines so on si.OrderID = so.OrderID
	where si.IsCreditNote = 0
	group by year(si.InvoiceDate)
)

select *, LAG(profit) OVER (ORDER BY tax_year) AS PreviousYearSales,
    ((profit - LAG(profit) OVER (ORDER BY tax_year)) * 100.0
        / LAG(profit) OVER (ORDER BY tax_year)) AS GrowthPercent from YearlyProfits yp
order by yp.tax_year


-- Targil 2


WITH RankedSales AS (
    SELECT
        YEAR(si.InvoiceDate) AS 'Year',
        DATEPART(QUARTER, si.InvoiceDate) AS 'Quarter',
        c.CustomerName,
        SUM(so.UnitPrice * so.Quantity) AS TotalSales,
        ROW_NUMBER() OVER (
            PARTITION BY YEAR(si.InvoiceDate), DATEPART(QUARTER, si.InvoiceDate)
            ORDER BY SUM(so.UnitPrice * so.Quantity) DESC
        ) AS rn
    FROM sales.Invoices si
    JOIN sales.OrderLines so
        ON si.OrderID = so.OrderID
    JOIN sales.Customers c
        ON si.CustomerID = c.CustomerID
    WHERE si.IsCreditNote = 0
    GROUP BY
        YEAR(si.InvoiceDate),
        DATEPART(QUARTER, si.InvoiceDate),
        c.CustomerName
)
SELECT *
FROM RankedSales
WHERE rn <= 5
ORDER BY Year, Quarter, TotalSales DESC;

-- Targil 3

SELECT TOP 10
    so.StockItemID,
    so.Description,
    SUM(so.UnitPrice - so.TaxRate) AS TotalProfit
FROM sales.OrderLines so
GROUP BY
    so.StockItemID,
    so.Description
ORDER BY
    TotalProfit DESC;

-- Targil 4

SELECT
    ROW_NUMBER() OVER (ORDER BY (RecommendedRetailPrice - UnitPrice) DESC) AS SerialNumber,
    StockItemID,
    StockItemName,
    (RecommendedRetailPrice - UnitPrice) AS NominalProfit
FROM Warehouse.StockItems
WHERE ValidTo >= GETDATE()
 AND RecommendedRetailPrice IS NOT NULL
ORDER BY NominalProfit DESC;

-- Targil 5


SELECT
    s.SupplierName,
    STRING_AGG(
        CONCAT(si.StockItemID, ' ', si.StockItemName),
        ' /, ' 
    ) AS StockItems
FROM Purchasing.Suppliers AS s
JOIN Warehouse.StockItems AS si
    ON s.SupplierID = si.SupplierID
GROUP BY s.SupplierName;

-- Targil 6 

SELECT top 5  c.CustomerName, ci.CityName, co.CountryName, co.Continent, co.Region , SUM(il.ExtendedPrice) as totalextededprice  
FROM Sales.Customers c
Join [Application].[Cities] as ci on c.PostalCityID = ci.CityID
Join [Application].[StateProvinces] as sp on ci.StateProvinceID = sp.StateProvinceID
Join [Application].[Countries] as co on sp.CountryID = co.CountryID
JOIN Sales.Invoices i ON c.CustomerID = i.CustomerID
JOIN Sales.Invoicelines il ON i.InvoiceID = il.invoiceid
GROUP BY c.CustomerName, ci.CityName, co.CountryName , co.Continent, co.Region
ORDER BY SUM(il.ExtendedPrice) DESC;
 
-- Targil 7

WITH MonthlyTotals AS
(
    SELECT
        YEAR(i.InvoiceDate) AS Year,
        MONTH(i.InvoiceDate) AS Month,
        SUM(il.Quantity) AS MonthlyTotal
    FROM Sales.Invoices i
    JOIN Sales.InvoiceLines il
        ON i.InvoiceID = il.InvoiceID
    GROUP BY 
        YEAR(i.InvoiceDate),
        MONTH(i.InvoiceDate)
),

RunningTotal AS
(
    SELECT
        Year,
        Month,
        MonthlyTotal,
        SUM(MonthlyTotal) OVER (
            PARTITION BY Year
            ORDER BY Month
        ) AS CumulativeTotal
    FROM MonthlyTotals
)

SELECT
    Year,
    CASE 
        WHEN Month IS NULL THEN 'Total'
        ELSE CAST(Month AS VARCHAR)
    END AS Month,
    MonthlyTotal,
    CumulativeTotal
FROM
(
    SELECT * FROM RunningTotal

    UNION ALL

    SELECT
        Year,
        NULL,
        SUM(MonthlyTotal),
        SUM(MonthlyTotal)
    FROM MonthlyTotals
    GROUP BY Year
) FinalResult

ORDER BY
    Year,
    CASE 
        WHEN Month IS NULL THEN 13
        ELSE Month
    END;

-- Targil 8

SELECT *
FROM
(
    SELECT 
        MONTH(InvoiceDate) AS OrderMonth,
        YEAR(InvoiceDate) AS OrderYear,
        COUNT(*) AS NumberOfOrders
    FROM sales.Invoices
    GROUP BY 
        MONTH(InvoiceDate),
        YEAR(InvoiceDate)
) SourceTable
PIVOT
(
    SUM(NumberOfOrders)
    FOR OrderYear IN ([2013],[2014],[2015],[2016])
) PivotTable
ORDER BY OrderMonth;


-- Targil 9 - ������ ����������� ������

WITH OrderLag AS
(
    SELECT
        c.CustomerID,
        c.CustomerName,
        i.InvoiceDate AS OrderDate,

        LAG(i.InvoiceDate) OVER (
            PARTITION BY c.CustomerID
            ORDER BY i.InvoiceDate
        ) AS PreviousOrderDate

    FROM sales.Invoices i
    JOIN sales.Customers c
        ON i.CustomerID = c.CustomerID
    WHERE i.IsCreditNote = 0
),

CustomerAvg AS
(
    SELECT
        *,
        AVG(DATEDIFF(day, PreviousOrderDate, OrderDate))
            OVER (PARTITION BY CustomerID) AS AvgDaysBetweenOrders

    FROM OrderLag
)

SELECT
    CustomerID,
    CustomerName,
    OrderDate,
    PreviousOrderDate,

    DATEDIFF(day, OrderDate, GETDATE()) AS DaysSinceLastOrder,

    AvgDaysBetweenOrders,

    CASE
        WHEN DATEDIFF(day, OrderDate, GETDATE()) >
             2 * AvgDaysBetweenOrders
        THEN 'Potential'
        ELSE 'Active'
    END AS CustomerStatus

FROM CustomerAvg
ORDER BY CustomerID, OrderDate;

-- Targil 10

WITH CategoryCounts AS
(
    SELECT
        CASE
            WHEN CustomerName LIKE 'Wingtip%' THEN 'Wingtip'
            WHEN CustomerName LIKE 'Tailspin%' THEN 'Tailspin'
            ELSE 'Other'
        END AS CustomerCategoryName,

        COUNT(DISTINCT CustomerID) AS CustomerCount

    FROM Sales.Customers
    GROUP BY
        CASE
            WHEN CustomerName LIKE 'Wingtip%' THEN 'Wingtip'
            WHEN CustomerName LIKE 'Tailspin%' THEN 'Tailspin'
            ELSE 'Other'
        END
),

TotalCustomers AS
(
    SELECT SUM(CustomerCount) AS TotalCustCount
    FROM CategoryCounts
)

SELECT
    cc.CustomerCategoryName,
    cc.CustomerCount,
    tc.TotalCustCount,

    FORMAT(cc.CustomerCount * 1.0 / tc.TotalCustCount, 'P0') 
    AS DistibutionFactor

FROM CategoryCounts cc
CROSS JOIN TotalCustomers tc
ORDER BY CustomerCount DESC;
