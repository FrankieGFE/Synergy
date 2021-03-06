USE
Assessments
GO

SELECT
	  [student_code]
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
      ,[DOB]
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
FROM
(
SELECT 
	  ROW_NUMBER () OVER (PARTITION BY [student_code], [test_section_name] ORDER BY [test_date_code] DESC) AS RN
	  ,[student_code]
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
      ,[DOB]
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
  FROM [dbo].[test_result_EOC]
  --where test_section_code = 'Algebra I 7 12 V001'
  --where test_section_code = 'Algebra II 10 12 V002'
  --where test_section_code = 'Algebra I 7 12 V003'
  --where test_section_code = 'Algebra II 10 12 V006'
  --where test_section_code = 'Biology 9 12 V003'
  --where test_section_code = 'Biology 9 12 V007'
  --where test_section_code = 'Chemistry 9 12 V003'
  --where test_section_code = 'Chemistry 9 12 V008'
  --where test_section_code = 'Drivers Education 9 12 V002'
  --where test_section_code = 'Economics 9 12 V001'
  --where test_section_code = 'Economics 9 12 V004'
  --where test_section_code = 'English Language Arts III Reading 11 11 V002'
  --where test_section_code = 'English Language Arts III Reading 11 11 V006'
  --where test_section_code = 'English Language Arts IV Reading 11 11 V003'
  --where test_section_code = 'English Language Arts III Writing 11 11 V002'
  --where test_section_code = 'English Language Arts IV Writing 12 12 V001'
  --where test_section_code = 'Financial Literacy 9 12 V003'
  --where test_section_code = 'Geometry 9 12 V003'
  --where test_section_code = 'Health Education 6 12 V001'
  --where test_section_code = 'Health Education 6 12 V002'
  --where test_section_code = 'New Mexico History 7 12 V001'
  --where test_section_code = 'New Mexico 7 12 History V004'
  --where test_section_code = 'Physics 9 12 V003'
  --where test_section_code = 'Pre-Calculus 9 12 V004'
  --where test_section_code = 'Spanish I 7 12 V001'
  --where test_section_code = 'US Government Comprehensive 9 12 V002'
  --where test_section_code = 'US Government Comprehensive 9 12 V005'
  --where test_section_code = 'US History 9 12 V002'
  --where test_section_code = 'US History 9 12 V007'
  --where test_section_code = 'World History And Geography 9 12 V001'
  --where test_section_code = 'World History And Geography 9 12 V003'
  --where test_section_code = 'Biology 9 12 V002'
  --where test_section_code = 'Chemistry 9 12 V002'
  --where test_section_code = 'English Language Arts III Reading 11 11 V001'
  --where test_section_code = 'English Language Arts III Writing 11 11 V001'
  --where test_section_code = 'English Language Arts IV Reading 12 12 V001'
  --where test_section_code = 'Integrated General Science 6 8 V001'
  --where test_section_code = 'Introduction to Art 4 5 V001'
  --where test_section_code = 'Introduction to Art 6 8 V001'
  --where test_section_code = 'Introduction to Art 9 12 V001'
  --where test_section_code = 'Music 4 5 V001'
	--where test_section_code = 'Music 9 12 V001'
  --where test_section_code = 'Physical Education 4 5 V001'
  --where test_section_code = 'Physical Education 6 8 V001'
  --where test_section_code = 'Physical Education 9 12 V001'
  --where test_section_code = 'Social Studies 6 6 V001'
  --where test_section_code = 'Spanish Language Arts III Reading 11 11 V001'
  --where test_section_code = 'Spanish Language Arts III Writing 11 11 V001'
  --where test_section_code = 'US Government Comprehensive 9 12 V001'
  --where test_section_code = 'US History 9 12 V001'
  --where test_section_code = 'Financial Literacy 9 12 V003'
  WHERE 1 = 1
  --AND test_section_code = 'Algebra I 7 12 V003'
  --AND test_section_code = 'Algebra II 9 12 V006'
  --AND test_section_code = 'Biology 9 12 V007'
  --AND test_section_code = 'Chemistry 9 12 V008'
  --AND test_section_code = 'Economics 9 12 V004'
  --AND test_section_code = 'ELA III Reading 9 12 V006'
  --AND test_section_code = 'English IV Writing 9 12 V003'
  --AND test_section_code = 'English Language Arts III Writing 11 11 V006'
  --AND test_section_code = 'Financial Literacy 9 12 V003'
  --AND test_section_code = 'Geometry 9 12 V003'
  --AND test_section_code = 'New Mexico History 9 12 V004'
  --AND test_section_code LIKE 'Spanish I 9 12 V0%'
  --AND test_section_code = 'Spanish I 9 12 V004'
  --AND test_section_code = 'Spanish I 9 12 V005'
  --AND test_section_code = 'Spanish I 9 12 V006'
  --AND test_section_code = 'US Government Comprehensive 9 12 V005'
  --AND test_section_code = 'US History 9 12 V007'
  AND test_section_code = 'World History and Geography 9 12 V003'
  --AND test_section_code = ''

) AS T1
--WHERE RN = 1