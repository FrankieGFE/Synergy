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
      ,PL
      --,[score_group_label]
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
      ,[score_group_code] AS PL
      ,[score_group_label]
      ,[last_name]
      ,[first_name]
      ,[DOB]
      ,[scaled_score]
  FROM [dbo].test_result_PARCC_ES_MS
  --WHERE test_section_name = 'ALG II'
  --WHERE test_section_name = 'ELA 11 READING'
  --WHERE test_section_name = 'ELA 11 WRITING'
  WHERE test_section_name = 'ELA'
  --WHERE test_section_name = 'GEOM'
  --WHERE test_section_name = 'ELA 10'
  --WHERE test_section_name = 'INT MATH 3'
  --WHERE test_section_name = 'ELA 9'
  --WHERE test_section_name = 'ALG 1'
  --WHERE test_section_name = 'INT MATH 2'
  --WHERE test_section_name = 'ELA 11'
  --WHERE test_section_name = 'INT MATH 1'
) AS PARCC
--WHERE RN = 1
--WHERE student_code = '102860434'
WHERE GRADE IN ('03','04','05')
GO


