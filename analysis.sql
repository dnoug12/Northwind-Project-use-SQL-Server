-- TỔNG QUAN VỀ BỘ DỮ LIỆU
-- Xem qua các bảng trong dataset
SELECT TABLE_SCHEMA, TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE';

-- Xem qua các cột trong từng bảng của dataset
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
ORDER BY TABLE_NAME, ORDINAL_POSITION;

-- Tổng doanh thu của Northwind
SELECT ROUND(SUM(UnitPrice * Quantity * (1 - Discount)),0) AS Total_Sales
FROM [Order Details] 

-- Doanh thu theo từng thời gian
SELECT YEAR(OrderDate) as OrderYear,
		ROUND(SUM(UnitPrice * Quantity * (1 - Discount)),0) AS Total_Sales
FROM Orders O
JOIN [Order Details] OD ON O.OrderID = OD.OrderID 
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear

-- Sản phẩm bán chạy nhất
SELECT TOP 10 p.ProductID, 
    p.ProductName, 
    c.CategoryName,
    SUM(od.Quantity) AS TotalQuantitySold,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)),0) AS TotalSales
FROM [Order Details] od
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY p.ProductID, p.ProductName, c.CategoryName
ORDER BY TotalSales DESC;


-- Phân nhóm khách hàng theo khu vực địa lý 
-- Đầu tiên ta xem qua danh sách khách hàng
SELECT *
FROM Customers -- TỔNG CỘNG CÓ 91 KHÁCH HÀNG RẢI RÁC NHIỀU NƯỚC

--Tiến hành nhóm theo Quốc gia
SELECT Country,
		COUNT(CustomerID) as Total_Customers
FROM Customers
GROUP BY Country
ORDER BY Total_Customers DESC

-- Nhóm theo thành phố
SELECT Country,
		City,
		COUNT(CustomerID) as Total_Customers
FROM Customers
GROUP BY Country, City
ORDER BY Country, Total_Customers DESC

-- Số lượng đơn hàng ở từng thành phố 
SELECT TOP 20 C.Country,
		C.City,
		COUNT(OrderID) AS Total_Order
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
GROUP BY C.City, C.Country
ORDER BY Total_Order DESC

-- Tốc độ lưu chuyển hàng
SELECT P.ProductName,
		P.ProductID,
		C.CategoryName,
		AVG(DATEDIFF(DAY, OrderDate, ShippedDate)) AS AvgTimeShip,
		COUNT(OD.OrderID) AS TotalOrders
FROM Orders O
JOIN [Order Details] OD ON O.OrderID = OD.OrderID
JOIN Products P ON P.ProductID = OD.ProductID
JOIN Categories C ON C.CategoryID = P.CategoryID
GROUP BY P.ProductName, P.ProductID, C.CategoryName
ORDER BY AvgTimeShip DESC

SELECT *
FROM Categories

-- Dữ liệu về thời gian giữa đơn đặt hàng và giao hàng được phân tích nhằm đánh giá hiệu quả quy trình xử lý đơn hàng
-- Thời gian xử lý đơn hàng theo danh mục sản phẩm
SELECT C.CategoryName,
		AVG(DATEDIFF(DAY,O.OrderDate, O.ShippedDate)) AS AvgProcessingTime,
		COUNT(O.OrderID) AS TotalOrders
FROM Orders O
JOIN [Order Details] OD ON OD.OrderID = O.OrderID
JOIN Products P ON P.ProductID = OD.ProductID
JOIN Categories C ON C.CategoryID = P.CategoryID
WHERE O.ShippedDate IS NOT NULL
GROUP BY C.CategoryName
ORDER BY C.CategoryName


-- Câu 1: Tác động của Chiết Khấu đến Số Lượng Sản Phẩm Trong Đơn Hàng
-- Thống kê số lượng theo mức chiết khấu (với dữ liệu từ bảng Order Details)
SELECT 
    Discount, 
    AVG(Quantity) AS AvgQuantity,
    STDEV(Quantity) AS StdDevQuantity,
    COUNT(*) AS NumOrders
FROM [Order Details]
GROUP BY Discount
ORDER BY Discount ASC;

