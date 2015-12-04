
SELECT SY, COUNT (*)
FROM 
(
SELECT DISTINCT 
	--SY, [STUDENT ID], PERIOD, [LOCATION CODE], [Field12] AS ALT_LOC, [Field13] AS ALT_STUID, [Field11] AS GRADE_LEVEL, [ENGLISH PROFICIENCY] 
	SY, [STUDENT ID]
FROM
	[046-WS02].[db_STARS_History].[dbo].[STUDENT] AS STARS
WHERE
[DISTRICT CODE] = '001'
--AND PERIOD LIKE '%-12-15'
AND PERIOD > '2010'
AND [ENGLISH PROFICIENCY] = 1
) AS T1
GROUP BY SY

--ORDER BY [STUDENT ID]