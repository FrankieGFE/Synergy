/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 05/08/2015 $
 *
 * Request By: Andy Gutierrez
 * InitialRequestDate: 05/08/2015
 * 
 * This script will pull detail enrollment information for all active students in the system
 * One Record Per Student
 */

-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[PrimaryEnrollmentDetailsAsOf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.PrimaryEnrollmentDetailsAsOf() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

ALTER FUNCTION APS.PrimaryEnrollmentDetailsAsOf(@AsOfDate DATE)
RETURNS TABLE
AS
RETURN
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
	-- Get Active Enrollments on Given Date
	APS.PrimaryEnrollmentsAsOf(@AsOfDate) AS [Enrollments] 
	
	-- Get Enrollments from SSY
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
	APS.LookupTable('K12','Grade') AS [Grades] -- Translate Grade Codes
	ON
	[StudentSchoolYear].[GRADE] = [Grades].[VALUE_CODE]
	
	INNER JOIN 
	rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
	
	LEFT JOIN
	APS.LookupTable('K12','ENTER_CODE') AS ENTER_CODE -- Enter Code Description
	ON
	[StudentSchoolYear].ENTER_CODE = ENTER_CODE.[VALUE_CODE]
	
	LEFT JOIN
	APS.LookupTable('K12','LEAVE_CODE') AS [LEAVE_CODE] -- Leave Code Description
	ON
	[StudentSchoolYear].[LEAVE_CODE] = [LEAVE_CODE].[VALUE_CODE]