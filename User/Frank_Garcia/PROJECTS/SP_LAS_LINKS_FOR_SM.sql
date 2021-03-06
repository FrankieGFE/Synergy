/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	   '1' AS DST_NBR 
      ,SP.[STUDENT #] AS ID_NBR
	  ,'SPANISH PROF' AS TEST_ID
	  ,'SP-LAS-LINKS' AS TEST_SUB
	  ,'2014' AS SCH_YR
      ,SP.[TEST DATE] AS TEST_DT
	  ,SP.[LOC NUMBER] AS SCH_NBR
      ,RIGHT ('00'+SP.[GRADE],2) AS GRDE
      ,[OVERALL        PROFICIENCY  LEVEL] AS SCORE1
	  --,JUL.[OVER ALL      SCALE SCORE]
	  ,JUL.[OVER ALL      SCALE SCORE] AS SCORE2
	  ,JUL.[READING        SCALE SCORE] AS SCORE3
      --,SP.[SCH_YR]
  FROM [SchoolNetDevelopment].[dbo].[SP_LAS_LINKS] SP
  INNER JOIN
  [SPA-LAS_072314] JUL
  ON SP.[STUDENT #] = JUL.[STUDENT #]
  --AND SP.[TEST DATE] = JUL.[TEST DATE]
  AND SP.[READING  SCALE SCORE] = JUL.[READING        SCALE SCORE]
  AND SP.[SPEAKING SCALE SCORE] = JUL.[SPEAKING       SCALE SCORE]
  AND SP.[LISTENING SCALE SCORE] = JUL.[LISTENING      SCALE SCORE]
  AND SP.[OVER ALL SCALE SCORE] = JUL.[OVER ALL      SCALE SCORE]
  AND SP.[OVER ALL SCALE SCORE] > '1'
  AND SP.SCH_YR = '2013-2014'
  ORDER BY GRDE