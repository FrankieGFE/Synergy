

UPDATE [StudentSchoolYear]

--SELECT
--	[STUDENT].[SIS_NUMBER]
--	,[STUDENT].[FIRST_NAME]
--	,[STUDENT].[LAST_NAME]
--	,[CURRENT_ENROLLMENTS].[SCHOOL_CODE] AS [CURRENT LOCATION]
--	,[CURRENT_ENROLLMENTS].[SCHOOL_NAME] AS [CURRENT SCHOOL]
--	,[CURRENT_ENROLLMENTS].[GRADE] AS [CURRENT GRADE]
	--,[CURRENT_ENROLLMENTS].[ENTER_DATE] AS [CURRENT ENTER DATE]
	--,[CURRENT_ENROLLMENTS].[LEAVE_DATE] AS [CURRENT LEAVE DATE]
	--,[CURRENT_ENROLLMENTS].[EXCLUDE_ADA_ADM] AS [CURRENT ADA]
	--,[CURRENT_ENROLLMENTS].[SUMMER_WITHDRAWL_CODE] AS [CURRENT SUMMER WITHDRAWAL]
	--,[StudentSchoolYear].[PREVIOUS_YEAR_END_STATUS]
	
	--,[PREVIOUS_ENROLLMENTS].[SCHOOL_CODE] AS [PREVIOUS LOCATION]
	--,[PREVIOUS_ENROLLMENTS].[SCHOOL_NAME] AS [PREVIOUS SCHOOL]
	--,[PREVIOUS_ENROLLMENTS].[GRADE] AS [PREVIOUS GRADE]
	--,[PREVIOUS_ENROLLMENTS].[ENTER_DATE] AS [PREVIOUS ENTER DATE]
	--,[PREVIOUS_ENROLLMENTS].[LEAVE_DATE] AS [PREVIOUS LEAVE DATE]
	--,[PREVIOUS_ENROLLMENTS].[EXCLUDE_ADA_ADM] AS [PREVIOUS ADA]
	--,[PREVIOUS_ENROLLMENTS].[SUMMER_WITHDRAWL_CODE] AS [PREVIOUS SUMMER WITHDRAWAL]
	SET [StudentSchoolYear].[PREVIOUS_YEAR_END_STATUS] = 
	CASE 
		WHEN [PREVIOUS_ENROLLMENTS].[YEAR_END_STATUS] = 'G' THEN 'R'
		WHEN [PREVIOUS_ENROLLMENTS].[YEAR_END_STATUS] IS NULL THEN 'P' 
		ELSE [PREVIOUS_ENROLLMENTS].[YEAR_END_STATUS] END --AS [PREVIOUS_YEAR_END_STATUS]
	
	--,[PREVIOUS_ENROLLMENTS].*
FROM
	(
	SELECT
		*
	FROM
		APS.StudentEnrollmentDetails AS [ENROLLMENT]
		
	WHERE
		[ENROLLMENT].[SCHOOL_YEAR] = '2015'
		AND [ENROLLMENT].[EXTENSION] = 'R'
		--AND [ENROLLMENT].[SUMMER_WITHDRAWL_CODE] IS NULL
		--AND [ENROLLMENT].[EXCLUDE_ADA_ADM] IS NULL
	) AS [CURRENT_ENROLLMENTS]
	
	INNER JOIN
	rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
	ON
	[CURRENT_ENROLLMENTS].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
	
	LEFT JOIN
	(
	SELECT
		*
		,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU, YEAR_GU ORDER BY ENTER_DATE DESC) AS RN
	FROM
		APS.StudentEnrollmentDetails AS [ENROLLMENT]
		
	WHERE
		[ENROLLMENT].[SCHOOL_YEAR] = '2014'
		AND [ENROLLMENT].[EXTENSION] = 'R'
		--AND [ENROLLMENT].[YEAR_END_STATUS] IS NULL
		AND [ENROLLMENT].[SUMMER_WITHDRAWL_CODE] IS NULL
		AND [ENROLLMENT].[EXCLUDE_ADA_ADM] IS NULL
	) AS [PREVIOUS_ENROLLMENTS]
	ON
	[CURRENT_ENROLLMENTS].[STUDENT_GU] = [PREVIOUS_ENROLLMENTS].[STUDENT_GU]
	AND [PREVIOUS_ENROLLMENTS].[RN] = 1
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[CURRENT_ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
WHERE
	[StudentSchoolYear].[PREVIOUS_YEAR_END_STATUS] IS NULL
	AND [CURRENT_ENROLLMENTS].[SUMMER_WITHDRAWL_CODE] IS NULL


--SELECT TOP 100
--	*
--FROM
--	rev.EPC_STU_YR AS [StudentYear]