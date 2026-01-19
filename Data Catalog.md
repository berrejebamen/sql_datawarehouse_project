
# Sales Data Warehouse - Data Catalog

## Overview

This document provides comprehensive documentation for the Sales Data Warehouse star schema model. The schema is designed to support sales analytics and reporting, enabling insights into customer purchasing patterns, product performance, and sales trends.

## Schema Architecture

The data model follows a **star schema** design pattern with:
- **1 Fact Table**: `gold.fact_sales` (central transaction table)
- **2 Dimension Tables**: `gold.dim_customers` and `gold.dim_products`

This design optimizes query performance for analytical workloads and provides a clear, intuitive structure for business intelligence tools.

---

## Fact Table

### `gold.fact_sales`

The central fact table containing sales transaction records. Each row represents a single sales order with associated metrics and foreign key references to dimension tables.

| Column | Data Type | Key Type | Description |
|--------|-----------|----------|-------------|
| `order_number` | VARCHAR/INT | **PK** | Unique identifier for each sales order. Primary key for the fact table. |
| `product_key` | INT | **FK1** | Foreign key reference to `gold.dim_products.product_key`. Links the sale to product details. |
| `customer_key` | INT | **FK2** | Foreign key reference to `gold.dim_customers.customer_key`. Links the sale to customer information. |
| `order_date` | DATE | - | Date when the order was placed by the customer. |
| `shipping_date` | DATE | - | Date when the order was shipped to the customer. |
| `due_date` | DATE | - | Expected delivery date or payment due date for the order. |
| `sales_amount` | DECIMAL | - | Total sales value for the order. **Calculated as**: `quantity * price`. |
| `quantity` | INT | - | Number of units ordered in this transaction. |
| `price` | DECIMAL | - | Unit price of the product at the time of sale. |

**Business Rules:**
- Sales Amount Calculation: `sales_amount = quantity * price`
- Each order_number must be unique across all transactions
- Foreign keys must reference valid entries in dimension tables

---

## Dimension Tables

### `gold.dim_customers`

Contains detailed customer information for analysis and segmentation. Provides demographic and identification data for each customer.

| Column | Data Type | Key Type | Description |
|--------|-----------|----------|-------------|
| `customer_key` | INT | **PK** | Surrogate key. Unique identifier for each customer in the data warehouse. |
| `customer_id` | VARCHAR/INT | - | Natural key. Business identifier for the customer from the source system. |
| `customer_number` | VARCHAR | - | Customer account number or reference number used in business operations. |
| `first_name` | VARCHAR | - | Customer's first name. |
| `last_name` | VARCHAR | - | Customer's last name. |
| `marital_status` | VARCHAR | - | Customer's marital status (e.g., Single, Married, Divorced, Widowed). |
| `gender` | VARCHAR | - | Customer's gender (e.g., Male, Female, Other, Prefer not to say). |
| `create_date` | DATE | - | Date when the customer record was created in the system. |
| `birthdate` | DATE | - | Customer's date of birth. Used for age-based analysis and marketing campaigns. |
| `country` | VARCHAR | - | Country of residence for the customer. Used for geographic analysis. |

**Purpose:**
- Enables customer segmentation and demographic analysis
- Supports targeted marketing campaigns
- Facilitates customer lifetime value calculations

---

### `gold.dim_products`

Contains comprehensive product information including categorization, pricing, and lifecycle data.

| Column | Data Type | Key Type | Description |
|--------|-----------|----------|-------------|
| `product_key` | INT | **PK** | Surrogate key. Unique identifier for each product in the data warehouse. |
| `product_id` | VARCHAR/INT | - | Natural key. Business identifier for the product from the source system. |
| `product_number` | VARCHAR | - | Product SKU or reference number used in inventory and catalog systems. |
| `product_name` | VARCHAR | - | Full descriptive name of the product. |
| `product_cost` | DECIMAL | - | Cost of goods sold (COGS) or acquisition cost for the product. |
| `product_line` | VARCHAR | - | High-level product line classification (e.g., Electronics, Apparel, Home Goods). |
| `product_start_date` | DATE | - | Date when the product was introduced or became available for sale. |
| `category` | VARCHAR | - | Primary product category for classification and reporting. |
| `subcategory` | VARCHAR | - | More granular product classification within the category. |
| `maintenance` | VARCHAR/BOOLEAN | - | Indicates if the product requires maintenance or has maintenance options available. |

**Purpose:**
- Enables product performance analysis
- Supports inventory management and planning
- Facilitates profitability analysis using product cost data

---

## Relationships

```
gold.dim_customers.customer_key ──────< gold.fact_sales.customer_key (FK2)
gold.dim_products.product_key ────────< gold.fact_sales.product_key (FK1)
```

**Cardinality:**
- One customer can have many sales transactions (1:N)
- One product can appear in many sales transactions (1:N)

## Data Quality Notes

- All foreign keys in the fact table must have corresponding records in dimension tables
- Date fields should be validated to ensure logical ordering (order_date ≤ shipping_date ≤ due_date)
- Sales amount should always equal quantity × price
- Surrogate keys (customer_key, product_key) are used to handle slowly changing dimensions

---

## Maintenance & Support

For questions or issues regarding this data model, please contact the Data Engineering team or open an issue in this repository.

**Last Updated:** January 2026  
**Schema Version:** 1.0
