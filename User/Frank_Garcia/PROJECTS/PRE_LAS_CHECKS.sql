USE [Assessments]
GO

SELECT [DST_NBR]
      ,[ID_NBR]
	  ,STUD.student_code
      ,[TEST_ID]
      ,[TEST_SUB]
      ,[SCH_YR]
      ,[TEST_DT]
      ,[SCH_NBR]
      ,[GRDE]
      ,[SCORE1]
      ,[SCORE2]
      ,[SCORE3]
      ,[FRST_NME]
	  ,STUD.first_name
      ,[LST_NME]
	  ,STUD.last_name
      ,[BRTH_DT]
      ,[STID]
      ,PRE.[School_Year]
  FROM [dbo].[SP_PRE_LAS] AS PRE
  LEFT JOIN
  ALLSTUDENTS AS STUD
  ON PRE.ID_NBR = STUD.student_code
  WHERE PRE.SCH_YR = '2015-2016'
  AND LEFT(FRST_NME,3) != LEFT (FIRST_NAME,3)
  ORDER BY student_code
GO


