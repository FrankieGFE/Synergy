


SELECT --TOP 100
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	
	,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_OF_RECORD]
	
	,[COURSE_HISTORY].[COURSE_ID]
	,[COURSE_HISTORY].[COURSE_TITLE]
	,[COURSE_HISTORY].[TERM_CODE]
	,[COURSE_HISTORY].[TEACHER_NAME]	
	,[REPEAT_TAG].[NAME] AS [REPEAT_TAG]
	
	--,[StudentYear].*
FROM
	rev.[EPC_STU_CRS_HIS] AS [COURSE_HISTORY]
	
	INNER JOIN
	rev.[EPC_REPEAT_TAG] AS [REPEAT_TAG]
	ON
	[COURSE_HISTORY].[REPEAT_TAG_GU] = [REPEAT_TAG].[REPEAT_TAG_GU]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[COURSE_HISTORY].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	LEFT OUTER JOIN
	rev.EPC_STU_YR AS [StudentYear]
	ON
	[COURSE_HISTORY].[STUDENT_GU] = [StudentYear].[STUDENT_GU]
	
	LEFT OUTER JOIN
	rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
	ON
	[StudentYear].[STU_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
	
	LEFT OUTER JOIN 
	rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
	ON 
	[StudentSchoolYear].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
	
	LEFT OUTER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	LEFT OUTER JOIN 
	rev.REV_YEAR AS [RevYear] -- Contains the School Year
	ON 
	[StudentYear].[YEAR_GU] = [RevYear].[YEAR_GU]
	
	--LEFT OUTER JOIN
	--APS.LookupTable('K12','Grade') AS [Grades]
	--ON
	--[StudentSchoolYear].[GRADE] = [Grades].[VALUE_CODE]
	
	--LEFT OUTER JOIN 
	--rev.EPC_SCH AS [School] -- Contains the School Code / Number
	--ON 
	--[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
	
WHERE
	[RevYear].[SCHOOL_YEAR] = '2014'
	AND [RevYear].[EXTENSION] = 'R'
	AND [COURSE_HISTORY].[REPEAT_TAG_GU] = '2FD0A98A-9175-44BA-9B17-55FE11A56B51'