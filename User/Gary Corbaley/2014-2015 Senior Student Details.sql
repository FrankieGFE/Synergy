




SELECT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[ENROLLMENTS].[GRADE] AS [2014_GRADE]
	,[ENROLLMENTS].[SCHOOL_CODE] AS [2014_SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME] AS [2014_SCHOOL_NAME]
	,[ENROLLMENTS].[ENTER_DATE] AS [2014_ENTER_DATE]
	,[ENROLLMENTS].[LEAVE_DATE] AS [2014_LEAVE_DATE]
	,[ENROLLMENTS].[YEAR_END_STATUS] AS [2014_YEAR_END_STATUS]
	,[STU].[GRADUATION_DATE]
	,[STU].[GRADUATION_STATUS]
	,[STU].[DIPLOMA_TYPE]
	,[DIPLOMA_TYPE].[VALUE_DESCRIPTION]
	,[1516_ENROLLMENTS].[SCHOOL_CODE] AS [2015_SCHOOL_CODE]
	,[1516_ENROLLMENTS].[SCHOOL_NAME] AS [2015_SCHOOL_NAME]
	,[1516_ENROLLMENTS].[GRADE] AS [2015_GRADE]
	,[1516_ENROLLMENTS].[ENTER_DATE] AS [2015_ENTER_DATE]
	,[1516_ENROLLMENTS].[LEAVE_DATE] AS [2015_LEAVE_DATE]
FROM
	(
	SELECT
		*
		,ROW_NUMBER() OVER (PARTITION BY [STUDENT_GU] ORDER BY [ENTER_DATE] DESC) AS RN
	FROM
		APS.StudentEnrollmentDetails
		
	WHERE
		SCHOOL_YEAR = 2014
		AND EXTENSION = 'R'
		AND EXCLUDE_ADA_ADM IS NULL
		AND GRADE = '12'
		AND ENTER_DATE IS NOT NULL		
	) AS [ENROLLMENTS]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	INNER JOIN
	rev.[EPC_STU] AS [STU]
	ON
	[STUDENT].[STUDENT_GU] = [STU].[STUDENT_GU]	
	
	LEFT OUTER JOIN
	APS.LookupTable('K12','DIPLOMA_TYPE') AS [DIPLOMA_TYPE]
	ON
	[STU].[DIPLOMA_TYPE] = [DIPLOMA_TYPE].[VALUE_CODE]
	
	LEFT OUTER JOIN
	(
	SELECT
		*
		,ROW_NUMBER() OVER (PARTITION BY [STUDENT_GU] ORDER BY [ENTER_DATE] DESC) AS RN
	FROM
		APS.StudentEnrollmentDetails
		
	WHERE
		SCHOOL_YEAR = 2015
		AND EXTENSION = 'R'
		AND EXCLUDE_ADA_ADM IS NULL	
		AND ENTER_DATE IS NOT NULL
	) AS [1516_ENROLLMENTS]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [1516_ENROLLMENTS].[STUDENT_GU]
	AND [1516_ENROLLMENTS].[RN] = 1
	
WHERE
	[ENROLLMENTS].[RN] = 1