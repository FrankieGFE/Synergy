/**
 * $Revision$
 * $LastChangedBy$
 * $LastChangedDate$
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
	ALLHistory.STUDENT_GU
	,ALLHistory.ORGANIZATION_YEAR_GU
	,ALLHistory.STUDENT_SCHOOL_YEAR_GU
	,ALLHistory.ENROLLMENT_GU
	,ALLHistory.ENTER_DATE
	,ALLHistory.LEAVE_DATE
	,ALLHistory.GRADE
	,ALLHistory.STU_PGM_ELL_HIS_GU
	,ALLHistory.ENTRY_DATE
	,ALLHistory.EXIT_DATE
	,ALLHistory.EXIT_REASON
FROM
	(
	SELECT
		Enroll.*
		,History.ENTRY_DATE
		,History.EXIT_DATE
		,History.EXIT_REASON
		,History.STU_PGM_ELL_HIS_GU
		,ROW_NUMBER() OVER (PARTITION BY Enroll.STUDENT_GU ORDER BY ENTRY_DATE DESC) AS RN
	FROM
		rev.EPC_STU_PGM_ELL_HIS AS History
		INNER JOIN
		APS.PrimaryEnrollmentsAsOf(@asOfDate) AS Enroll
		ON 
		History.STUDENT_GU = Enroll.STUDENT_GU
	WHERE
		@asOfDate BETWEEN History.ENTRY_DATE AND COALESCE(History.EXIT_DATE, @asOfDate)
	) AS ALLHistory
WHERE 
	RN=1