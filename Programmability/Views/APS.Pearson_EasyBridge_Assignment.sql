/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 8/24/2015
 *
 * Request By: Andy Gutierrez
 * InitialRequestDate: 08/19/2015
 * 
 * Initial Request: Pull all active courses for Pearson EasyBridge extract
 *
 * Description: 
 * One Record Per course
 *
 * Tables Referenced: 
 */

ALTER VIEW APS.Pearson_EasyBridge_Assignment
AS
 
SELECT DISTINCT	
	REPLACE([STAFF].[BADGE_NUM],'e','') + '-' + CONVERT(VARCHAR,[ENROLLMENT].[SCHOOL_CODE]) + CONVERT(VARCHAR,[SCHEDULE].[SECTION_ID]) + '-' + CONVERT(VARCHAR,[ENROLLMENT].[SCHOOL_YEAR]) AS [native_assignment_code]
	,REPLACE([STAFF].[BADGE_NUM],'e','') AS [staff_code]
	,[ENROLLMENT].[SCHOOL_YEAR] AS [school_year]
	,[ENROLLMENT].[SCHOOL_CODE] AS [institution_code]
	,'2015-08-13' AS [date_start]
	,'2016-05-25' AS [date_end]
	,CASE WHEN [STAFF].[TYPE] = 'TE' THEN 'Teacher' ELSE 'Staff' END AS [position_code]
	
	
FROM
	APS.PrimaryEnrollmentDetailsAsOf('08/11/2016') AS [ENROLLMENT]
	
	INNER JOIN
	APS.ScheduleDetailsAsOf('08/11/2016') AS [SCHEDULE]
	ON
	[ENROLLMENT].[STUDENT_GU] = [SCHEDULE].[STUDENT_GU]
	AND [ENROLLMENT].[ORGANIZATION_YEAR_GU] = [SCHEDULE].[ORGANIZATION_YEAR_GU]
	
	INNER JOIN
	rev.[EPC_STAFF] AS [STAFF]
	ON
	[SCHEDULE].[STAFF_GU] = [STAFF].[STAFF_GU]
	
	INNER JOIN
	rev.[REV_PERSON] AS [STAFF_PERSON]
	ON
	[STAFF].[STAFF_GU] = [STAFF_PERSON].[PERSON_GU]
	
WHERE
	[ENROLLMENT].[GRADE] IN ('06','07','08')
