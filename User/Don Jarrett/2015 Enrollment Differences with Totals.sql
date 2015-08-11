-- change @onDate to whatever enrollment date you want to use.
DECLARE @SchoolYear INT = 2015
DECLARE @Extension VARCHAR(1) ='R'
DECLARE @onDate DATE='2015-08-13'
DECLARE @sameDayLastYear DATE, @CURRENT_MEMBER_DAY AS INT

SET @CURRENT_MEMBER_DAY = APS.DistrictMemberDayFromDate(@SchoolYear,@Extension,@onDate)

SET @sameDayLastYear = CONVERT(VARCHAR(10),APS.DateFromMemberDayAndSchoolYear(@SchoolYear-1,@Extension,@CURRENT_MEMBER_DAY),101)

SET @CURRENT_MEMBER_DAY = APS.DistrictMemberDayFromDate(@SchoolYear,@Extension,@onDate)

SET @sameDayLastYear = CONVERT(VARCHAR(10),APS.DateFromMemberDayAndSchoolYear(@SchoolYear-1,@Extension,@CURRENT_MEMBER_DAY),101) --, @CURRENT_MEMBER_DAY

SELECT
	[Enroll].[School_Name]
	,[Enroll].[GRADE]
	,[Enroll].[Current_Date]
	,[Enroll].[Current_Enrollment_Count]
	,[Enroll].[Previous Year Date]
	,[Enroll].[Previous_Year_Enrollment_Count]
	,[Enroll].[Enrollment Difference]
FROM
(
SELECT
	[ENROL_CONT_COMPARE].[School_Name]
	,[ENROL_CONT_COMPARE].[GRADE]
	,[ENROL_CONT_COMPARE].[Current_Date]
	,[ENROL_CONT_COMPARE].[Current_Enrollment_Count]
	,[ENROL_CONT_COMPARE].[Previous Year Date]
	,[ENROL_CONT_COMPARE].[Previous_Year_Enrollment_Count]
	,[ENROL_CONT_COMPARE].[Current_Enrollment_Count]-[ENROL_CONT_COMPARE].[Previous_Year_Enrollment_Count] AS [Enrollment Difference]
	,[ENROL_CONT_COMPARE].[VALUE_CODE]
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
	FROM
		(
		SELECT
			COUNT([EnrollmentsNow].[STUDENT_GU]) AS [STUDENT_COUNT]
			,[OrgYear].[ORGANIZATION_GU]
			,[Organization].[ORGANIZATION_NAME]
			,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
			,[Grades].[VALUE_CODE]
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
			
			LEFT OUTER JOIN
			 APS.LookupTable('K12','Grade') AS [Grades]
			ON
			[EnrollmentsNow].[GRADE] = [Grades].[VALUE_CODE]
			
		GROUP BY
			[OrgYear].[ORGANIZATION_GU]
			,[Organization].[ORGANIZATION_NAME]
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
			
			LEFT OUTER JOIN
			 APS.LookupTable('K12','Grade') AS [Grades]
			ON
			[EnrollmentsLastYear].[GRADE] = [Grades].[VALUE_CODE]		
			
		GROUP BY
			[OrgYear].[ORGANIZATION_GU]
			,[Organization].[ORGANIZATION_NAME]
			,[Grades].[VALUE_DESCRIPTION]
			,[Grades].[VALUE_CODE]
			
		) AS [ENROLL_COUNT_LAST_YEAR]
		ON
		[ENROLL_COUNT_NOW].[ORGANIZATION_GU] = [ENROLL_COUNT_LAST_YEAR].[ORGANIZATION_GU]
		AND [ENROLL_COUNT_NOW].[GRADE] = [ENROLL_COUNT_LAST_YEAR].[GRADE]	
		
	) AS [ENROL_CONT_COMPARE]

UNION

