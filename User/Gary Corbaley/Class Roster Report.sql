
;WITH
DROPPED_CLASSES
AS
(
SELECT DISTINCT
	[SCHEDULE].[STUDENT_GU]
	,[SCHEDULE].[STUDENT_SCHOOL_YEAR_GU]
	,[COURSE].[COURSE_ID]
	,[COURSE].[COURSE_TITLE]
	,[SCHEDULE].[SECTION_ID]
	,[COURSE].[DEPARTMENT]
	,[SCHEDULE].[COURSE_ENTER_DATE]
	,[SCHEDULE].[COURSE_LEAVE_DATE]
	,[SCHEDULE].[TERM_CODE]
	,[TERMDATES].[TermEnd]
	,[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,[ENROLLMENTS].[GRADE]
	,[SCHEDULE].[YEAR_GU]
	,[SCHEDULE].[ORGANIZATION_YEAR_GU]
FROM
	APS.BasicSchedule AS [SCHEDULE]
	
	INNER JOIN 
	rev.REV_YEAR AS [RevYear] -- Contains the School Year
	ON 
	[SCHEDULE].[YEAR_GU] = [RevYear].[YEAR_GU]
	
	INNER JOIN
	rev.EPC_CRS AS [COURSE]
	ON
	[SCHEDULE].[COURSE_GU] = [COURSE].[COURSE_GU]
	
	INNER JOIN
	APS.TermDates() AS [TERMDATES]
	ON
	[SCHEDULE].[YEAR_GU] = [TERMDATES].[YEAR_GU]
	AND [SCHEDULE].[ORGANIZATION_GU] = [TERMDATES].[ORGANIZATION_GU]
	AND [SCHEDULE].[TERM_CODE] = [TERMDATES].[TermCode]
	
	INNER JOIN
	APS.StudentEnrollmentDetails AS [ENROLLMENTS]
	ON
	[SCHEDULE].[STUDENT_SCHOOL_YEAR_GU] = [ENROLLMENTS].[STUDENT_SCHOOL_YEAR_GU]
	
WHERE
	[RevYear].[SCHOOL_YEAR] = '2015'
	AND [RevYear].[EXTENSION] = 'R'
	AND [SCHEDULE].[COURSE_LEAVE_DATE] IS NOT NULL
	AND [SCHEDULE].[COURSE_LEAVE_DATE] < [TERMDATES].[TermEnd]
),

OPEN_CLASSES
AS
(
SELECT DISTINCT
	[SCHEDULE].[STUDENT_GU]
	,[SCHEDULE].[STUDENT_SCHOOL_YEAR_GU]
	,[COURSE].[COURSE_ID]
	,[COURSE].[COURSE_TITLE]
	,[SCHEDULE].[SECTION_ID]
	,[COURSE].[DEPARTMENT]
	,[SCHEDULE].[COURSE_ENTER_DATE]
	,[SCHEDULE].[COURSE_LEAVE_DATE]
	,[SCHEDULE].[TERM_CODE]
	,[TERMDATES].[TermEnd]
	,[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,[ENROLLMENTS].[GRADE]
	,[SCHEDULE].[YEAR_GU]
	,[SCHEDULE].[ORGANIZATION_YEAR_GU]
FROM
	APS.BasicSchedule AS [SCHEDULE]
	
	INNER JOIN 
	rev.REV_YEAR AS [RevYear] -- Contains the School Year
	ON 
	[SCHEDULE].[YEAR_GU] = [RevYear].[YEAR_GU]
	
	INNER JOIN
	rev.EPC_CRS AS [COURSE]
	ON
	[SCHEDULE].[COURSE_GU] = [COURSE].[COURSE_GU]
	
	INNER JOIN
	APS.TermDates() AS [TERMDATES]
	ON
	[SCHEDULE].[YEAR_GU] = [TERMDATES].[YEAR_GU]
	AND [SCHEDULE].[ORGANIZATION_GU] = [TERMDATES].[ORGANIZATION_GU]
	AND [SCHEDULE].[TERM_CODE] = [TERMDATES].[TermCode]
	
	INNER JOIN
	APS.StudentEnrollmentDetails AS [ENROLLMENTS]
	ON
	[SCHEDULE].[STUDENT_SCHOOL_YEAR_GU] = [ENROLLMENTS].[STUDENT_SCHOOL_YEAR_GU]
	
WHERE
	[RevYear].[SCHOOL_YEAR] = '2015'
	AND [RevYear].[EXTENSION] = 'R'
	AND ([SCHEDULE].[COURSE_LEAVE_DATE] IS NULL
	OR [SCHEDULE].[COURSE_LEAVE_DATE] = [TERMDATES].[TermEnd])
)


/*
SELECT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[GENDER]
	,[COURSE].[COURSE_ID]
	,[COURSE].[COURSE_TITLE]
	,[SCHEDULE].[SECTION_ID]
	,[COURSE].[DEPARTMENT]
	,[SCHEDULE].[COURSE_ENTER_DATE]
	,[SCHEDULE].[COURSE_LEAVE_DATE]
	,[TERMDATES].[TermEnd]
	,[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,[ENROLLMENTS].[GRADE]
	
	--,[COURSE2].[COURSE_ID]
	--,[COURSE2].[COURSE_TITLE]
	--,[SCHEDULE2].[SECTION_ID]
	--,[COURSE2].[DEPARTMENT]
	--,[SCHEDULE2].[COURSE_ENTER_DATE]
	--,[SCHEDULE2].[COURSE_LEAVE_DATE]
	--,[SCHEDULE2].[TERM_CODE]
	--,[TERMDATES2].[TermEnd]
	--,[ENROLLMENTS2].[SCHOOL_CODE]
	--,[ENROLLMENTS2].[SCHOOL_NAME]
	--,[ENROLLMENTS2].[GRADE]
FROM
	APS.BasicSchedule AS [SCHEDULE]
	
	INNER JOIN 
	rev.REV_YEAR AS [RevYear] -- Contains the School Year
	ON 
	[SCHEDULE].[YEAR_GU] = [RevYear].[YEAR_GU]
	
	INNER JOIN
	rev.EPC_CRS AS [COURSE]
	ON
	[SCHEDULE].[COURSE_GU] = [COURSE].[COURSE_GU]
	
	INNER JOIN
	APS.TermDates() AS [TERMDATES]
	ON
	[SCHEDULE].[YEAR_GU] = [TERMDATES].[YEAR_GU]
	AND [SCHEDULE].[ORGANIZATION_GU] = [TERMDATES].[ORGANIZATION_GU]
	AND [SCHEDULE].[TERM_CODE] = [TERMDATES].[TermCode]
	
	INNER JOIN
	APS.BasicStudent  AS [STUDENT]
	ON
	[SCHEDULE].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	INNER JOIN
	APS.StudentEnrollmentDetails AS [ENROLLMENTS]
	ON
	[SCHEDULE].[STUDENT_SCHOOL_YEAR_GU] = [ENROLLMENTS].[STUDENT_SCHOOL_YEAR_GU]
	
	LEFT OUTER JOIN
	APS.BasicSchedule AS [SCHEDULE2]
	ON
	[SCHEDULE].[YEAR_GU] = [SCHEDULE2].[YEAR_GU]
	AND [SCHEDULE].[COURSE_GU] = [SCHEDULE2].[COURSE_GU]
	AND [SCHEDULE].[STUDENT_GU] = [SCHEDULE2].[STUDENT_GU]	
	
	LEFT OUTER JOIN
	APS.TermDates() AS [TERMDATES2]
	ON
	[SCHEDULE2].[YEAR_GU] = [TERMDATES2].[YEAR_GU]
	AND [SCHEDULE2].[ORGANIZATION_GU] = [TERMDATES2].[ORGANIZATION_GU]
	AND [SCHEDULE2].[TERM_CODE] = [TERMDATES2].[TermCode]
	
	LEFT OUTER JOIN
	rev.EPC_CRS AS [COURSE2]
	ON
	[SCHEDULE2].[COURSE_GU] = [COURSE2].[COURSE_GU]
	
	LEFT OUTER JOIN
	APS.StudentEnrollmentDetails AS [ENROLLMENTS2]
	ON
	[SCHEDULE2].[STUDENT_SCHOOL_YEAR_GU] = [ENROLLMENTS2].[STUDENT_SCHOOL_YEAR_GU]
	
WHERE
	[RevYear].[SCHOOL_YEAR] = '2014'
	AND [RevYear].[EXTENSION] = 'R'
	AND [SCHEDULE].[COURSE_LEAVE_DATE] IS NOT NULL
	AND [SCHEDULE].[COURSE_LEAVE_DATE] < [TERMDATES].[TermEnd]
	AND ([SCHEDULE2].[COURSE_LEAVE_DATE] IS NOT NULL OR [SCHEDULE2].[COURSE_LEAVE_DATE] = [TERMDATES2].[TermEnd])
	
*/

SELECT TOP 100000
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[GENDER]
	,[DROPPED_CLASSES].[COURSE_ID]
	,[DROPPED_CLASSES].[COURSE_TITLE]
	,[DROPPED_CLASSES].[SECTION_ID]
	,[DROPPED_CLASSES].[DEPARTMENT]
	,[DROPPED_CLASSES].[COURSE_ENTER_DATE]
	,[DROPPED_CLASSES].[COURSE_LEAVE_DATE]
	,[DROPPED_CLASSES].[TERM_CODE]
	,[DROPPED_CLASSES].[TermEnd]
	,[DROPPED_CLASSES].[SCHOOL_CODE]
	,[DROPPED_CLASSES].[SCHOOL_NAME]
	,[DROPPED_CLASSES].[GRADE]
	
	,[OPEN_CLASSES].[COURSE_ID]
	,[OPEN_CLASSES].[COURSE_TITLE]
	,[OPEN_CLASSES].[SECTION_ID]
	,[OPEN_CLASSES].[DEPARTMENT]
	,[OPEN_CLASSES].[COURSE_ENTER_DATE]
	,[OPEN_CLASSES].[COURSE_LEAVE_DATE]
	,[OPEN_CLASSES].[TERM_CODE]
	,[OPEN_CLASSES].[TermEnd]
	,[OPEN_CLASSES].[SCHOOL_CODE]
	,[OPEN_CLASSES].[SCHOOL_NAME]
	,[OPEN_CLASSES].[GRADE]
FROM
	DROPPED_CLASSES AS [DROPPED_CLASSES]
	
	INNER JOIN
	APS.BasicStudent  AS [STUDENT]
	ON
	[DROPPED_CLASSES].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	LEFT OUTER JOIN
	OPEN_CLASSES AS [OPEN_CLASSES]
	ON
	[DROPPED_CLASSES].[YEAR_GU] = [OPEN_CLASSES].[YEAR_GU]
	AND [DROPPED_CLASSES].[COURSE_ID] = [OPEN_CLASSES].[COURSE_ID]
	AND [DROPPED_CLASSES].[SECTION_ID] != [OPEN_CLASSES].[SECTION_ID]
	AND [DROPPED_CLASSES].[STUDENT_GU] = [OPEN_CLASSES].[STUDENT_GU]
	
--WHERE
--	[STUDENT].[SIS_NUMBER] = '100003714'
	
ORDER BY
	[STUDENT].[SIS_NUMBER]