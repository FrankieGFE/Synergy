USE [Assessments]
GO

SELECT 
	  TWO.[District Number]
      ,TWO.[ID Number] TWO_ID
	  ,THREE.[ID Number] THREE_ID
      ,THREE.[Test ID]
      ,THREE.[Subtest]
      ,THREE.[School Year]
      ,THREE.[test Date]
      ,TWO.[School]
      ,TWO.[Grade]
      ,TWO.[Score1]
      ,TWO.[Score2]
      ,TWO.[Score3]
      ,TWO.[DOB]
      ,TWO.[last_name]
      ,TWO.[first_name]
      ,TWO.[SCH_YR]
      ,TWO.[full_name]
      ,TWO.[assessment_id]
	  ,THREE.assessment_id
  FROM [dbo].[SPRING_EOC_2] AS TWO
  RIGHT JOIN
  SPRING_EOC_3 AS THREE
  ON TWO.[ID Number] = THREE.[ID Number]
  AND LTRIM(RTRIM(TWO.assessment_id)) = LTRIM(RTRIM(THREE.assessment_id))
  AND LTRIM(RTRIM(TWO.[test Date])) = LTRIM(RTRIM(THREE.[test Date]))
  --AND TWO.Score1 = THREE.Score1
  --AND TWO.[ID Number] IS NULL

  ORDER BY TWO.[ID Number], TWO.assessment_id

GO


