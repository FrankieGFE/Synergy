USE
Assessments
TRUNCATE TABLE TEST_RESULT
INSERT INTO TEST_RESULT

SELECT
	  DISTINCT
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
	  [SIS_NUMBER] AS student_code
	  ,[SCHOOL_YEAR] AS school_year  
	  ,SCHOOL_CODE AS school_code
	  ,'2015-04-01' AS test_date_code
	  ,'SEMESTER GRADES' AS test_type_code
	  ,'SEMESTER GRADES' AS test_type_name
	  ,COURSE_ID + TEACHER+ TERM_CODE AS test_section_code
	  ,COURSE_TITLE + ' ' + TEACHER + '  ' + TERM_CODE AS test_section_name
	  ,'0' AS parent_test_section_code
	  ,'06' AS low_test_level_code
	  ,'12' AS high_test_level_code
	  ,GRADE AS [test_level_name]
	  ,'' AS version_code
	  ,[MARK] AS score_group_name
	  ,[MARK] AS score_group_code
	  ,TERM_CODE AS [score_group_label]
	  ,[LAST_NAME] AS last_name 
      ,[FIRST_NAME] AS first_name
	  ,'' AS DOB
	  ,'' AS raw_score
	  ,'' AS scaled_score
	  ,'' AS nce_score
	  ,'' AS percentile_score
	  ,'' AS score_1
      ,COURSE_TITLE AS [score_2]
      ,TEACHER AS [score_3]
      ,TERM_CODE AS [score_4]
      ,COURSE_ID AS [score_5]
      ,'' AS [score_6]
      ,'' AS [score_7]
      ,'' AS [score_8]
      ,'' AS [score_9]
      ,'' AS [score_10]
      ,'' AS [score_11]
      ,'' AS [score_12]
      ,'' AS [score_13]
      ,'' AS [score_14]
      ,'' AS [score_15]
      ,'' AS [score_16]
      ,'' AS [score_17]
      ,'' AS [score_18]
      ,'' AS [score_19]
      ,'' AS [score_20]
      ,'' AS [score_21]
      ,'' AS [score_raw_name]
      ,'' AS [score_scaled_name]
      ,'' AS [score_nce_name]
      ,'' AS [score_percentile_name]
      ,'' AS [score_1_name]
      ,'Course Title' AS [score_2_name]
      ,'Teacher' AS [score_3_name]
      ,'Term' AS [score_4_name]
      ,'Course ID' AS [score_5_name]
      ,'' AS [score_6_name]
      ,'' AS [score_7_name]
      ,'' AS [score_8_name]
      ,'' AS [score_9_name]
      ,'' AS [score_10_name]
      ,'' AS [score_11_name]
      ,'' AS [score_12_name]
      ,'' AS [score_13_name]
      ,'' AS [score_14_name]
      ,'' AS [score_15_name]
      ,'' AS [score_16_name]
      ,'' AS [score_17_name]
      ,'' AS [score_18_name]
      ,'' AS [score_19_name]
      ,'' AS [score_20_name]
      ,'' AS [score_21_name]
FROM
(
SELECT [SIS_NUMBER]
      ,[FIRST_NAME]
      ,[LAST_NAME]
      ,[GRADE]
      ,[SCHOOL_CODE]
      ,[SCHOOL_NAME]
      ,[SCHOOL_YEAR]
      ,[COURSE_ID]
      ,[SECTION_ID]
      ,[COURSE_TITLE]
      ,[TERM_CODE]
      ,[MARK]
      ,[TEACHER]
      ,[BADGE_NUM]
	  ,DEPARTMENT
  FROM [Assessments].[dbo].[2014-2015_ELA_MATH_SCORES_TEACHERS_S1_S2]
) AS T1
) AS T2
--where student_code = '100004035'
WHERE score_group_label LIKE 'S%'
ORDER BY test_section_name, test_section_code