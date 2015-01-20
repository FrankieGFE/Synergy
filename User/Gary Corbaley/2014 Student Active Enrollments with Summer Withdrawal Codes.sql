




SELECT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	--,[StudentSchoolYear].[STUDENT_GU]
	--,[StudentSchoolYear].[ORGANIZATION_YEAR_GU]
	--,[Organization].[ORGANIZATION_GU]
	,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
	,[School].[SCHOOL_CODE]
	,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	,[StudentSchoolYear].[ENTER_DATE]
	,[StudentSchoolYear].[LEAVE_DATE]
	,[StudentSchoolYear].[EXCLUDE_ADA_ADM]
	,[StudentSchoolYear].[SUMMER_WITHDRAWL_CODE]
	,[StudentSchoolYear].[SUMMER_WITHDRAWL_DATE]
	,[RevYear].[SCHOOL_YEAR]
	,[RevYear].[EXTENSION]
	
	--,[STUDENT].*
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
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[StudentSchoolYear].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
WHERE
	[StudentSchoolYear].[SUMMER_WITHDRAWL_CODE] IS NOT NULL
	AND [StudentSchoolYear].[ENTER_DATE] IS NOT NULL
	AND [StudentSchoolYear].[LEAVE_DATE] IS NULL
	AND [RevYear].[SCHOOL_YEAR] = '2014'
	AND [RevYear].[EXTENSION] = 'R'