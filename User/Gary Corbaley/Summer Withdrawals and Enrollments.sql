




SELECT 
	*
FROM
	(
	SELECT
		*
		,ROW_NUMBER() OVER (PARTITION BY [STUDENT_GU] ORDER BY [ENTER_DATE] DESC) AS RN
	FROM
		APS.StudentEnrollmentDetails
		
	WHERE
		SCHOOL_YEAR = 2015
		AND SUMMER_WITHDRAWL_CODE IS NOT NULL
		
	) AS [ENROLLMENTS]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]