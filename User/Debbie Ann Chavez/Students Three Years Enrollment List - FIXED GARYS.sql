SELECT STUDENT.SIS_NUMBER, GRADE_LEVEL, SCHOOL_NAME, STUDENT.[ENROLL_LESS_THREE_OVR], LAST_ENROLLED, NEW_FLAG_VALUE
FROM
	(
	SELECT
		[STUDENT].[SIS_NUMBER]
		,[STUDENT].[STUDENT_GU]
		,[STUDENT].[ENROLL_LESS_THREE_OVR]
		,[STUDENT_YEARS_ENROLLED].[ENROLLMENT_YEARS]
		,[PERSON].[LAST_NAME]
		,[PERSON].[FIRST_NAME]
		,[School].[SCHOOL_CODE]well 
		,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
		--,[RevYear].[SCHOOL_YEAR]
		,[Grades].[VALUE_CODE]
		,[Grades].[VALUE_DESCRIPTION] AS [GRADE_LEVEL]
		--,[LAST_ENROLLED_SSY].*
		,CASE
			WHEN [Grades].[VALUE_DESCRIPTION] IN ('K','01','02') AND [STUDENT].[ENROLL_LESS_THREE_OVR] = 'N' THEN 'Y'
			WHEN [Grades].[VALUE_DESCRIPTION] = '03' AND [STUDENT].[ENROLL_LESS_THREE_OVR] = 'Y' AND [STUDENT_YEARS_ENROLLED].[ENROLLMENT_YEARS] >= 3 THEN 'N'
			WHEN [Grades].[VALUE_DESCRIPTION] = '04' AND [STUDENT].[ENROLL_LESS_THREE_OVR] = 'Y' AND [STUDENT_YEARS_ENROLLED].[ENROLLMENT_YEARS] >= 3 THEN 'N'
			ELSE [STUDENT].[ENROLL_LESS_THREE_OVR]
		END AS [NEW_FLAG_VALUE]
		--,YEAR(GETDATE()) AS [CURRENT_YEAR]
		
		--,[RevYear].*
		
		,[RevYear].[SCHOOL_YEAR] AS [LAST_ENROLLED]
		
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
				,[RevYear].[EXTENSION]
				,[OrgYear].[YEAR_GU]
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
			WHERE
				[StudentSchoolYear].[GRADE] >= 100 --Grade 04
				AND [OrgYear].[YEAR_GU] NOT IN (SELECT [YEAR_GU] FROM APS.YearDates WHERE [END_DATE] >= GETDATE())
				AND [RevYear].[EXTENSION] NOT IN ('S','N')
				--AND [StudentSchoolYear].[STUDENT_GU] = '382EA4E3-B45E-44A7-A548-1535BDBB58A0'
					
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
			,ROW_NUMBER() OVER (PARTITION BY [STUDENT_GU] ORDER BY [ENTER_DATE] DESC, EXCLUDE_ADA_ADM) AS RN
		FROM
			rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
		WHERE
			[StudentSchoolYear].[YEAR_GU] = 'F7D112F7-354D-4630-A4BC-65F586BA42EC'

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
		--[STUDENT_YEARS_ENROLLED].[ENROLLMENT_YEARS] = 3
		--AND [STUDENT].[ENROLL_LESS_THREE_OVR] = 'Y'
		(([Grades].[VALUE_DESCRIPTION] IN ('K','01','02') AND [STUDENT].[ENROLL_LESS_THREE_OVR] = 'N')
		OR
		([Grades].[VALUE_DESCRIPTION] = '03' AND [STUDENT].[ENROLL_LESS_THREE_OVR] = 'Y' AND [STUDENT_YEARS_ENROLLED].[ENROLLMENT_YEARS] >= 3)
		OR	
		([Grades].[VALUE_DESCRIPTION] = '04' AND [STUDENT].[ENROLL_LESS_THREE_OVR] = 'Y' AND [STUDENT_YEARS_ENROLLED].[ENROLLMENT_YEARS] >= 3))
		
		--AND [STUDENT].[SIS_NUMBER] = '970088178'
		
		--AND [RevYear].[SCHOOL_YEAR] = '2016'
	) AS [THREE_YEARS]
	
	INNER JOIN
	rev.[EPC_STU] AS [STUDENT]
	ON
	[THREE_YEARS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
