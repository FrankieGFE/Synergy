

UPDATE
	ALS
SET 
	ALS.[SPRING_DBA_MATH] = Dba.[test_score]
	,ALS.[SPRING_DBA_MATH_PL] = DBA_PL.[proficiency_score]

FROM
	db_Logon.dbo.[2013] AS ALS
	LEFT JOIN
	[db_DBA].[dbo].DBA_FORM3_2012_2013_SCORE AS Dba
	ON
	ALS.[ID_NBR] = [Dba].[student_code]
	LEFT JOIN
	[db_DBA].[dbo].DBA_FORM_3_2012_2013_PL AS Dba_PL
	ON
	ALS.[ID_NBR] = [Dba_PL].student_ID
	

WHERE (DBA_PL.assessment_name NOT LIKE '%READING%' AND DBA_PL.[assessment_name] NOT LIKE '%LANG%')
	AND (DBA.[benchmark_test_code] NOT LIKE '%ELA%')

--AND DBA.BENCHMARK_TEST_CODE LIKE '%ELA%'
--WHERE (ALS.[SPRING_DBA_MATH] IS NULL OR ALS.[SPRING_DBA_MATH] = '')
--WHERE
	--AND Dba.FLD_TEST_WINDOW = 'FORM 3'
	--AND (FLD_TEST_NAME  LIKE '%READING%' OR FLD_TEST_NAME  LIKE '%LANGUAGE%')
	--AND FLD_SCHOOL_YEAR = 2012
	
	
	

	
	

	


