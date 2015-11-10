
/**
 * 
 * $LastChangedBy: Debbie Chavez
 * $LastChangedDate: 11/10/2015 $
 */


IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[APS].[StudentEnrollmentDetails]'))
	EXEC ('CREATE VIEW APS.StudentEnrollmentDetails AS SELECT 0 AS DUMMY')
GO

ALTER VIEW [APS].[StudentEnrollmentDetails] AS

SELECT	
	[School].[SCHOOL_CODE]
	,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	,[StudentSchoolYear].[ENTER_DATE]
	,[StudentSchoolYear].[ENTER_CODE]
	,[ENTER_CODE].[VALUE_DESCRIPTION] AS [ENTER_DESCRIPTION]
	,[StudentSchoolYear].[LEAVE_DATE]
	,[StudentSchoolYear].[LEAVE_CODE]
	,[LEAVE_CODE].[VALUE_DESCRIPTION] AS [LEAVE_DESCRIPTION]
	,[StudentSchoolYear].[SUMMER_WITHDRAWL_CODE]
	,[StudentSchoolYear].[YEAR_END_STATUS]
	,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
	,[Grades].[LIST_ORDER]
	,[StudentSchoolYear].[EXCLUDE_ADA_ADM]
	,[StudentSchoolYear].[ACCESS_504]
	,CASE WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 2 THEN 'CONCURRENT'
		WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 1 THEN 'NO ADA/ADM'
		ELSE '' END AS [CONCURRENT]	
	,[RevYear].[SCHOOL_YEAR]
	,[RevYear].[EXTENSION]
	,[StudentSchoolYear].[STUDENT_GU]
	,[StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
	,[StudentSchoolYear].[ORGANIZATION_YEAR_GU]
	,[Organization].[ORGANIZATION_GU]
	,[OrgYear].[YEAR_GU]
	,[StudentSchoolYear].[HOMEROOM_SECTION_GU]
	
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
	
	LEFT JOIN
	APS.LookupTable('K12,Enrollment','ENTER_CODE') AS ENTER_CODE
	ON
	[StudentSchoolYear].ENTER_CODE = ENTER_CODE.[VALUE_CODE]
	
	LEFT JOIN
	APS.LookupTable('K12.Enrollment','LEAVE_CODE') AS [LEAVE_CODE]
	ON
	[StudentSchoolYear].[LEAVE_CODE] = [LEAVE_CODE].[VALUE_CODE]



