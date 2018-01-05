

UPDATE
	[180-SMAXODS-01].SchoolNet.dbo.IAAT
SET
	SchoolNet.dbo.IAAT.[School Code] = STUDENT.[LOCATION CODE]
   ,SchoolNet.dbo.IAAT.[DOB] = STUDENT.[BIRTHDATE]	

	
--SELECT
--	STUDENT.[ALTERNATE STUDENT ID]
--	,STUDENT.[STUDENT ID]
--	,CCR.F_Name
--	,CCR.L_Name
--	,CCR.DOB
--	,STUDENT.BIRTHDATE
--	,STUDENT.Period
--	,STUDENT.[LOCATION CODE]
FROM
	[180-SMAXODS-01].SchoolNet.dbo.IAAT AS CCR
	
INNER HASH JOIN
	[046-WS02].[db_STARS_History].[dbo].[STUDENT] AS STUDENT
	ON
	STUDENT.[ALTERNATE STUDENT ID] = CCR.[Student ID]
	--AND STUDENT.[SY] = 2014
	AND CCR.SCH_YR = '2013-2014'
	--AND STUDENT.[CURRENT GRADE LEVEL] = CCR.Grade
	AND STUDENT.Period = '2013-12-15'
WHERE	
	CCR.[School Code] IS NULL OR CCR.[School Code] = ''
----	


