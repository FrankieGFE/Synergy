/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 09/18/2014 $
 *
 * Request By: Andy
 * InitialRequestDate: 09/18/2014
 * 
 * This script will get a list of all students with a single active enrollment that is also marked as Concurrent.
 */


SELECT 
	[ENROLL_DETAIL].[SIS_NUMBER]
	,[ENROLL_DETAIL].[LAST_NAME]
	,[ENROLL_DETAIL].[FIRST_NAME]
	,[ENROLL_DETAIL].[MIDDLE_NAME]
	,[ENROLL_DETAIL].[GRADE]
	,[ENROLL_DETAIL].[SCHOOL_CODE]
	,[ENROLL_DETAIL].[School]
	,[ENROLL_DETAIL].[ENTER_DATE]
	,[ENROLL_DETAIL].[LEAVE_DATE]
	,[ENROLL_DETAIL].[EXCLUDE_ADA_ADM]
	,CASE WHEN [ENROLL_DETAIL].[EXCLUDE_ADA_ADM] = 2 THEN 'CONCURRENT'
		WHEN [ENROLL_DETAIL].[EXCLUDE_ADA_ADM] = 1 THEN 'ADA ADM'
		ELSE NULL END AS [CONCURRENT]
FROM
	(
	SELECT
		[STUDENT_GU]
		,SUM(RN) AS [ENROLLMENT_COUNT]
	FROM
		(
		SELECT
			[StudentSchoolYear].[STUDENT_GU]
			,[RevYear].[SCHOOL_YEAR]
			,[RevYear].[EXTENSION]
			,[StudentSchoolYear].[ENTER_DATE]
			,[StudentSchoolYear].[LEAVE_DATE]
			,ROW_NUMBER() OVER (PARTITION BY [StudentSchoolYear].[STUDENT_GU] ORDER BY [EnrollmentDetails].[ENTER_DATE]) AS RN
		FROM
			rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
			
			LEFT OUTER JOIN
			rev.EPC_STU_ENROLL AS [EnrollmentDetails]
			ON
			[StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU] = [EnrollmentDetails].[STUDENT_SCHOOL_YEAR_GU]
			
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
			
		WHERE
			[RevYear].[SCHOOL_YEAR] = 2014
			AND [RevYear].[EXTENSION] = 'R'
			AND [StudentSchoolYear].[ENTER_DATE] IS NOT NULL
			AND [StudentSchoolYear].[LEAVE_DATE] IS NULL
		) AS [STU_ENROLL]
	GROUP BY
		[STUDENT_GU]
	) AS [STU_ENROLL_COUNT]
	
	INNER JOIN
	(
	SELECT
		[StudentSchoolYear].[STUDENT_GU]
		,[Student].[SIS_NUMBER]
		,[Student].[LAST_NAME]
		,[Student].[FIRST_NAME]
		,[Student].[MIDDLE_NAME]
		,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
		,[School].[SCHOOL_CODE]
		,[Organization].[ORGANIZATION_NAME] AS [School]
		,[StudentSchoolYear].[ENTER_DATE]
		,[StudentSchoolYear].[LEAVE_DATE]
		,[EnrollmentDetails].[EXCLUDE_ADA_ADM]
	FROM
		
		rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
		
		LEFT OUTER JOIN
		rev.EPC_STU_ENROLL AS [EnrollmentDetails]
		ON
		[StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU] = [EnrollmentDetails].[STUDENT_SCHOOL_YEAR_GU]
		
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
		APS.BasicStudent AS [Student] -- Contains Student ID State ID Language Code Cohort Year
		ON 
		[StudentSchoolYear].[STUDENT_GU] = [Student].[STUDENT_GU]
		
		LEFT OUTER JOIN
		APS.LookupTable('K12','Grade') AS [Grades]
		ON
		[StudentSchoolYear].[GRADE] = [Grades].[VALUE_CODE]
		
		INNER JOIN 
		rev.EPC_SCH AS [School] -- Contains the School Code / Number
		ON 
		[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
	
	WHERE
		[RevYear].[SCHOOL_YEAR] = 2014
		AND [RevYear].[EXTENSION] = 'R'
		AND [StudentSchoolYear].[ENTER_DATE] IS NOT NULL
		AND [StudentSchoolYear].[LEAVE_DATE] IS NULL
	) AS [ENROLL_DETAIL]
	ON
	[STU_ENROLL_COUNT].[STUDENT_GU] = [ENROLL_DETAIL].[STUDENT_GU]
	
WHERE
	[STU_ENROLL_COUNT].[ENROLLMENT_COUNT] = 1
	AND [ENROLL_DETAIL].[EXCLUDE_ADA_ADM] IS NOT NULL
	--AND [ENROLL_DETAIL].[SIS_NUMBER] = '970103026'

ORDER BY
	[ENROLL_DETAIL].[LAST_NAME]
	,[ENROLL_DETAIL].[FIRST_NAME]

