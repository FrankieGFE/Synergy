USE [Assessments]
GO

SELECT [SIS_NUMBER]
      ,[FIRST_NAME]
      ,[LAST_NAME]
      ,[SCHOOL_CODE]
      ,[SCHOOL_NAME]
      ,[GRADE]
      ,[COURSE_ID]
      ,[COURSE_TITLE]
      ,[SECTION_ID]
      ,[TERM_CODE]
      ,[DEPARTMENT]
      ,[MARK]
      ,[CREDIT]
      ,[GRADE_PERIOD]
      ,IAAT.[Overall Percent Score] [IAAT]
  FROM [dbo].[TRASH_8th Grade Student 1st Semester Grades Math-English 011516] AS GRADE
  LEFT JOIN
  [TRASH_IAAT Form B Scored Students] AS IAAT
  ON GRADE.SIS_NUMBER = IAAT.[Student ID]
GO


