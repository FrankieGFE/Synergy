/**
 * $Revision: 19 $
 * $LastChangedBy: e201594 $
 * $LastChangedDate: 2014-08-06 08:34:31 -0600 (Wed, 6 Sep 2014) $
 */
 
-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[ELLAsOf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.ELLAsOf() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

/**
 * FUNCTION APS.ELLAsOf
 * Pulls ELL kids as of a certain date + Basic enrollment information.
 *
 * Tables Used: APS.ELLAsOf,  EPC_STU_PGM_ELL_HIS
 *
 * #param DATE @AsOfDate date to look for enrollments
 * 
 * #return TABLE basic enrollment information + ELL Infro for all ELL students who are enrolled on that date.
 */
ALTER FUNCTION APS.ELLAsOf(@AsOfDate DATE)
RETURNS TABLE
AS
RETURN	
SELECT
	Enroll.*
	,History.ENTRY_DATE
	,History.EXIT_DATE
	,History.EXIT_REASON
	,History.STU_PGM_ELL_HIS_GU
FROM
	rev.EPC_STU_PGM_ELL_HIS AS History

	INNER JOIN
	APS.PrimaryEnrollmentsAsOf(@asOfDate) AS Enroll
	ON 
	History.STUDENT_GU = Enroll.STUDENT_GU
WHERE
	@asOfDate BETWEEN History.ENTRY_DATE AND COALESCE(History.EXIT_DATE, CONVERT(DATE, GETDATE()))