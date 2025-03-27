# Northwind Project - SQL Server  

## 📚 Giới Thiệu  
Northwind là một cơ sở dữ liệu mẫu phổ biến, được sử dụng để học tập và thực hành SQL Server. Dữ liệu mô phỏng một công ty bán hàng với các bảng liên quan đến khách hàng, đơn hàng, sản phẩm, nhân viên và nhà cung cấp.

---

## 👥 Hướng Dẫn Tải Xuống và Import Dữ Liệu  

### 1. Tải dữ liệu Northwind  
   - Truy cập vào link sau để tải file database Northwind:  
     👉 [Tải Northwind Database](https://github.com/microsoft/sql-server-samples/tree/master/samples/databases/northwind-pubs)

### 2. Import vào SQL Server  
   - Mở **SQL Server Management Studio (SSMS)**.  
   - Chạy lệnh sau để tạo database:  
     ```sql
     CREATE DATABASE Northwind;
     ```
   - Sử dụng chức năng **Restore Database** để import file `.bak` vào SQL Server.  
   - Nếu sử dụng file `.sql`, mở và chạy từng lệnh để tạo bảng và nhập dữ liệu.

> Nếu gặp lỗi khi import, hãy kiểm tra quyền truy cập và phiên bản SQL Server của bạn.

---

## 👤 Hướng Dẫn Mở File Code  

### 1. Clone Repository  
   ```bash
   git clone https://github.com/dnoug12/Northwind-Project-use-SQL-Server.git
   cd Northwind-Project-use-SQL-Server
   ```

### 2. Mở file SQL trên SSMS  
   - Mở **SQL Server Management Studio (SSMS)**.  
   - Chọn **File** → **Open** → **File...**  
   - Tìm đến thư mục chứa project và mở file `.sql`.  

### 3. Chạy Query  
   - Chọn **Northwind Database**.  
   - Chạy từng lệnh SQL trong file để kiểm tra dữ liệu.  

---

## 📈 Các Bảng Quan Trọng  

| Bảng       | Mô tả |
|------------|-------|
| Customers  | Thông tin khách hàng |
| Orders     | Thông tin đơn hàng |
| Employees  | Danh sách nhân viên |
| Products   | Danh mục sản phẩm |
| Suppliers  | Danh sách nhà cung cấp |
| Categories | Phân loại sản phẩm |
| OrderDetails | Chi tiết đơn hàng |
| Shippers | Đơn vị vận chuyển |
| .........| ......... |
> Xem chi tiết thông tin các bảng trong file `Northwind Summary.pdf`

---

## 🔧 Các Lệnh SQL Mẫu  

```sql
-- Lấy danh sách khách hàng
SELECT * FROM Customers;

-- Lấy danh sách đơn hàng
SELECT * FROM Orders WHERE OrderDate > '2023-01-01';

-- Thống kê số lượng đơn hàng theo năm
SELECT YEAR(OrderDate) AS OrderYear, COUNT(*) AS TotalOrders 
FROM Orders 
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear DESC;

-- Truy vấn danh sách sản phẩm và nhà cung cấp
SELECT Products.ProductName, Suppliers.CompanyName 
FROM Products
JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID;
```

---

## 💎 Tính Năng Chính  
- ✅ Truy vấn và quản lý dữ liệu khách hàng, đơn hàng, sản phẩm.
- ✅ Thống kê doanh số và báo cáo bán hàng.
- ✅ Thực hành các truy vấn SQL nâng cao như **JOIN, GROUP BY, HAVING**.
- ✅ Hỗ trợ học tập và thực hành SQL Server trên Northwind.
- ✅ Xây dựng dashboard và báo cáo trên Power BI hoặc Tableau.

---

## 📍 Yêu Cầu Hệ Thống  
- **SQL Server**: Phiên bản 2016 trở lên (khuyến nghị SQL Server 2019+).
- **SSMS**: SQL Server Management Studio để thực thi truy vấn.
- **Git**: Để clone repository (tùy chọn).
- **Power BI / Tableau**: (Tùy chọn) để phân tích và trực quan hóa dữ liệu.


---

## 👤 Đóng Góp  
Bạn có thể đóng góp bằng cách:
- Tạo **Issue** nếu bạn gặp lỗi hoặc có câu hỏi.
- Fork repository và gửi **Pull Request** để đóng góp code.
- Đề xuất các truy vấn SQL hữu ích hoặc báo cáo phân tích dữ liệu.

---

## 📌 Liên hệ  
Nếu có vấn đề gì, hãy mở **Issue trên GitHub** hoặc liên hệ với tôi qua email! 🚀  

---

📌 *Lưu ý*: Đây là file `README.md` để sử dụng trên GitHub. Khi upload lên GitHub, nội dung sẽ được hiển thị với định dạng rõ ràng trên giao diện web của repository.

