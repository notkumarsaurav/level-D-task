# 📅 Time Dimension Table Generator (SQL Server)

## About the Project

This project is a **Time Dimension Table Generator** built for **Microsoft SQL Server (MSSQL)**. It uses a **single insert statement** (as per the problem constraint) to populate an entire year's worth of dates, starting from a user-defined date. Each record comes with a wide range of useful calendar and fiscal attributes, making it ideal for use in **data warehousing**, **reporting**, and **BI tools**.

This repository was developed as part of a learning opportunity provided by **Celebal Technologies**, who gave students a chance to dive deep into real-world database concepts through hands-on experience. 

---

## Output Screenshot
(all the screenshot are from a single table)
<img width="888" height="516" alt="Screenshot 2025-07-23 225820" src="https://github.com/user-attachments/assets/26e4d344-98b9-460c-9a36-bc5d2e76e0a0" />
<img width="890" height="489" alt="Screenshot 2025-07-23 225837" src="https://github.com/user-attachments/assets/6a258a8c-806c-4cc9-9994-a39b4a540ebb" />
<img width="924" height="727" alt="Screenshot 2025-07-23 225856" src="https://github.com/user-attachments/assets/2f67b936-760a-4aee-bb65-793d134a9557" />
<img width="914" height="574" alt="Screenshot 2025-07-23 225905" src="https://github.com/user-attachments/assets/25af4c92-0813-4982-8685-33d355afb8f4" />




## 🚀 Features

- 📅 Populates all dates for the **year of a given input date**
- ✅ **Single INSERT** statement using recursive CTE
- 🗓️ Rich date attributes:
  - Calendar & Fiscal Year
  - Day names, suffixes (e.g., 1st, 2nd, 3rd)
  - Weekend detection
  - Month and Quarter info
- 💡 Great for use in **time-based reporting and analytics**

---

## ⚙️ Technologies Used

- Microsoft SQL Server
- T-SQL Stored Procedures
- Recursive CTEs
- SQL Date & Time Functions

---

## 🧑‍💻 Usage

```sql
-- Call the procedure with a sample date
EXEC dbo.PopulateTimeDimension '2020-07-14';

-- View your populated data
SELECT * FROM dbo.TimeDimension;
