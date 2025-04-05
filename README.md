# 📊 Northwind Project - SQL Server

## 📚 Introduction
Northwind is a popular sample database used for learning and practicing SQL Server. The data simulates a sales company with tables related to customers, orders, products, employees, and suppliers.

---

## 👥 Download and Import Instructions

### 1. Download the Northwind Database
- Visit the following link to download the Northwind database files:  
  👉 [Download Northwind Database](https://github.com/microsoft/sql-server-samples/tree/master/samples/databases/northwind-pubs)

### 2. Import into SQL Server
- Open **SQL Server Management Studio (SSMS)**.  
- Run the following command to create the database:
  ```sql
  CREATE DATABASE Northwind;
  ```
- Use the **Restore Database** feature to import the `.bak` file into SQL Server.  
- If you have a `.sql` script version, open and execute each statement to create tables and insert data.

> If you encounter import errors, verify your permissions and SQL Server version.

---

## 👤 Opening the Code Files

### 1. Clone the Repository
```bash
git clone https://github.com/dnoug12/Northwind-Project-use-SQL-Server.git
cd Northwind-Project-use-SQL-Server
```

### 2. Open SQL Files in SSMS
- Launch **SQL Server Management Studio (SSMS)**.  
- Go to **File** → **Open** → **File...**  
- Navigate to the project folder and open the `.sql` files.

### 3. Execute Queries
- Select the **Northwind** database.  
- Run each SQL statement to explore the data.

---

## 📈 Key Tables

| Table         | Description                 |
|---------------|-----------------------------|
| Customers     | Customer information        |
| Orders        | Order information           |
| Employees     | Employee list               |
| Products      | Product catalog             |
| Suppliers     | Supplier list               |
| Categories    | Product categories          |
| OrderDetails  | Order line details          |
| Shippers      | Shipping companies          |
| ...           | ...                         |

> For detailed table descriptions, see `Northwind Summary.pdf`.

---

## 🔧 Sample SQL Queries
```sql
-- List all customers
SELECT * FROM Customers;

-- List orders placed after January 1, 2023
SELECT *
FROM Orders
WHERE OrderDate > '2023-01-01';

-- Count orders by year
SELECT YEAR(OrderDate) AS OrderYear,
       COUNT(*) AS TotalOrders
FROM Orders
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear DESC;

-- Join products with suppliers
SELECT p.ProductName,
       s.CompanyName
FROM Products p
JOIN Suppliers s
  ON p.SupplierID = s.SupplierID;
```

---

## 💎 Main Features
- ✅ Query and manage customer, order, and product data.
- ✅ Generate sales statistics and reports.
- ✅ Practice advanced SQL queries such as **JOIN**, **GROUP BY**, **HAVING**.
- ✅ Learn and practice SQL Server using the Northwind dataset.
- ✅ Build dashboards and reports in Power BI or Tableau.

---

## 📍 System Requirements
- **SQL Server**: Version 2016 or later (recommended SQL Server 2019+).
- **SSMS**: SQL Server Management Studio for query execution.
- **Git**: To clone the repository (optional).
- **Power BI / Tableau**: (Optional) For data analysis and visualization.

---

## 👤 Contributing
You can contribute by:
- Creating an **Issue** if you find bugs or have questions.
- Forking the repository and submitting a **Pull Request** to improve code or documentation.
- Suggesting useful SQL queries or analytical reports.

---

## 📌 Contact
If you have any questions or issues, please open an **Issue** on GitHub or contact me via email! 🚀

