




SELECT DISTINCT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,[ENROLLMENTS].[GRADE]
	
	,[COURSE].[COURSE_ID]
	,[COURSE].[COURSE_TITLE]
	,[SCHEDULE].[SECTION_ID]
	,[SCHEDULE].[TERM_CODE]
	,[COURSE].[DEPARTMENT]
	,[GRADES].[MARK]
	,[GRADES].[CREDIT]
	,[GRADES].[GRADE_PERIOD]
	
FROM
	APS.StudentEnrollmentDetails AS [ENROLLMENTS]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON [ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	INNER JOIN
	APS.BasicSchedule AS [SCHEDULE]
	ON
	[ENROLLMENTS].[STUDENT_SCHOOL_YEAR_GU] = [SCHEDULE].[STUDENT_SCHOOL_YEAR_GU]
	
	INNER JOIN
	rev.EPC_CRS AS [COURSE]
	ON
	[SCHEDULE].[COURSE_GU] = [COURSE].[COURSE_GU]
	
	INNER JOIN
	APS.StudentGrades AS [GRADES]
	ON
	[SCHEDULE].[STUDENT_SCHOOL_YEAR_GU] = [GRADES].[STUDENT_SCHOOL_YEAR_GU]
	AND [SCHEDULE].[SECTION_GU] = [GRADES].[SECTION_GU]
	
WHERE
	[ENROLLMENTS].[SCHOOL_YEAR] = '2015'
	AND [ENROLLMENTS].[EXTENSION] = 'R'
	AND [ENROLLMENTS].[GRADE] = '08'
	AND [COURSE].[DEPARTMENT] IN ('Math', 'Eng')
	AND [GRADES].[GRADE_PERIOD] = 'S1'