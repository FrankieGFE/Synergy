USE [SchoolNet]
GO
--BEGIN TRAN

INSERT INTO [SchoolNet].[dbo].[IAAT_assessment_data]
SELECT [assessment_id]
      ,[assessment_name]
      ,[assessment_date]
      ,[student_id]
      ,[student_name]
      ,[proficiency_measure]
      ,[proficiency_score]
      --,[grade]
  FROM [dbo].[Performance_Tasks]
  where assessment_name not like '%task%'

--ROLLBACK

GO


