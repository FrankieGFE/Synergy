USE [Assessments]
GO

SELECT
	   [student_code]
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_name]
      ,GRADE
	  ,[PASS-FAIL]
      ,[score_group_name]
      ,[score_group_code]
      ,[score_group_label]
      ,[last_name]
      ,[first_name]
      ,[DOB]
      ,[scaled_score]
FROM
(
SELECT 
	  ROW_NUMBER () OVER (PARTITION BY [student_code] ORDER BY TEST_DATE_CODE) AS RN
	  ,[student_code]
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_name]
      ,[test_level_name] AS GRADE
	  ,CASE
			WHEN score_group_code IN ('1','2') THEN 'FAIL'
			ELSE 'PASS'
	  END AS 'PASS-FAIL'
      ,[score_group_name]
      ,[score_group_code]
      ,[score_group_label]
      ,[last_name]
      ,[first_name]
      ,[DOB]
      ,[scaled_score]
  FROM [dbo].test_result_PARCC_ES_MS
  WHERE test_level_name IN ('06','07','08')
  --AND test_section_name = 'ALG 1'
  --AND test_section_name = 'ALG II'
  --AND test_section_name = 'GEOM'
  --AND test_section_name = 'ELA'
  AND test_section_name = 'MATH'
) AS PARCC
WHERE RN = 1
--WHERE student_code = '104446463'
ORDER BY student_code
GO


