USE [SchoolNet]
GO

SELECT 
	  --[DST_NBR]
      --,[ID_NBR]
      --,[TEST_ID]
      --,[TEST_SUB]
      --,[SCH_YR]
	  [SCH_NBR]
      ,[TEST_DT]
      ,count (*) as total
      --,[GRDE]
      --,[SCORE1]
      --,[SCORE2]
      --,[SCORE3]
      --,[FRST_NME]
      --,[LST_NME]
      --,[BRTH_DT]
      --,[STID]
      --,[School_Year]
  FROM [dbo].[SP_PRE_LAS]
  where School_Year = '2014-2015'
  group by SCH_NBR, TEST_DT
  order by SCH_NBR
GO


