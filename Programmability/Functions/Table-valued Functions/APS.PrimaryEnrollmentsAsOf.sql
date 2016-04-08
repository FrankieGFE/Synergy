/**
 * $Revision$
 * $LastChangedBy$
 * $LastChangedDate$
 */
 
-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[PrimaryEnrollmentsAsOf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.PrimaryEnrollmentsAsOf() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

/**
 * FUNCTION APS.PrimaryEnrollmentsAsOf
 * Pulls primary enrollment information based on a current day.  Great for doing student counts.
 * It looks a little complex because this function does not require you speciify a year/extension.
 * 
 * By not having to specify a year/extention, or lookup "current year" in system it allows queries
 * based off this function to work idenpendently of current values or having to know what year/extension
 * a date falls in.
 *
 * ++NOTE++: Currently (8/6/2014) Counts from this function are VERY close, but not exactly matching Synergy
 * report.  Preliminary tests on some static date yields the 2 being off between 2-5 per day (variable amount,
 * and these are net differences)
 *
 * Tables Used: EPC_ATT_CAL_TYPE, EPC_ATT_CAL_OPT, REV_ORGANIZATION_YEAR, EPC_STU_SCH_YR, EPC_STU_ENROLL
 *
 * #param DATE @AsOfDate date to look for enrollments
 * 
 * #return TABLE basic enrollment information for all students who are enrolled on that date.
 */
ALTER FUNCTION APS.PrimaryEnrollmentsAsOf(@AsOfDate DATE)
RETURNS TABLE
AS
RETURN	
SELECT
	STUDENT_GU
	,ORGANIZATION_YEAR_GU
	,STUDENT_SCHOOL_YEAR_GU
	,ENROLLMENT_GU
	,GRADE
	,ENTER_DATE
	,LEAVE_DATE
FROM
	--see below why are subselecting (row_number)--
	(
	SELECT
		SSY.STUDENT_GU
		,SSY.ORGANIZATION_YEAR_GU
		,SSY.STUDENT_SCHOOL_YEAR_GU
		,Enrollment.ENROLLMENT_GU
		,SSY.GRADE
		,Enrollment.ENTER_DATE
		,Enrollment.LEAVE_DATE
		-- We have to row number to make sure we only get one record per kid.  We noticed
		-- about 4 kids who have overlapping ADA enrollments.  This could have been caused
		-- by import + NYR, but regardless of reason, we can only count kids once
		,ROW_NUMBER() OVER (PARTITION BY SSY.STUDENT_GU ORDER BY ENROLLMENT.ENTER_DATE) AS RN
	FROM
		--YearDates and OrgYears help us focus our search 
		APS.YearDates
		INNER JOIN
		rev.REV_ORGANIZATION_YEAR AS OrgYear
		ON
		YearDates.YEAR_GU = OrgYear.YEAR_GU

		-- Student School Year - Everything flows through here
		INNER JOIN
		rev.EPC_STU_SCH_YR AS SSY
		ON
		OrgYear.ORGANIZATION_YEAR_GU = SSY.ORGANIZATION_YEAR_GU

		-- Enrollment because enter and leave dates truly reside here, and not most recent as it is bubbled up to SSY
		INNER JOIN
		rev.EPC_STU_ENROLL AS Enrollment
		ON
		SSY.STUDENT_SCHOOL_YEAR_GU = Enrollment.STUDENT_SCHOOL_YEAR_GU

	WHERE
		-- This is what narrows down the School Years (OrgYears) we need to be focusining on
		@AsOfDate BETWEEN YearDates.START_DATE AND YearDates.END_DATE
		
		-- We are dealing with Enrollment enter/leaves because SSY only has **most recent** info, and not necessarily what it was on
		-- the date we are looking for.
		AND @AsOfDate BETWEEN Enrollment.ENTER_DATE AND COALESCE(Enrollment.LEAVE_DATE, YearDates.END_DATE)

		-- only show ADA students not excluded from ADA/ADM
		AND Enrollment.EXCLUDE_ADA_ADM IS NULL

	) AS MainPull
WHERE
	-- here is where we only take the first record.
	RN = 1