

DECLARE @SCHOOLYEAR INT = 2014

SELECT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[ENROLLMENTS].[SCHOOL_CODE] AS [9TH_SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME] AS [9TH_SCHOOL_NAME]
	,[ENROLLMENTS].[ENTER_DATE] AS [9TH_ENTER_DATE]
	,[ENROLLMENTS].[LEAVE_DATE] AS [9TH_LEAVE_DATE]
	,[ENROLLMENTS].[YEAR_END_STATUS] AS [9TH_YEAR_END_STATUS]
	--,[ENROLLMENTS_8TH].[SCHOOL_CODE] AS [8TH_SCHOOL_CODE]
	--,[ENROLLMENTS_8TH].[SCHOOL_NAME] AS [8TH_SCHOOL_NAME]
	--,[ENROLLMENTS_8TH].[ENTER_DATE] AS [8TH_ENTER_DATE]
	--,[ENROLLMENTS_8TH].[LEAVE_DATE] AS [8TH_LEAVE_DATE]
	--,[ENROLLMENTS_8TH].[YEAR_END_STATUS] AS [8TH_YEAR_END_STATUS]
	
FROM
	(
	SELECT
		*
		,ROW_NUMBER() OVER (PARTITION BY [STUDENT_GU] ORDER BY [ENTER_DATE] DESC) AS RN
	FROM
		APS.StudentEnrollmentDetails
		
	WHERE
		SCHOOL_YEAR = @SCHOOLYEAR
		AND EXTENSION = 'R'
		AND EXCLUDE_ADA_ADM IS NULL
		AND GRADE = '08'
		AND YEAR_END_STATUS != 'P'
	) AS [ENROLLMENTS]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	--INNER JOIN
	--(
	--SELECT
	--	*
	--	,ROW_NUMBER() OVER (PARTITION BY [STUDENT_GU] ORDER BY [ENTER_DATE] DESC) AS RN
	--FROM
	--	APS.StudentEnrollmentDetails
		
	--WHERE
	--	EXCLUDE_ADA_ADM IS NULL
	--	AND GRADE = '08'
	--	AND YEAR_END_STATUS = 'P'
	--) AS [ENROLLMENTS_8TH]
	--ON
	--[ENROLLMENTS].[STUDENT_GU] = [ENROLLMENTS_8TH].[STUDENT_GU]
	--AND [ENROLLMENTS_8TH].[RN] = 1
	
WHERE
	[ENROLLMENTS].[RN] = 1