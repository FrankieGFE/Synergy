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

--DECLARE @Today DATE = GETDATE()
DECLARE @Today DATE = '08/13/2014'

	SELECT
		[School].[SCHOOL_CODE]
		,[Organization].[ORGANIZATION_NAME] AS [School]
		,COUNT ([Enrollments].[STUDENT_GU]) AS ENROLL_COUNT
	FROM
		(
		SELECT
			StudentYear.YEAR_GU
			,StudentYear.STUDENT_GU
			,SSY.ORGANIZATION_YEAR_GU
			,SSY.STUDENT_SCHOOL_YEAR_GU
			,SSY.ENTER_DATE
			,SSY.LEAVE_DATE
			,SSY.GRADE
		FROM
			rev.EPC_STU_YR AS StudentYear -- (SOR)
			INNER JOIN
			rev.EPC_STU_SCH_YR AS SSY
			ON
			StudentYear.STU_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU
		WHERE
			StudentYear.YEAR_GU = (SELECT year_gu FROM rev.SIF_22_Common_CurrentYearGU)
			AND SSY.STATUS IS NULL --SSY is not inactive
			AND SSY.EXCLUDE_ADA_ADM IS NULL -- only primarys
			AND (
				-- no "closed" enrollments
				SSY.LEAVE_DATE >= @Today
				OR 
				SSY.LEAVE_DATE IS NULL
		)
		) AS [Enrollments]
		
		
		INNER JOIN
		rev.EPC_STU_SCH_YR AS [StudentSchoolYear] -- Contains Grade and Start Date 	
		ON
		[Enrollments].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
		
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
	
	GROUP BY
		[School].[SCHOOL_CODE]
		,[Organization].[ORGANIZATION_NAME]
	
ORDER BY
	[School].[SCHOOL_CODE]