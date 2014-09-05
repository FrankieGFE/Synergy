
/**
 * $Revision:1 $
 * $LastChangedBy: e104090 $
 * $LastChangedDate: 20140902 $
 */
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[LCEMostRecentALSRefusalAsOf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.LCEMostRecentALSRefusalAsOf()RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

/*
*	Pull Most Recent LCE Refusal of ALS Services
*/

ALTER FUNCTION APS.LCEMostRecentALSRefusalAsOf(@AsOfDate DATETIME)
RETURNS TABLE
AS
RETURN

SELECT 
	STUDENT_GU
	,WAIVER_TYPE
	,WAIVER_ENTER_DATE
	,WAIVER_EXIT_DATE
FROM 
	(
	SELECT
		STUDENT_GU
		,WAIVER_TYPE
		,WAIVER_ENTER_DATE
		,WAIVER_EXIT_DATE
		--ORDER ALL OF THE WAIVERS BY MOST RECENT ENTER DATE
		 ,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY WAIVER_ENTER_DATE DESC) AS RN
	 FROM
		rev.EPC_STU_PGM_ELL_WAV
	 WHERE
	 --THERE IS ONLY ONE TYPE OF REFUSAL CODE FOR REFUSAL OF ALS SERVICES
	 WAIVER_TYPE IN ('RALS')
	 AND @AsOfDate BETWEEN WAIVER_ENTER_DATE AND COALESCE (WAIVER_EXIT_DATE, @asOfDate)
	 
	 ) AS ALLWAIVERS

--PULL MOST RECENT TEST ASSESSMENT
WHERE
	RN = 1