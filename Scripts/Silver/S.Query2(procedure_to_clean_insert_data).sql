/*purpose:
it creates a procedure that clean and store the data present in Bronze into Silver schema
but before that it truncate the entire schema if any data is present into the Silver schema,
therfore it can be used to refresh the silver schema*/


--===========================--
--CLEANING DATA AND INSERTING--
--===========================--

CREATE PROCEDURE Silver.load_silver AS
BEGIN
	BEGIN TRY

		print'truncating Silver.crm_cust_info';
		TRUNCATE TABLE Silver.crm_cust_info;
        print'iserting data into Silver.crm_cust_info';
		INSERT INTO Silver.crm_cust_info(
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date)
		SELECT 
			cst_id,
			cst_key,
			TRIM(cst_firstname) as cst_firstname,
			TRIM(cst_lastname) AS cst_lastname,
			CASE
				WHEN UPPER(TRIM(cst_marital_status))='S' THEN 'Single'
				WHEN UPPER(TRIM(cst_marital_status))='M' THEN 'Married'
				ELSE 'N/A'
			END cst_marital_status,
			CASE 
				WHEN UPPER(TRIM(cst_gndr))='F' THEN 'Female'
				WHEN UPPER(TRIM(cst_gndr))='M' THEN 'Male'
				ELSE 'N/A'
			END cst_gndr,
			cst_create_date
		FROM 
			(SELECT *,
			ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC ) FLAG
			FROM Bronze.crm_cust_info) T
		WHERE FLAG=1;



        print'truncating Silver.crm_prd_info';
		TRUNCATE TABLE silver.crm_prd_info;
		print'iserting data into silver.crm_prd_info';
		INSERT INTO silver.crm_prd_info(
			prd_id,
			cat_id ,
			prd_key ,
			prd_nm ,
			prd_cost ,
			prd_line ,
			prd_start_dt,
			prd_end_dt)
		SELECT
			prd_id,
			REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,
			SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,
			prd_nm,
			ISNULL(prd_cost,0) AS prd_cost,
			CASE UPPER(TRIM(prd_line))
				WHEN 'M' THEN 'Mountain'
				WHEN 'R' THEN 'Road'
				WHEN 'S' THEN 'Other sales'
				WHEN 'T' THEN 'Touring'
				ELSE 'N/A'
			END AS prd_line,
			prd_start_dt,
			prd_end_dt
		FROM Bronze.crm_prd_info;



		print'truncating silver.crm_sales_details';
		TRUNCATE TABLE Silver.crm_sales_details;
		print'iserting data into silver.crm_sales_details';
		INSERT INTO Silver.crm_sales_details(
			sls_ord_num ,
			sls_prd_key ,
			sls_cust_id ,
			sls_order_dt ,
			sls_ship_dt ,
			sls_due_dt ,
			sls_sales ,
			sls_quantity ,
			sls_price )
		SELECT
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			CASE 
				WHEN sls_order_dt = 0 OR LEN(sls_order_dt) !=8 THEN NULL
				ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
			END AS sls_order_dt,
			CASE 
				WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) !=8 THEN NULL
				ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
			END AS sls_ship_dt,
			CASE 
				WHEN sls_due_dt = 0 OR LEN(sls_due_dt) !=8 THEN NULL
				ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
			END AS sls_due_dt,
			CASE
				WHEN sls_sales IS NULL OR sls_sales <=0 or sls_sales !=sls_quantity * ABS(sls_price)
					THEN sls_quantity * ABS(sls_price)
				ELSE sls_sales
			END sls_sales,
			sls_quantity,
			CASE
				WHEN sls_price IS NULL OR sls_price <=0
					THEN sls_sales/NULLIF(sls_quantity,0)
				ELSE sls_price
			END AS sls_price
		FROM Bronze.crm_sales_details;



		print'truncating silver.erm_CUST_AZ1o';
		TRUNCATE TABLE Silver.erm_CUST_AZ12;
		print'iserting data into silver.erm_CUST_AZ12';
		INSERT INTO Silver.erm_CUST_AZ12(
			CID ,
			BDATE ,
			GEN 
		)
		SELECT 
			CASE 
				WHEN cid LIKE 'NAS%' THEN SUBSTRING(CID,4,LEN(CID))
				ELSE CID
			END AS CID,
				CASE WHEN BDATE > GETDATE() THEN NULL
				ELSE BDATE
			END AS BDATE,
			CASE 
				WHEN UPPER(TRIM (GEN)) IN ('F','FEMALE') THEN 'Female'
				WHEN UPPER(TRIM (GEN)) IN ('M','MALE') THEN 'Male'
				ELSE 'N/A'
			END AS GEN
		FROM Bronze.erm_CUST_AZ12;



		print'truncating silver.erm_LOC_A101';
		TRUNCATE TABLE Silver.erm_LOC_A101;
		print'iserting data into silver.erm_LOC_A101';
		INSERT INTO Silver.erm_LOC_A101(
			CID,
			CNTRY
		)
		SELECT
			REPLACE(CID,'-','') CID,
			CASE
				WHEN TRIM(CNTRY) ='DE' THEN 'Germany'
				WHEN TRIM(CNTRY) IN ('US','USA') THEN 'United States'
				WHEN TRIM(CNTRY) = '' OR CNTRY IS NULL THEN 'N/A'
				ELSE TRIM(CNTRY)
			END AS CNTRY
		FROM Bronze.erm_LOC_A101;



		print'truncating silver.erm_PX_CAT_G1V';
		TRUNCATE TABLE Silver.erm_PX_CAT_G1V2;
		print'iserting data into silver.erm_PX_CAT_G1V2';
		INSERT INTO Silver.erm_PX_CAT_G1V2(
			ID,
			CAT,
			SUBCAT,
			MAINTENANCE
		)
		SELECT
			ID,
			CAT,
			SUBCAT,
			MAINTENANCE
		FROM Bronze.erm_PX_CAT_G1V2



	END TRY
	BEGIN CATCH
        PRINT '-------------------------------------------------';
        print 'Error Occured during loading data';
        print 'Error Message: '+ ERROR_MESSAGE();
        PRINT 'Error Number: '+ CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT '-------------------------------------------------';
	END CATCH
END;

exec Silver.load_silver