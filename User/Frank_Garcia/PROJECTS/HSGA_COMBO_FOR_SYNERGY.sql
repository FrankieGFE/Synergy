USE Assessments
GO

SELECT 
	   COMP.[student_code]
      ,COMP.[school_year]
      ,COMP.[school_code]
      ,COMP.[test_date_code]
      ,COMP.[test_type_code]
      ,COMP.[test_type_name]
      ,COMP.[test_section_code]
      ,COMP.[test_section_name]
	  ,SBA.test_section_name
	  ,SBA.scaled_score
	  ,SBA.score_group_name
      ,COMP.[parent_test_section_code]
      ,COMP.[low_test_level_code]
      ,COMP.[high_test_level_code]
      ,COMP.[test_level_name]
      ,COMP.[version_code]
      ,CASE	WHEN COMP.score_group_name LIKE 'FAILED%' THEN 'FAIL' WHEN COMP.score_group_name LIKE 'PASSED%' THEN 'PASS' END AS [score_group_name]
      ,COMP.[score_group_code]
      ,COMP.[score_group_label]
      ,COMP.[last_name]
      ,COMP.[first_name]
      ,COMP.[DOB]
      ,COMP.[raw_score]
      ,COMP.[scaled_score]
      ,COMP.[nce_score]
      ,COMP.[percentile_score]
      ,COMP.[score_1]
      ,COMP.[score_2]
      ,COMP.[score_3]
      ,COMP.[score_4]
      ,COMP.[score_5]
      ,COMP.[score_6]
      --,[score_7]
      --,[score_8]
      --,[score_9]
      --,[score_10]
      --,[score_11]
      --,[score_12]
      --,[score_13]
      --,[score_14]
      --,[score_15]
      --,[score_16]
      --,[score_17]
      --,[score_18]
      --,[score_19]
      --,[score_20]
      --,[score_21]
      ,COMP.[score_raw_name]
      ,COMP.[score_scaled_name]
      ,COMP.[score_nce_name]
      ,COMP.[score_percentile_name]
      --,[score_1_name]
      --,[score_2_name]
      --,[score_3_name]
      --,[score_4_name]
      --,[score_5_name]
      --,[score_6_name]
      --,[score_7_name]
      --,[score_8_name]
      --,[score_9_name]
      --,[score_10_name]
      --,[score_11_name]
      --,[score_12_name]
      --,[score_13_name]
      --,[score_14_name]
      --,[score_15_name]
      --,[score_16_name]
      --,[score_17_name]
      --,[score_18_name]
      --,[score_19_name]
      --,[score_20_name]
      --,[score_21_name]
  FROM [Assessments].[dbo].[test_result_HSGA] AS COMP
  LEFT JOIN
  allstudents_ALL AS STUD
  ON COMP.student_code = STUD.student_code
  AND STUD.school_year = '2014'
  AND STUD.school_code = COMP.school_code

  LEFT JOIN
  SBA
  ON COMP.student_code = SBA.student_code
  AND SBA.school_year = '2014'
  AND SBA.test_section_name IN ('MATH', 'READING')

  WHERE COMP.test_section_code = 'Comp'
  AND COMP.score_group_name LIKE 'PASS%'
  --and SBA.test_section_name = 'READING'
  --AND SBA.test_section_name = 'MATH'
  ORDER BY SBA.score_group_name