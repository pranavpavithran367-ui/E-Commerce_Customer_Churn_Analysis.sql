USE ecomm;
SELECT *
FROM customer_churn
LIMIT 10;
SELECT
COUNT(*) AS Total_Rows,
SUM(Tenure IS NULL) AS Missing_Tenure,
SUM(PreferredLoginDevice IS NULL) AS Missing_Login_Device,
SUM(HourSpendOnApp IS NULL) AS Missing_App_Hours,
SUM(MaritalStatus IS NULL) AS Missing_Marital_Status
FROM customer_churn;
SELECT Tenure, COUNT(*) AS Frequency
FROM customer_churn
WHERE Tenure IS NOT NULL
GROUP BY Tenure
ORDER BY Frequency DESC
LIMIT 1;
UPDATE customer_churn
SET Tenure = 1
WHERE CustomerID IN 
(SELECT CustomerID
FROM (SELECT CustomerID
FROM customer_churn
WHERE Tenure IS NULL) AS missing_customers);
SELECT ROUND(AVG(HourSpendOnApp)) AS Average_App_Hours
FROM customer_churn
WHERE HourSpendOnApp IS NOT NULL;
UPDATE customer_churn
SET HourSpendOnApp = 3
WHERE CustomerID IN 
(SELECT CustomerID
FROM (SELECT CustomerID
FROM customer_churn
WHERE HourSpendOnApp IS NULL)
 AS missing_hours);
SELECT
SUM(Tenure IS NULL) AS Missing_Tenure,
SUM(HourSpendOnApp IS NULL) AS Missing_App_Hours
FROM customer_churn;
SELECT ROUND(AVG(WarehouseToHome)) AS Average_WarehouseToHome
FROM customer_churn
WHERE WarehouseToHome IS NOT NULL;
UPDATE customer_churn
SET WarehouseToHome = 16
WHERE CustomerID IN 
(SELECT CustomerID
FROM (SELECT CustomerID
FROM customer_churn
WHERE WarehouseToHome IS NULL)
 AS missing_distance);
SELECT COUNT(*) AS Rows_Above_100
FROM customer_churn
WHERE WarehouseToHome > 100;
DELETE FROM customer_churn
WHERE CustomerID IN (
SELECT CustomerID
FROM (SELECT CustomerID
FROM customer_churn
WHERE WarehouseToHome > 100) 
AS outlier_customers);
SELECT ROUND(AVG(OrderAmountHikeFromlastYear))
AS Average_Order_Amount_Hike
FROM customer_churn
WHERE OrderAmountHikeFromlastYear IS NOT NULL;
UPDATE customer_churn
SET OrderAmountHikeFromlastYear = 16
WHERE CustomerID IN 
(SELECT CustomerID
FROM (SELECT CustomerID
FROM customer_churn
WHERE OrderAmountHikeFromlastYear IS NULL) 
AS missing_hikes);
SELECT ROUND(AVG(DaySinceLastOrder))
AS Average_Days_Since_Last_Order
FROM customer_churn
WHERE DaySinceLastOrder IS NOT NULL;
UPDATE customer_churn
SET DaySinceLastOrder = 5
WHERE CustomerID IN 
(SELECT CustomerID
FROM (SELECT CustomerID
FROM customer_churn
WHERE DaySinceLastOrder IS NULL) 
AS missing_days);
SELECT CouponUsed, COUNT(*) AS Frequency
FROM customer_churn
WHERE CouponUsed IS NOT NULL
GROUP BY CouponUsed
ORDER BY Frequency DESC
LIMIT 1;
UPDATE customer_churn
SET CouponUsed = 1
WHERE CustomerID IN 
(SELECT CustomerID
FROM (SELECT CustomerID
FROM customer_churn
WHERE CouponUsed IS NULL) 
AS missing_coupons);
SELECT OrderCount, COUNT(*) AS Frequency
FROM customer_churn
WHERE OrderCount IS NOT NULL
GROUP BY OrderCount
ORDER BY Frequency DESC
LIMIT 1;
UPDATE customer_churn
SET OrderCount = 2
WHERE CustomerID IN (
SELECT CustomerID
FROM (SELECT CustomerID
FROM customer_churn
WHERE OrderCount IS NULL) 
AS missing_orders);
UPDATE customer_churn
SET PreferredLoginDevice = 'Mobile Phone'
WHERE CustomerID IN (
SELECT CustomerID
FROM (SELECT CustomerID
FROM customer_churn
WHERE PreferredLoginDevice = 'Phone'
) AS phone_customers);
UPDATE customer_churn
SET PreferedOrderCat = 'Mobile Phone'
WHERE CustomerID IN (
SELECT CustomerID
FROM (SELECT CustomerID
FROM customer_churn
WHERE PreferedOrderCat = 'Mobile')
 AS mobile_customers);
