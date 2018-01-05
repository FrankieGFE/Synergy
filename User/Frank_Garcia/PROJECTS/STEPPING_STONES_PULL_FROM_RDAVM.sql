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
  WHERE proficiency_MEASURE LIKE '%overall%'
  AND assessment_name LIKE '%Quarterly%'
  ORDER BY student_id, proficiency_measure
GO


