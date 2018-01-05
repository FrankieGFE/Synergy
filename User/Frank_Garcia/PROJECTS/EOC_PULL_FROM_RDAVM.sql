USE [SchoolNetDW]
GO

SELECT
	 [assessment_id]
      ,[assessment_name]
      ,[assessment_date]
      ,[student_id]
      ,[student_name]
      ,[proficiency_measure]
      ,[proficiency_score]
      ,[grade]
      ,[filename]
  FROM [dbo].[Riverside_Assessment_Data]
  WHERE assessment_name LIKE '%eoc%'
  ORDER BY assessment_id
GO