UPDATE customer_churn
SET PreferredPaymentMode = 'Cash on Delivery'
WHERE CustomerID IN (
SELECT CustomerID
FROM (SELECT CustomerID
FROM customer_churn
WHERE PreferredPaymentMode = 'COD') 
AS cod_customers);
UPDATE customer_churn
SET PreferredPaymentMode = 'Credit Card'
WHERE CustomerID IN 
(SELECT CustomerID
FROM (SELECT CustomerID 
FROM customer_churn
WHERE PreferredPaymentMode = 'CC')
AS cc_customers);
ALTER TABLE customer_churn
RENAME COLUMN PreferedOrderCat To PreferredOrderCat;
ALTER TABLE customer_churn
RENAME COLUMN HourSpendOnApp TO HoursSpendOnApp;
ALTER TABLE customer_churn
ADD COLUMN ComplaintReceived VARCHAR(3);
UPDATE customer_churn
SET ComplaintReceived = CASE
WHEN Complain = 1 THEN 'Yes'
ELSE 'No'
END WHERE CustomerID > 0;
ALTER TABLE customer_churn
ADD COLUMN ChurnStatus VARCHAR(10);
UPDATE customer_churn
SET ChurnStatus = CASE
WHEN Churn = 1 THEN 'Churned'
ELSE 'Active'
END
WHERE CustomerID > 0;
ALTER TABLE customer_churn
DROP COLUMN Churn,
DROP COLUMN Complain;
SELECT *
FROM customer_churn
LIMIT 10;
SELECT ChurnStatus, COUNT(*) AS CustomerCount
FROM customer_churn
GROUP BY ChurnStatus;
SELECT ROUND(AVG(Tenure), 2) AS AverageTenure
FROM customer_churn
WHERE ChurnStatus = 'Churned';
SELECT SUM(CashbackAmount) AS TotalCashback
FROM customer_churn
WHERE ChurnStatus = 'Churned';
SELECT ROUND
(SUM(CASE WHEN ComplaintReceived = 'Yes' THEN 1 ELSE 0 END)
* 100.0 / COUNT(*), 2)
 AS ComplaintPercentage
