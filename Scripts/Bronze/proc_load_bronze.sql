create or alter procedure bronze.load_bronze as
begin
    declare @start_time datetime , @end_time datetime , @batch_start_time datetime , @batch_end_time datetime
    set @batch_start_time = getdate()
    begin try
        print '====================================';
        print 'Loading Bronze Layer';
        print '====================================';

        print '------------------------------------';
        print 'Loading CRM Tables';
        print '-------------------------------------';


        --truncate then bulk insert
        set @start_time = getdate()
        Truncate table bronze.crm_cust_info;

        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\Gaurav\Desktop\Udemy SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,             -- Skip header
            FIELDTERMINATOR = ',',    -- Comma separated
            ROWTERMINATOR = '\n',     -- New line
            CODEPAGE = '65001',       -- UTF-8 encoding
            TABLOCK
        );
        set @end_time = getdate()
        print'================================================================================================'
        print ' >>> Load Duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'Seconds' ;
        print'================================================================================================'


         set @start_time = getdate()
        Truncate table bronze.crm_prd_info;

        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\Gaurav\Desktop\Udemy SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,             -- Skip header
            FIELDTERMINATOR = ',',    -- Comma separated
            ROWTERMINATOR = '\n',     -- New line
            CODEPAGE = '65001',       -- UTF-8 encoding
            TABLOCK
        );
         set @end_time = getdate()
        print'================================================================================================'
        print ' >>> Load Duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'Seconds' ;
        print'================================================================================================'




         set @start_time = getdate()
        Truncate table bronze.crm_sales_details;

        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\Gaurav\Desktop\Udemy SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,             -- Skip header
            FIELDTERMINATOR = ',',    -- Comma separated
            ROWTERMINATOR = '\n',     -- New line
            CODEPAGE = '65001',       -- UTF-8 encoding
            TABLOCK
        );
          set @end_time = getdate()
        print'================================================================================================'
        print ' >>> Load Duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'Seconds' ;
        print'================================================================================================'


        print '-----------------------------------';
        print 'Loading ERP Tables';
        print '-----------------------------------';

         set @start_time = getdate()
        Truncate table bronze.erp_cust_az12;

        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\Gaurav\Desktop\Udemy SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,             -- Skip header
            FIELDTERMINATOR = ',',    -- Comma separated
            ROWTERMINATOR = '\n',     -- New line
            CODEPAGE = '65001',       -- UTF-8 encoding
            TABLOCK
        );
         set @end_time = getdate()
        print'================================================================================================'
        print ' >>> Load Duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'Seconds' ;
        print'================================================================================================'


         set @start_time = getdate()
        Truncate table bronze.erp_cust_az12;

        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\Gaurav\Desktop\Udemy SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,             -- Skip header
            FIELDTERMINATOR = ',',    -- Comma separated
            ROWTERMINATOR = '\n',     -- New line
            CODEPAGE = '65001',       -- UTF-8 encoding
            TABLOCK
        );
        set @end_time = getdate()
        print'================================================================================================'
        print ' >>> Load Duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'Seconds' ;
        print'================================================================================================'


         set @start_time = getdate()
        Truncate table bronze.erp_cust_az12;

        BULK INSERT bronze.erp_px_cat_giv2
        FROM 'C:\Users\Gaurav\Desktop\Udemy SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,             -- Skip header
            FIELDTERMINATOR = ',',    -- Comma separated
            ROWTERMINATOR = '\n',     -- New line
            CODEPAGE = '65001',       -- UTF-8 encoding
            TABLOCK
        );
        set @end_time = getdate()
        print'================================================================================================'
        print ' >>> Load Duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'Seconds' ;
        print'================================================================================================'
    set @batch_end_time= getdate()
    print 'Bronze layer loaded'
    print '>>>Loading time :' + cast(datediff(second , @batch_start_time , @batch_end_time ) as nvarchar) + 'seconds'
    End try
    begin catch
        print '============================================';
        print 'Error occured during loading brinze layer';
        print 'Error Message' + ERROR_MESSAGE();
        PRINT 'ERROR MESSAGE' + CAST(ERROR_NUMBER()AS NVARCHAR);
        print '=============================================';
    end catch
    

END
