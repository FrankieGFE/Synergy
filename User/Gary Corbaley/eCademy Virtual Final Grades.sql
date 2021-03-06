



SELECT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[ENROLLMENTS].[GRADE]
	,[ENROLLMENTS].[SCHOOL_CODE] AS [PRIMARY_SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME] AS [PRIMARY_SCHOOL_NAME]
	,[COURSE_HISTORY].[TERM_CODE]
	,[COURSE_HISTORY].[COURSE_ID]
	,[COURSE_HISTORY].[COURSE_TITLE]
	,[COURSE_HISTORY].[MARK]
	,[Organization].[ORGANIZATION_NAME] AS [IN_DISTRICT_NAME]
	
FROM
	rev.[EPC_STU_CRS_HIS] AS [COURSE_HISTORY]
	
	LEFT OUTER JOIN
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[COURSE_HISTORY].[SCHOOL_IN_DISTRICT_GU] = [Organization].[ORGANIZATION_GU]
	
	INNER JOIN 
	rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[COURSE_HISTORY].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	LEFT OUTER JOIN
	(
	SELECT
		*
		,ROW_NUMBER() OVER (PARTITION BY [STUDENT_GU], [SCHOOL_YEAR], [EXTENSION] ORDER BY [ENTER_DATE] DESC) AS RN
	FROM
		APS.StudentEnrollmentDetails
	WHERE
		SCHOOL_YEAR = '2015'
		AND EXTENSION = 'R'
		AND EXCLUDE_ADA_ADM IS NULL
	) AS [ENROLLMENTS]
	ON
	[STUDENT].[STUDENT_GU] = [ENROLLMENTS].[STUDENT_GU]
	AND [ENROLLMENTS].[RN] = 1
	
WHERE
	[COURSE_HISTORY].[SCHOOL_YEAR] = '2015'
	AND [Organization].[ORGANIZATION_NAME] LIKE '%eCademy%'
	AND [COURSE_HISTORY].[TERM_CODE] = 'S2'