


SELECT
	[StudentSchoolYear].[STUDENT_GU]
	--,[School].[SCHOOL_CODE] AS [SUMMER SCHOOL NUMBER]
	--,[Organization].[ORGANIZATION_NAME] AS [SUMMER SCHOOL NAME]
	,[RevYear].[SCHOOL_YEAR]
	,[RevYear].[EXTENSION]
	--,[StudentSchoolYear].[NO_SHOW_STUDENT]
	--,[SCHOOL_YEAR_OPTION].[SCHOOL_TYPE]
	--,[STUDENT].[ENROLL_LESS_THREE_OVR]
	,[STUDENT].[SIS_NUMBER]
FROM
	---------------------------------------------------------------------
	-- Enrollment Information

	rev.EPC_STU_SCH_YR AS [StudentSchoolYear] -- Contains Grade and Start Date 
			
	INNER JOIN 
	rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
	ON 
	[StudentSchoolYear].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
	
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	INNER JOIN 
	rev.REV_YEAR AS [RevYear] -- Contains the School Year
	ON 
	[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
	
	INNER JOIN 
	rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	[OrgYear].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]	
	
	INNER JOIN
	rev.[EPC_SCH_YR_OPT] AS [SCHOOL_YEAR_OPTION]
	ON
	[StudentSchoolYear].[ORGANIZATION_YEAR_GU] = [SCHOOL_YEAR_OPTION].[ORGANIZATION_YEAR_GU]
	
	------------------------------------------------------------------------------------------
	-- STUDENT DEMOGRAPHICS
	INNER JOIN
	rev.[EPC_STU] AS [STUDENT]
	ON
	[StudentSchoolYear].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
		
WHERE
	[StudentSchoolYear].[NO_SHOW_STUDENT] = 'N'
	
	AND [STUDENT].[SIS_NUMBER] = '970084740'
	--AND [StudentSchoolYear].[STUDENT_GU] = '748860B4-A57B-42E4-98AB-A17278059684' --'BAD45F84-53C3-4275-9428-00002830186D'--'9A11A8D3-EC24-4C92-A95D-295EDE9345C2'
	


SELECT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[ENROLL_LESS_THREE_OVR]
	,[STUDENT_YEARS_ENROLLED].[ENROLLMENT_YEARS]
	,[PERSON].[LAST_NAME]
	,[PERSON].[FIRST_NAME]
	,[School].[SCHOOL_CODE]
	,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	--,[RevYear].[SCHOOL_YEAR]
	,[Grades].[VALUE_DESCRIPTION] AS [GRADE_LEVEL]
	--,[LAST_ENROLLED_SSY].*
FROM	
	(	
	SELECT
		[STUDENT_GU]
		,COUNT([SCHOOL_YEAR]) AS [ENROLLMENT_YEARS]
	FROM
		(	
		SELECT DISTINCT
			[StudentSchoolYear].[STUDENT_GU]
			,[RevYear].[SCHOOL_YEAR]
		FROM
			rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
			
			INNER JOIN 
			rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
			ON 
			[StudentSchoolYear].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
			
			INNER JOIN 
			rev.REV_YEAR AS [RevYear] -- Contains the School Year
			ON 
			[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
				
		) AS [STUDENT_YEARS]

	GROUP BY
		[STUDENT_GU]
	) AS [STUDENT_YEARS_ENROLLED]
	
	INNER JOIN
	rev.[EPC_STU] AS [STUDENT]
	ON
	[STUDENT_YEARS_ENROLLED].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	INNER JOIN
	rev.[REV_PERSON] AS [PERSON]
	ON
	[STUDENT_YEARS_ENROLLED].[STUDENT_GU] = [PERSON].[PERSON_GU]
	
	LEFT OUTER JOIN
	(
	SELECT
		*
		,ROW_NUMBER() OVER (PARTITION BY [STUDENT_GU] ORDER BY [ENTER_DATE] DESC) AS RN
	FROM
		rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
	) AS [LAST_ENROLLED_SSY]
	ON
	[STUDENT].[STUDENT_GU] = [LAST_ENROLLED_SSY].[STUDENT_GU]
	AND [LAST_ENROLLED_SSY].[RN] = 1
	
	LEFT JOIN 
	rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
	ON 
	[LAST_ENROLLED_SSY].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
	
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	LEFT JOIN 
	rev.REV_YEAR AS [RevYear] -- Contains the School Year
	ON 
	[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
	
	LEFT JOIN 
	rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	[OrgYear].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
	
	LEFT JOIN
	APS.LookupTable('K12','Grade') AS [Grades]
	ON
	[LAST_ENROLLED_SSY].[GRADE] = [Grades].[VALUE_CODE]
	
WHERE
	[STUDENT_YEARS_ENROLLED].[ENROLLMENT_YEARS] = 3
	AND [STUDENT].[ENROLL_LESS_THREE_OVR] = 'Y'
	--AND [STUDENT].[SIS_NUMBER] = '970087794'


	
	
	
--E11FC8A8-18EA-499B-8632-F95E94F4B06E