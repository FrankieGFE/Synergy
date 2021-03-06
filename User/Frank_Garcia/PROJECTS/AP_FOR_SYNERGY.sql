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
	  ,score_group_name 
      ,score_group_code
      ,[score_group_label]
      ,[last_name]
      ,[first_name]
      ,[DOB]
      ,[raw_score]
      ,RIGHT ('00'+CAST([scaled_score]AS VARCHAR (4)),3) AS scaled_score
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
	  ROW_NUMBER () OVER (PARTITION BY [student_code],[test_section_name],[school_year] ORDER BY [test_date_code]) AS RN
	  ,LTRIM(RTRIM([student_code])) AS student_code
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
	  ,score_group_name 
      ,score_group_code
      ,[score_group_label]
      ,[last_name]
      ,[first_name]
      ,[DOB]
      ,[raw_score]
      ,RIGHT ('00'+CAST([scaled_score]AS VARCHAR (4)),3) AS scaled_score
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
  FROM [test_result_AP]
  --WHERE test_section_name = 'Art History'
  --WHERE test_section_name = 'Biology'
  --WHERE test_section_name = 'Chemistry'
  --WHERE test_section_name = 'Calculus AB'
  --WHERE test_section_name = 'Calculus BC'
  --WHERE test_section_name = 'Chinese Language and Culture'
  --WHERE test_section_name = 'Computer Science A'
  --WHERE test_section_name = 'English Language and Composition'
  --WHERE test_section_name = 'English Literature and Composition'
  --WHERE test_section_name = 'Environmental Science'
  --WHERE test_section_name = 'European History'
  --WHERE test_section_name = 'French Language and Culture'
  --WHERE test_section_name = 'German Language and Culture'
  --WHERE test_section_name = 'Human Geography'
  --WHERE test_section_name = 'Italian Language and Culture'
  --WHERE test_section_name = 'Japanese Language and Culture'
  --WHERE test_section_name = 'Macroeconomics'
  --WHERE test_section_name = 'Microeconomics'
  --WHERE test_section_name = 'Music Aural Subscore'
  --WHERE test_section_name = 'Music Theory'
  --WHERE test_section_name = 'Physics C: Electricity and Magnetism'
  --WHERE test_section_name = 'Physics C: Mechanics'
  --WHERE test_section_name = 'Psychology'
  --WHERE test_section_name = 'Spanish Language and Culture'
  --WHERE test_section_name = 'Spanish Literature and Culture'
  --WHERE test_section_name = 'Statistics'
  --WHERE test_section_name = 'Studio Art: 2-D Design Portfolio'
  --WHERE test_section_name = 'Studio Art: 3-D Design Portfolio'
  --WHERE test_section_name = 'Studio Art: Drawing Portfolio'
  --WHERE test_section_name = 'United States Government and Politics'
  --WHERE test_section_name = 'United States History'
  --WHERE test_section_name = 'World History'
) AS T1

WHERE 1 = 1
AND RN = 1
AND student_code IS NOT NULL
and student_code in ('970092783','970092753')
ORDER BY school_code

