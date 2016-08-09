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
 --ALTER VIEW
 --APS.Pearson_EasyBridge_Staff
 --AS
 
SELECT DISTINCT	
	REPLACE([STAFF].[BADGE_NUM],'e','') + '-' + CONVERT(VARCHAR,[ENROLLMENT].[SCHOOL_CODE]) + CONVERT(VARCHAR,[SCHEDULE].[SECTION_ID]) AS [section_teacher_code]
	,REPLACE([STAFF].[BADGE_NUM],'e','') AS [staff_code]
	,CONVERT(VARCHAR,[ENROLLMENT].[SCHOOL_CODE]) + CONVERT(VARCHAR,[SCHEDULE].[SECTION_ID]) AS [native_section_code]
	,[TERMDATES].[TermBegin] AS [date_start]
	,[TERMDATES].[TermEnd] AS [date_end]
	,[ENROLLMENT].[SCHOOL_YEAR] AS [school_year]
	,CASE WHEN [SCHEDULE].[PRIMARY_STAFF] = '1' THEN 'true' ELSE 'false' END AS [teacher_of_record]
	,CASE WHEN [SCHEDULE].[PRIMARY_STAFF] = '1' THEN 'Teacher' ELSE 'Co-teacher' END AS [teaching_assignment]
	
	--,[SCHEDULE].*
	
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
	
	LEFT OUTER JOIN
	(
	SELECT
		[TERMDATES].[OrgYearGU]
		,[TERMDATES].[TermCode]
		,CONVERT(VARCHAR(10),MIN([TERMDATES].[TermBegin]),126) AS [TermBegin]
		,CONVERT(VARCHAR(10),MAX([TERMDATES].[TermEnd]),126) AS [TermEnd]
	FROM
		APS.TermDates() AS [TERMDATES]
		
	GROUP BY
		[TERMDATES].[OrgYearGU]
		,[TERMDATES].[TermCode]
	) AS [TERMDATES]
	ON
	[SCHEDULE].[ORGANIZATION_YEAR_GU] = [TERMDATES].[OrgYearGU]
	AND [SCHEDULE].[TERM_CODE] = [TERMDATES].[TermCode]
	
WHERE
	[ENROLLMENT].[GRADE] IN ('06','07','08')
	AND [SCHEDULE].[PRIMARY_STAFF] = '1'