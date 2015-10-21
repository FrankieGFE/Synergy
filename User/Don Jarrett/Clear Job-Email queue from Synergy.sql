--Clearing Job Queue
-- -------------------------------------------------------
PRINT '*** Clearing Job Queue'
BEGIN TRANSACTION
	-- Remove foreign constraint so we can use the faster truncate process
	ALTER TABLE [rev].[REV_PROCESS_QUEUE_RESULT] DROP [REV_PROCESS_QUEUE_RESULT_F1]

	TRUNCATE TABLE rev.REV_PROCESS_QUEUE_RESULT
	TRUNCATE TABLE rev.REV_PROCESS_QUEUE
--	DELETE FROM rev.REV_PROCESS_QUEUE -- HAVE to delete because truncate does not work with tables with constraints


	--readd the constraint
	ALTER TABLE [rev].[REV_PROCESS_QUEUE_RESULT]  WITH CHECK ADD  CONSTRAINT [REV_PROCESS_QUEUE_RESULT_F1] FOREIGN KEY([PROCESS_QUEUE_GU])
	REFERENCES [rev].[REV_PROCESS_QUEUE] ([PROCESS_QUEUE_GU])
	ON UPDATE CASCADE
	ON DELETE CASCADE

	ALTER TABLE [rev].[REV_PROCESS_QUEUE_RESULT] CHECK CONSTRAINT [REV_PROCESS_QUEUE_RESULT_F1]
COMMIT

--remove items in the e-mail queue
-- -------------------------------------------------------
PRINT '*** Removing E-mail Queue'
DELETE FROM 
	rev.REV_EMAIL_QUEUE

DELETE FROM 
	rev.REV_EMAIL

--Turning off e-mail capabilities
-- -------------------------------------------------------
PRINT '*** Turning off e-mail capabilities'
DECLARE @XMLData XML

--Populate the XML variable with the appropriate contents form the settings table
SELECT			
	@XMLData= CONVERT(XML, [VALUE])
FROM
	rev.rev_application
WHERE
	[KEY] = 'REV_INSTALL_CONSTANT'

-- Code if you want to see the value
--SELECT @XMLData.value('(/ROOT/SYSTEM_TOGGLE/@EMAIL_ENABLED)[1]','VARCHAR(3)')

-- modify the email_enabled attribute 
SET @XMLData.modify('
  replace value of (/ROOT/SYSTEM_TOGGLE/@EMAIL_ENABLED)[1]
  with     "OFF"
')

-- Update the entire XML
UPDATE
	rev.REV_APPLICATION
SET
	[VALUE] = CONVERT(NVARCHAR(MAX), @XMLData)
WHERE
	[KEY] = 'REV_INSTALL_CONSTANT'