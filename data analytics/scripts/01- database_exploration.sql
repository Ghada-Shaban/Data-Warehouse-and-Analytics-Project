/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/
-- explore all objects
SELECT * FROM INFORMATION_SCHEMA.TABLES;

-- explore all columns

SELECT * FROM INFORMATION_SCHEMA.COLUMNS;
