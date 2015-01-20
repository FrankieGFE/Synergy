/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 11/04/2014 $
 *
 * Request By: Andy
 * InitialRequestDate: 09/18/2014
 * 
 * This script checks to see if any student's school of record is marked as none primary, either ADA/ADM or Concurrent.
 
 */



DECLARE @YearGu UNIQUEIDENTIFIER
DECLARE @SchoolGu UNIQUEIDENTIFIER
DECLARE @Concurrent INT = NULL

SET @YearGu = APS.YearGUFromYearAndExtension(2014, 'R')

SELECT
		[Student].[SIS_NUMBER]
		,[Student].[FIRST_NAME]
		,[Student].[LAST_NAME]
		,[Student].[MIDDLE_NAME]
		,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
		,[School].[SCHOOL_CODE]
		,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
		,[STUDENT_SCHOOL_YEAR].[ENTER_DATE]
		,[STUDENT_SCHOOL_YEAR].[LEAVE_DATE]
		,[STUDENT_SCHOOL_YEAR].[EXCLUDE_ADA_ADM]
		,CASE WHEN [STUDENT_SCHOOL_YEAR].[EXCLUDE_ADA_ADM] = 2 THEN 'CONCURRENT'
		WHEN [STUDENT_SCHOOL_YEAR].[EXCLUDE_ADA_ADM] = 1 THEN 'ADA ADM'
		ELSE NULL END AS [CONCURRENT]
FROM
		rev.[EPC_STU_YR] AS [STUDENT_YEAR] -- School of Record

		INNER JOIN
		rev.[EPC_STU_SCH_YR] AS [STUDENT_SCHOOL_YEAR]
		ON
		[STUDENT_YEAR].[STU_SCHOOL_YEAR_GU] = [STUDENT_SCHOOL_YEAR].[STUDENT_SCHOOL_YEAR_GU]

		INNER JOIN 
		rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
		ON 
		[STUDENT_SCHOOL_YEAR].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]

		INNER JOIN 
		rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
		ON 
		[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
		
		INNER JOIN 
		rev.EPC_SCH AS [School] -- Contains the School Code / Number
		ON 
		[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
		
		LEFT OUTER JOIN
		APS.LookupTable('K12','Grade') AS [Grades]
		ON
		[STUDENT_SCHOOL_YEAR].[GRADE] = [Grades].[VALUE_CODE]
		
		INNER JOIN
		APS.BasicStudent AS [Student] -- Contains Student ID State ID Language Code Cohort Year
		ON 
		[STUDENT_SCHOOL_YEAR].[STUDENT_GU] = [Student].[STUDENT_GU]
       
WHERE
		[STUDENT_YEAR].[YEAR_GU] = @YearGu
		AND [STUDENT_SCHOOL_YEAR].[EXCLUDE_ADA_ADM] IS NOT NULL -- Only get none NULL values
		AND [STUDENT_SCHOOL_YEAR].[EXCLUDE_ADA_ADM] = COALESCE (@Concurrent,[STUDENT_SCHOOL_YEAR].[EXCLUDE_ADA_ADM]) -- Match user's choice, or get all values
		AND [Organization].[ORGANIZATION_GU] = COALESCE (@Concurrent,[Organization].[ORGANIZATION_GU]) -- Match user's choice, or get all values
