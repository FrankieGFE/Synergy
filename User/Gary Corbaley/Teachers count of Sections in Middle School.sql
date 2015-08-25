


SELECT
	[SCHOOL_YEAR]
	,[SCHOOL_CODE]
	,[SCHOOL_NAME]
	,[TEACHER NAME]
	,[BADGE_NUM]
	,[TERM_CODE]
	,COUNT([SECTION_ID]) AS [SECTIONS]
	
FROM
	(
	SELECT DISTINCT
		[ENROLLMENT].[SCHOOL_YEAR]
		,[ENROLLMENT].[SCHOOL_CODE]
		,[ENROLLMENT].[SCHOOL_NAME]
		,[SCHEDULE].[COURSE_ID]
		,[SCHEDULE].[COURSE_TITLE]
		,[SCHEDULE].[SECTION_ID]
		,[SCHEDULE].[DEPARTMENT]
		,[SCHEDULE].[TERM_CODE]
		--,[SCHEDULE].[STAFF_GU]
		,[SCHEDULE].[TEACHER NAME]
		,[STAFF].[BADGE_NUM]
		,[STAFF].[STATE_ID]
		,[SCHEDULE].[PRIMARY_STAFF]
		
		,[SCHEDULE].[PERIOD_BEGIN]
		,[SCHEDULE].[PERIOD_END]
		
	FROM
		APS.StudentEnrollmentDetails AS [ENROLLMENT]
		
		INNER JOIN
		APS.StudentScheduleDetails AS [SCHEDULE]
		ON
		[ENROLLMENT].[STUDENT_GU] = [SCHEDULE].[STUDENT_GU]
		AND [ENROLLMENT].[ORGANIZATION_YEAR_GU] = [SCHEDULE].[ORGANIZATION_YEAR_GU]
		
		INNER JOIN
		rev.[EPC_STAFF] AS [STAFF]
		ON
		[SCHEDULE].[STAFF_GU] = [STAFF].[STAFF_GU]
		
	WHERE
		[ENROLLMENT].[SCHOOL_YEAR] = '2014'
		AND [ENROLLMENT].[EXTENSION] = 'R'
		AND [ENROLLMENT].[GRADE] BETWEEN '06' AND '08'
	) AS [TEACHER_SECTIONS]
	
	
GROUP BY
	[SCHOOL_YEAR]
	,[SCHOOL_CODE]
	,[SCHOOL_NAME]
	,[TEACHER NAME]
	,[BADGE_NUM]
	,[TERM_CODE]