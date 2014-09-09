/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 09/09/2014 $
 *
 * Request By: Brian
 * InitialRequestDate: 09//2014
 * 
 * This script will get a count of students currently enrolled, grouped by grade levels,and compare them to the counts from the same member day last year.
 */


DECLARE @SchoolYear NUMERIC, @Extension NVARCHAR(1), @onDate DATE, @sameDayLastYear DATE, @CURRENT_MEMBER_DAY AS INT

SET @SchoolYear = 2014
SET @Extension = 'R'
SET @onDate = GETDATE()

SET @CURRENT_MEMBER_DAY = APS.DistrictMemberDayFromDate(@SchoolYear,@Extension,@onDate)

SET @sameDayLastYear = CONVERT(VARCHAR(10),APS.DateFromMemberDayAndSchoolYear(@SchoolYear-1,@Extension,@CURRENT_MEMBER_DAY),101) --, @CURRENT_MEMBER_DAY

SELECT
	[Organization].[ORGANIZATION_NAME] AS [School_Name]
	,[ENROLL_COUNT_NOW].[GRADE]
	,@CURRENT_MEMBER_DAY AS [Member_Day]
	,@onDate AS [Current_Date]
	,[ENROLL_COUNT_NOW].[STUDENT_COUNT] AS [Current_Enrollment_Count]
	,@sameDayLastYear AS [Previous Year Date]
	,[ENROLL_COUNT_LAST_YEAR].[STUDENT_COUNT] AS [Previous_Year_Enrollment_Count]
FROM
	(
	SELECT
		COUNT([EnrollmentsNow].[STUDENT_GU]) AS [STUDENT_COUNT]
		,[OrgYear].[ORGANIZATION_GU]
		,[Grades].[ALT_CODE_1] AS [GRADE]
	FROM
		APS.PrimaryEnrollmentsAsOf(@onDate) AS [EnrollmentsNow] 
		
		-- Get location year
		INNER JOIN 
		rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
		ON 
		[EnrollmentsNow].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
		
		LEFT OUTER JOIN
		(
		SELECT
			  Val.[ALT_CODE_1]
			  ,Val.VALUE_CODE
		FROM
			  [rev].[REV_BOD_LOOKUP_DEF] AS [Def]
			  INNER JOIN
			  [rev].[REV_BOD_LOOKUP_VALUES] AS [Val]
			  ON
			  [Def].[LOOKUP_DEF_GU]=[Val].[LOOKUP_DEF_GU]
			  AND [Def].[LOOKUP_NAMESPACE]='K12'
			  AND [Def].[LOOKUP_DEF_CODE]='Grade'
		) AS [Grades]
		ON
		[EnrollmentsNow].[GRADE] = [Grades].[VALUE_CODE]
		
	GROUP BY
		[OrgYear].[ORGANIZATION_GU]
		,[Grades].[ALT_CODE_1]
	) AS [ENROLL_COUNT_NOW]
	
	
	LEFT OUTER JOIN
	(
	SELECT
		COUNT([EnrollmentsLastYear].[STUDENT_GU]) AS [STUDENT_COUNT]
		,[OrgYear].[ORGANIZATION_GU]
		,[Grades].[ALT_CODE_1] AS [GRADE]
	FROM
		APS.PrimaryEnrollmentsAsOf(@sameDayLastYear) AS [EnrollmentsLastYear] 
		
		-- Get location year
		INNER JOIN 
		rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
		ON 
		[EnrollmentsLastYear].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
		
		LEFT OUTER JOIN
		(
		SELECT
			  Val.[ALT_CODE_1]
			  ,Val.VALUE_CODE
		FROM
			  [rev].[REV_BOD_LOOKUP_DEF] AS [Def]
			  INNER JOIN
			  [rev].[REV_BOD_LOOKUP_VALUES] AS [Val]
			  ON
			  [Def].[LOOKUP_DEF_GU]=[Val].[LOOKUP_DEF_GU]
			  AND [Def].[LOOKUP_NAMESPACE]='K12'
			  AND [Def].[LOOKUP_DEF_CODE]='Grade'
		) AS [Grades]
		ON
		[EnrollmentsLastYear].[GRADE] = [Grades].[VALUE_CODE]
		
	GROUP BY
		[OrgYear].[ORGANIZATION_GU]
		,[Grades].[ALT_CODE_1]
	) AS [ENROLL_COUNT_LAST_YEAR]
	ON
	[ENROLL_COUNT_NOW].[ORGANIZATION_GU] = [ENROLL_COUNT_LAST_YEAR].[ORGANIZATION_GU]
	AND [ENROLL_COUNT_NOW].[GRADE] = [ENROLL_COUNT_LAST_YEAR].[GRADE]
	
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[ENROLL_COUNT_NOW].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
ORDER BY
	[Organization].[ORGANIZATION_NAME]