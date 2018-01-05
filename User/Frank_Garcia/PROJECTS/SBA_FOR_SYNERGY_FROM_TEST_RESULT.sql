USE Assessments
GO
SELECT
	  [student_code]
      ,CAST ([school_year] AS INT) AS school_year
      ,[school_code]
      ,[test_date_code]
      ,[test_type_name]
      ,[test_section_name]
      ,[test_level_name] AS 'SBA GRADE'
      ,T1.[last_name]
      ,T1.[first_name]
      ,[score_group_name] AS 'SBA PROFICIENCY LEVEL'
      ,[dob]
      ,[raw_score]
      ,[scaled_score]

	  ---CUT SCORE FOR MATH AND READING IS 1137 SCIENCE IS 1138---
	  ,CASE 
           WHEN   SCALED_SCORE  >= 1138  THEN 'PASS' 
		   ELSE 'FAIL'
      END AS 'PERFROMANCE LEVEL'

   --- PERFORMANCE LEVEL FOR COMBO ---
   --   ,CASE
			--WHEN score_group_name LIKE 'PASSED%' THEN 'PASS'
	  --END AS 'PERFORMANCE LEVEL'
      ,[score_15] AS 'STATE ID'
      ,[score_16] AS 'GRADE'
FROM
(

SELECT 
	  ROW_NUMBER () OVER (PARTITION BY [student_code] ORDER BY TEST_DATE_CODE) AS RN
	  ,CAST ([student_code] AS INT) AS student_code
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,[test_section_name]
      ,[parent_test_section_code]
      ,[low_test_level_code]
      ,[high_test_level_code]
      ,[test_level_name]
      ,[version_code]
      ,[score_group_name]
      ,[score_group_code]
      ,[score_group_label]
      ,[last_name]
      ,[first_name]
      ,[dob]
      ,[raw_score]
      ,[scaled_score]
      ,[nce_score]
      ,[percentile_score]
      ,[score_1]
      ,[score_2]
      ,[score_3]
      ,[score_4]
      ,[score_5]
      ,[score_6]
      ,[score_7]
      ,[score_8]
      ,[score_9]
      ,[score_10]
      ,[score_11]
      ,[score_12]
      ,[score_13]
      ,[score_14]
      ,[score_15]
      ,[score_16]
      ,[score_17]
      ,[score_18]
      ,[score_19]
      ,[score_20]
      ,[score_21]
      ,[score_raw_name]
      ,[score_scaled_name]
      ,[score_nce_name]
      ,[score_percentile_name]
      ,[score_1_name]
      ,[score_2_name]
      ,[score_3_name]
      ,[score_4_name]
      ,[score_5_name]
      ,[score_6_name]
      ,[score_7_name]
      ,[score_8_name]
      ,[score_9_name]
      ,[score_10_name]
      ,[score_11_name]
      ,[score_12_name]
      ,[score_13_name]
      ,[score_14_name]
      ,[score_15_name]
      ,[score_16_name]
      ,[score_17_name]
      ,[score_18_name]
      ,[score_19_name]
      ,[score_20_name]
      ,[score_21_name]
  FROM [dbo].[SBA]
  --WHERE TEST_SECTION_NAME = 'READING'
  --WHERE TEST_SECTION_NAME = 'WRITING'
  --WHERE TEST_SECTION_NAME = 'MATH'
  WHERE TEST_SECTION_NAME = 'SCIENCE'
  --WHERE TEST_SECTION_NAME = 'COMPOSITE'
  --AND score_group_name LIKE 'PASS%'
  ----WHERE TEST_SECTION_NAME = 'reading(s)'
  ----AND school_code NOT IN ('006','007','016','017','027','028','047','061','063','069','095','098','7','118','6','035','116','17')
  AND (test_level_name  IN ('09','10','11','12') OR TEST_LEVEL_NAME LIKE 'H%' )
  ----AND test_level_name IN ('03','04','05')
  ----AND test_level_name IN ('06','07','08')
  --AND scaled_score NOT LIKE '99%'
  --AND student_code != ''
  AND SCHOOL_YEAR IN ('2010','2011','2012','2013','2014','2015')
  AND score_11 != 'CHARTER ONLY'
  and student_code > 0
  ----AND student_code = '102907912'
  --AND score_group_name LIKE 'PASSED%'
) AS T1
--INNER JOIN
--SIS_NUMBER_FIX AS FIX
--ON T1.student_code = FIX.APS_ID
--AND APS_ID != 'CHARTER ONLY'

WHERE RN = 1
AND scaled_score NOT LIKE '99%'
--AND student_code = '100043942'
--ORDER BY [STATE ID]

GO


