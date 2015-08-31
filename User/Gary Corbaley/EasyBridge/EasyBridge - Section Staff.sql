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
	REPLACE([STAFF].[BADGE_NUM],'e','') + '-' + CONVERT(VARCHAR,[ENROLLMENT].[SCHOOL_CODE]) + CONVERT(VARCHAR,[SCHEDULE].[SECTION_ID]) AS [section_teacher_code]
	,REPLACE([STAFF].[BADGE_NUM],'e','') AS [staff_code]
	,CONVERT(VARCHAR,[ENROLLMENT].[SCHOOL_CODE]) + CONVERT(VARCHAR,[SCHEDULE].[SECTION_ID]) AS [native_section_code]
	,'2015-08-13' AS [date_start]
	,'' AS [date_end]
	,[ENROLLMENT].[SCHOOL_YEAR] AS [school_year]
	,CASE WHEN [SCHEDULE].[PRIMARY_STAFF] = '1' THEN 'true' ELSE 'false' END AS [teacher_of_record]
	,CASE WHEN [SCHEDULE].[PRIMARY_STAFF] = '1' THEN 'Teacher' ELSE 'Co-teacher' END AS [teaching_assignment]
	
FROM
	APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS [ENROLLMENT]
	
	INNER JOIN
	APS.ScheduleDetailsAsOf(GETDATE()) AS [SCHEDULE]
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