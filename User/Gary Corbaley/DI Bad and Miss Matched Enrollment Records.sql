



--SELECT TOP 100
--	*
--FROM
--	rev.EPC_STU_SCH_YR AS [StudentSchoolYear] -- Contains Grade and Start Date
	
--	--INNER JOIN 
--	--rev.EPC_STU_ENROLL AS [EnrollmentDetails] -- Contains Grade and Start Date
--	--ON 
--	--[EnrollmentsAsOf].[ENROLLMENT_GU] = [EnrollmentDetails].[ENROLLMENT_GU]
	
--WHERE
--	NOT
--	([StudentSchoolYear].[SUMMER_WITHDRAWL_CODE] IS NOT NULL
--	AND [StudentSchoolYear].[SUMMER_WITHDRAWL_DATE] IS NOT NULL
--	AND [StudentSchoolYear].[ENTER_DATE] IS NULL
--	AND [StudentSchoolYear].[LEAVE_DATE] IS NULL)
	
	
SELECT
	*
FROM
	(
	SELECT
		[StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU] AS [SSY_SSY_GU]
		,[StudentSchoolYear].[ENTER_DATE] AS [SSY_ENTER_DATE]
		,[StudentSchoolYear].[LEAVE_DATE] AS [SSY_LEAVE_DATE]
		,[StudentSchoolYear].[EXCLUDE_ADA_ADM] AS [SSY_EXCLUDE_ADA_ADM]
		,[StudentSchoolYear].[GRADE] AS [SSY_GRADE]
		,[StudentSchoolYear].[SUMMER_WITHDRAWL_CODE]
		,[StudentSchoolYear].[SUMMER_WITHDRAWL_DATE]
		,[EnrollmentDetails].[STUDENT_SCHOOL_YEAR_GU] AS [ENR_SSY_GU]
		,[EnrollmentDetails].[ENTER_DATE] AS [ENR_ENTER_DATE]
		,[EnrollmentDetails].[LEAVE_DATE] AS [ENR_LEAVE_DATE]
		,[EnrollmentDetails].[EXCLUDE_ADA_ADM] AS [ENR_EXCLUDE_ADA_ADM]
		,[EnrollmentDetails].[GRADE] AS [ENR_GRADE]
		
		,[EnrollmentDetails].[RN]
	FROM
		rev.EPC_STU_SCH_YR AS [StudentSchoolYear] -- Contains Grade and Start Date
		
		LEFT OUTER JOIN
		(
		SELECT
			[STU_ENROLL].[STUDENT_SCHOOL_YEAR_GU]
			,[STU_ENROLL].[ENTER_DATE]
			,[STU_ENROLL].[LEAVE_DATE]
			,[STU_ENROLL].[EXCLUDE_ADA_ADM]
			,[STU_ENROLL].[GRADE]
			,ROW_NUMBER() OVER (PARTITION BY [STU_ENROLL].[STUDENT_SCHOOL_YEAR_GU] ORDER BY [STU_ENROLL].[ENTER_DATE] DESC) AS RN
		FROM
			rev.EPC_STU_ENROLL AS [STU_ENROLL]
		) AS [EnrollmentDetails] -- Contains Grade and Start Date
		ON
		[StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU] = [EnrollmentDetails].[STUDENT_SCHOOL_YEAR_GU]
		
	WHERE
	--	[StudentSchoolYear].[ENTER_DATE] >= '08/13/2014'
		[EnrollmentDetails].[STUDENT_SCHOOL_YEAR_GU] IS NULL
		OR
		COALESCE([StudentSchoolYear].[ENTER_DATE],'') != COALESCE([EnrollmentDetails].[ENTER_DATE],'')
		OR
		COALESCE([StudentSchoolYear].[LEAVE_DATE],'') != COALESCE([EnrollmentDetails].[LEAVE_DATE],'')
		OR
		COALESCE([StudentSchoolYear].[EXCLUDE_ADA_ADM],'') != COALESCE([EnrollmentDetails].[EXCLUDE_ADA_ADM],'')
		OR
		COALESCE([StudentSchoolYear].[GRADE],'') != COALESCE([EnrollmentDetails].[GRADE],'')
		OR
		(([StudentSchoolYear].[SUMMER_WITHDRAWL_CODE] IS NOT NULL OR [StudentSchoolYear].[SUMMER_WITHDRAWL_DATE] IS NOT NULL)
			AND ([StudentSchoolYear].[ENTER_DATE] IS NOT NULL OR [StudentSchoolYear].[LEAVE_DATE] IS NOT NULL))
		
	) AS [STUDENT_ENROLLMENTS]
	
WHERE
	[STUDENT_ENROLLMENTS].[RN] = 1
	
ORDER BY
	[STUDENT_ENROLLMENTS].[SSY_SSY_GU]
	
	

	