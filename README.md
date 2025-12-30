# SQL-DataWarehouse-Project
###Hi I am Sarvesh Maurya, I am a student and this is my Data-Warehouse project that i made to test my SQL skills 
#SQL Server End-to-End Data Warehouse (Medallion Architecture)
##Project Overview
This project demonstrates the design and implementation of a robust, SQL-only Data Warehouse. It transforms raw data from disparate CRM and ERP source systems into a structured Star Schema optimized for high-performance data analysis and machine learning model training. The entire ETL (Extract, Transform, Load) process is orchestrated within SQL Server using a multi-layered Medallion Architecture.

## Architecture & Data Flow
The warehouse is divided into three logical layers to ensure data quality, lineage, and scalability.

###1. Bronze Layer (Raw Data)
Source Systems: Ingests data from two main business units: CRM and ERP.

Object Type: Physical tables populated via batch processing.

Interface: Ingested from CSV files stored in a designated folder structure.

Loading Strategy: Full load using "Truncate & Insert" to capture the current state of source files.

Transformations: None. Data is stored in its raw format for auditability.

###2. Silver Layer (Standardized Data)
Purpose: Acts as the "Cleansing & Integration" zone.

Key Transformations:

Data Cleansing: Handling nulls, removing duplicates, and fixing formatting.

Standardization: Ensuring consistent data types and naming conventions across CRM and ERP sources.

Data Enrichment: Adding derived columns and normalizing tables.

Lineage: Data flows from bronze tables (e.g., crm_sales_details, erm_cust_az12) into refined silver equivalents.

###3. Gold Layer (Curated Analytics)
Object Type: Primarily implemented as SQL Views to provide real-time, non-load transformations for downstream consumption.

Data Modeling: Implements a Star Schema consisting of a centralized Fact table and descriptive Dimension tables.

Features: Includes data integrations, complex aggregations, and applied business logic.

## Data Modeling (Star Schema)
The Gold Layer is designed specifically for analytical efficiency and ease of use in BI tools and ML pipelines.

###Fact Table
gold.fact_sales: Contains the core business metrics.

Keys: Linked via product_key and customer_key.

Measures: sales_amount, quantity, and price.

Dates: Tracks order_date, shipping_date, and due_date.

###Dimension Tables
gold.dim_customers: Stores descriptive attributes of customers including first_name, last_name, country, marital_status, and gender.

gold.dim_products: Details product hierarchy including product_name, category, subcategory, cost, and product_line.

##Technical Stack
Database Engine: Microsoft SQL Server

ETL Tool: T-SQL (Stored Procedures, Views, and Batch Processing)

Modeling Technique: Star Schema & Medallion Architecture

##Downstream Consumption
The final Gold Layer provides a clean, high-performance interface for:

BI Reporting: Power BI / Tableau dashboards for executive decision-making.

Machine Learning: Prepared "Flat Tables" and feature sets ready for model training in Python or R.
