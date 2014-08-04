/**
 * $Revision: 19 $
 * $LastChangedBy: e201594 $
 * $LastChangedDate: 2012-09-27 08:34:31 -0600 (Thu, 27 Sep 2012) $
 */
 
-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[PrimaryEnrollmentsAsOf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.PrimaryEnrollmentsAsOf() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

/**
 * FUNCTION APS.PrimaryEnrollmentsAsOf
 * pulls values for a specified lookup table.  This differs from the Edupoint SIF standard as
 * it retrieves more inofrmation (such as list information)
 *
 * Tables Used: REV_BOD_LOOKUP_DEF, REV_BOD_LOOKUP_VALUES
 *
 * #param nvarchar(50) @namespace lookup namespace (e.g. 'k12')
 * #param nvarchar(50) @lookupname lookup name (e.g. 'enter_code')
 * 
 * #return TABLE All value fields (see REV_BOD_LOOKUP_VALUES clomuns) for the lookup table.
 */
ALTER FUNCTION APS.PrimaryEnrollmentsAsOf(@AsOfDate DATE)
RETURNS TABLE
AS
RETURN
	SELECT
		SSY.STUDENT_GU
		,SSY.ORGANIZATION_YEAR_GU
		,SSY.STUDENT_SCHOOL_YEAR_GU
		,Enrollment.ENROLLMENT_GU
		,Enrollment.GRADE
		,Enrollment.ENTER_DATE
		,Enrollment.LEAVE_DATE
		,SchoolCalendar.START_DATE AS SchoolYearStartDate
		,SchoolCalendar.END_DATE AS SchoolYearEndDate
	FROM
		-- we start with school canendar to narrow down the org_years
		-- becasue enrollments never really have a leave date, unless they are duing the term
		rev.EPC_SCH_ATT_CAL_OPT AS SchoolCalendar

		-- SSY, because you never know what the School of Record (SOR) is in a historical context
		INNER JOIN
		rev.EPC_STU_SCH_YR AS SSY
		ON
		SchoolCalendar.ORG_YEAR_GU = SSY.ORGANIZATION_YEAR_GU

		-- Enrollment because enter and leave dates truly reside here, and not most recent as it is bubbled up to SSY
		INNER JOIN
		rev.EPC_STU_ENROLL AS Enrollment
		ON
		SSY.STUDENT_SCHOOL_YEAR_GU = Enrollment.STUDENT_SCHOOL_YEAR_GU

	WHERE
		@AsOfDate BETWEEN SchoolCalendar.START_DATE AND SchoolCalendar.END_DATE
		AND Enrollment.ENTER_DATE <= CONVERT(DATE, @AsOfDate) -- check for existing and applicable enrollmentdate

		-- make sure not past leave dates
		AND (
			Enrollment.LEAVE_DATE IS NULL
			OR Enrollment.LEAVE_DATE >= @AsOfDate
			)

		-- only show students not excluded from ADA/ADM
		AND (
			Enrollment.EXCLUDE_ADA_ADM IS NULL
			OR Enrollment.EXCLUDE_ADA_ADM = '1' -- No concurrents, only null (ADA) or 1 (non-ADA/ADM)
			)