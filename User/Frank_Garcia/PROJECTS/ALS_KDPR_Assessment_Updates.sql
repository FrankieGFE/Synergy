
BEGIN TRAN

UPDATE
	ALS
SET 
	ALS.[SPRING KDPR ELA] = KDPR.FLD_LANG_PERFLVL

FROM
	db_Logon.dbo.ALS_2010 AS ALS
	LEFT JOIN
	[db_KDPR].[dbo].Results_0910 AS KDPR
	ON
	ALS.[ID_NBR] = [KDPR].FLD_ID_NBR
WHERE
	KDPR.FLD_ASSESSMENTWINDOW = 'SPRING'
	
ROLLBACK	
	

	


