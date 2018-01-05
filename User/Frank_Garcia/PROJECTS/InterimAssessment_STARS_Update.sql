

UPDATE
	[180-SMAXODS-01].SchoolNet.dbo.Interim_Assessment
SET
	SchoolNet.dbo.Interim_Assessment.school_code = STUDENT.[LOCATION CODE]
	,SchoolNet.dbo.Interim_Assessment.dob = STUDENT.BIRTHDATE

	
--SELECT
--	STUDENT.[ALTERNATE STUDENT ID]
--	,STUDENT.[STUDENT ID]
--	,CCR.F_Name
--	,CCR.L_Name
--	,CCR.DOB_NEW
--	,STUDENT.BIRTHDATE
--	,STUDENT.Period
FROM
	[180-SMAXODS-01].SchoolNet.dbo.Interim_Assessment AS CCR
	
INNER JOIN
	[046-WS02].[db_STARS_History].[dbo].[STUDENT] AS STUDENT
	ON
	STUDENT.[ALTERNATE STUDENT ID] = CCR.student_code
	AND STUDENT.period = '2013-12-15'

WHERE	
	CCR.school_code is null or CCR.school_code = ''

----CCR.SCH_YR = '2012-2013'
--CCR.APS_ID is null

