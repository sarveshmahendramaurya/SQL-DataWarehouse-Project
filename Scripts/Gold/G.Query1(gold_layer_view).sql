/* purpose:
it merges the data from silver schema and create tow dimension view and one fact view
it also creates surogate keys to fulfill the work of primary key using ROW_NUMBER()
and all the views are stored in the gold schema
*/

--==========================================--
--CREATIING VIEWS AND STORING IN GOLD SCHEMA--


CREATE VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY  cst_id) AS customer_key,
	ci.cst_id  AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.CNTRY AS country,
	ci.cst_marital_status AS marital_status,
	CASE
		WHEN ci.cst_gndr != 'N/A' THEN ci.cst_gndr 
		ELSE COALESCE(ca.gen,'N/A')
	END AS gender,
	ca.BDATE AS birthdate,
	ci.cst_create_date AS create_date
FROM Silver.crm_cust_info ci
	LEFT JOIN Silver.erm_CUST_AZ12 ca
	ON ci.cst_key=ca.cid
	LEFT JOIN Silver.erm_LOC_A101 la
	ON ci.cst_key=la.CID;

select * from gold.dim_customers;

CREATE VIEW Gold.dim_product AS
SELECT
	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
	pn.prd_id AS product_id,
	PN.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS catagory_id,
	pc.CAT AS categorry,
	pc.SUBCAT AS subcategory,
	pc.MAINTENANCE AS maintenance,
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt
FROM Silver.crm_prd_info pn
LEFT JOIN Silver.erm_PX_CAT_G1V2 pc
ON PN.cat_id=pc.ID
WHERE prd_end_dt IS NULL;

select * from gold.dim_product;

CREATE VIEW Gold.fact_sales AS
SELECT
	sd.sls_ord_num AS order_number,
	pr.product_key,
	cu.customer_key,
	SD.sls_order_dt AS order_date,
	sd.sls_ship_dt AS shipping_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS sales_amount,
	sd.sls_quantity as quantity,
	sd.sls_price AS price
FROM Silver.crm_sales_details sd
LEFT JOIN Gold.dim_product pr
ON sd.sls_prd_key=pr.product_number
LEFT JOIN Gold.dim_customers cu
ON sd.sls_cust_id=cu.customer_id;

select * from gold.fact_sales;