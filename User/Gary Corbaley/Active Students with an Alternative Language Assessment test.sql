



--SELECT --TOP 100
--	*
--FROM
--	rev.REV_BOD_LOOKUP_VALUES AS [BOD]
	
--WHERE
--	[BOD].[VALUE_DESCRIPTION] LIKE '%Alternative Language%'


SELECT DISTINCT-- TOP 100
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
	,[School].[SCHOOL_CODE]
	,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	,[RevYear].[SCHOOL_YEAR]
	,[RevYear].[EXTENSION]
	,[TEST].[TEST_NAME]
	,[BOD].[VALUE_DESCRIPTION]
	
FROM
	rev.EPC_STU_TEST AS [STUDENT_TEST]
	
	INNER JOIN
	rev.EPC_TEST AS [TEST]
	ON
	[STUDENT_TEST].[TEST_GU] = [TEST].[TEST_GU]
	AND [TEST].[SCHOOL_YEAR] = 2014
	
	INNER JOIN
	rev.REV_BOD_LOOKUP_VALUES AS [BOD]
	ON
	[TEST].[TEST_TYPE] = [BOD].[VALUE_CODE] 
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[STUDENT_TEST].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	INNER JOIN
	APS.PrimaryEnrollmentsAsOf(GETDATE()) AS [ENROLLMENTS]
	ON
	[STUDENT_TEST].[STUDENT_GU] = [ENROLLMENTS].[STUDENT_GU]
	
	INNER JOIN
	rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
	ON
	[ENROLLMENTS].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
	
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
	
	LEFT OUTER JOIN
	APS.LookupTable('K12','Grade') AS [Grades]
	ON
	[StudentSchoolYear].[GRADE] = [Grades].[VALUE_CODE]
	
	INNER JOIN 
	rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
	
WHERE
	TEST_TYPE = 'ALTRN'