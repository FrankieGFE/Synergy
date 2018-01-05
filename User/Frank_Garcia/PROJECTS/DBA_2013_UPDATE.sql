

UPDATE
	AIMS.dbo.Construction_Schools_Cohort_IDs_And_Years
SET 
	AIMS.dbo.Construction_Schools_Cohort_IDs_And_Years.[DBA_Y-M] = DBA.[test_Score]
	--AIMS.dbo.Construction_Schools_Cohort_IDs_And_Years.[DBA_Y-LA] = DBA.[test_Score]

FROM
	AIMS.dbo.Construction_Schools_Cohort_IDs_And_Years AS COHORT
	LEFT JOIN
	[db_DBA].[dbo].DBA_FORM3_2012_2013_SCORE AS DBA
	ON
	COHORT.ID_NBR = DBA.[STUDENT_CODE]
WHERE
	COHORT.[COHORT YEAR] = 2013
	AND DBA.benchmark_test_code NOT LIKE '%ela%' 
	--AND DBA.benchmark_test_code like '%ela%'
	


