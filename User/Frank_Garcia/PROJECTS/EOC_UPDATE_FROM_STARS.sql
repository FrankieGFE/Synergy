BEGIN TRAN
 
UPDATE [SchoolNet].[dbo].[EOC_2]
SET
[School] = STUD.[LOCATION CODE]
,[Grade] = STUD.[CURRENT GRADE LEVEL]
,DOB = STUD.[BIRTHDATE]
,last_name = STUD.[LAST NAME LONG]
,first_name = STUD.[FIRST NAME LONG]
--SELECT 
--	   [District Number]
--      ,[ID Number]
--      ,[Test ID]
--      ,[Subtest]
--      ,[School Year]
--      ,[test Date]
--      ,[School]
--      ,[Grade]
--      ,[Score1]
--      ,[Score2]
--      ,[Score3]
--      ,[DOB]
--      ,[last_name]
--      ,[first_name]
--      ,[SCH_YR]
--      ,[full_name]
  FROM [SchoolNet].[dbo].[EOC_2] AS EOC
  LEFT JOIN
	  [046-WS02].[db_STARS_History].dbo.STUDENT AS STUD
	  ON
	   EOC.[ID Number] = STUD.[ALTERNATE STUDENT ID]
  WHERE EOC.DOB IS NULL
  --AND STUD.SY = EOC.[School Year]
  AND STUD.SY = '2013'

  ROLLBACK