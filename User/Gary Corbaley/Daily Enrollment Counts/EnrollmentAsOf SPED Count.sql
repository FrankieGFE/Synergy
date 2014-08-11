



DECLARE @Today DATE = '08/13/2014'

	SELECT
		[School].[SCHOOL_CODE]
		,[Organization].[ORGANIZATION_NAME] AS [School]
		,COUNT ([EnrollmentsAsOf].[ENROLLMENT_GU]) AS ENROLL_COUNT
	FROM
		APS.PrimaryEnrollmentsAsOf(@Today) AS [EnrollmentsAsOf]
		
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
		
		
		
	WHERE
		[EnrollmentDetails].[ENR_USER_DD_6] IS NOT NULL
	
	GROUP BY
		[School].[SCHOOL_CODE]
		,[Organization].[ORGANIZATION_NAME]
		--,[Grades].[ALT_CODE_1]
		
	ORDER BY
		[School].[SCHOOL_CODE]
		,[Organization].[ORGANIZATION_NAME]