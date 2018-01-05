USE [SchoolNetDevelopment]
GO

SELECT [student_code]
      ,[last_name]
      ,[first_name]
      ,[test_level_name] AS grade_level
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_name]
      ,[test_section_name] 
      ,[score_group_name]
      ,[score_1] AS 'EOC REQUIREMENTS'
      ,[score_2] AS 'SBA REQUIREMENTS'
      ,[score_3] AS 'MATH SBA ATTEMPTS' 
      ,[score_4] AS 'READING SBA ATTEMPTS'
      ,[score_5] AS 'SCIENCE SBA ATTEMPTS'
      ,[score_6] AS 'SCIENCE FINAL DETERMINATION'
  FROM [dbo].[test_result_EES]
  WHERE score_1 LIKE '%WRI%'
  AND [test_level_name] = '12'
  ORDER BY score_2
GO


