



SELECT
	[SCHOOL_CODE]
	,[SCHOOL_NAME]
	
	,[COURSE_ID]
	,[SECTION_ID]
	,[COURSE_TITLE]
	,[TERM_CODE]
	,[PERIOD]
	,[BADGE_NUM]
	,[TEACHER NAME]
	,COUNT([SIS_NUMBER]) AS [TOTAL SEATS]
FROM
	(
	SELECT DISTINCT
		[STUDENT].[SIS_NUMBER]
		,[STUDENT].[FIRST_NAME]
		,[STUDENT].[LAST_NAME]
		,[STUDENT].[MIDDLE_NAME]
		,[ENROLLMENTS].[GRADE]
		,[ENROLLMENTS].[SCHOOL_CODE]
		,[ENROLLMENTS].[SCHOOL_NAME]
		
		,[SCHEDULE].[COURSE_ID]
		,[SCHEDULE].[SECTION_ID]
		,[SCHEDULE].[COURSE_TITLE]
		,[SCHEDULE].[TERM_CODE]
		,[SCHEDULE].[PERIOD_BEGIN] AS [PERIOD]
		
		,[STAFF].[BADGE_NUM]
		,[STAFF_PERSON].[FIRST_NAME] +' '+ [STAFF_PERSON].[LAST_NAME] AS [TEACHER NAME]	
		
		
	FROM
		APS.ScheduleAsOf(@AsOfDate) AS [SCHEDULE]
		
		INNER HASH JOIN
		APS.StudentEnrollmentDetails AS [ENROLLMENTS]
		ON
		[SCHEDULE].[STUDENT_SCHOOL_YEAR_GU] = [ENROLLMENTS].[STUDENT_SCHOOL_YEAR_GU]
		
		INNER HASH JOIN
		APS.BasicStudent AS [STUDENT]
		ON
		[SCHEDULE].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
		
		INNER JOIN
		rev.[EPC_STAFF] AS [STAFF]
		ON
		[SCHEDULE].[STAFF_GU] = [STAFF].[STAFF_GU]

		INNER JOIN
		rev.[REV_PERSON] AS [STAFF_PERSON]
		ON
		[SCHEDULE].[STAFF_GU] = [STAFF_PERSON].[PERSON_GU]
		
	WHERE
		[SCHEDULE].[TERM_CODE] = @TermCode
		AND [ENROLLMENTS].[SCHOOL_CODE] BETWEEN '500' AND '599'
		AND [SCHEDULE].[CREDIT] > 0
	
	) AS [STUDENT_COURSES]
	
GROUP BY
	[SCHOOL_CODE]
	,[SCHOOL_NAME]	
	,[COURSE_ID]
	,[SECTION_ID]
	,[COURSE_TITLE]
	,[TERM_CODE]
	,[PERIOD]
	,[BADGE_NUM]
	,[TEACHER NAME]
	
ORDER BY
	[SCHOOL_CODE]
	,[COURSE_ID]