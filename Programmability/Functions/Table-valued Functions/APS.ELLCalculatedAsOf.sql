/**
 * $Revision: 19 $
 * $LastChangedBy: e201594 $
 * $LastChangedDate: 2014-08-06 08:34:31 -0600 (Wed, 6 Sep 2014) $
 */
 
-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[ELLCalculatedAsOf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.ELLCalculatedAsOf() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

/**
 * FUNCTION APS.ELLCalculatedAsOf
 * Pulls ELL kids as of a certain date + Basic enrollment information. It Calculates ELL based on PHLOTE status, and 
 * Most recent assessment.
 *
 * Tables Used: APS.ELLCalculatedAsOf,  EPC_STU_PGM_ELL_HIS
 *
 * #param DATE @AsOfDate date to look for enrollments
 * 
 * #return TABLE basic enrollment information + ELL Infro for all ELL students who are enrolled on that date.
 */
ALTER FUNCTION APS.ELLCalculatedAsOf(@AsOfDate DATE)
RETURNS TABLE
AS
RETURN	
SELECT
	Enroll.*
	,Assessment.ADMIN_DATE
	,Assessment.PERFORMANCE_LEVEL
	,Assessment.TEST_GU
	,Assessment.GRADE AS GradeELLEntered
	,Assessment.TEST_NAME
FROM
	-- Enrollments
	APS.PrimaryEnrollmentsAsOf(GETDATE()) AS Enroll
	-- PHLOTE Students
	INNER JOIN
	APS.PHLOTEAsOf(GETDATE()) AS PHLOTE
	ON
	Enroll.STUDENT_GU = PHLOTE.STUDENT_GU
	-- Latest Assessment
	INNER JOIN
	APS.LCELatestEvaluationAsOf(GETDATE()) AS Assessment
	ON
	Enroll.STUDENT_GU = Assessment.STUDENT_GU
WHERE
	-- Only those where performance level qualifies them for ELL
	Assessment.IS_ELL = 1