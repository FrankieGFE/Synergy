USE [Assessments]
GO

SELECT [student_code]
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
  FROM [dbo].[SBA_2014-2015]
  where test_section_name in ('READING(S)','science','WRITING')
  and student_code IN
  (
  '157681297',
  '188414494',
  '421813353',
  '483247458',
  '521184168',
  '544784978',
  '561123944',
  '627724883',
  '634188155',
  '659531651',
  '6901193',
  '6901198',
  '6901199',
  '6901201',
  '6901221',
  '6901241',
  '6901261',
  '6901298',
  '6901367',
  '6901852',
  '746415355',
  '781711650',
  '783565971',
  '797856747',
  '829591858',
  '847984291',
  '877744995',
  '879738227',
  '881271837',
  '970023003',
  '970064033',
  '6901551',
  ''

  )
  order by test_level_name
GO


