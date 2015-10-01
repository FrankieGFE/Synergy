

--SELECT
--	[STUDENTS].[SCHOOL_CODE]
--	,[STUDENTS].[SCHOOL_NAME]
--	,COUNT([STUDENTS].[SIS_NUMBER]) AS [STUDENTS]
--FROM
--	(
	SELECT
		*
	FROM
	(
	SELECT
		[STUDENT].[SIS_NUMBER]
		,[STUDENT].[FIRST_NAME]
		,[STUDENT].[LAST_NAME]
		,[STUDENT].[MIDDLE_NAME]
		,[NO_1ST_PERIOD].[GRADE]
		,[NO_1ST_PERIOD].[SCHOOL_CODE]
		,[NO_1ST_PERIOD].[SCHOOL_NAME]
		,[ENROLLMENTS_2014].[GRADE]  AS [2014_GRADE]
		,[ENROLLMENTS_2014].[SCHOOL_CODE] AS [2014_CODE]
		,[ENROLLMENTS_2014].[SCHOOL_NAME] AS [2014_LOCATION]
		,[ENROLLMENTS_2014].[ENTER_DATE]
		,ROW_NUMBER() OVER (PARTITION BY [STUDENT].STUDENT_GU ORDER BY [ENROLLMENTS_2014].ENTER_DATE DESC) AS RN
		
	FROM
		(
		SELECT DISTINCT
			[ENROLLMENTS].*
		FROM
			APS.StudentEnrollmentDetails AS [ENROLLMENTS]
			
			LEFT OUTER JOIN
			APS.StudentScheduleDetails AS [SCHEDULE]
			ON
			[ENROLLMENTS].[STUDENT_GU] = [SCHEDULE].[STUDENT_GU]
			AND [ENROLLMENTS].[ORGANIZATION_YEAR_GU] = [SCHEDULE].[ORGANIZATION_YEAR_GU]
			AND [SCHEDULE].[PERIOD_BEGIN] = 1
			
		WHERE
			[ENROLLMENTS].[SCHOOL_YEAR] = '2015'
			AND [ENROLLMENTS].[EXTENSION] = 'R'
			AND [ENROLLMENTS].[LEAVE_DATE] IS NULL
			AND [ENROLLMENTS].[SUMMER_WITHDRAWL_CODE] IS NULL
			AND [ENROLLMENTS].[SCHOOL_NAME] LIKE '%Elementary%'
			AND [SCHEDULE].[COURSE_ID] IS NULL
		) AS [NO_1ST_PERIOD]
		
		INNER JOIN
		APS.BasicStudent AS [STUDENT]
		ON
		[NO_1ST_PERIOD].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
		
		LEFT OUTER JOIN
		APS.StudentEnrollmentDetails AS [ENROLLMENTS_2014]
		ON
		[STUDENT].[STUDENT_GU] = [ENROLLMENTS_2014].[STUDENT_GU]
		AND [ENROLLMENTS_2014].[SCHOOL_YEAR] = '2014'
		AND [ENROLLMENTS_2014].[EXCLUDE_ADA_ADM] IS NULL
		
	) AS [SUB 1]

	WHERE
		RN = 1
		--AND [SIS_NUMBER] = '970038936'
--	) AS [STUDENTS]
	
--GROUP BY
--	[STUDENTS].[SCHOOL_CODE]
--	,[STUDENTS].[SCHOOL_NAME]
	
--ORDER BY
--	[STUDENTS].[SCHOOL_CODE]	