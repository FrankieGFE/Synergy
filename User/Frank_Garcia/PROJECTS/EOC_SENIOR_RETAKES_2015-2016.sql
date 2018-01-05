USE [Assessments]
GO

SELECT
	  [District Number]
      ,[ID Number]
      ,[Test ID]
      ,[Subtest]
      ,[School Year]
      ,[test Date]
      ,[School]
      ,[Grade]
      ,[Score1]
      ,[Score2]
      ,[Score3]
      ,[DOB]
      ,[last_name]
      ,[first_name]
      ,[SCH_YR]
      ,[full_name]
      ,[assessment_id]
      ,[Content]
FROM
(
SELECT
	  ROW_NUMBER () OVER (PARTITION BY [ID Number] ORDER BY [ID Number] DESC) AS RN 
	  ,[District Number]
      ,[ID Number]
      ,[Test ID]
      ,[Subtest]
      ,[School Year]
      ,[test Date]
      ,[School]
      ,[Grade]
      ,[Score1]
      ,[Score2]
      ,[Score3]
      ,[DOB]
      ,[last_name]
      ,[first_name]
      ,[SCH_YR]
      ,[full_name]
      ,[assessment_id]
      ,[Content]
  FROM [dbo].[EOC_Senior_Retakes_2015-2016]
  WHERE 1 = 1
  --AND Subtest = 'Algebra I 7 12 V003'
  --AND Subtest = 'Algebra II 9 12 V006'
  --AND Subtest = 'Biology 9 12 V007'
  --AND Subtest = 'Chemistry 9 12 V008'
  --AND Subtest = 'Economics 9 12 V004'
  --AND Subtest = 'ELA III Reading 9 12 V006'
  --AND Subtest = 'English IV Writing 9 12 V003'
  --AND Subtest = 'English Language Arts III Writing 11 11 V006'
  --AND Subtest = 'Financial Literacy 9 12 V003'
  --AND Subtest = 'Geometry 9 12 V003'
  --AND Subtest = 'New Mexico History 9 12 V004'
  --AND Subtest = 'Spanish I 9 12 V003'
  --AND Subtest = 'Spanish I 9 12 V004'
  --AND Subtest = 'Spanish I 9 12 V005'
  --AND Subtest = 'Spanish I 9 12 V006'
  --AND Subtest = 'US Government Comprehensive 9 12 V005'
  --AND Subtest = 'US History 9 12 V007'
  --AND Subtest = 'World History and Geography 9 12 V003'
  --AND Subtest = ''
) AS EOC
--WHERE RN = 1
GO


