






; WITH 
-- From Student School Year [EPC_STU_SCH_YR]
SSY_ENROLLMENTS AS
(
SELECT
	[StudentSchoolYear].[STUDENT_GU]
	,[StudentSchoolYear].[ORGANIZATION_YEAR_GU]
	,[Organization].[ORGANIZATION_GU]
	,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
	,[Grades].[LIST_ORDER]
	,[School].[SCHOOL_CODE]
	,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	,[StudentSchoolYear].[ENTER_DATE]
	,[StudentSchoolYear].[LEAVE_DATE]
	,[StudentSchoolYear].[EXCLUDE_ADA_ADM]
	,[StudentSchoolYear].[ACCESS_504]
	,CASE WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 2 THEN 'CONCURRENT'
		WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 1 THEN 'NO ADA/ADM'
		ELSE '' END AS [CONCURRENT]
	,[OrgYear].[YEAR_GU]
	,[RevYear].[SCHOOL_YEAR]
	,[RevYear].[EXTENSION]
FROM
	rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
	
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
)


--------------------------------------------------------------------------------------------------------------------

	--UPDATE [STUDENT]

	--SET [STUDENT].[EXPECTED_GRADUATION_YEAR] = '2019'

	SELECT
		[STUDENT].[SIS_NUMBER]
		,[PERSON].[FIRST_NAME]
		,[PERSON].[LAST_NAME]
		,[PERSON].[MIDDLE_NAME]
		,[ENROLLMENTS].[SCHOOL_NAME]
		,[ENROLLMENTS].[GRADE]
		,[ENROLLMENTS].[ENTER_DATE]
		,[ENROLLMENTS].[SCHOOL_YEAR]
		,[STUDENT].[EXPECTED_GRADUATION_YEAR]
	FROM
		SSY_ENROLLMENTS AS [ENROLLMENTS]
		
		INNER JOIN
		rev.[EPC_STU] AS [STUDENT]
		ON
		[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
		
		INNER JOIN
		rev.[REV_PERSON] AS [PERSON]
		ON
		[ENROLLMENTS].[STUDENT_GU] = [PERSON].[PERSON_GU]
		
	WHERE
		[ENROLLMENTS].[SCHOOL_YEAR] = '2015'
		AND [ENROLLMENTS].[EXTENSION] = 'R'
		AND [ENROLLMENTS].[GRADE] = '09'
		AND [STUDENT].[EXPECTED_GRADUATION_YEAR] = '2018'