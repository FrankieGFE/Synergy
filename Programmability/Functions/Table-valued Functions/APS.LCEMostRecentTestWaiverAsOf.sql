
/**
 * $Revision:1 $
 * $LastChangedBy: e104090 $
 * $LastChangedDate: 20140829 $
 */
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[LCEMostRecentTestWaiverAsOf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.LCEMostRecentTestWaiverAsOf()RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO


/*
*	Pull Most Recent LCE Test Assessment Refusal or Sped Waiver
*/

ALTER FUNCTION APS.LCEMostRecentTestWaiverAsOf(@AsOfDate DATETIME)
RETURNS TABLE
AS
RETURN


SELECT 
	STU.STUDENT_GU
	,WAIVER_TYPE
	,WAIVER_ENTER_DATE
	,WAIVER_EXIT_DATE
FROM (

	SELECT
		STUDENT_GU
		,WAIVER_TYPE
		,WAIVER_ENTER_DATE
		,WAIVER_EXIT_DATE
		-- Why are we row numbering
		 ,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY WAIVER_ENTER_DATE DESC) AS RN
	 FROM
	rev.EPC_STU_PGM_ELL_WAV
	WHERE
	-- why are we using these codes
	WAIVER_TYPE IN ('RTEST', 'RSPED')
	AND @AsOfDate BETWEEN WAIVER_ENTER_DATE AND COALESCE (WAIVER_EXIT_DATE, @asOfDate)

	) AS ALLWAIVERS
	INNER JOIN
	rev.EPC_STU AS STU
	ON
	ALLWAIVERS.STUDENT_GU = STU.STUDENT_GU

WHERE
	RN = 1 -- again.. need comments on why we are row nubering