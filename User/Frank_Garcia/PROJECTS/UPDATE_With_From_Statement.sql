UPDATE
	AIMS.dbo.Spring2012_District001_studentds
SET 
	AIMS.dbo.Spring2012_District001_studentds.APS_ID = STARS.[ALTERNATE STUDENT ID]

FROM
	AIMS.dbo.Spring2012_District001_studentds AS SBA
	LEFT JOIN
	[db_STARS_History].[dbo].[STUDENT] AS STARS
	ON
	SBA.StudentID = [STARS].[STUDENT ID]
WHERE
	STARS.[DISTRICT CODE] = '001'
	AND	STARS.SY = '2012'


