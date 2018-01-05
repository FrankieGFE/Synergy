USE [SchoolNetDevelopment]
GO

SELECT [student_code]
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_name]
      ,[test_section_name]
      ,[test_level_name] AS grade_level
      ,[score_group_name]
      ,[score_group_code]
      ,[last_name]
      ,[first_name]
      ,[score_3] AS 'MATH SBA ATTEMPTS'
      ,[score_4] AS 'READING SBA ATTEMPTS'
      ,[score_5] AS 'SCIENCE SBA ATTEMPTS'
      ,[score_6] AS 'SCIENCE FINAL DETERMINATION'
	  ,SCORE_1 AS 'EOC REQUIREMENTS'
	  ,SCORE_2 AS 'SBA REQUIREMENTS'
  FROM [dbo].[test_result_EES]
  WHERE test_section_name = 'Passed All Required Tests'
  AND score_group_code = 'YES'
  --AND [test_level_name] = '12'
  AND [score_6] = 'PASS'
  ORDER BY school_code
GO


