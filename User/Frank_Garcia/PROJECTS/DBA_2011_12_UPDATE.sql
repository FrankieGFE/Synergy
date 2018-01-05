	

UPDATE
	AIMS.dbo.Construction_Schools_Cohort_IDs_And_Years
SET 
	--AIMS.dbo.Construction_Schools_Cohort_IDs_And_Years.[DBA_Y-2-LA] = DBA.[fld_Total_Score]
	AIMS.dbo.Construction_Schools_Cohort_IDs_And_Years.[DBA_Y-2M] = DBA.[fld_Total_Score]

FROM
	AIMS.dbo.Construction_Schools_Cohort_IDs_And_Years AS COHORT
	LEFT JOIN
	[db_DBA].[dbo].[tbl_DBA_Student_Results_2010-2011] AS DBA
	ON
	COHORT.ID_NBR = DBA.[fld_Student_ID]
WHERE
	COHORT.[COHORT YEAR] = 2013
	AND DBA.FLD_SCHOOL_YEAR = 2011
	AND DBA.FLD_TEST_WINDOW = 'FORM 3'
	AND DBA.FLD_TEST_NAME NOT LIKE '%READ%' AND DBA.FLD_TEST_NAME NOT LIKE '%LANG%'
	--AND (DBA.FLD_TEST_NAME LIKE '%READ%' OR DBA.FLD_TEST_NAME LIKE '%LANG%')
	
