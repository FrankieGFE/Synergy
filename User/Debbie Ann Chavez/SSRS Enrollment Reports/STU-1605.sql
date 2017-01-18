-- change @onDate to whatever enrollment date you want to use.
DECLARE @SchoolYear INT = 2016
DECLARE @Extension VARCHAR(1) ='R'
DECLARE @onDate DATE=@asOfDate
DECLARE @sameDayLastYear DATE, @CURRENT_MEMBER_DAY AS INT

SET @CURRENT_MEMBER_DAY = APS.DistrictMemberDayFromDate(@SchoolYear,@Extension,@onDate)

SET @sameDayLastYear = CONVERT(VARCHAR(10),APS.DateFromMemberDayAndSchoolYear(@SchoolYear-1,@Extension,@CURRENT_MEMBER_DAY),101)

SET @CURRENT_MEMBER_DAY = APS.DistrictMemberDayFromDate(@SchoolYear,@Extension,@onDate)

SET @sameDayLastYear = CONVERT(VARCHAR(10),APS.DateFromMemberDayAndSchoolYear(@SchoolYear-1,@Extension,@CURRENT_MEMBER_DAY),101) --, @CURRENT_MEMBER_DAY

SELECT
	[Enroll].[School_Name]
	,CONVERT(VARCHAR(10),[Enroll].[Current_Date],101) AS [Current_Date]
	,SUM([Enroll].[Current_Enrollment_Count]) AS [Current_Enrollment_Count]
	,CONVERT(VARCHAR(10),[Enroll].[Previous Year Date],101) AS [Previous Year Date]
	,SUM([Enroll].[Previous_Year_Enrollment_Count]) AS [Previous_Year_Enrollment_Count]
	,SUM([Enroll].[Enrollment Difference]) AS [Enrollment Difference]
	,[Enroll].[SCHOOL_CODE]
	,1 AS [TempValue]
