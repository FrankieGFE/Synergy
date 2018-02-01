USE Assessments
GO

BEGIN TRAN

UPDATE
	[CCR_ACT]

SET
	GSY = RIGHT(GSTY.GSY,4)
	
--SELECT
--	CCR.APS_ID
--	,CCR.GSY
--	,CCR.APS_Sch_Code
--	,CCR.APS_ID	
--	,GSTY.program_code
FROM
	[CCR_ACT] AS CCR
	
LEFT JOIN
	ALLSTUDENTS AS GSTY
	ON
	CCR.APS_ID  = GSTY.student_code
	--CAST (REPLACE (REPLACE(APS_ID, CHAR (13),''), CHAR(10),'') AS INT) = GSTY.ID_NBR
WHERE
	CCR.SCH_YR = '2014-2015'
	--AND CCR.GSY IS NULL OR CCR.GSY = ''
	AND CCR.GSY IS NULL
	--AND CCR.[District Code] = 'FRANK'


ROLLBACK