-- Để có cái nhìn tổng quát hơn, ta có thể phân nhóm Discount thành các khoảng 
-- (ví dụ: không chiết khấu, 0-5%, 5-10%, >10%) và so sánh số lượng bán
SELECT 
    CASE 
      WHEN Discount = 0 THEN 'No Discount'
      WHEN Discount > 0 AND Discount <= 0.05 THEN '0-5%'
      WHEN Discount > 0.05 AND Discount <= 0.10 THEN '5-10%'
      WHEN Discount > 0.10 THEN '>10%'
    END AS DiscountRange,
    COUNT(*) AS OrderCount,
    AVG(Quantity) AS AvgQuantity,
    STDEV(Quantity) AS StdDevQuantity
FROM [Order Details]
GROUP BY 
    CASE 
      WHEN Discount = 0 THEN 'No Discount'
      WHEN Discount > 0 AND Discount <= 0.05 THEN '0-5%'
      WHEN Discount > 0.05 AND Discount <= 0.10 THEN '5-10%'
      WHEN Discount > 0.10 THEN '>10%'
    END;

WITH Stats AS (
  SELECT 
    AVG(Discount) AS AvgDiscount,
    AVG(Quantity) AS AvgQuantity,
    STDEV(Discount) AS StdDevDiscount,
    STDEV(Quantity) AS StdDevQuantity
  FROM [Order Details]
)
SELECT
  SUM((d.Discount - s.AvgDiscount) * (d.Quantity - s.AvgQuantity)) / (COUNT(*) - 1) AS Covariance,
  (SUM((d.Discount - s.AvgDiscount) * (d.Quantity - s.AvgQuantity)) / (COUNT(*) - 1)) / (s.StdDevDiscount * s.StdDevQuantity) AS Correlation
FROM [Order Details] d CROSS JOIN Stats s;

--2. Hiệu Suất của Nhân Viên US vs. UK
--Tổng hợp doanh thu và số đơn hàng theo nhân viên
SELECT 
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    e.Country,
    COUNT(DISTINCT o.OrderID) AS NumOrders,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalRevenue,
    AVG(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS AvgOrderRevenue
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Employees e ON o.EmployeeID = e.EmployeeID
WHERE e.Country IN ('USA', 'UK')
GROUP BY e.EmployeeID, CONCAT(e.FirstName, ' ', e.LastName), e.Country;

-- b) Thống kê tổng hợp theo quốc gia
WITH EmployeeStats AS (
    SELECT 
        e.EmployeeID,
        e.Country,
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalRevenue
    FROM Orders o
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    JOIN Employees e ON o.EmployeeID = e.EmployeeID
    WHERE e.Country IN ('USA', 'UK')
    GROUP BY e.EmployeeID, e.Country
)
SELECT 
    Country,
    ROUND(AVG(TotalRevenue), 2) AS AvgEmployeeRevenue,
    ROUND(MIN(TotalRevenue), 2) AS MinEmployeeRevenue,
    ROUND(MAX(TotalRevenue), 2) AS MaxEmployeeRevenue,
    COUNT(*) AS NumEmployees
FROM EmployeeStats
GROUP BY Country;


-- 3. Chiết Khấu của Nhân Viên USA và UK
-- Thông tin chiết khấu theo nhân viên
SELECT 
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    e.Country,
    AVG(od.Discount) AS AvgDiscount,
    COUNT(*) AS OrderCount
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Employees e ON o.EmployeeID = e.EmployeeID
WHERE e.Country IN ('USA', 'UK')
GROUP BY e.EmployeeID, CONCAT(e.FirstName, ' ', e.LastName), e.Country;


-- Thống kê tổng hợp theo quốc gia
SELECT 
    Country,
    ROUND(AVG(Discount), 2) AS AvgDiscount,
    STDEV(Discount) AS StdDevDiscount,
    COUNT(*) AS TotalRecords
FROM (
    SELECT 
        e.Country,
        od.Discount
    FROM Orders o
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    JOIN Employees e ON o.EmployeeID = e.EmployeeID
    WHERE e.Country IN ('USA', 'UK')
) AS DiscountData
GROUP BY Country;