SELECT
	[ENROL_CONT_COMPARE].[School_Name]
	,'Total' AS [GRADE]
	,[ENROL_CONT_COMPARE].[Current_Date]
	,SUM([ENROL_CONT_COMPARE].[Current_Enrollment_Count]) AS [Current_Enrollment_Count]
	,[ENROL_CONT_COMPARE].[Previous Year Date]
	,SUM([ENROL_CONT_COMPARE].[Previous_Year_Enrollment_Count]) AS [Previous_Year_Enrollment_Count]
	,SUM([ENROL_CONT_COMPARE].[Current_Enrollment_Count])-SUM([ENROL_CONT_COMPARE].[Previous_Year_Enrollment_Count]) AS [Enrollment Difference]
	,999 AS [VALUE_CODE]
FROM
	(
	SELECT
		CASE WHEN [ENROLL_COUNT_NOW].[ORGANIZATION_NAME] IS NULL THEN [ENROLL_COUNT_LAST_YEAR].[ORGANIZATION_NAME] ELSE [ENROLL_COUNT_NOW].[ORGANIZATION_NAME] END AS [School_Name]
		--,CASE WHEN [ENROLL_COUNT_NOW].[GRADE] IS NULL THEN ISNULL([ENROLL_COUNT_LAST_YEAR].[GRADE],'N/A') ELSE [ENROLL_COUNT_NOW].[GRADE] END AS [GRADE]
		,@CURRENT_MEMBER_DAY AS [Member_Day]
		,@onDate AS [Current_Date]
		,ISNULL([ENROLL_COUNT_NOW].[STUDENT_COUNT],0) AS [Current_Enrollment_Count]
		,@sameDayLastYear AS [Previous Year Date]
		,ISNULL([ENROLL_COUNT_LAST_YEAR].[STUDENT_COUNT],0) AS [Previous_Year_Enrollment_Count]
		--,CASE WHEN [ENROLL_COUNT_NOW].[VALUE_CODE] IS NULL THEN [ENROLL_COUNT_LAST_YEAR].[VALUE_CODE] ELSE [ENROLL_COUNT_NOW].[VALUE_CODE] END AS [VALUE_CODE] --for ordering grade
	FROM
		(
		SELECT
			COUNT([EnrollmentsNow].[STUDENT_GU]) AS [STUDENT_COUNT]
			,[OrgYear].[ORGANIZATION_GU]
			,[Organization].[ORGANIZATION_NAME]
			--,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
			--,[Grades].[VALUE_CODE]
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
			
			LEFT OUTER JOIN
			 APS.LookupTable('K12','Grade') AS [Grades]
			ON
			[EnrollmentsNow].[GRADE] = [Grades].[VALUE_CODE]
			
		GROUP BY
			[OrgYear].[ORGANIZATION_GU]
			,[Organization].[ORGANIZATION_NAME]
			
		) AS [ENROLL_COUNT_NOW]
		
		
		FULL OUTER JOIN
		(
		SELECT
			COUNT([EnrollmentsLastYear].[STUDENT_GU]) AS [STUDENT_COUNT]
			,[OrgYear].[ORGANIZATION_GU]
			,[Organization].[ORGANIZATION_NAME]
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
			
			LEFT OUTER JOIN
			 APS.LookupTable('K12','Grade') AS [Grades]
			ON
			[EnrollmentsLastYear].[GRADE] = [Grades].[VALUE_CODE]		
			
		GROUP BY
			[OrgYear].[ORGANIZATION_GU]
			,[Organization].[ORGANIZATION_NAME]
			
		) AS [ENROLL_COUNT_LAST_YEAR]
		ON
		[ENROLL_COUNT_NOW].[ORGANIZATION_GU] = [ENROLL_COUNT_LAST_YEAR].[ORGANIZATION_GU]
		
	) AS [ENROL_CONT_COMPARE]
	
GROUP BY
	[ENROL_CONT_COMPARE].[School_Name]
	,[ENROL_CONT_COMPARE].[Current_Date]
	,[ENROL_CONT_COMPARE].[Previous Year Date]

) AS [Enroll]

ORDER BY
	[Enroll].[School_Name]
	,[Enroll].[VALUE_CODE]