FROM
(
SELECT
	1 AS [TempValue]
	,[ENROL_CONT_COMPARE].[School_Name]
	,[ENROL_CONT_COMPARE].[GRADE]
	,[ENROL_CONT_COMPARE].[Current_Date]
	,[ENROL_CONT_COMPARE].[Current_Enrollment_Count]
	,[ENROL_CONT_COMPARE].[Previous Year Date]
	,[ENROL_CONT_COMPARE].[Previous_Year_Enrollment_Count]
	,[ENROL_CONT_COMPARE].[Current_Enrollment_Count]-[ENROL_CONT_COMPARE].[Previous_Year_Enrollment_Count] AS [Enrollment Difference]
	,[ENROL_CONT_COMPARE].[VALUE_CODE]
	,[ENROL_CONT_COMPARE].[SCHOOL_CODE]
FROM
	(
	SELECT
		CASE WHEN [ENROLL_COUNT_NOW].[ORGANIZATION_NAME] IS NULL THEN [ENROLL_COUNT_LAST_YEAR].[ORGANIZATION_NAME] ELSE [ENROLL_COUNT_NOW].[ORGANIZATION_NAME] END AS [School_Name]
		,CASE WHEN [ENROLL_COUNT_NOW].[GRADE] IS NULL THEN ISNULL([ENROLL_COUNT_LAST_YEAR].[GRADE],'N/A') ELSE [ENROLL_COUNT_NOW].[GRADE] END AS [GRADE]
		,@CURRENT_MEMBER_DAY AS [Member_Day]
		,@onDate AS [Current_Date]
		,ISNULL([ENROLL_COUNT_NOW].[STUDENT_COUNT],0) AS [Current_Enrollment_Count]
		,@sameDayLastYear AS [Previous Year Date]
		,ISNULL([ENROLL_COUNT_LAST_YEAR].[STUDENT_COUNT],0) AS [Previous_Year_Enrollment_Count]
		,CASE WHEN [ENROLL_COUNT_NOW].[VALUE_CODE] IS NULL THEN [ENROLL_COUNT_LAST_YEAR].[VALUE_CODE] ELSE [ENROLL_COUNT_NOW].[VALUE_CODE] END AS [VALUE_CODE] --for ordering grade
		,[ENROLL_COUNT_NOW].[SCHOOL_CODE]
	FROM
		(
		SELECT
			COUNT([EnrollmentsNow].[STUDENT_GU]) AS [STUDENT_COUNT]
			,[OrgYear].[ORGANIZATION_GU]
			,[Organization].[ORGANIZATION_NAME]
			,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
			,[Grades].[VALUE_CODE]
			,[School].[SCHOOL_CODE]
		FROM
			APS.PrimaryEnrollmentsAsOf(@onDate) AS [EnrollmentsNow] 
			
			-- Get location year
			INNER JOIN 
			rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
			ON 
			[EnrollmentsNow].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
			
			INNER JOIN 
			rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
			ON 
			[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
			
			INNER JOIN
			[rev].[EPC_SCH] AS [School]
			ON
			[Organization].[ORGANIZATION_GU]=[School].[ORGANIZATION_GU]

			LEFT OUTER JOIN
			 APS.LookupTable('K12','Grade') AS [Grades]
			ON
			[EnrollmentsNow].[GRADE] = [Grades].[VALUE_CODE]
			
		GROUP BY
			[OrgYear].[ORGANIZATION_GU]
			,[Organization].[ORGANIZATION_NAME]
			,[School].[SCHOOL_CODE]
			,[Grades].[VALUE_DESCRIPTION]
			,[Grades].[VALUE_CODE]
			
		) AS [ENROLL_COUNT_NOW]
		
		
		FULL OUTER JOIN
		(
		SELECT
			COUNT([EnrollmentsLastYear].[STUDENT_GU]) AS [STUDENT_COUNT]
			,[OrgYear].[ORGANIZATION_GU]
			,[Organization].[ORGANIZATION_NAME]
			,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
			,[Grades].[VALUE_CODE]
			,[School].[SCHOOL_CODE]
		FROM
			APS.PrimaryEnrollmentsAsOf(@sameDayLastYear) AS [EnrollmentsLastYear] 
			
			-- Get location year
			INNER JOIN 
			rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
			ON 
			[EnrollmentsLastYear].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
			
			INNER JOIN 
			rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
			ON 
			[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
			
			INNER JOIN
			[rev].[EPC_SCH] AS [School]
			ON
			[Organization].[ORGANIZATION_GU]=[School].[ORGANIZATION_GU]

			LEFT OUTER JOIN
			 APS.LookupTable('K12','Grade') AS [Grades]
			ON
			[EnrollmentsLastYear].[GRADE] = [Grades].[VALUE_CODE]		
			
		GROUP BY
			[OrgYear].[ORGANIZATION_GU]
			,[Organization].[ORGANIZATION_NAME]
			,[School].[SCHOOL_CODE]
			,[Grades].[VALUE_DESCRIPTION]
			,[Grades].[VALUE_CODE]
			
		) AS [ENROLL_COUNT_LAST_YEAR]
		ON
		[ENROLL_COUNT_NOW].[ORGANIZATION_GU] = [ENROLL_COUNT_LAST_YEAR].[ORGANIZATION_GU]
		AND [ENROLL_COUNT_NOW].[GRADE] = [ENROLL_COUNT_LAST_YEAR].[GRADE]	
		
	) AS [ENROL_CONT_COMPARE]

) AS [Enroll]

WHERE
	[SCHOOL_CODE] IS NOT NULL
	AND
		[SCHOOL_CODE] BETWEEN 
			CASE 
				WHEN @SchoolType='Elementary' THEN '200'
				WHEN @SchoolType='Middle' THEN '400'
				WHEN @SchoolType='High' THEN '500'
			END

		AND
			CASE 
				WHEN @SchoolType='Elementary' THEN '399'
				WHEN @SchoolType='Middle' THEN '499'
				WHEN @SchoolType='High' THEN '599'
			END

GROUP BY
	[Enroll].[School_Name]
	,[Enroll].[SCHOOL_CODE]
	,CONVERT(VARCHAR(10),[Enroll].[Current_Date],101)
	,CONVERT(VARCHAR(10),[Enroll].[Previous Year Date],101)

UNION
SELECT
	'Totals' AS [School_Name]
	,CONVERT(VARCHAR(10),[Enroll].[Current_Date],101) AS [Current_Date]
	,SUM([Enroll].[Current_Enrollment_Count]) AS [Current_Enrollment_Count]
	,CONVERT(VARCHAR(10),[Enroll].[Previous Year Date],101) AS [Previous Year Date]
	,SUM([Enroll].[Previous_Year_Enrollment_Count]) AS [Previous_Year_Enrollment_Count]
	,SUM([Enroll].[Enrollment Difference]) AS [Enrollment Difference]
	,'' AS [SCHOOL_CODE]
	,2 AS [TempValue]
FROM
(
SELECT
	1 AS [TempValue]
	,[ENROL_CONT_COMPARE].[School_Name]
	,[ENROL_CONT_COMPARE].[GRADE]
	,[ENROL_CONT_COMPARE].[Current_Date]
	,[ENROL_CONT_COMPARE].[Current_Enrollment_Count]
	,[ENROL_CONT_COMPARE].[Previous Year Date]
	,[ENROL_CONT_COMPARE].[Previous_Year_Enrollment_Count]
	,[ENROL_CONT_COMPARE].[Current_Enrollment_Count]-[ENROL_CONT_COMPARE].[Previous_Year_Enrollment_Count] AS [Enrollment Difference]
	,[ENROL_CONT_COMPARE].[VALUE_CODE]
	,[ENROL_CONT_COMPARE].[SCHOOL_CODE]
FROM
	(
	SELECT
		CASE WHEN [ENROLL_COUNT_NOW].[ORGANIZATION_NAME] IS NULL THEN [ENROLL_COUNT_LAST_YEAR].[ORGANIZATION_NAME] ELSE [ENROLL_COUNT_NOW].[ORGANIZATION_NAME] END AS [School_Name]
		,CASE WHEN [ENROLL_COUNT_NOW].[GRADE] IS NULL THEN ISNULL([ENROLL_COUNT_LAST_YEAR].[GRADE],'N/A') ELSE [ENROLL_COUNT_NOW].[GRADE] END AS [GRADE]
		,@CURRENT_MEMBER_DAY AS [Member_Day]
		,@onDate AS [Current_Date]
		,ISNULL([ENROLL_COUNT_NOW].[STUDENT_COUNT],0) AS [Current_Enrollment_Count]
		,@sameDayLastYear AS [Previous Year Date]
		,ISNULL([ENROLL_COUNT_LAST_YEAR].[STUDENT_COUNT],0) AS [Previous_Year_Enrollment_Count]
		,CASE WHEN [ENROLL_COUNT_NOW].[VALUE_CODE] IS NULL THEN [ENROLL_COUNT_LAST_YEAR].[VALUE_CODE] ELSE [ENROLL_COUNT_NOW].[VALUE_CODE] END AS [VALUE_CODE] --for ordering grade
		,[ENROLL_COUNT_NOW].[SCHOOL_CODE]
	FROM
		(
		SELECT
			COUNT([EnrollmentsNow].[STUDENT_GU]) AS [STUDENT_COUNT]
			,[OrgYear].[ORGANIZATION_GU]
			,[Organization].[ORGANIZATION_NAME]
			,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
			,[Grades].[VALUE_CODE]
			,[School].[SCHOOL_CODE]
		FROM
			APS.PrimaryEnrollmentsAsOf(@onDate) AS [EnrollmentsNow] 
			
			-- Get location year
			INNER JOIN 
			rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
			ON 
			[EnrollmentsNow].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
			
			INNER JOIN 
			rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
			ON 
			[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
			
			INNER JOIN
			[rev].[EPC_SCH] AS [School]
			ON
			[Organization].[ORGANIZATION_GU]=[School].[ORGANIZATION_GU]

			LEFT OUTER JOIN
			 APS.LookupTable('K12','Grade') AS [Grades]
			ON
			[EnrollmentsNow].[GRADE] = [Grades].[VALUE_CODE]
			
		GROUP BY
			[OrgYear].[ORGANIZATION_GU]
			,[Organization].[ORGANIZATION_NAME]
			,[School].[SCHOOL_CODE]
			,[Grades].[VALUE_DESCRIPTION]
			,[Grades].[VALUE_CODE]
			
		) AS [ENROLL_COUNT_NOW]
		
		
		FULL OUTER JOIN
		(
		SELECT
			COUNT([EnrollmentsLastYear].[STUDENT_GU]) AS [STUDENT_COUNT]
			,[OrgYear].[ORGANIZATION_GU]
			,[Organization].[ORGANIZATION_NAME]
			,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
			,[Grades].[VALUE_CODE]
			,[School].[SCHOOL_CODE]
		FROM
			APS.PrimaryEnrollmentsAsOf(@sameDayLastYear) AS [EnrollmentsLastYear] 
			
			-- Get location year
			INNER JOIN 
			rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
			ON 
			[EnrollmentsLastYear].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
			
			INNER JOIN 
			rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
			ON 
			[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
			
			INNER JOIN
			[rev].[EPC_SCH] AS [School]
			ON
			[Organization].[ORGANIZATION_GU]=[School].[ORGANIZATION_GU]

			LEFT OUTER JOIN
			 APS.LookupTable('K12','Grade') AS [Grades]
			ON
			[EnrollmentsLastYear].[GRADE] = [Grades].[VALUE_CODE]		
			
		GROUP BY
			[OrgYear].[ORGANIZATION_GU]
			,[Organization].[ORGANIZATION_NAME]
			,[School].[SCHOOL_CODE]
			,[Grades].[VALUE_DESCRIPTION]
			,[Grades].[VALUE_CODE]
			
		) AS [ENROLL_COUNT_LAST_YEAR]
		ON
		[ENROLL_COUNT_NOW].[ORGANIZATION_GU] = [ENROLL_COUNT_LAST_YEAR].[ORGANIZATION_GU]
		AND [ENROLL_COUNT_NOW].[GRADE] = [ENROLL_COUNT_LAST_YEAR].[GRADE]	
		
	) AS [ENROL_CONT_COMPARE]

) AS [Enroll]

WHERE
	[SCHOOL_CODE] IS NOT NULL
	AND
		[SCHOOL_CODE] BETWEEN 
			CASE 
				WHEN @SchoolType='Elementary' THEN '200'
				WHEN @SchoolType='Middle' THEN '400'
				WHEN @SchoolType='High' THEN '500'
			END

		AND
			CASE 
				WHEN @SchoolType='Elementary' THEN '399'
				WHEN @SchoolType='Middle' THEN '499'
				WHEN @SchoolType='High' THEN '599'
			END

GROUP BY
	CONVERT(VARCHAR(10),[Enroll].[Current_Date],101)
	,CONVERT(VARCHAR(10),[Enroll].[Previous Year Date],101)