

;WITH
-- From Primary Enrollments As Of
ASOF_ENROLLMENTS AS
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
	APS.PrimaryEnrollmentsAsOf(GETDATE()) AS [Enrollments]
	
	INNER JOIN
	rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
	ON
	[Enrollments].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
	
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


--------------------------------------


SELECT
	[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,[STUDENT].[SIS_NUMBER]
	,[STUDENT].[STATE_STUDENT_NUMBER]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[ENROLLMENTS].[GRADE]
	,[STUDENT].[GENDER]
FROM
	ASOF_ENROLLMENTS AS [ENROLLMENTS]
	
	-- Get student parents
	LEFT JOIN
	rev.[EPC_STU_PARENT] AS [STUDENT_PARENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT_PARENT].[STUDENT_GU]
	--AND [STUDENT_PARENT].[LIVES_WITH] = 'Y'
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
WHERE
	[STUDENT_PARENT].[PARENT_GU] IS NULL
	
ORDER BY
	[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[GRADE]