

SELECT 
	--SY, [STUDENT ID], PERIOD, [LOCATION CODE], [Field5], [Field9], [Field18] 
	COUNT(*), SY
FROM
	[046-WS02].[db_STARS_History].[dbo].[PROGRAMS_FACT] AS STARS2

WHERE
[Field5] = 'BEP'
AND PERIOD LIKE '%-12-15'
AND [DISTRICT CODE] = '001'
AND PERIOD > '2010'

GROUP BY SY