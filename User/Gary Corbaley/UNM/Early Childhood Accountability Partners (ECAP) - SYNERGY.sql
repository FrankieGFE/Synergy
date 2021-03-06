



SELECT
	'2014-2015' AS [SCHOOL_YEAR]
	,[STUDENT].[SIS_NUMBER]
	,[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,[ENROLLMENTS].[ENTER_DATE]
	,[ENROLLMENTS].[LEAVE_DATE]
	,[ENROLLMENTS].[LEAVE_DESCRIPTION]
	,[ENROLLMENTS].[GRADE]
	
FROM
	APS.StudentEnrollmentDetails AS [ENROLLMENTS]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
WHERE
	[ENROLLMENTS].[SCHOOL_YEAR] = '2014'
	AND [ENROLLMENTS].[EXTENSION] = 'R'
	AND [ENROLLMENTS].[SUMMER_WITHDRAWL_CODE] IS NULL
	AND [ENROLLMENTS].[GRADE] = 'K'