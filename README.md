# E-Commerce Customer Churn Analysis

> A MySQL project analyzing e-commerce customer churn patterns — covering data cleaning, transformation, and structured analytical queries on customer behaviour, payment preferences, satisfaction scores, and return details.

---

## Project Showcase

<p align="center">
  <img src="https://raw.githubusercontent.com/bibythayyil/bibythayyil/main/assets/ecommerce_customer_churn_dashboard.png" width="900">
</p>

---

## Project Overview

In the e-commerce domain, understanding customer churn is critical for sustaining profitability and customer relationships. This project uses MySQL to clean, transform, and analyze historical transactional data from an e-commerce platform, uncovering patterns in customer attrition and behavior to support targeted retention strategies.

---

## Problem Statement

Analyze customer churn within an e-commerce database to:
- Identify patterns and drivers of customer attrition
- Understand how tenure, payment modes, satisfaction scores, and purchase behavior relate to churn
- Provide actionable insights to support customer retention strategies

---

## Database

| Property | Details |
|---|---|
| Database Name | ecomm |
| Table | customer_churn |
| Records | ~5,630 customers |
| Columns | 20 fields |

### Key Variables

| Category | Columns |
|---|---|
| Customer Info | CustomerID, Gender, MaritalStatus, CityTier |
| Behaviour | PreferredLoginDevice, PreferredPaymentMode, PreferredOrderCat |
| Activity | Tenure, HoursSpentOnApp, NumberOfDeviceRegistered, NumberOfAddress |
| Orders | OrderCount, OrderAmountHikeFromlastYear, CouponUsed, DaySinceLastOrder |
| Satisfaction | SatisfactionScore, CashbackAmount |
| Logistics | WarehouseToHome |
| Derived | ChurnStatus (Active / Churned), ComplaintReceived (Yes / No) |

---

## Project Workflow

### 1. Data Cleaning

**Missing Value Imputation:**
- Mean imputation (rounded): `WarehouseToHome`, `HoursSpentOnApp`, `OrderAmountHikeFromlastYear`, `DaySinceLastOrder`
- Mode imputation: `Tenure`, `CouponUsed`, `OrderCount`

**Outlier Handling:**
- Deleted rows where `WarehouseToHome > 100`

**Inconsistency Fixes:**
- Standardised "Phone" to "Mobile Phone" in `PreferredLoginDevice`
- Standardised "Mobile" to "Mobile Phone" in `PreferredOrderCat`
- Standardised "COD" to "Cash on Delivery" and "CC" to "Credit Card" in `PreferredPaymentMode`

### 2. Data Transformation

**Column Renaming:**
- `PreferedOrderCat` renamed to `PreferredOrderCat`
- `HourSpendOnApp` renamed to `HoursSpentOnApp`

**New Columns Created:**
- `ComplaintReceived` — "Yes" if Complain = 1, else "No"
- `ChurnStatus` — "Churned" if Churn = 1, else "Active"

**Columns Dropped:**
- `Churn` and `Complain` (replaced by derived columns above)

### 3. Data Analysis — 18 Queries

| # | Query |
|---|---|
| 1 | Count of churned vs active customers |
| 2 | Average tenure and total cashback of churned customers |
| 3 | Percentage of churned customers who complained |
| 4 | City tier with highest churned customers ordering Laptop & Accessory |
| 5 | Most preferred payment mode among active customers |
| 6 | Total order amount hike for single customers preferring mobile phones |
| 7 | Average devices registered among UPI users |
| 8 | City tier with highest number of customers |
| 9 | Gender with highest coupon usage |
| 10 | Customer count and max app hours by preferred order category |
| 11 | Total orders by Credit Card users with maximum satisfaction score |
| 12 | Average satisfaction score of customers who complained |
| 13 | Preferred order categories among customers using more than 5 coupons |
| 14 | Top 3 order categories by average cashback amount |
| 15 | Payment modes of customers with average tenure of 10 months and 500+ orders |
| 16 | Churn breakdown by warehouse-to-home distance category |
| 17 | Order details of married City Tier-1 customers with above-average order counts |
| 18 | Customer returns table — creation, data insertion, and join with churn data |

---

## Files in This Repository

| File | Description |
|---|---|
| `E-Commerce_Customer_churn_db.sql` | Database creation script — creates ecomm database and loads all customer data |
| `E-Commerce_Customer_Churn_Analysis.sql` | Full analysis script — data cleaning, transformation, and all 18 analytical queries |
| `README.md` | Project documentation |

---

## How to Use

1. Clone or download this repository
```bash
git clone https://github.com/bibythayyil/ecommerce-customer-churn-analysis-mysql
```

2. Open MySQL Workbench or any MySQL client

3. Run the database script first to create and populate the database:
```sql
SOURCE E-Commerce_Customer_churn_db.sql;
```

4. Then run the analysis script:
```sql
SOURCE E-Commerce_Customer_Churn_Analysis.sql;
```

> **Important:** Always run the database script before the analysis script — the analysis depends on the ecomm database being set up first.

---

## Tools Used

| Tool | Purpose |
|---|---|
| MySQL | Database creation, data storage, and querying |
| MySQL Workbench | Query development and execution |
| SQL | Data cleaning, transformation, and analysis |


---

## Author

**Bibin T S**

---
