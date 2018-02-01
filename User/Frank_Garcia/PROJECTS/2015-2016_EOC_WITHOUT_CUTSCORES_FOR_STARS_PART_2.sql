USE [Assessments]
GO

SELECT [DISTRICT CODE]
      ,[TEST DESCRIPTION]
      ,[ASSESSMENT SCHOOL YEAR DATE]
      ,[ITEM DESCRIPTION CODE]
      ,[TEST DATE]
      ,STUD.STATE_ID AS [STUDENT ID]
      ,STUD.school_code AS [LOCATION CODE]
      ,[RAW SCORE]
  FROM [dbo].[EOC_W_NO_CUT_SCORES_PART_2] AS EOC
  LEFT JOIN
  ALLSTUDENTS AS STUD
  ON EOC.[STUDENT ID] = STUD.student_code
  WHERE STUD.student_code IS NOT NULL
  ORDER BY [STUDENT ID]
GO

