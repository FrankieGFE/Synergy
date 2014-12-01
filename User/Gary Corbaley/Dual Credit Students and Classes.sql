

; WITH 
-- From Student School Year [EPC_STU_SCH_YR]
SSY_ENROLLMENTS AS
(
SELECT
	[StudentSchoolYear].[STUDENT_GU]
	,[StudentSchoolYear].[ORGANIZATION_YEAR_GU]
	,[Organization].[ORGANIZATION_GU]
	,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
	,[School].[SCHOOL_CODE]
	,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	,[StudentSchoolYear].[ENTER_DATE]
	,[StudentSchoolYear].[LEAVE_DATE]
	,[StudentSchoolYear].[EXCLUDE_ADA_ADM]
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
	
WHERE
	[StudentSchoolYear].[NO_SHOW_STUDENT] = 'N'
)


SELECT DISTINCT--TOP 100
	[STUDENT].[SIS_NUMBER]
	--,[SCHEDULE].[STUDENT_GU]
	,[PERSON].[FIRST_NAME]
	,[PERSON].[LAST_NAME]
	,[PERSON].[MIDDLE_NAME]
	--,CASE WHEN [Organization].[ORGANIZATION_NAME] IS NULL THEN [Organization_S].[ORGANIZATION_NAME] ELSE [Organization].[ORGANIZATION_NAME] END AS [SOR_NAME]
	--,[Organization].[ORGANIZATION_NAME]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,[ENROLLMENT_ENTER_DATE]
	,[ENROLLMENT_LEAVE_DATE]
	,[COURSE].[COURSE_ID]
	,[COURSE].[COURSE_TITLE]
	,[SCHEDULE].[COURSE_ENTER_DATE]
	,[SCHEDULE].[COURSE_LEAVE_DATE]
	,[SCHEDULE].[SECTION_ID]
	,[SCHEDULE].[TERM_CODE]
	,[COURSE].[DUAL_CREDIT]
	,[COURSE].[OTHER_PROVIDER_NAME]
	,[COURSE].[CREDIT]
	
	--,[ENROLLMENTS].*
	
FROM
	APS.BasicSchedule AS [SCHEDULE]
	
	INNER JOIN
	rev.EPC_CRS AS [COURSE]
	ON
	[SCHEDULE].[COURSE_GU] = [COURSE].[COURSE_GU]
	
	INNER JOIN 
	rev.REV_YEAR AS [RevYear] -- Contains the School Year
	ON 
	[SCHEDULE].[YEAR_GU] = [RevYear].[YEAR_GU]
	
	INNER JOIN
	rev.EPC_STU AS [STUDENT]
	ON
	[SCHEDULE].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	INNER JOIN
	rev.REV_PERSON AS [PERSON]
	ON
	[SCHEDULE].[STUDENT_GU] = [PERSON].[PERSON_GU]
	
	--LEFT OUTER JOIN
	--APS.PrimaryEnrollmentsAsOF(GETDATE()) AS [ENROLLMENTS]
	--ON
	--[SCHEDULE].[STUDENT_GU] = [ENROLLMENTS].[STUDENT_GU]
	
	--LEFT OUTER JOIN 
	--rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
	--ON 
	--[ENROLLMENTS].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
	
	--LEFT OUTER JOIN 
	--rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	--ON 
	--[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	--LEFT OUTER JOIN 
	--rev.REV_ORGANIZATION_YEAR AS [OrgYear_S] -- Links between School and Year
	--ON 
	--[SCHEDULE].[ORGANIZATION_YEAR_GU] = [OrgYear_S].[ORGANIZATION_YEAR_GU]
	
	--LEFT OUTER JOIN 
	--rev.REV_ORGANIZATION AS [Organization_S] -- Contains the School Name
	--ON 
	--[OrgYear_S].[ORGANIZATION_GU] = [Organization_S].[ORGANIZATION_GU]
	
	LEFT OUTER JOIN
	SSY_ENROLLMENTS AS [ENROLLMENTS]
	ON
	[SCHEDULE].[STUDENT_GU] = [ENROLLMENTS].[STUDENT_GU]
	
WHERE
	([COURSE].[DUAL_CREDIT] = 'Y' OR [COURSE].[OTHER_PROVIDER_NAME] IN ('CNM','UNM'))
	AND [ENROLLMENTS].[SCHOOL_YEAR] = '2014'
	AND [ENROLLMENTS].[EXTENSION] = 'R'
	AND [RevYear].[SCHOOL_YEAR] = '2014'
	AND [RevYear].[EXTENSION] = 'R'
	AND [ENROLLMENTS].[EXCLUDE_ADA_ADM] IS NULL
	--AND [STUDENT].[SIS_NUMBER] = '970063636' --'102757721'
	AND [SCHEDULE].[TERM_CODE] IN ('S1','T1')