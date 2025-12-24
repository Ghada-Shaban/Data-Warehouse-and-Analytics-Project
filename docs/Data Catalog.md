# Gold Layer Data Catalog 

**Overview :**  
The Gold layer contains three business-ready views forming a classic Star Schema for sales analytics:  
- **dim_customers**: Enriched customer dimension  
- **dim_products**: Current product dimension  
- **fact_sales**: Transactional sales fact table  

All views are based on transformations and joins from the Silver layer.

---

### **1. gold.dim_customers**
- **Purpose:** provides a enriched view of all customers (demographic and geographic data)

| Column Name       | Data Type         | Description                                     |
|-------------------|-------------------|---------------------------------------------------------------------|
| customer_key      | INT               | Surrogate key (unique warehouse identifier)                         |
| customer_id       | INT               | Unique numerical identifier assigned to each customer                                      |
| customer_number   | NVARCHAR(50)      | Alphanumeric identifier representing the customer, used for tracking and referencing |
| first_name        | NVARCHAR(50)      | Customer's first name                                               |
| last_name         | NVARCHAR(50)      | Customer's last name                                                |
| country           | NVARCHAR(50)      | Customer's country (e.g., 'Australia')                              |
| marital_status    | NVARCHAR(50)      | Marital status (e.g., Married , Single )                             |
| gender            | NVARCHAR(50)      | Gender (e.g.,Male , Female)    |
| birthdate         | DATE              | Customer's date of birth formatted as YYYY-MM-DD (e.g., 1971-10-06)                                           |
| create_date       | DATE              | Date when the customer record was created                   |

---
### **2. gold.dim_products**
- **Purpose:**  represents the current catalog of products with full hierarchy

| Column Name     | Data Type         | Description                                     |
|-----------------|-------------------|---------------------------------------------------------------------|
| product_key     | INT               | Surrogate key (unique warehouse identifier)                         |
| product_id      | INT    | A unique identifier assigned to the product for internal tracking and referencing                                        |
| product_number  | NVARCHAR(50)      | A structured alphanumeric code representing the product, often used for categorization or inventory                                       |
| product_name    | NVARCHAR(50)     | Descriptive name of the product, including key details                                                 |
| category_id     | NVARCHAR(50)      | A unique identifier for the product's category, linking to its high-level classification                    |
| category        | NVARCHAR(50)     | The broader classification of the product (e.g., Bikes, Components) to group related items                                              |
| subcategory     | NVARCHAR(50)     | A more detailed classification of the product within the category                                          |
| maintenance     | NVARCHAR(50)      | Indicates whether the product requires maintenance (e.g., 'Yes', 'No')                          |
| cost            | INT               | Product cost or base price of the product                                                        |
| product_line    | NVARCHAR(50)      |The specific product line or series to which the product belongs (e.g.,Road, Mountain , Touring..)       |
| start_date      | DATE              | Date when this product version became active                        |

---
### **3. gold.fact_sales**
- **Purpose:** Stores transactional sales data for analytical purposes

| Column Name      | Data Type         | Description                                     |
|------------------|-------------------|---------------------------------------------------------------------|
| order_number     | NVARCHAR(50)      | Unique identifier for each sales order                                         |
| product_key      | INT               | Surrogate key linking the order to the product dimension table                                         |
| customer_key     | INT               | Surrogate key linking the order to the customer dimension table                                        |
| order_date       | DATE              | Date when the order was placed                                      |
| shipping_date    | DATE              | Date when the order was shipped to the customer                                    |
| due_date         | DATE              | Payment due date                                                    |
| sales_amount     | INT     | The total monetary value of the sale for the line item               |
| quantity         | INT               | Number of units sold for the line item                                                |
| price            | INT     |The price per unit of the product for the line item, in whole currency units                                                 |

---
**Notes**  
- Sales Amount = Quantity × Price (business rule)  
- Surrogate keys protect from source system changes  
- Data enriched from multiple silver sources (CRM + ERP)
