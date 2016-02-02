





SELECT
	*
FROM
	(
	SELECT
		[ENROLLMENTS].[SCHOOL_CODE]
		,[ENROLLMENTS].[SCHOOL_NAME]
		,[STUDENT].[SIS_NUMBER]
		,[STUDENT].[STATE_STUDENT_NUMBER]
		,[STUDENT].[LAST_NAME]
		,[STUDENT].[FIRST_NAME]
		,[STUDENT].[MIDDLE_NAME]
		,[ENROLLMENTS].[GRADE]
		,[STUDENT].[GENDER]
		
		,[PARENT_PERSON].[FIRST_NAME] + ' ' + [PARENT_PERSON].[LAST_NAME] AS [PARENT_NAME]
		
		--,[PARENT_PERSON].[EMAIL]
		
		--,[STUDENT_PARENT].[ORDERBY]
		--,ROW_NUMBER() OVER (PARTITION BY [STUDENT].[SIS_NUMBER] ORDER BY 
		--	CASE WHEN [STUDENT_PARENT].[ORDERBY] IS NULL THEN 99 ELSE [STUDENT_PARENT].[ORDERBY] END) AS [RN]
		
		,[STUDENT].[HOME_ADDRESS]
		,[STUDENT].[HOME_CITY]
		,[STUDENT].[HOME_STATE]
		,[STUDENT].[HOME_ZIP]	
		
	FROM
		APS.StudentEnrollmentDetails AS [ENROLLMENTS]
		
		INNER JOIN
		APS.BasicStudent AS [STUDENT]
		ON
		[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
		
		-- Get student parents
		LEFT JOIN
		(
		SELECT
			*
			,ROW_NUMBER() OVER (PARTITION BY [STUDENT_PARENT].[STUDENT_GU] ORDER BY 
					CASE WHEN [STUDENT_PARENT].[ORDERBY] IS NULL THEN 99 ELSE [STUDENT_PARENT].[ORDERBY] END) AS [RN]
		FROM
			rev.[EPC_STU_PARENT] AS [STUDENT_PARENT]
		WHERE
			[STUDENT_PARENT].[LIVES_WITH] = 'Y'
		) AS [STUDENT_PARENT]
		ON
		[ENROLLMENTS].[STUDENT_GU] = [STUDENT_PARENT].[STUDENT_GU]
		AND [STUDENT_PARENT].[RN] = 1
		
		LEFT JOIN
		rev.REV_PERSON AS [PARENT_PERSON]
		ON
		[STUDENT_PARENT].[PARENT_GU] = [PARENT_PERSON].[PERSON_GU]
		
	WHERE
		[ENROLLMENTS].[SCHOOL_YEAR] = '2015'
		AND [ENROLLMENTS].[EXTENSION] = 'R'
	) AS [SUB1]
	
--WHERE
--	[PRIMARY_PARENT] = 1
	
ORDER BY
	[SIS_NUMBER]