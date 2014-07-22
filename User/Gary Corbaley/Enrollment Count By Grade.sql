/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 07/22/2014 $
 *
 * Request By: Andy
 * InitialRequestDate: 7/17/2014
 * 
 * This script will get a count of students currently enrolled, grouped by grade levels, from the Synergy system and compare them to the counts from the same day last year in the School Max system.
 */
 
USE [PR]
 
--Change the variable @Today if you want to check another member day
DECLARE 
		@Today DATE = GETDATE()
		--@Today DATE = '2014-08-14 00:00:00.000'
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
			@Today AS TODAY
			,School.SCHOOL_CODE
			,Organization.ORGANIZATION_NAME AS [School]
			,[Grades].[ALT_CODE_1] AS [Grade]
			,COUNT (*)AS ENROLL_COUNT
		FROM
			[011-SYNERGYDB].ST_Production.rev.EPC_STU_SCH_YR AS StudentSchoolYear
			INNER JOIN 
			[011-SYNERGYDB].ST_Production.rev.EPC_STU AS Student
			ON 
			Student.STUDENT_GU = StudentSchoolYear.STUDENT_GU
			INNER JOIN 
			[011-SYNERGYDB].ST_Production.rev.REV_ORGANIZATION_YEAR AS OrgYear 
			ON 
			OrgYear.ORGANIZATION_YEAR_GU = StudentSchoolYear.ORGANIZATION_YEAR_GU
			INNER JOIN 
			[011-SYNERGYDB].ST_Production.rev.REV_ORGANIZATION AS Organization 
			ON 
			Organization.ORGANIZATION_GU = OrgYear.ORGANIZATION_GU
			INNER JOIN 
			[011-SYNERGYDB].ST_Production.rev.EPC_SCH AS School 
			ON 
			School.ORGANIZATION_GU = OrgYear.ORGANIZATION_GU
			INNER JOIN 
			[011-SYNERGYDB].ST_Production.rev.REV_YEAR AS RevYear 
			ON 
			RevYear.YEAR_GU = OrgYear.YEAR_GU 
			AND RevYear.SCHOOL_YEAR = 2014
			
			INNER JOIN 
			[011-SYNERGYDB].ST_Production.rev.EPC_STU_ENROLL AS Enroll
			ON 
			Enroll.STUDENT_SCHOOL_YEAR_GU = StudentSchoolYear.STUDENT_SCHOOL_YEAR_GU
			
			INNER JOIN
			(
			SELECT
				  Val.[ALT_CODE_1]
				  ,Val.VALUE_CODE
			FROM
				  [011-SYNERGYDB].ST_Production.[rev].[REV_BOD_LOOKUP_DEF] AS [Def]
				  INNER JOIN
				  [011-SYNERGYDB].ST_Production.[rev].[REV_BOD_LOOKUP_VALUES] AS [Val]
				  ON
				  [Def].[LOOKUP_DEF_GU]=[Val].[LOOKUP_DEF_GU]
				  AND [Def].[LOOKUP_NAMESPACE]='K12'
				  AND [Def].[LOOKUP_DEF_CODE]='Grade'
			) AS [Grades]
			ON
			Enroll.[GRADE]=[Grades].[VALUE_CODE]
			
		WHERE
			(RevYear.SCHOOL_YEAR = 2014 )--AND RevYear.EXTENSION = 'S')
			AND SCHOOL_CODE != '592'
			AND StudentSchoolYear.ENTER_DATE <= @Today
			AND (StudentSchoolYear.LEAVE_DATE IS NULL OR StudentSchoolYear.LEAVE_DATE < @Today)

	GROUP BY 
		School.SCHOOL_CODE
		,Organization.ORGANIZATION_NAME
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
