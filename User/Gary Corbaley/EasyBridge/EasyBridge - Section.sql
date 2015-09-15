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
	CONVERT(VARCHAR,[ENROLLMENT].[SCHOOL_CODE]) + CONVERT(VARCHAR,[SCHEDULE].[SECTION_ID]) AS [native_section_code]
	,[ENROLLMENT].[SCHOOL_CODE] AS [school_code]
	,'' AS [section_type]
	,'' AS [section_type_description]
	,[TERMDATES].[TermBegin] AS [date_start]
	,[TERMDATES].[TermEnd] AS [date_end]
	,[ENROLLMENT].[SCHOOL_YEAR] AS [school_year]
	,[SCHEDULE].[COURSE_ID] AS [course_number]
	,[SCHEDULE].[COURSE_TITLE] AS [course_name]
	,[SCHEDULE].[SECTION_ID] AS [section_name]
	,[SCHEDULE].[SECTION_ID] AS [section_number]
	
FROM
	APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS [ENROLLMENT]
	
	INNER JOIN
	APS.ScheduleDetailsAsOf(GETDATE()) AS [SCHEDULE]
	ON
	[ENROLLMENT].[STUDENT_GU] = [SCHEDULE].[STUDENT_GU]
	AND [ENROLLMENT].[ORGANIZATION_YEAR_GU] = [SCHEDULE].[ORGANIZATION_YEAR_GU]
	
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
	AND [SCHEDULE].[COURSE_TITLE] NOT LIKE '%AIDE%'