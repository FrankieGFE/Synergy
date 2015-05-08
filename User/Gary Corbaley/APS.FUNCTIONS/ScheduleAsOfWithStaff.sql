/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 05/08/2015 $
 *
 * Request By: Andy Gutierrez
 * InitialRequestDate: 05/08/2015
 * 
 * This script will pull detail schedule information for all active students in the system
 * One Record Per Student Per Course
 */ 
 
 
-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[SchedulesAsOfWithStaff]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.SchedulesAsOfWithStaff() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

ALTER FUNCTION APS.SchedulesAsOfWithStaff(@AsOfDate DATE)
RETURNS TABLE
AS
RETURN
 SELECT
	[SCHEDULE].*
	,[COURSE].[DUAL_CREDIT]
	,[COURSE].[OTHER_PROVIDER_NAME]
	,[STAFF_PERSON].[FIRST_NAME] +' '+ [STAFF_PERSON].[LAST_NAME] AS [TEACHER NAME]	
	,[ALL_STAFF_SCH_YR].[PRIMARY_STAFF]
	
FROM	
	APS.ScheduleAsOf(@AsOfDate) AS [SCHEDULE]
	
	INNER JOIN
	rev.EPC_CRS AS [COURSE]
	ON
	[SCHEDULE].[COURSE_GU] = [COURSE].[COURSE_GU]
	
	-- Get both primary and secodary staff
	INNER JOIN
	(
	SELECT
		[STAFF_SCHOOL_YEAR_GU]
		,[STAFF_GU]
		,[ORGANIZATION_YEAR_GU]
		,1 AS [PRIMARY_STAFF]
	FROM
		rev.[EPC_STAFF_SCH_YR] AS [STAFF_SCHOOL_YEAR]
		
	UNION ALL
		
	SELECT
		[STAFF_SCHOOL_YEAR].[STAFF_SCHOOL_YEAR_GU]
		,[STAFF_SCHOOL_YEAR].[STAFF_GU]
		,[STAFF_SCHOOL_YEAR].[ORGANIZATION_YEAR_GU]
		,0 AS [PRIMARY_STAFF]
	FROM
		rev.[EPC_SCH_YR_SECT_STF] AS [SECONDARY_STAFF]
		
		INNER JOIN
		rev.[EPC_STAFF_SCH_YR] AS [STAFF_SCHOOL_YEAR]
		ON
		[SECONDARY_STAFF].[STAFF_SCHOOL_YEAR_GU] = [STAFF_SCHOOL_YEAR].[STAFF_SCHOOL_YEAR_GU]
	) AS [ALL_STAFF_SCH_YR]
	ON
   [SCHEDULE].[STAFF_SCHOOL_YEAR_GU] = [ALL_STAFF_SCH_YR].[STAFF_SCHOOL_YEAR_GU]
   
	INNER JOIN
	rev.[EPC_STAFF] AS [STAFF]
	ON
	[ALL_STAFF_SCH_YR].[STAFF_GU] = [STAFF].[STAFF_GU]

	INNER JOIN
	rev.[REV_PERSON] AS [STAFF_PERSON]
	ON
	[STAFF].[STAFF_GU] = [STAFF_PERSON].[PERSON_GU]