-- Phân nhóm theo khoảng Discount (cho mỗi quốc gia)
SELECT 
    e.Country,
    CASE 
      WHEN od.Discount = 0 THEN 'No Discount'
      WHEN od.Discount > 0 AND od.Discount <= 0.05 THEN '0-5%'
      WHEN od.Discount > 0.05 AND od.Discount <= 0.10 THEN '5-10%'
      WHEN od.Discount > 0.10 THEN '>10%'
    END AS DiscountRange,
    COUNT(*) AS OrderCount,
    AVG(od.Discount) AS AvgDiscount
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Employees e ON o.EmployeeID = e.EmployeeID
WHERE e.Country IN ('USA', 'UK')
GROUP BY 
    e.Country,
    CASE 
      WHEN od.Discount = 0 THEN 'No Discount'
      WHEN od.Discount > 0 AND od.Discount <= 0.05 THEN '0-5%'
      WHEN od.Discount > 0.05 AND od.Discount <= 0.10 THEN '5-10%'
      WHEN od.Discount > 0.10 THEN '>10%'
    END
ORDER BY e.Country, DiscountRange;

-- 4. Nhu Cầu của Produce Mỗi Tháng
--Tổng hợp doanh số theo tháng cho danh mục Produce
SELECT 
    DATEPART(YEAR, o.OrderDate) AS OrderYear,
    DATEPART(MONTH, o.OrderDate) AS OrderMonth,
    SUM(od.Quantity) AS TotalProduceQuantity,
    COUNT(DISTINCT o.OrderID) AS OrderCount
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Produce'
GROUP BY DATEPART(YEAR, o.OrderDate), DATEPART(MONTH, o.OrderDate)
ORDER BY OrderYear, OrderMonth;


-- 5. Sự Khác Biệt về Chiết Khấu giữa Các Danh Mục
-- Thống kê Discount theo danh mục
SELECT 
    o.EmployeeID,
    e.Country,
    od.Discount,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalRevenue
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Employees e ON o.EmployeeID = e.EmployeeID
WHERE e.Country IN ('USA', 'UK')
GROUP BY o.EmployeeID, e.Country, od.Discount;

-- Phân nhóm Discount theo khoảng trong từng danh mục
SELECT 
    c.CategoryName,
    CASE 
      WHEN od.Discount = 0 THEN 'No Discount'
      WHEN od.Discount > 0 AND od.Discount <= 0.05 THEN '0-5%'
      WHEN od.Discount > 0.05 AND od.Discount <= 0.10 THEN '5-10%'
      WHEN od.Discount > 0.10 THEN '>10%'
    END AS DiscountRange,
    COUNT(*) AS OrderCount,
    AVG(od.Discount) AS AvgDiscount
FROM [Order Details] od
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName,
    CASE 
      WHEN od.Discount = 0 THEN 'No Discount'
      WHEN od.Discount > 0 AND od.Discount <= 0.05 THEN '0-5%'
      WHEN od.Discount > 0.05 AND od.Discount <= 0.10 THEN '5-10%'
      WHEN od.Discount > 0.10 THEN '>10%'
    END
ORDER BY c.CategoryName, DiscountRange;

-- 6. Hiệu Suất của Các Công Ty Vận Chuyển (Shippers)
-- Tính số ngày giao hàng trung bình
SELECT 
    o.ShipVia AS ShipperID,
    AVG(DATEDIFF(DAY, o.OrderDate, o.ShippedDate)) AS AvgDeliveryTime,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalRevenue
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.ShipVia;

SELECT 
    s.CompanyName,
    AVG(DATEDIFF(DAY, o.OrderDate, o.ShippedDate)) AS AvgDeliveryTime,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalRevenue
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Shippers s ON o.ShipVia = s.ShipperID
GROUP BY s.CompanyName;


-- Phân tích đơn hàng giao trễ và đúng hạn
SELECT 
    s.ShipperID,
    s.CompanyName,
    SUM(CASE WHEN DATEDIFF(day, o.OrderDate, o.ShippedDate) > 7 THEN 1 ELSE 0 END) AS LateOrders,
    SUM(CASE WHEN DATEDIFF(day, o.OrderDate, o.ShippedDate) <= 7 THEN 1 ELSE 0 END) AS OnTimeOrders
FROM Orders o
JOIN Shippers s ON o.ShipVia = s.ShipperID
WHERE o.ShippedDate IS NOT NULL
GROUP BY s.ShipperID, s.CompanyName;
