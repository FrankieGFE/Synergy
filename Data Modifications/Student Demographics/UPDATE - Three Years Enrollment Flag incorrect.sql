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
SELECT
	*
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
		(	
		SELECT
			[STUDENT_GU]
			,COUNT([SCHOOL_YEAR]) AS [ENROLLMENT_YEARS]
		FROM
			(	
			SELECT DISTINCT
				[StudentSchoolYear].[STUDENT_GU]
				,[RevYear].[SCHOOL_YEAR]
			FROM
				rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
				
				INNER JOIN 
				rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
				ON 
				[StudentSchoolYear].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
				
				INNER JOIN 
				rev.REV_YEAR AS [RevYear] -- Contains the School Year
				ON 
				[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
					
			) AS [STUDENT_YEARS]

		GROUP BY
			[STUDENT_GU]
		) AS [STUDENT_YEARS_ENROLLED]
		
		INNER JOIN
		rev.[EPC_STU] AS [STUDENT]
		ON
		[STUDENT_YEARS_ENROLLED].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
		
		INNER JOIN
		rev.[REV_PERSON] AS [PERSON]
		ON
		[STUDENT_YEARS_ENROLLED].[STUDENT_GU] = [PERSON].[PERSON_GU]
		
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
		
		LEFT JOIN 
		rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
		ON 
		[LAST_ENROLLED_SSY].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
		
		INNER JOIN 
		rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
		ON 
		[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
		
		LEFT JOIN 
		rev.REV_YEAR AS [RevYear] -- Contains the School Year
		ON 
		[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
		
		LEFT JOIN 
		rev.EPC_SCH AS [School] -- Contains the School Code / Number
		ON 
		[OrgYear].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
		
		LEFT JOIN
		APS.LookupTable('K12','Grade') AS [Grades]
		ON
		[LAST_ENROLLED_SSY].[GRADE] = [Grades].[VALUE_CODE]
		
	WHERE
		[STUDENT_YEARS_ENROLLED].[ENROLLMENT_YEARS] >= 3
		AND [STUDENT].[ENROLL_LESS_THREE_OVR] = 'Y'
		AND [Grades].[VALUE_DESCRIPTION] = '04'
		
	) AS [MATCHED_FLAGS]
	ON
	[STUDENT].[STUDENT_GU] = [MATCHED_FLAGS].[STUDENT_GU]

ROLLBACK