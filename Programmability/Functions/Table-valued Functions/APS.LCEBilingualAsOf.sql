/**
 * $Revision$
 * $LastChangedBy$
 * $LastChangedDate$
 */
  
-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[LCEBilingualAsOf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.LCEBilingualAsOf() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

/**
 * FUNCTION APS.LCEBilingualAsOf
 * Returns a list of properly tagged and credentialed sections as it applies to LCE
 *
 * Tables Used: APS.LCEBilingualAsOf,  EPC_STU_PGM_ELL_HIS
 *
 * #param DATE @AsOfDate date to look for credentials
 * 
 * #return TABLE one record per section.  Includes credential and basic course information
 */
ALTER FUNCTION APS.LCEBilingualAsOf(@AsOfDate DATE)
RETURNS TABLE
AS
RETURN
SELECT
	STUDENT_GU
	,PROGRAM_CODE
	,PROGRAM_INTENSITY
	,ENTER_DATE
FROM
	(
	SELECT
		STUDENT_GU
		,PROGRAM_CODE
		,PROGRAM_INTENSITY
		,ENTER_DATE
		,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY ENTER_DATE DESC) AS RN
	FROM
		REV.EPC_STU_PGM_ELL_BEP
	WHERE
		ENTER_DATE <= @asOfDate
		--I ADDED THIS BECAUSE IT WAS PULLING CLOSED OUT KIDS
		AND (EXIT_DATE >= @AsOfDate
					OR EXIT_DATE IS NULL)
	) AS RowedBEP
WHERE
	RN = 1