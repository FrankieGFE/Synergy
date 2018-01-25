

UPDATE
	AIMS.dbo.Construction_Schools_Cohort_IDs_And_Years
SET 
	AIMS.dbo.Construction_Schools_Cohort_IDs_And_Years.[DBA_Y-1-LA] = DBA.[A2L Total Score Reading]
	,AIMS.dbo.Construction_Schools_Cohort_IDs_And_Years.[DBA_Y-1-M] = DBA.[A2L Total Score Math]

FROM
	AIMS.dbo.Construction_Schools_Cohort_IDs_And_Years AS COHORT
	LEFT JOIN
	[db_Logon].[dbo].[ALS_DBA_A2LSpring_0809_Final] AS DBA
	ON
	COHORT.ID_NBR = DBA.[SCHOOLMAX ID]
WHERE
	COHORT.[COHORT YEAR] = 2010
	

