/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 08/11/2014 $
 *
 * Request By: Andy
 * InitialRequestDate: 7/17/2014
 * 
 * This script will get a count of students currently enrolled in each School.
 * One Record Per School
 */



	SELECT
		[School].[SCHOOL_CODE]
		,[Organization].[ORGANIZATION_NAME] AS [School]
		,[Grades].[VALUE_DESCRIPTION] AS [Grade]
		,[LEVEL_INTEGRATION].[VALUE_DESCRIPTION] AS [SPED FUNDING LEVEL]
		--,[SPED_REPORT].[LEVEL_INTEGRATION]
		,COUNT ([EnrollmentsAsOf].[ENROLLMENT_GU]) AS ENROLL_COUNT
	FROM
		APS.PrimaryEnrollmentsAsOf('10/08/2014') AS [EnrollmentsAsOf]
		
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
		
		INNER JOIN
		APS.LookupTable('K12','Grade') AS [Grades]
		ON
		[StudentSchoolYear].[GRADE] = [Grades].[VALUE_CODE]	
		
		INNER JOIN
		APS.BasicStudent AS [STUDENT]
		ON
		[StudentSchoolYear].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
		
		INNER JOIN
		rev.EPC_NM_STU_SPED_RPT AS [SPED_REPORT]
		ON
		[STUDENT].[STUDENT_GU] = [SPED_REPORT].[STUDENT_GU]
		
		INNER JOIN
		APS.LookupTable ('K12.SpecialEd.IEP', 'LEVEL_INTEGRATION') AS [LEVEL_INTEGRATION]
		ON
		[SPED_REPORT].[LEVEL_INTEGRATION] = [LEVEL_INTEGRATION].[VALUE_CODE]
		
	WHERE
		[SPED_REPORT].[LEVEL_INTEGRATION] IN (3,4)
		
	GROUP BY
		[School].[SCHOOL_CODE]
		,[Organization].[ORGANIZATION_NAME]
		,[Grades].[VALUE_DESCRIPTION]
		,[LEVEL_INTEGRATION].[VALUE_DESCRIPTION]
		--,[SPED_REPORT].[LEVEL_INTEGRATION]
		
	ORDER BY
		[School].[SCHOOL_CODE]