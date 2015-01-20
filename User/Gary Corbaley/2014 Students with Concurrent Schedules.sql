
;WITH
-- From School of Record [EPC_STU_YR]
ASOF_ENROLLMENTS AS
(
SELECT
	[StudentSchoolYear].[STUDENT_GU]
	,[StudentSchoolYear].[ORGANIZATION_YEAR_GU]
	,[Organization].[ORGANIZATION_GU]
	,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
	,[School].[SCHOOL_CODE]
	,[Organization].[ORGANIZATION_NAME] AS [SCHOOL]
	,[StudentSchoolYear].[ENTER_DATE]
	,[StudentSchoolYear].[LEAVE_DATE]
	,[StudentSchoolYear].[EXCLUDE_ADA_ADM]
	,[OrgYear].[YEAR_GU]
	,[RevYear].[SCHOOL_YEAR]
	,[RevYear].[EXTENSION]
FROM
	APS.PrimaryEnrollmentsAsOf(GETDATE()) AS [Enrollments]
	
	INNER JOIN
	rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
	ON
	[Enrollments].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
	
	INNER JOIN 
	rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
	ON 
	[StudentSchoolYear].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
	
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	INNER JOIN 
	rev.REV_YEAR AS [RevYear] -- Contains the School Year
	ON 
	[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
	
	LEFT OUTER JOIN
	APS.LookupTable('K12','Grade') AS [Grades]
	ON
	[StudentSchoolYear].[GRADE] = [Grades].[VALUE_CODE]
	
	INNER JOIN 
	rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
)

-----------------------------------------------------------------------------

SELECT
	[ENROLLMENTS].[SCHOOL] AS [SOR_NAME]
	,[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[ENROLLMENTS].[GRADE]
	,[Concurrent_Organization].[ORGANIZATION_NAME] AS [Concurrent School Name]
	,[SCHEDULES].[COURSE_TITLE]
	,[SCHEDULES].[COURSE_ID]
	,[SCHEDULES].[SECTION_ID]
	,[SCHEDULES].[TERM_CODE]
	
	,[CONCURRENT_STUDENTS].*
FROM
	-- Get enrollment details
	ASOF_ENROLLMENTS AS [ENROLLMENTS]
	
	-- Get students with more then 1 active enrollment
	INNER JOIN
	(
	SELECT
		[Enroll].*
		,ROW_NUMBER() OVER (PARTITION BY [Enroll].[STUDENT_GU] ORDER BY [Enroll].[ENTER_DATE]) [RN]
	FROM
		APS.EnrollmentsAsOf(GETDATE()) AS [Enroll]
	) AS [CONCURRENT_STUDENTS]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [CONCURRENT_STUDENTS].[STUDENT_GU]
	AND [CONCURRENT_STUDENTS].[RN] = 2
	
	-- Get student details
	INNER JOIN
	APS.BasicStudent as [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	-- Get student schedules
	-- This date set in the future in order to aquire second semester courses.
	LEFT OUTER JOIN	
	APS.ScheduleAsOf('03/01/15') AS [SCHEDULES]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [SCHEDULES].[STUDENT_GU]
	--AND [ENROLLMENTS].[YEAR_GU] = [SCHEDULES].[YEAR_GU]
	AND [ENROLLMENTS].[ORGANIZATION_GU] != [SCHEDULES].[ORGANIZATION_GU]
	
	-- Get concurrent school details
	LEFT OUTER JOIN
	rev.REV_ORGANIZATION AS [Concurrent_Organization] -- Contains the School Name
	ON 
	[SCHEDULES].[ORGANIZATION_GU] = [Concurrent_Organization].[ORGANIZATION_GU]
	
--WHERE
--	[STUDENT].[SIS_NUMBER] = '100017011' --'103461919'
	
	

--SELECT TOP 100
--	*
--FROM
--	APS.BasicSchedule