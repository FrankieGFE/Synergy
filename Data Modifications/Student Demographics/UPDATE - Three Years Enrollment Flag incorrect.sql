/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 10/06/2014
 *
 * Request By: Andy Gutierrez
 * InitialRequestDate: 10/02/2014
 * 
 * Initial Request: Indentify 4th graders who have their '3 years of enrollments' flag checked and reset them to unchecked.  
 *
 *
 * Tables Referenced: EPC_STU, REV_PERSON, EPC_STU_SCH_YR, REV_ORGANIZATION_YEAR, REV_YEAR
 */

	
BEGIN TRAN

UPDATE rev.[EPC_STU]
	SET [ENROLL_LESS_THREE_OVR] = 'N'
	
FROM
	rev.[EPC_STU] AS [STUDENT]
	
	INNER JOIN
	(
	SELECT
		[STUDENT].[SIS_NUMBER]
		,[STUDENT].[STUDENT_GU]
		,[STUDENT].[ENROLL_LESS_THREE_OVR]
		,[STUDENT_YEARS_ENROLLED].[ENROLLMENT_YEARS]
		,[PERSON].[LAST_NAME]
		,[PERSON].[FIRST_NAME]
		,[School].[SCHOOL_CODE]
		,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
		,[Grades].[VALUE_DESCRIPTION] AS [GRADE_LEVEL]
	FROM
		-- Get student enrollment counts for regular years only	
		(	
		SELECT
			[StudentYear].[STUDENT_GU]
			,COUNT([RevYear].[SCHOOL_YEAR]) AS [ENROLLMENT_YEARS]
		FROM
			rev.EPC_STU_YR AS [StudentYear] -- School of record
			
			INNER JOIN 
			rev.REV_YEAR AS [RevYear] -- Contains the School Year
			ON 
			[StudentYear].[YEAR_GU] = [RevYear].[YEAR_GU]
			AND [RevYear].[EXTENSION] = 'R'	 -- Regular school year only			
		GROUP BY
			[StudentYear].[STUDENT_GU]
		) AS [STUDENT_YEARS_ENROLLED]
		
		-- Get student details
		INNER JOIN
		rev.[EPC_STU] AS [STUDENT]
		ON
		[STUDENT_YEARS_ENROLLED].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
		
		-- Get the student full name
		INNER JOIN
		rev.[REV_PERSON] AS [PERSON]
		ON
		[STUDENT_YEARS_ENROLLED].[STUDENT_GU] = [PERSON].[PERSON_GU]

		-- Get most recent student school year record				
		LEFT OUTER JOIN
		(
		SELECT
			*
			,ROW_NUMBER() OVER (PARTITION BY [STUDENT_GU] ORDER BY [ENTER_DATE] DESC) AS RN
		FROM
			rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
		) AS [LAST_ENROLLED_SSY]
		ON
		[STUDENT].[STUDENT_GU] = [LAST_ENROLLED_SSY].[STUDENT_GU]
		AND [LAST_ENROLLED_SSY].[RN] = 1
		
		-- Get organization year
		LEFT JOIN 
		rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
		ON 
		[LAST_ENROLLED_SSY].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
		
		-- Get school name
		INNER JOIN 
		rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
		ON 
		[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
		
		-- Get the school year
		LEFT JOIN 
		rev.REV_YEAR AS [RevYear] -- Contains the School Year
		ON 
		[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
		
		-- Get school number
		LEFT JOIN 
		rev.EPC_SCH AS [School] -- Contains the School Code / Number
		ON 
		[OrgYear].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
		
		-- Get grade level conversion
		LEFT JOIN
		APS.LookupTable('K12','Grade') AS [Grades]
		ON
		[LAST_ENROLLED_SSY].[GRADE] = [Grades].[VALUE_CODE]
		
	WHERE
		[STUDENT_YEARS_ENROLLED].[ENROLLMENT_YEARS] >= 3
		AND [RevYear].[EXTENSION] = 'R'
		AND [STUDENT].[ENROLL_LESS_THREE_OVR] = 'Y'
		AND [Grades].[VALUE_DESCRIPTION] = '04'
		
	) AS [MATCHED_FLAGS]
	ON
	[STUDENT].[STUDENT_GU] = [MATCHED_FLAGS].[STUDENT_GU]

ROLLBACK