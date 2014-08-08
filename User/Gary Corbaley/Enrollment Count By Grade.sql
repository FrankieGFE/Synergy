/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 08/08/2014 $
 *
 * Request By: Andy
 * InitialRequestDate: 7/17/2014
 * 
 * This script will get a count of students currently enrolled, grouped by grade levels, from the Synergy system and compare them to the counts from the same day last year in the School Max system.
 */
 
USE [PR]
 
--Change the variable @Today if you want to check another member day
DECLARE 
		--@Today DATE = GETDATE()
		@Today DATE = '2014-08-14 00:00:00.000'
		,@MemberDay INT 
		,@CurrentSchoolYear INT
		,@DayLastYear DATE
		
--Set variables
SET @MemberDay = APS.MemberDayFromDate(1, @Today)
SET @CurrentSchoolYear = APS.SchoolYearFromDate(@Today)
SET @DayLastYear = APS.DateFromMemberDayAndSchoolYear(1,@CurrentSchoolYear-1,@MemberDay)
	

SELECT
	[SYNERGY_COUNTS].SCHOOL_CODE
	,[SYNERGY_COUNTS].School
	,[SYNERGY_COUNTS].[Grade]
	,[SYNERGY_COUNTS].[ENROLL_COUNT] AS [Today's Enroll Count]
	,CASE WHEN [SMAX_COUNTS].[LastYearCount] IS NULL THEN 0 ELSE [SMAX_COUNTS].[LastYearCount] END AS [Same Day Last Year]
	,[SYNERGY_COUNTS].[ENROLL_COUNT] - CASE WHEN [SMAX_COUNTS].[LastYearCount] IS NULL THEN 0 ELSE [SMAX_COUNTS].[LastYearCount] END AS [Count Difference]
FROM
	(
	SELECT
		[School].[SCHOOL_CODE]
		,[Organization].[ORGANIZATION_NAME] AS [School]
		,[Grades].[ALT_CODE_1] AS [Grade]
		,COUNT ([EnrollmentsAsOf].[ENROLLMENT_GU]) AS ENROLL_COUNT
	FROM
		OPENQUERY([SYNSECONDDB.APS.EDU.ACTD],'SELECT * FROM  [ST_Experiment].APS.PrimaryEnrollmentsAsOf(''08/14/2014'')') AS [EnrollmentsAsOf]
		
		INNER JOIN 
		[SYNSECONDDB.APS.EDU.ACTD].[ST_Experiment].rev.EPC_STU_ENROLL AS [EnrollmentDetails] -- Contains Grade and Start Date
		ON 
		[EnrollmentsAsOf].[ENROLLMENT_GU] = [EnrollmentDetails].[ENROLLMENT_GU]
		
		INNER JOIN
		[SYNSECONDDB.APS.EDU.ACTD].[ST_Experiment].rev.EPC_STU_SCH_YR AS [StudentSchoolYear] -- Contains Grade and Start Date 	
		ON
		[EnrollmentDetails].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
		
		INNER JOIN 
		[SYNSECONDDB.APS.EDU.ACTD].[ST_Experiment].rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
		ON 
		[StudentSchoolYear].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
		
		INNER JOIN 
		[SYNSECONDDB.APS.EDU.ACTD].[ST_Experiment].rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
		ON 
		[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
		
		INNER JOIN 
		[SYNSECONDDB.APS.EDU.ACTD].[ST_Experiment].rev.REV_YEAR AS [RevYear] -- Contains the School Year
		ON 
		[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
		
		INNER JOIN 
		[SYNSECONDDB.APS.EDU.ACTD].[ST_Experiment].rev.EPC_SCH AS [School] -- Contains the School Code / Number
		ON 
		[OrgYear].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
		
		LEFT OUTER JOIN
		(
		SELECT
			  Val.[ALT_CODE_1]
			  ,Val.VALUE_CODE
		FROM
			  [SYNSECONDDB.APS.EDU.ACTD].[ST_Experiment].[rev].[REV_BOD_LOOKUP_DEF] AS [Def]
			  INNER JOIN
			  [SYNSECONDDB.APS.EDU.ACTD].[ST_Experiment].[rev].[REV_BOD_LOOKUP_VALUES] AS [Val]
			  ON
			  [Def].[LOOKUP_DEF_GU]=[Val].[LOOKUP_DEF_GU]
			  AND [Def].[LOOKUP_NAMESPACE]='K12'
			  AND [Def].[LOOKUP_DEF_CODE]='Grade'
		) AS [Grades]
		ON
		[EnrollmentDetails].[GRADE] = [Grades].[VALUE_CODE]
	    
		INNER JOIN 
		[SYNSECONDDB.APS.EDU.ACTD].[ST_Experiment].rev.EPC_STU AS [Student] -- Contains Student ID State ID Language Code Cohort Year
		ON 
		[StudentSchoolYear].[STUDENT_GU] = [Student].[STUDENT_GU]
	
	GROUP BY
		[School].[SCHOOL_CODE]
		,[Organization].[ORGANIZATION_NAME]
		,[Grades].[ALT_CODE_1]

	) AS [SYNERGY_COUNTS]
	
	LEFT OUTER JOIN
	(
	SELECT
		@Today AS TODAY
		,SchoolGrades.SCH_NBR AS SchoolNumber
		,School.SCH_NME AS School
		,SchoolGrades.GRDE
		,ISNULL(LastYear.TheCount,0) AS LastYearCount
		,ISNULL(ThisYear.TheCount,0) AS ThisYearCount
		,ISNULL(ThisYear.TheCount,0) - ISNULL(LastYear.TheCount,0) AS [CountDifference]
	FROM
		(
		SELECT
			DISTINCT SCH_NBR, GRDE
		FROM
			APS.PrimaryEnrollmentsAsOf(@Today)
		WHERE
			DST_NBR = 1

		UNION

		SELECT
			DISTINCT SCH_NBR, GRDE
		FROM
			APS.PrimaryEnrollmentsAsOf(@DayLastYear)
		WHERE
			DST_NBR = 1
		) AS SchoolGrades
		
		LEFT JOIN
		(
		SELECT
			SCH_NBR
			,GRDE
			,COUNT(*) AS TheCount
		FROM
			APS.PrimaryEnrollmentsAsOf(@DayLastYear) 
		WHERE
			DST_NBR = 1
		GROUP BY
			SCH_NBR
			,GRDE		
		) AS LastYear
		
		ON	
		SchoolGrades.SCH_NBR = LastYear.SCH_NBR
		AND SchoolGrades.GRDE = LastYear.GRDE
		
		LEFT JOIN

		(
		SELECT
			SCH_NBR
			,GRDE
			,COUNT(*) AS TheCount
		FROM
			APS.PrimaryEnrollmentsAsOf(@Today) 
		WHERE
			DST_NBR = 1
		GROUP BY
			SCH_NBR
			,GRDE		
		) AS ThisYear
		
		ON	
		SchoolGrades.SCH_NBR = ThisYear.SCH_NBR
		AND SchoolGrades.GRDE = ThisYear.GRDE
		
		LEFT JOIN	
		APS.GradeSorting
		
		ON	
		SchoolGrades.GRDE = GradeSorting.GRDE
		
		LEFT JOIN	
		APS.School
		
		ON	
		SchoolGrades.SCH_NBR = School.SCH_NBR
	) AS [SMAX_COUNTS]
	
	ON
	[SYNERGY_COUNTS].[SCHOOL_CODE] = [SMAX_COUNTS].[SchoolNumber] COLLATE Latin1_General_BIN
	AND [SYNERGY_COUNTS].[Grade] = [SMAX_COUNTS].[GRDE] COLLATE Latin1_General_BIN
	
ORDER BY [SYNERGY_COUNTS].SCHOOL_CODE
