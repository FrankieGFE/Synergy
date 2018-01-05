USE Assessments
GO

SELECT [District Number]
      ,[ID Number]
      ,[Test ID]
      ,[Subtest]
      ,[School Year]
      ,[test Date]
      ,[School]
	  ,SSN.SCH_NME
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
  FROM [dbo].[EOC_] AS EOC
  LEFT JOIN
  [State School Number] AS SSN
  ON EOC.School = SSN.SCH_NBR
  WHERE [test Date] IN ('2015-04-27','2015-07-15','2015-05-11')
  ORDER BY School
GO


