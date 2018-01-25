

UPDATE
	ALS
SET 
	ALS.[SPRING_KDPR_ELA] = KDPR.fld_Lang_PerfLvl
	,ALS.[SPRING_KDPR_MATH] = KDPR.fld_Math_PerfLvl
FROM
	db_Logon.dbo.[2013] AS ALS
	LEFT JOIN
	[db_KDPR].[dbo].Results_12_13 AS KDPR
	ON
	ALS.[ID_NBR] = [KDPR].fld_ID_NBR
WHERE
	KDPR.fld_AssessmentWindow = 'SPRING'
	

