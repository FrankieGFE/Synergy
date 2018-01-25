
SELECT
	  [SIS_NUMBER]
      ,[STATE_STUDENT_NUMBER]
      ,[LAST_NAME]
      ,[FIRST_NAME]
      ,[GRADE]
      ,[ASSESSMENT_NAME]
      ,[RESOLVED_RACE]
      ,[ELL_STATUS]
      ,[SPED_STATUS]
      ,[LUNCH_STATUS]
	  ,SBA_READING
	  ,SBA_MATH
	  ,SBA_WRITING
	  ,PARCC_ELA_11
	  ,PARCC_ALG_11
	  ,PARCC_GEOM
	  ,ES_MS_PARCC_ELA
	  ,ES_MS_PARCC_MATH
FROM
(
SELECT 
	  ROW_NUMBER () OVER (PARTITION BY SIS_NUMBER, ASSESSMENT_NAME ORDER BY SIS_NUMBER DESC) AS RN
	  ,[SIS_NUMBER]
      ,[STATE_STUDENT_NUMBER]
      ,OO.[LAST_NAME]
      ,OO.[FIRST_NAME]
      ,[GRADE]
      ,[ASSESSMENT_NAME]
      ,[RESOLVED_RACE]
      ,[ELL_STATUS]
      ,[SPED_STATUS]
      ,[LUNCH_STATUS]
	  ,READING.score_group_name AS SBA_READING
	  ,MATH.score_group_name AS SBA_MATH
	  ,WRITING.score_group_name AS SBA_WRITING
	  ,PARCC_ELA.score_group_name AS PARCC_ELA_11
	  ,ALG_II.score_group_name AS PARCC_ALG_11
	  ,GEOM.score_group_name AS PARCC_GEOM
	  ,ELA.score_group_name AS ES_MS_PARCC_ELA
	  ,PARCC_MATH.score_group_name AS ES_MS_PARCC_MATH
  FROM [Assessments].[dbo].[TRASH_2015-2016_opt_outs] AS OO

  LEFT JOIN
  (
SELECT
	 *
FROM
(
SELECT
	ROW_NUMBER () OVER (PARTITION BY STUDENT_CODE ORDER BY TEST_DATE_CODE DESC) AS RN
	,STUDENT_CODE
	,TEST_DATE_CODE
	,TEST_SECTION_NAME
	,SCALED_SCORE
	,score_group_name
FROM
	SBA
WHERE test_section_name = 'READING'
) AS T1
PIVOT
	(MAX([SCALED_SCORE]) FOR TEST_SECTION_NAME  IN ([READING])) AS UP1
WHERE 1 = 1
AND READING IS NOT NULL
AND RN = 1
) AS READING
ON READING.student_code = SIS_NUMBER

LEFT JOIN
  (
SELECT
	 *
FROM
(
SELECT
	ROW_NUMBER () OVER (PARTITION BY STUDENT_CODE ORDER BY TEST_DATE_CODE DESC) AS RN
	,STUDENT_CODE
	,TEST_DATE_CODE
	,TEST_SECTION_NAME
	,SCALED_SCORE
	,score_group_name
FROM
	SBA
WHERE test_section_name = 'MATH'
) AS T1
PIVOT
	(MAX([SCALED_SCORE]) FOR TEST_SECTION_NAME  IN (MATH)) AS UP1
WHERE 1 = 1
AND MATH IS NOT NULL
AND RN = 1
) AS MATH
ON MATH.student_code = SIS_NUMBER

  LEFT JOIN
  (
SELECT
	 *
FROM
(
SELECT
	ROW_NUMBER () OVER (PARTITION BY STUDENT_CODE ORDER BY TEST_DATE_CODE DESC) AS RN
	,STUDENT_CODE
	,TEST_DATE_CODE
	,TEST_SECTION_NAME
	,SCALED_SCORE
	,score_group_name
FROM
	SBA
WHERE test_section_name = 'WRITING'
) AS T1
PIVOT
	(MAX([SCALED_SCORE]) FOR TEST_SECTION_NAME  IN ([WRITING])) AS UP1
WHERE 1 = 1
AND WRITING IS NOT NULL
AND RN = 1
) AS WRITING
ON WRITING.student_code = SIS_NUMBER

LEFT JOIN
(
SELECT
	*
FROM
(
SELECT  [student_code]
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_section_name]
	  ,test_section_code
      ,[score_group_name]
      ,[last_name]
      ,[first_name]
      ,[DOB]
      ,[scaled_score]
  FROM [Assessments].[dbo].[test_result_PARCC] AS PARCC
  WHERE test_section_name = 'ELA 11'
  --AND student_code = '100003896'
  ) AS PARCC
PIVOT
	(MAX([SCALED_SCORE]) FOR TEST_SECTION_NAME  IN ([ELA 11])) AS UP1
) AS PARCC_ELA
ON PARCC_ELA.student_code = SIS_NUMBER

LEFT JOIN
(
SELECT
	*
FROM
(
SELECT  [student_code]
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_section_name]
	  ,test_section_code
      ,[score_group_name]
      ,[last_name]
      ,[first_name]
      ,[DOB]
      ,[scaled_score]
  FROM [Assessments].[dbo].[test_result_PARCC] AS PARCC
  WHERE test_section_name = 'ALG II'
  --AND student_code = '100003896'
  ) AS PARCC
PIVOT
	(MAX([SCALED_SCORE]) FOR TEST_SECTION_NAME  IN ([ELA 11])) AS UP1
) AS ALG_II
ON ALG_II.student_code = SIS_NUMBER



  LEFT JOIN
  (
SELECT
	 *
FROM
(
SELECT
	ROW_NUMBER () OVER (PARTITION BY STUDENT_CODE ORDER BY TEST_DATE_CODE DESC) AS RN
     ,[student_code]
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_section_name]
	  ,test_section_code
      ,[score_group_name]
      ,[last_name]
      ,[first_name]
      ,[DOB]
      ,[scaled_score]
FROM
	test_result_PARCC
WHERE test_section_name = 'GEOM'
) AS T1
PIVOT
	(MAX([SCALED_SCORE]) FOR TEST_SECTION_NAME  IN ([GEOM])) AS UP1
WHERE 1 = 1
AND RN = 1
) AS GEOM
ON GEOM.student_code = SIS_NUMBER

LEFT JOIN
(
SELECT
	*
FROM
(
SELECT  [student_code]
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_section_name]
	  ,test_section_code
      ,[score_group_name]
      ,[last_name]
      ,[first_name]
      ,[DOB]
      ,[scaled_score]
  FROM [Assessments].[dbo].[test_result_PARCC_ES_MS] AS PARCC
) AS ES_MS
PIVOT
	(MAX([SCALED_SCORE]) FOR TEST_SECTION_NAME  IN ([ELA])) AS UP1
) AS ELA
ON ELA.student_code = SIS_NUMBER

LEFT JOIN
(
SELECT
	*
FROM
(
SELECT  [student_code]
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_section_name]
	  ,test_section_code
      ,[score_group_name]
      ,[last_name]
      ,[first_name]
      ,[DOB]
      ,[scaled_score]
  FROM [Assessments].[dbo].[test_result_PARCC_ES_MS] AS PARCC
) AS ES_MS
PIVOT
	(MAX([SCALED_SCORE]) FOR TEST_SECTION_NAME  IN ([MATH])) AS UP1
) AS PARCC_MATH
ON PARCC_MATH.student_code = SIS_NUMBER

) AS DONE
WHERE RN = 1

ORDER BY SIS_NUMBER
