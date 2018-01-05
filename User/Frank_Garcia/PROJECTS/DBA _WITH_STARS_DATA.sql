

/**
 * 
 * $LastChangedBy: Frank Garcia
 * $LastChangedDate: 2/26/2013 $
 *
 * Request By: Regular Request for DBA data
 * InitialRequestDate: 2/26/2013 by Frank Garcia
 * 
 * Initial Request:
 * 
 *
 * Tables Referenced: All db_DBA, db.STARS_History.[LOCATION CODE], and [CURRENT GRADE LEVEL]
 *
 * Notes: 
 */
 
 -- Proficiency Levels: 1 = Beginning Steps 2 = Nearing Proficient 3 = Proficient 4 = Advanced

DECLARE @District VARCHAR(50) = '001'
		-- Fall = Form 1 Winter = Form 2 Spring = Form 3
		,@TestWindow VARCHAR(50)= 'Form 1'

SELECT
	*
FROM
(
	-- Selecting all student data from DBA and getting location and student grade level from STARS_History

SELECT
	-- Using row number over partition to ensure one record per student per assessment
	ROW_NUMBER () OVER (PARTITION BY fld_Student_ID, fld_Test_Name ORDER BY fld_Test_Name DESC) AS RN
	,STARS.[LAST NAME LONG]+', '+STARS.[FIRST NAME LONG] AS [Student Name]
	,DBA.fld_Student_ID AS [APS ID]
	,STARS.[CURRENT GRADE LEVEL] AS [GRADE LEVEL]
	,STARS.[LOCATION CODE] AS [LOCATION]
	,DBA.fld_School_Year AS [SCHOOL YEAR]
	,DBA.fld_Test_Window AS [TEST WINDOW]
	,DBA.fld_Test_Name AS [TEST NAME]	
	,DBA.fld_Total_Score AS [TOTAL SCORE]
	,DBA.fld_Total_Score_Percentage AS [TOTAL SCORE PERCENTAGE]
	,DBA.fld_Proficiency_Level AS [PROFICIENCY LEVEL NUMBER]
	,DBA.fld_Proficiency_Level_Text AS [PROFICIENCY LEVEL]


FROM
	[046-WS02].db_DBA.dbo.tbl_DBA_Student_Results AS DBA
	LEFT JOIN
	[046-WS02].db_STARS_History.dbo.STUDENT AS STARS
	ON
	DBA.fld_Student_ID = STARS.[ALTERNATE STUDENT ID]
WHERE
	-- DBA has school year in the same format as STARS_History. Joining on that
	STARS.SY = DBA.fld_School_Year
	AND STARS.[DISTRICT CODE] = @District
	AND fld_Test_Window = @TestWindow
	)AS DBA_RN
WHERE RN = '1'
ORDER BY
	[GRADE LEVEL]



