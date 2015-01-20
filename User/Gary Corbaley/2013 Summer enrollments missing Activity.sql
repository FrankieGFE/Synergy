




SELECT	
	--[EnrollmentActivity].*
	--[StudentSchoolYear].*
	--[RevYear].*
	[Student].[SIS_NUMBER]
	,[Student].[LAST_NAME]
	,[Student].[FIRST_NAME]
	,[Student].[MIDDLE_NAME]
	,[Grades].[ALT_CODE_1] AS [GRADE]
	,[School].[SCHOOL_CODE]
	,[Organization].[ORGANIZATION_NAME] AS [School]
	,[RevYear].[SCHOOL_YEAR]
	,[RevYear].[EXTENSION]
	,[StudentSchoolYear].[ENTER_DATE]
	,[StudentSchoolYear].[LEAVE_DATE]
	,[EnrollmentDetails].[ENROLLMENT_GU]
	,[StudentSchoolYear].[SUMMER_WITHDRAWL_CODE]
FROM
	--rev.EPC_STU_ENROLL AS [EnrollmentDetails]
	rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
	
	LEFT OUTER JOIN
	rev.EPC_STU_ENROLL AS [EnrollmentDetails]
	ON
	[StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU] = [EnrollmentDetails].[STUDENT_SCHOOL_YEAR_GU]
	
	LEFT OUTER JOIN
	rev.EPC_STU_ENROLL_ACTIVITY AS [EnrollmentActivity]
	ON
	[EnrollmentDetails].[ENROLLMENT_GU] = [EnrollmentActivity].[ENROLLMENT_GU]
	
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
	[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
	
	LEFT OUTER JOIN
	APS.BasicStudent AS [Student] -- Contains Student ID State ID Language Code Cohort Year
	ON 
	[StudentSchoolYear].[STUDENT_GU] = [Student].[STUDENT_GU]
	
	LEFT OUTER JOIN
	(
	SELECT
		  Val.[ALT_CODE_1]
		  ,Val.VALUE_CODE
	FROM
		  [rev].[REV_BOD_LOOKUP_DEF] AS [Def]
		  INNER JOIN
		  [rev].[REV_BOD_LOOKUP_VALUES] AS [Val]
		  ON
		  [Def].[LOOKUP_DEF_GU]=[Val].[LOOKUP_DEF_GU]
		  AND [Def].[LOOKUP_NAMESPACE]='K12'
		  AND [Def].[LOOKUP_DEF_CODE]='Grade'
	) AS [Grades]
	ON
	[StudentSchoolYear].[GRADE] = [Grades].[VALUE_CODE]
	
	LEFT OUTER JOIN 
	rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
	
WHERE
	[RevYear].[SCHOOL_YEAR] = 2013
	AND [RevYear].[EXTENSION] = 'S'
	--AND [StudentSchoolYear].[YEAR_END_STATUS] IS NULL
	--AND [EnrollmentActivity].[ENROLLMENT_ACTIVITY_GU] IS NULL
	AND [Grades].[ALT_CODE_1] IS NULL
	
	--AND [Student].[LAST_NAME] = 'Rubio'