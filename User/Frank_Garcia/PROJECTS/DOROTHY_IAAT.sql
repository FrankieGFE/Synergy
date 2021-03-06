/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
	   [Last Name]
      ,[First Name]
      ,[Student ID #]
      ,[School Name]
      ,[School #]
      ,[Course Number]
      ,[COURSE_TITLE]
      ,[DEPARTMENT]
      ,[Grade 1st Semester]
      ,[IAAT %]
      ,[Recommendation ]
      ,[Work Ethic]
      ,[Attitude Independence]
      ,[Comments]
	  ,[IAAT Work Ethic]
	  ,[IAAT Placement Recommendations]
	  ,[IAAT Attitude and Independence]
	  ,[IAAT Comments]
  FROM [Assessments].[dbo].[TRASH_Student math data for HS 3.7.16] AS STUDENT
  LEFT JOIN
  [TRASH_MS IAAT Recommendations & Comments] AS IAAT
  ON STUDENT.[Student ID #] = IAAT.SIS_NUMBER