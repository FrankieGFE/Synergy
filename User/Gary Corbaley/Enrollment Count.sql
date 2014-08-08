/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 07/22/2014 $
 *
 * Request By: Andy
 * InitialRequestDate: 7/17/2014
 * 
 * This script will get the count of students enrolled in the 2014 school year from the Synergy system.
 */

USE [ST_Experiment]

DECLARE @AsOfDate DATETIME = GETDATE()

SELECT	
		School.SCHOOL_CODE
		,Organization.ORGANIZATION_NAME
		,COUNT (*)AS ENROLL_COUNT
	FROM
	APS.PrimaryEnrollmentsAsOf(@AsOfDate) AS [EnrollmentsAsOf]
	
	INNER JOIN 
	rev.EPC_STU_ENROLL AS [EnrollmentDetails] -- Contains Grade and Start Date
	ON 
	[EnrollmentsAsOf].[ENROLLMENT_GU] = [EnrollmentDetails].[ENROLLMENT_GU]
	
	INNER JOIN
	rev.EPC_STU_SCH_YR AS [StudentSchoolYear] -- Contains Grade and Start Date 	
	ON
	[EnrollmentDetails].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
	
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
	
	INNER JOIN 
	rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	[OrgYear].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]

GROUP BY 
	School.SCHOOL_CODE
	,Organization.ORGANIZATION_NAME
	
ORDER BY School.SCHOOL_CODE