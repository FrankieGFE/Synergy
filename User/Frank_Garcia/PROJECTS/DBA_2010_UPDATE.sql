

UPDATE
	AIMS.dbo.Construction_Schools_Cohort_IDs_And_Years
SET 
	---AIMS.dbo.Construction_Schools_Cohort_IDs_And_Years.[DBA_Y-3-M] = DBA.[Total Score]
	AIMS.dbo.Construction_Schools_Cohort_IDs_And_Years.[DBA_Y-3-LA] = DBA.[Total Score]

FROM
	AIMS.dbo.Construction_Schools_Cohort_IDs_And_Years AS COHORT
	LEFT JOIN
	[db_Logon].[dbo].ALS_MS_rdg0910_form3 AS DBA
	ON
	COHORT.ID_NBR = DBA.[Student Id]
WHERE
	COHORT.[COHORT YEAR] = 2013
	


