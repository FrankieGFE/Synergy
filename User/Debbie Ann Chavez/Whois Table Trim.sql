--WHOIS TABLE TRIM

-- 20151002 rtt The Whois tables will contine to take up disk space if left unchecked.  
--  This script will trim the tables if they get @daystodelete 

USE [ST_UTILS]
GO

DECLARE
	-- ops
	-- set to 0 for COMMIT 1 = no commit (ROLLBACK) 
   @DebugOn INT = 0
   
   BEGIN TRANSACTION

		--SELECT name AS object_name 
		--  ,SCHEMA_NAME(schema_id) AS schema_name
		--  ,type_desc
		--  ,create_date
		--  ,modify_date
		--FROM sys.objects
		--WHERE create_date < GETDATE() - 60
		--	  and name like 'WhoIsActive%'
		--ORDER BY create_date;
		

		Declare @daystodelete int = 60
		DECLARE @tname VARCHAR(100)
		DECLARE @sql VARCHAR(max)

		DECLARE db_cursor CURSOR FOR 
		SELECT name AS tname
		FROM sys.objects
		WHERE create_date < GETDATE() - @daystodelete
			  and name like 'WhoIsActive%'
		ORDER BY create_date;

		OPEN db_cursor  
		FETCH NEXT FROM db_cursor INTO @tname  

		WHILE @@FETCH_STATUS = 0  
		BEGIN  
			   SET @sql = 'DROP TABLE ' + @tname
			   EXEC (@sql)
			   PRINT @sql

			   FETCH NEXT FROM db_cursor INTO @tname  
		END  

		CLOSE db_cursor  
		DEALLOCATE db_cursor

   
   IF @DebugOn = 0 COMMIT
ELSE ROLLBACK