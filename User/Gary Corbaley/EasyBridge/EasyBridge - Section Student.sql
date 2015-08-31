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
 
 
SELECT DISTINCT
	CONVERT(VARCHAR,[STUDENT].[SIS_NUMBER]) + '-' + CONVERT(VARCHAR,[ENROLLMENT].[SCHOOL_CODE]) + CONVERT(VARCHAR,[SCHEDULE].[SECTION_ID]) AS [section_student_code]
	,[STUDENT].[SIS_NUMBER] AS [student_code]
	,CONVERT(VARCHAR,[ENROLLMENT].[SCHOOL_CODE]) + CONVERT(VARCHAR,[SCHEDULE].[SECTION_ID]) AS [native_section_code]
	,'2015-08-13' AS [date_start]
	,'' AS [date_end]
	,[ENROLLMENT].[SCHOOL_YEAR] AS [school_year]
	
FROM
	APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS [ENROLLMENT]
	
	INNER JOIN
	APS.ScheduleDetailsAsOf(GETDATE()) AS [SCHEDULE]
	ON
	[ENROLLMENT].[STUDENT_GU] = [SCHEDULE].[STUDENT_GU]
	AND [ENROLLMENT].[ORGANIZATION_YEAR_GU] = [SCHEDULE].[ORGANIZATION_YEAR_GU]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[ENROLLMENT].[STUDENT_GU] = [STUDENT].[STUDENT_GU]