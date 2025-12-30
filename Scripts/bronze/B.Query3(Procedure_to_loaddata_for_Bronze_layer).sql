/*purpose:
creating a procedure that insert the bulk data from sources into tables and also reload data if it already exists.
by runnig this procedure It loads the data present in the csv file present in a perticular file by using pth of all the file we can load all the files in the
tables of bronze schema but before that if there exixst any table specified it will truncate it
*/

CREATE OR ALTER PROCEDURE Bronze_load
AS
BEGIN
    BEGIN TRY
        --===============================--
        --Bulk Inserting data into tables--
        --===============================--
        print'truncating bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;
        print'iserting data into bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\Sandhya\Desktop\data warehouse project\Sources\source_crm\cust_info.csv'
        WITH (
	        FIRSTROW=2,
	        FIELDTERMINATOR =',',
	        TABLOCK
        );
 
        print'truncating bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;
        SET DATEFORMAT dmy;  -- for dd-mm-yyyy
        print'iserting data into bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\Sandhya\Desktop\data warehouse project\Sources\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            KEEPNULLS,
            TABLOCK
        );
    
        print'truncating bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;
        print'iserting data into bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\Sandhya\Desktop\data warehouse project\Sources\source_crm\sales_details.csv'
        WITH (
	        FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            KEEPNULLS,
            TABLOCK
        );
 
        print'truncating bronze.erm_CUST_AZ1o';
        TRUNCATE TABLE bronze.erm_CUST_AZ12;
        print'iserting data into bronze.erm_CUST_AZ12';
        BULK INSERT bronze.erm_CUST_AZ12
        FROM 'C:\Users\Sandhya\Desktop\data warehouse project\Sources\source_erp\CUST_AZ12.csv'
        WITH (
	        FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            KEEPNULLS,
            TABLOCK
        );
   
        print'truncating bronze.erm_PX_CAT_G1V';
        TRUNCATE TABLE bronze.erm_PX_CAT_G1V2;
        print'iserting data into bronze.erm_PX_CAT_G1V2';
        BULK INSERT bronze.erm_PX_CAT_G1V2
        FROM 'C:\Users\Sandhya\Desktop\data warehouse project\Sources\source_erp\PX_CAT_G1V2.csv'
        WITH (
	        FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            KEEPNULLS,
            TABLOCK
        );
  
        print'truncating bronze.erm_LOC_A101';
        TRUNCATE TABLE bronze.erm_LOC_A101;
        print'iserting data into bronze.erm_LOC_A101';
        BULK INSERT bronze.erm_LOC_A101
        FROM 'C:\Users\Sandhya\Desktop\data warehouse project\Sources\source_erp\LOC_A101.csv'
        WITH (
	        FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            KEEPNULLS,
            TABLOCK
        );
    END TRY
    BEGIN CATCH
        PRINT '-------------------------------------------------';
        print 'Error Occured during loading data';
        print 'Error Message: '+ ERROR_MESSAGE();
        PRINT 'Error Number: '+ CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT '-------------------------------------------------';
    END CATCH
END;

EXEC Bronze_load;