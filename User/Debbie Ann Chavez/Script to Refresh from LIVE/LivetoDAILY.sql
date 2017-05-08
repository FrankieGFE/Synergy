

/*
 *
 * This script refreshes ST_DAILY on SynSecondDB with backups (integrating the weekly full and
 * dailys.  It then does some "cleanup" prepping the data file for use in 
 * non-production mode!
 */

 -- while performing the restore, we cannot be "focused" at ST_DAILY
 USE master

/* ****************************************************************
 *  Get Latest Full Backup and set the FileName Variable
 * ****************************************************************/

DECLARE @FileName NVARCHAR(255) = NULL
DECLARE @BKFolder VARCHAR(255) = '\\NETAPPFILER2\synergybackups\SynergyDBDC Backups\SYNERGYDBDC\ST_Production\FULL\'  --needs trailing slash or kablooey
DECLARE @BKDiffFolder VARCHAR(255) = '\\NETAPPFILER2\synergybackups\SynergyDBDC Backups\SYNERGYDBDC\ST_Production\DIFF\' --needs trailing slash or kablooey
DECLARE @DayOfWeek INT = 0 
DECLARE @FileList TABLE (
	FileName VARCHAR(255)
	,DepthFlag INT
	,FileFlag INT
)

-- Get Day of Week
SELECT @DayOfWeek = DATEPART(DW,getdate()) - 1 --0=Sunday, 6 = saturday

--get all the files and folders in the backup folder and put them in temporary table
INSERT INTO @FileList exec xp_dirtree @BKFolder,0,1

SELECT TOP 1 @FileName = @BKFolder + FileName FROM @filelist ORDER BY FileName DESC

/* ****************************************************************
 *  Start The restore process
 * ****************************************************************/

-- kick off current users/processes
-- -------------------------------------------------------
PRINT '*** Switching DB into single user'

ALTER DATABASE ST_Daily
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

-- First, Restore the Full (Norecovery if differentials to follow)
-- -------------------------------------------------------
IF @DayOfWeek = 0 
	-- No diffs are needed, so norecovery option is not turned on
	BEGIN
		PRINT '*** Starting Full restore (no diffs)'
		RESTORE DATABASE 
			ST_Daily 
		FROM DISK=@FileName
		WITH 
			MOVE 'ST_Production' TO 'D:\DATABASES\ST_Daily.mdf'
			,MOVE 'ST_Production_log' TO 'L:\LOGS\ST_Daily_log.ldf'
			,REPLACE
	END --endif
ELSE
	-- diffs will be needed, restore with norecovery
	BEGIN
		PRINT '*** Starting Full restore (diffs to follow)'
		RESTORE DATABASE 
			ST_Daily 
		FROM DISK=@FileName
		WITH 
			MOVE 'ST_Production' TO 'D:\DATABASES\ST_Daily.mdf'
			,MOVE 'ST_Production_log' TO 'L:\LOGS\ST_Daily_log.ldf'
			,REPLACE
			,NORECOVERY -- We use Norecovery if there are no differentials to restore.
	END --endelse

IF @DayOfWeek != 0 
BEGIN
	 DELETE FROM @FileList
	 INSERT INTO @FileList exec xp_dirtree @BKDiffFolder,0,1

	-- Set filename to next in line to restore
	SELECT
		@FileName = @BKDiffFolder + FileName
	FROM
	(
		SELECT 
			FileName
			,ROW_NUMBER() OVER (PARTITION BY FileFlag ORDER BY FileName DESC) AS RN
		FROM		
			@FileList
	) AS NumberedList
	WHERE 
		RN = 1

	PRINT '*** Starting Last DIFF restore'
	RESTORE DATABASE 
		ST_Daily 
	FROM DISK=@FileName

END

-- Turning to simple logging ----------------------------
PRINT '*** Turning Off Log File'
ALTER DATABASE [ST_Daily] SET RECOVERY SIMPLE WITH NO_WAIT

PRINT '*** Turning On Multi-User'
--Let people/processes back in!
ALTER DATABASE ST_Daily
SET MULTI_USER WITH ROLLBACK IMMEDIATE;

/* ****************************************************************
 * Any Extras should be done after the restore like:
 * + Restoring certian users rights (sisprog??)
 * + turning off e-mail capability
 * + cleaning out job queue's 
 * ****************************************************************/
USE ST_Daily

-- Createing SISProg Rights
-- -------------------------------------------------------

/*
PRINT '*** Creating USER APS\SISProg'
CREATE USER [APS\SISProg] FOR LOGIN [APS\SISProg] WITH DEFAULT_SCHEMA=[dbo] -- SISProg should not have access to production
EXEC sp_addrolemember 'db_datareader', 'APS\SISProg'; -- adding role data_reader
GRANT CONNECT TO [APS\SISProg]
GRANT EXECUTE TO [APS\SISProg]
GRANT SELECT TO [APS\SISProg]
GRANT VIEW DEFINITION TO [APS\SISProg]

CREATE USER [APS\Max.Janairo] FOR LOGIN [APS\Max.Janairo] WITH DEFAULT_SCHEMA=[dbo] -- SISProg should not have access to production
GRANT CONNECT TO [APS\Max.Janairo]
GRANT EXECUTE TO [APS\Max.Janairo]
GRANT SELECT TO [APS\Max.Janairo]
GRANT VIEW DEFINITION TO [APS\Max.Janairo]

CREATE USER [APS\Josh.Meyer] FOR LOGIN [APS\Josh.Meyer] WITH DEFAULT_SCHEMA=[dbo] -- SISProg should not have access to production
GRANT CONNECT TO [APS\Josh.Meyer]
GRANT EXECUTE TO [APS\Josh.Meyer]
GRANT SELECT TO [APS\Josh.Meyer]
GRANT VIEW DEFINITION TO [APS\Josh.Meyer]

PRINT '*** Creating USER APS\SynAdministratorSPED'
CREATE USER [APS\SynAdministratorSPED] FOR LOGIN [APS\SynAdministratorSPED] WITH DEFAULT_SCHEMA=[dbo] -- SynAdministratorSPED should not have access to production
EXEC sp_addrolemember 'db_datareader', 'APS\SynAdministratorSPED'; -- adding role data_reader
GRANT CONNECT TO [APS\SynAdministratorSPED]
GRANT EXECUTE TO [APS\SynAdministratorSPED]
GRANT SELECT TO [APS\SynAdministratorSPED]
GRANT VIEW DEFINITION TO [APS\SynAdministratorSPED]
*/
--EXEC sp_addrolemember 'db_datawriter', 'APS\Gary.Corbaley'; -- adding role data_reader

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

/* ****************************************************************
 * Finally, Create a backup so the DB can be used to do a DB to DB 
 * restore
 * ****************************************************************/
PRINT '*** Creating Local Backup'
BACKUP DATABASE [ST_DAILY] TO DISK='D:\BACKUPS\MANUAL\ST_DAILY.BAK' WITH FORMAT