




SELECT --TOP 100
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[STUDENT].[BIRTH_DATE]
	,[STUDENT].[GENDER]
	,[STUDENT].[CLASS_OF]
	,[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,[ENROLLMENTS].[LEAVE_CODE]
	,[ENROLLMENTS].[LEAVE_DESCRIPTION]
	,[ENROLLMENTS].[YEAR_END_STATUS]
	,[ENROLLMENTS].[GRADE]
	
	,[STU_TOO].[GRADUATION_DATE]
	,[STU_TOO].[GRADUATION_STATUS]
	,[STU_TOO].[DIPLOMA_TYPE]
	,[STU_TOO].[GRADUATION_SEMESTER]
	,[STU_TOO].[POST_SECONDARY]
FROM
	APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS [ENROLLMENTS]
	
	INNER JOIN
	APS.BasicStudentWithMoreInfo AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	INNER JOIN
	rev.EPC_STU AS [STU_TOO]
	ON
	[STUDENT].[STUDENT_GU] = [STU_TOO].[STUDENT_GU]
	
WHERE
	[ENROLLMENTS].[GRADE] = '12'
	OR
	[STUDENT].[CLASS_OF] = '2015'
	
	AND [ENROLLMENTS].[SCHOOL_CODE] NOT IN ('517','910','611','592','701','058','847','327','846','192')