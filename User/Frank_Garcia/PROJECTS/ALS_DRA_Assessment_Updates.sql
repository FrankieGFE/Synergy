

UPDATE
	ALS
SET 
	ALS.[SPRING_DRA_PL] = DRA.FLD_PERFORMANCE_LVL

FROM
	db_Logon.dbo.[2013] AS ALS
	LEFT JOIN
	[db_DRA].dbo.Results_1213 AS DRA
	ON
	ALS.[ID_NBR] = [DRA].FLD_ID_NBR
WHERE
	FLD_ASSESSMENTWINDOW = 'SPRING'
	

	

	

