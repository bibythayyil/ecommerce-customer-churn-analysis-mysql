/************************************* 'E-Commerce Customer Churn Analysis' ***************************************/

USE ecomm;
SELECT * FROM customer_churn;

/***** Imputing mean and round off to nearest integer *****/

-- For WarehouseToHome column:
UPDATE customer_churn 
SET 
    WarehouseToHome = (SELECT 
            avg_val
        FROM
            (SELECT 
                ROUND(AVG(WarehouseToHome)) AS avg_val
            FROM
                customer_churn) AS t)
WHERE
    WarehouseToHome IS NULL;
    
-- For HourspendOnApp column:
UPDATE customer_churn 
SET 
    HourSpendOnApp = (SELECT 
            avg_val
        FROM
            (SELECT 
                ROUND(AVG(HourSpendOnApp)) AS avg_val
            FROM
                customer_churn) AS t)
WHERE
    HourSpendOnApp IS NULL;
    
-- For OrderAmountHikeFromlastYear column:
UPDATE customer_churn 
SET 
    OrderAmountHikeFromlastYear = (SELECT 
            avg_val
        FROM
            (SELECT 
                ROUND(AVG(OrderAmountHikeFromlastYear)) AS avg_val
            FROM
                customer_churn) AS t)
WHERE
    OrderAmountHikeFromlastYear IS NULL;
    
-- For DaySinceLastOrder column:
UPDATE customer_churn 
SET 
    DaySinceLastOrder = (SELECT 
            avg_val
        FROM
            (SELECT 
                ROUND(AVG(DaySinceLastOrder)) AS avg_val
            FROM
                customer_churn) AS t)
WHERE
    DaySinceLastOrder IS NULL;
    
/***** Imputing mode *****/

-- For Tenure column:
UPDATE customer_churn 
SET 
    Tenure = (SELECT 
            mode_val
        FROM
            (SELECT 
                Tenure AS mode_val
            FROM
                customer_churn
            GROUP BY Tenure
            ORDER BY COUNT(*) DESC
            LIMIT 1) AS t)
WHERE
    Tenure IS NULL;
    
-- For CouponUsed column:
UPDATE customer_churn 
SET 
    CouponUsed = (SELECT 
            mode_val
        FROM
            (SELECT 
                CouponUsed AS mode_val
            FROM
                customer_churn
            GROUP BY CouponUsed
            ORDER BY COUNT(*) DESC
            LIMIT 1) AS t)
WHERE
    CouponUsed IS NULL;
    
-- For OrderCount column:
UPDATE customer_churn 
SET 
    OrderCount = (SELECT 
            mode_val
        FROM
            (SELECT 
                OrderCount AS mode_val
            FROM
                customer_churn
            GROUP BY OrderCount
            ORDER BY COUNT(*) DESC
            LIMIT 1) AS t)
WHERE
    OrderCount IS NULL;
    
/***** Handling outliers by deleting > 100 values *****/

-- In WarehoustToHome column:
DELETE FROM customer_churn WHERE WarehouseToHome > 100;

/***** Replacing Phone & Mobile values to Mobile Phone *****/

-- Changing Phone to Mobile Phone in PreferredLoginDevice column:
UPDATE customer_churn 
SET 
    PreferredLoginDevice = 'Mobile Phone'
WHERE
    PreferredLoginDevice = 'Phone';
    
-- Changing Mobile to Mobile Phone in PreferedOrderCat column:
UPDATE customer_churn 
SET 
    PreferedOrderCat = 'Mobile Phone'
WHERE
    PreferedOrderCat = 'Mobile';
    
/***** Standardize payment mode values *****/

-- Replacing COD & CC in PreferredPaymentMode column:
UPDATE customer_churn 
SET 
    PreferredPaymentMode = CASE
        WHEN PreferredPaymentMode = 'COD' THEN 'Cash on Delivery'
        WHEN PreferredPaymentMode = 'CC' THEN 'Credit Card'
        ELSE PreferredPaymentMode
    END;
    
/***** Column renaming *****/

-- Renaming PreferedOrderCat column:
ALTER TABLE customer_churn CHANGE PreferedOrderCat PreferredOrderCat VARCHAR(20);

-- Renaming HourSpendOnApp column:
ALTER TABLE customer_churn CHANGE HourSpendOnApp HoursSpentOnApp INT;

/***** Creating new columns *****/

-- Creating ComplaintReceived & ChurnStatus Columns:
ALTER TABLE customer_churn 
ADD ComplaintReceived VARCHAR(3),
ADD ChurnStatus VARCHAR(7);

-- Populating values to ComplaintReceived column:
UPDATE customer_churn 
SET 
    ComplaintReceived = CASE
        WHEN Complain = 1 THEN 'Yes'
        ELSE 'No'
    END;
  
-- Populating values to ChurnStatus column:
UPDATE customer_churn 
SET 
    ChurnStatus = CASE
        WHEN Churn = 1 THEN 'Churned'
        ELSE 'Active'
    END;
    
/***** Column dropping *****/

-- Dropping Churn & Complain columns:
ALTER TABLE customer_churn
DROP COLUMN Complain,
DROP COLUMN Churn;

/***** Data exploration and analysis *****/

-- Count of churned and active customers:
SELECT 
    ChurnStatus, COUNT(*) AS CustomerCount
FROM
    customer_churn
GROUP BY ChurnStatus;

-- Average tenure & total cashback amount of churned customers:
SELECT 
    AVG(Tenure) AS AverageTenure,
    SUM(CashbackAmount) AS TotalCashback
FROM
    customer_churn
WHERE
    churnStatus = 'Churned';
    
-- Percentage of churned customers who complained:
SELECT 
    ROUND(100 * SUM(ComplaintReceived = 'Yes') / COUNT(*),
            2) AS ComplaintPercentage