FROM customer_churn
WHERE ChurnStatus = 'Churned';
SELECT CityTier, COUNT(*) AS CustomerCount
FROM customer_churn
WHERE ChurnStatus = 'Churned'
AND PreferredOrderCat = 'Laptop & Accessory'
GROUP BY CityTier
ORDER BY CustomerCount DESC
LIMIT 1;
SELECT PreferredPaymentMode, COUNT(*) AS CustomerCount
FROM customer_churn
WHERE ChurnStatus = 'Active'
GROUP BY PreferredPaymentMode
ORDER BY CustomerCount DESC
LIMIT 1;
SELECT SUM(OrderAmountHikeFromlastYear) AS TotalOrderAmountHike
FROM customer_churn
WHERE MaritalStatus = 'Single'
AND PreferredOrderCat = 'Mobile Phone';
SELECT ROUND(AVG(NumberOfDeviceRegistered), 2)
AS AverageDevicesRegistered
FROM customer_churn
WHERE PreferredPaymentMode = 'UPI';
SELECT CityTier, COUNT(*) AS CustomerCount
FROM customer_churn
GROUP BY CityTier
ORDER BY CustomerCount DESC
LIMIT 1;
SELECT Gender, SUM(CouponUsed) AS TotalCouponsUsed
FROM customer_churn
GROUP BY Gender
ORDER BY TotalCouponsUsed DESC
LIMIT 1;
SELECT
PreferredOrderCat,
COUNT(*) AS CustomerCount,
MAX(HoursSpentOnApp) AS MaxAppHours
FROM customer_churn
GROUP BY PreferredOrderCat
ORDER BY CustomerCount DESC;
DESCRIBE customer_churn;
SELECT
PreferredOrderCat,
COUNT(*) AS CustomerCount,
MAX(HoursSpendOnApp) AS MaxAppHours
FROM customer_churn
GROUP BY PreferredOrderCat
ORDER BY CustomerCount DESC;
SELECT SUM(OrderCount) AS TotalOrderCount
FROM customer_churn
WHERE PreferredPaymentMode = 'Credit Card'
AND SatisfactionScore = (
SELECT MAX(SatisfactionScore)
FROM customer_churn);
SELECT ROUND(AVG(SatisfactionScore), 2)
AS AverageSatisfactionScore
FROM customer_churn
WHERE ComplaintReceived = 'Yes';
SELECT PreferredOrderCat, COUNT(*) AS CustomerCount
FROM customer_churn
WHERE CouponUsed > 5
GROUP BY PreferredOrderCat
ORDER BY CustomerCount DESC
LIMIT 1;
SELECT
PreferredOrderCat,
ROUND(AVG(CashbackAmount), 2) AS AverageCashback
FROM customer_churn
GROUP BY PreferredOrderCat
ORDER BY AverageCashback DESC
LIMIT 3;
SELECT DISTINCT PreferredPaymentMode
FROM customer_churn
WHERE Tenure = 10
AND OrderCount > 500;
SELECT MAX(Tenure) AS MaximumTenure
FROM customer_churn;
SELECT AVG(Tenure) AS AverageTenure
FROM customer_churn
WHERE OrderCount > 500;
SELECT COUNT(*) AS CustomersOver500Orders
FROM customer_churn
WHERE OrderCount > 500;
SELECT AVG(Tenure) AS AverageTenure
FROM customer_churn;
SELECT MAX(OrderCount) AS MaximumOrderCount
FROM customer_churn;
SELECT
CASE
WHEN WarehouseToHome <= 5 THEN 'Very Close Distance'
WHEN WarehouseToHome <= 10 THEN 'Close Distance'
WHEN WarehouseToHome <= 15 THEN 'Moderate Distance'
ELSE 'Far Distance'
END AS DistanceCategory,
ChurnStatus,
COUNT(*) AS CustomerCount
FROM customer_churn
GROUP BY DistanceCategory, ChurnStatus
ORDER BY
CASE DistanceCategory
WHEN 'Very Close Distance' THEN 1
WHEN 'Close Distance' THEN 2
WHEN 'Moderate Distance' THEN 3
WHEN 'Far Distance' THEN 4
END,
ChurnStatus;
SELECT *
FROM customer_churn
WHERE MaritalStatus = 'Married'
AND CityTier = 1
AND OrderCount > (
SELECT AVG(OrderCount)
FROM customer_churn);
USE ecomm;
CREATE TABLE customer_returns (
ReturnID INT PRIMARY KEY,
CustomerID INT,
ReturnDate DATE,
RefundAmount INT);
INSERT INTO customer_returns
(ReturnID, CustomerID, ReturnDate, RefundAmount)
VALUES
(1001, 50022, '2023-01-01', 2130),
(1002, 50316, '2023-01-23', 2000),
(1003, 51099, '2023-02-14', 2290),
(1004, 52321, '2023-03-08', 2510),
(1005, 52928, '2023-03-20', 3000),
(1006, 53749, '2023-04-17', 1740),
(1007, 54206, '2023-04-21', 3250),
(1008, 54838, '2023-04-30', 1990);
SELECT
cr.ReturnID,
cr.CustomerID,
cr.ReturnDate,
cr.RefundAmount,
cc.*
FROM customer_returns AS cr
INNER JOIN customer_churn AS cc
ON cr.CustomerID = cc.CustomerID
WHERE cc.ChurnStatus = 'Churned'
AND cc.ComplaintReceived = 'Yes';
DESCRIBE customer_churn;
ALTER TABLE customer_churn
RENAME COLUMN HoursSpendOnApp TO HoursSpentOnApp;
SHOW COLUMNS FROM customer_churn LIKE '%Hour%';
