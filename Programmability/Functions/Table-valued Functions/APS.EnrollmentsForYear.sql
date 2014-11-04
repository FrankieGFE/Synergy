/**
 * $Revision$
 * $LastChangedBy$
 * $LastChangedDate$
 */
 
-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[EnrollmentsForYear]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.EnrollmentsForYear() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

/**
 * FUNCTION APS.EnrollmentsForYear
 * Pulls all enrollment information for a current year.  
 * 
 * By using the CurrentPrimarySSY and RowedSSy field, you can narrow it down to the pertinent School of record
 * Although depending on what you are doing, it may be worth just going SOR to SSY for speed purposes.
 *
 * #param UNIQUIEIDENTIFIER @YearGu Year Gu to look for enrollments
 * 
 * #return TABLE basic enrollment information for all enrollments for the year.
 */
ALTER FUNCTION APS.EnrollmentsForYear(@YearGu UNIQUEIDENTIFIER)
RETURNS TABLE
AS
RETURN	
SELECT
	SSY.STUDENT_GU
	,SSY.STUDENT_SCHOOL_YEAR_GU
	,OrgYear.ORGANIZATION_GU
	,SSY.YEAR_GU
	,Enrollment.ENROLLMENT_GU
	,Enrollment.ENTER_DATE
	,Enrollment.LEAVE_DATE
	,Enrollment.GRADE
	,Enrollment.EXCLUDE_ADA_ADM
	,CASE WHEN SOR.STU_SCHOOL_YEAR_GU IS NOT NULL THEN 'Y' END AS CurrentPrimarySSY
	,ROW_NUMBER() OVER (PARTITION BY Enrollment.STUDENT_SCHOOL_YEAR_GU ORDER BY Enrollment.ENTER_DATE) AS RowedSSY
FROM
	rev.EPC_STU_ENROLL AS Enrollment
	INNER JOIN
	rev.EPC_STU_SCH_YR AS SSY
	ON
	Enrollment.STUDENT_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU

	INNER JOIN
	rev.REV_ORGANIZATION_YEAR AS OrgYear
	ON
	SSY.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

	LEFT JOIN
	rev.EPC_STU_YR AS SOR
	ON
	Enrollment.STUDENT_SCHOOL_YEAR_GU = SOR.STU_SCHOOL_YEAR_GU
WHERE
	SSY.YEAR_GU = @YearGu