FROM
    customer_churn
WHERE
    ChurnStatus = 'Churned';
    
-- City tier with highest number of churned customers ordered Laptop & Accessory:
SELECT 
    CityTier, COUNT(*) AS ChurnedCustomers
FROM
    customer_churn
WHERE
    ChurnStatus = 'Churned'
        AND PreferredOrderCat = 'Laptop & Accessory'
GROUP BY CityTier
ORDER BY ChurnedCustomers DESC
LIMIT 1;

-- Most preferred payment mode among active customers:
SELECT 
    PreferredPaymentMode, COUNT(*) AS ActiveCustomersCount
FROM
    customer_churn
WHERE
    ChurnStatus = 'Active'
GROUP BY PreferredPaymentMode
ORDER BY ActiveCustomersCount DESC
LIMIT 1;

-- Total order amount hike from last year for customers who are single and preferred ordering mobile phone:
SELECT 
    SUM(OrderAmountHikeFromlastYear) AS TotalAmount
FROM
    customer_churn
WHERE
    MaritalStatus = 'Single'
        AND PreferredOrderCat = 'Mobile Phone';
        
-- Average number of devices registered among customers who used UPI:
SELECT 
    AVG(NumberOfDeviceRegistered) AS AverageDevices
FROM
    customer_churn
WHERE
    PreferredPaymentMode = 'UPI';
    
-- City tier with highest number of customers:
SELECT 
    CityTier, COUNT(CityTier) AS CustomerCount
FROM
    customer_churn
GROUP BY CityTier
ORDER BY CustomerCount DESC
LIMIT 1;

-- Gender that utilized highest number of coupons:
SELECT 
    Gender, SUM(CouponUsed) AS TotalCoupons
FROM
    customer_churn
GROUP BY Gender
ORDER BY TotalCoupons DESC
LIMIT 1;

-- Number of customers and the maximum hours spent on the app in each preferred order category:
SELECT 
    PreferredOrderCat,
    COUNT(*) AS TotalCustomers,
    MAX(HoursSpentOnApp) AS MaximumHours
FROM
    customer_churn
GROUP BY PreferredOrderCat;

-- Total order count of customers who prefer using credit cards and having maximum satisfaction score:
SELECT 
    SUM(OrderCount) AS TotalCount
FROM
    customer_churn
WHERE
    PreferredPaymentMode = 'Credit Card'
        AND SatisfactionScore = (SELECT 
            MAX(SatisfactionScore)
        FROM
            customer_churn);

-- Average satisfaction score of customers who have complained:
SELECT 
    AVG(SatisfactionScore) AS AverageScore
FROM
    customer_churn
WHERE
    ComplaintReceived = 'Yes';
    
-- Preferred order category among customers who used more than 5 coupons:
SELECT DISTINCT
    PreferredOrderCat
FROM
    customer_churn
WHERE
    CouponUsed > 5;
    
-- Top 3 preferred order categories with the highest average cashback amount:
SELECT 
    PreferredOrderCat, AVG(CashbackAmount) AS AverageCashback
FROM
    customer_churn
GROUP BY PreferredOrderCat
ORDER BY AverageCashback DESC
LIMIT 3;

-- Preferred payment modes of customers whose average tenure is 10 months and have more than 500 orders:
SELECT 
    PreferredPaymentMode
FROM
    customer_churn
GROUP BY PreferredPaymentMode
HAVING ROUND(AVG(Tenure)) = 10
    AND SUM(OrderCount) > 500;
    
-- Categorizing customers based on their distance from warehouse to home and churn status breakdown:
SELECT 
    CASE
        WHEN WarehouseToHome <= 5 THEN 'Very Close Distance'
        WHEN WarehouseToHome <= 10 THEN 'Close Distance'
        WHEN WarehouseToHome <= 15 THEN 'Moderate Distance'
        ELSE 'Far Distance'
    END AS DistanceCategory,
    ChurnStatus,
    COUNT(*) AS CustomerCount
FROM
    customer_churn
GROUP BY DistanceCategory , ChurnStatus
ORDER BY DistanceCategory , ChurnStatus;

-- Order details of married, live in City Tier-1, and their order counts > average number of orders by all customers:
SELECT 
    *
FROM
    customer_churn
WHERE
    MaritalStatus = 'Married'
        AND CityTier = 1
        AND OrderCount > (SELECT 
            AVG(OrderCount)
        FROM
            customer_churn);
            
/***** Creating new table, inseting data and joining data *****/

-- Creating Customer_returns table:
CREATE TABLE customer_returns (
    ReturnID INT PRIMARY KEY,
    CustomerID INT,
    ReturnDate DATE,
    RefundAmount INT,
    FOREIGN KEY (CustomerID)
        REFERENCES customer_churn (CustomerID)
);

-- Inserting data:
INSERT INTO customer_returns (ReturnID, CustomerID, ReturnDate, RefundAmount) VALUES
(1001, 50022, '2023-01-01', 2130),
(1002, 50316, '2023-01-23', 2000),
(1003, 51099, '2023-02-14', 2290),
(1004, 52321, '2023-03-08', 2510),
(1005, 52928, '2023-03-20', 3000),
(1006, 53749, '2023-04-17', 1740),
(1007, 54206, '2023-04-21', 3250),
(1008, 54838, '2023-04-30', 1990);

-- Return details along with the customer details of those who have churned and have made complaints:
SELECT 
    a.*, b.*
FROM
    customer_returns a
        JOIN
    customer_churn b ON a.CustomerID = b.CustomerID
WHERE
    b.ChurnStatus = 'Churned'
        AND b.ComplaintReceived = 'Yes';

/********************************************************************************************************/
SELECT * FROM customer_churn;
SELECT * FROM customer_returns;