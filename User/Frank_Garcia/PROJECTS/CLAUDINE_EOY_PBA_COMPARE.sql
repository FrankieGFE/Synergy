SELECT
	*
	,CASE
		WHEN EOY = 'Y' AND PBA = 'Y' THEN '1'
		ELSE '2'
	END AS 'COMPARE'
FROM
(

SELECT
	[State Student Identifier]
	,[Local Student Identifier]
	,[Test Code]
	--,CASE	
	--	WHEN VERSION = 'EOY'
	--	THEN [TEST ATTEMPTEDNESS FLAG]
	--END AS 'EOY ATTEMPT'
	--,CASE	
	--	WHEN VERSION = 'PBA'
	--	THEN [TEST ATTEMPTEDNESS FLAG]
	--END AS 'PBA ATTEMPT'
	,[Test Attemptedness Flag]
	,VERSION

FROM
	[EOY_Student Test Update Export 2015-06-23]
)AS P1
PIVOT
(MAX ([TEST ATTEMPTEDNESS FLAG]) FOR VERSION IN ([EOY], [PBA])) AS P2
ORDER BY [State Student Identifier]
