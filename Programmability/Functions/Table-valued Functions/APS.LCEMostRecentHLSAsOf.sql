/**
 * $Revision: 1 $
 * $LastChangedBy: e104090 $
 * $LastChangedDate: 2015-05-07 $
 */
 
-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[LCEMostRecentHLSAsOf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.LCEMostRecentHLSAsOf() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO


ALTER FUNCTION APS.LCEMostRecentHLSAsOf(@AsOfDate DATE)
RETURNS TABLE
AS
RETURN
	
--DECLARE @asOfDate DATE = '2015-05-22'

SELECT
	*
FROM
	(
	SELECT
		HISTORY.*
		,ROW_NUMBER() OVER (PARTITION BY Enroll.STUDENT_GU ORDER BY ADD_DATE_TIME_STAMP DESC) AS RN
	FROM
		rev.UD_HLS_HISTORY AS History
		INNER JOIN
		APS.PrimaryEnrollmentsAsOf(@asOfDate) AS Enroll
		ON 
		History.STUDENT_GU = Enroll.STUDENT_GU
	WHERE
		History.DATE_ASSIGNED <= @asOfDate 
	) AS ALLHistory
WHERE 
	RN=1

