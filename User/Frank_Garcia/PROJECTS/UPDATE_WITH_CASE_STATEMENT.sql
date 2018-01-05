USE [Assessments]
GO
BEGIN TRAN

--SELECT [LAST NAME]
--      ,[FIRST NAME]
--      ,[MIDDLE NAME]
--      ,SSS.[PERM ID]
--      ,[SCHOOL]
--      ,[GRADE]
--      ,[SCHOOL NBR]
--	  ,LIST.[Section ID]
--	  ,CASE
--			WHEN [Section ID] LIKE 'C%' THEN '580'
--			WHEN [Section ID] LIKE 'S%' THEN '550'
--			WHEN [Section ID] LIKE 'W%' THEN '570'
--			WHEN [Section ID] LIKE 'E%' THEN '517'
--	 END AS SCH_NBRS
BEGIN TRAN
UPDATE
	SUMMER_SCHOOL_STUDENTS
	SET [SCHOOL NBR] = (case when [Section ID] LIKE 'C%' THEN '580'
						 WHEN [Section ID] LIKE 'S%' THEN '550'
						 WHEN [Section ID] LIKE 'W%' THEN '570'
						 WHEN [Section ID] LIKE 'E%' THEN '517' end)
  FROM [dbo].[SUMMER_SCHOOL_STUDENTS] AS SSS
  LEFT JOIN
  [SUMMER_SCHOOL_student list] AS LIST
  ON
  SSS.[PERM ID] = LIST.[Perm ID]
  WHERE [SCHOOL NBR] IS NULL
ROLLBACK
  --LEFT JOIN
  --[State School Number] AS SCHOOL
  --ON SSS.SCHOOL = SCHOOL.SCH_NME
  ORDER BY SCH_NBRS

ROLLBACK

GO


