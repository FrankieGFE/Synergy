/*
*****************************************************************************************************************
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
DON'T RUN THIS ON A PRODUCTION DATABASE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 
*****************************************************************************************************************
20121120 mrr clean up, comment and deploy coding standard
20142401 rtt added wrapper to check for DB name like Production
20160331 rtt updated to add REV_WEB_FARM_SERVER and to Support Post 10.03 Audit Trail Table names

*/

-- @Debug = 0 causes COMMIT anything else ROLLBACK
DECLARE @DebugOn INT = 0
, @RvTrcSQLAlter INT = 0, @PrntPXPEmailUpdated INT = 0, @RPSSANUpdated INT = 0, @RPPhnUpdated INT = 0
, @RPEmailUpdated INT = 0, @REmailUpdated INT = 0, @RPPriPhnUpdated INT = 0, @LastNameChanges INT = 0
, @FirstNameChanges INT = 0, @RPCompKeysUpdated INT = 0, @dbname nvarchar (100)

-- Lets make sure that we are not running on production database
SET @dbname =(SELECT DB_NAME() AS DataBaseName)

IF @dbname not like '%Prod%'

BEGIN

	PRINT 'This does not appear to be a Production Database Process will continue '  + @dbname

		BEGIN TRANSACTION

			TRUNCATE TABLE rev.EPC_GBW_SCHL_YR_WS_LOG
			TRUNCATE TABLE rev.REV_DATASET_FILTER
			TRUNCATE TABLE rev.REV_AUDIT_TRAIL_PROP_HIS
			TRUNCATE TABLE rev.REV_PROCESS_QUEUE_RESULT
			TRUNCATE TABLE rev.REV_TRACE_SQL
			TRUNCATE TABLE rev.REV_PERSON_PHOTO
			TRUNCATE TABLE rev.REV_EMAIL_QUEUE
			TRUNCATE TABLE rev.REV_ERROR
			TRUNCATE TABLE rev.REV_WEB_FARM_SERVER

			IF  EXISTS 
				(
				SELECT * 
				FROM sys.foreign_keys 
				WHERE object_id = OBJECT_ID(N'rev.REV_AUDIT_TRAIL_PROP_F1') 
					AND parent_object_id = OBJECT_ID(N'rev.REV_AUDIT_TRAIL_PROP_HIS')
				)
				BEGIN
				ALTER TABLE rev.REV_AUDIT_TRAIL_PROP_HIS DROP CONSTRAINT REV_AUDIT_TRAIL_PROP_F1
			END

			IF  EXISTS
				(
				SELECT * FROM sys.foreign_keys 
				WHERE object_id = OBJECT_ID(N'rev.REV_PROCESS_QUEUE_RESULT_F1') 
					AND parent_object_id = OBJECT_ID(N'rev.REV_PROCESS_QUEUE_RESULT')
				)
				BEGIN
				ALTER TABLE rev.REV_PROCESS_QUEUE_RESULT DROP CONSTRAINT REV_PROCESS_QUEUE_RESULT_F1
			END

			IF  EXISTS 
				(
				SELECT * 
				FROM sys.foreign_keys 
				WHERE object_id = OBJECT_ID
					(N'rev.REV_TRACE_SQL_F1') 
				AND parent_object_id = OBJECT_ID(N'rev.REV_TRACE_SQL')
				)
				BEGIN
				ALTER TABLE rev.REV_TRACE_SQL DROP CONSTRAINT REV_TRACE_SQL_F1
			END

			TRUNCATE TABLE rev.REV_AUDIT_TRAIL_HIS
			TRUNCATE TABLE rev.REV_PROCESS_QUEUE
			TRUNCATE TABLE rev.REV_TRACE

			ALTER TABLE rev.REV_AUDIT_TRAIL_PROP_HIS  
				WITH CHECK ADD  CONSTRAINT REV_AUDIT_TRAIL_PROP_F1 
				FOREIGN KEY(AUDIT_TRAIL_GU)
				REFERENCES rev.REV_AUDIT_TRAIL_HIS (AUDIT_TRAIL_GU)
				ON UPDATE CASCADE
				ON DELETE CASCADE

			ALTER TABLE rev.REV_PROCESS_QUEUE_RESULT  
				WITH CHECK ADD  CONSTRAINT REV_PROCESS_QUEUE_RESULT_F1 FOREIGN KEY(PROCESS_QUEUE_GU)
				REFERENCES rev.REV_PROCESS_QUEUE (PROCESS_QUEUE_GU)
				ON UPDATE CASCADE
				ON DELETE CASCADE

			ALTER TABLE rev.REV_TRACE_SQL  
				WITH CHECK ADD  CONSTRAINT REV_TRACE_SQL_F1 FOREIGN KEY(TRACE_GU)
				REFERENCES rev.REV_TRACE (TRACE_GU)
				ON UPDATE CASCADE
				ON DELETE CASCADE

			ALTER TABLE rev.REV_AUDIT_TRAIL_PROP_HIS 
				CHECK CONSTRAINT REV_AUDIT_TRAIL_PROP_F1
				
			ALTER TABLE rev.REV_PROCESS_QUEUE_RESULT 
				CHECK CONSTRAINT REV_PROCESS_QUEUE_RESULT_F1
				
			ALTER TABLE rev.REV_TRACE_SQL 
				CHECK CONSTRAINT REV_TRACE_SQL_F1
			SET @RvTrcSQLAlter = @@ROWCOUNT


			UPDATE rev.EPC_PARENT_PXP
			SET 	EMAIL_1 = 'email@edupoint.com', 
					EMAIL_2 = 'email@edupoint.com', 
					EMAIL_3 = 'email@edupoint.com', 
					EMAIL_4 = 'email@edupoint.com', 
					EMAIL_5 = 'email@edupoint.com'
			SET @PrntPXPEmailUpdated = @@ROWCOUNT

					
			UPDATE rev.REV_PERSON 
			SET SOCIAL_SECURITY_NUMBER = '123456789' 
			WHERE SOCIAL_SECURITY_NUMBER is not null
			SET @RPSSANUpdated = @@ROWCOUNT
			
			UPDATE rev.REV_PERSON_PHONE 
			SET PHONE = SUBSTRING(PHONE,1,3) + '5551234' 
			WHERE LEN(PHONE) = 10
			SET @RPPhnUpdated = @RPPhnUpdated + @@ROWCOUNT
			
			UPDATE rev.REV_PERSON_PHONE 
			SET PHONE = '5551234' 
			WHERE LEN(PHONE) <> 10
			SET @RPPhnUpdated = @RPPhnUpdated + @@ROWCOUNT
			
			UPDATE rev.REV_PERSON 
			SET PRIMARY_PHONE = SUBSTRING(PRIMARY_PHONE,1,3) + '5551234' 
			WHERE LEN(PRIMARY_PHONE) = 10
			SET @RPPriPhnUpdated = @RPPriPhnUpdated + @@ROWCOUNT
			
			UPDATE rev.REV_PERSON 
			SET PRIMARY_PHONE = '5551234' 
			WHERE LEN(PRIMARY_PHONE) <> 10
			SET @RPPriPhnUpdated = @RPPriPhnUpdated + @@ROWCOUNT

			UPDATE rev.REV_PERSON 
			SET EMAIL = 'email@edupoint.com'
			SET @RPEmailUpdated = @@ROWCOUNT
			
			UPDATE rev.REV_EMAIL 
			SET TO_ADDRESS = 'email@edupoint.com', 
				FROM_ADDRESS = 'email@edupoint.com'
			SET @REmailUpdated = @@ROWCOUNT
			
		-- handle all other states of @DebugOn with a rollback..... preventleaving the transaction open 
		IF @DebugOn = 0 COMMIT
		ELSE ROLLBACK

		PRINT ''
		PRINT 	'ParentPXP Updated: ' + CAST(@PrntPXPEmailUpdated AS VARCHAR(6))	 + 	'.'
		PRINT 	'SSAN Updated: ' + CAST(@RPSSANUpdated AS VARCHAR(6))	 + 	'.'
		PRINT 	'Phone # Updated: '	+ CAST(@RPPhnUpdated AS VARCHAR(6))	 + 	'.'
		PRINT 	'Primary Phone # Updated: ' + CAST(@RPPriPhnUpdated AS VARCHAR(6))	 + 	'.'
		PRINT 	'Person Email Updated: ' + CAST(@RPEmailUpdated AS VARCHAR(6))	 + 	'.'
		PRINT 	'RevEmail Updated: ' + CAST(@REmailUpdated AS VARCHAR(6))	 + 	'.'
	END
		
ELSE
	
	PRINT 'This was a Production Database so the DBCleanse was skipped ' + @dbname

