/**
 * 
 * $LastChangedBy: Frank Garcia
 * $LastChangedDate: 11/28/2012 $
 *
 * Request By: Rigo
 * InitialRequestDate: 11/28/2012
 * 
 * Initial Request:
 * pulling Discipline response data from EV030 (EV230) (disciplinary actions taken against students) for Sandia HS 550 for three years 2011, 2012, 2013 YTD and aggregating counts broken down by kind of discipline and race.
 *
 * Tables Referenced: DBTSIS.EV065_V, APS.BasicStudent, DBTSIS.EV030_V, DBTSIS.EV020_V
 */
SELECT
	APS.BasicStudent.Race
	,DBTSIS.EV065_V.RESP_DESC
	,COUNT (*) AS [COUNT]

FROM 
	DBTSIS.EV030_V
	INNER JOIN
	DBTSIS.EV065_V
	ON
	-- This is for the response description
	DBTSIS.EV065_V.RESP_CD = DBTSIS.EV030_V.RESP_CD

	INNER JOIN
	DBTSIS.EV020_V
	ON
	-- This is to ensure I get unique event and student
	DBTSIS.EV030_V.EV_SEQ_NBR = DBTSIS.EV020_V.EV_SEQ_NBR
	AND DBTSIS.EV030_V.PART_SEQ = DBTSIS.EV020_V.PART_SEQ

	INNER JOIN
	APS.BasicStudent
	ON
	-- Ties event to student to bring in race
	DBTSIS.EV020_V.ID_NBR = APS.BasicStudent.ID_NBR
WHERE 
	DBTSIS.EV030_V.SCH_NBR = '550' AND DBTSIS.EV030_V.SCH_YR = 2011
	AND DBTSIS.EV020_V.SCH_NBR = '550' AND DBTSIS.EV020_V.SCH_YR = 2011
	AND DBTSIS.EV020_V.PART_CD = 'S'
	AND DBTSIS.EV020_V.PART_TYPE = 'O'
	AND DBTSIS.EV065_V.SCH_NBR = '550'

	
GROUP BY Race, RESP_DESC
ORDER BY RESP_DESC, Race
