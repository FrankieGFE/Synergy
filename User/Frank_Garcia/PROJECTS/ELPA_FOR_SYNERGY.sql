/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  
      [GRDE]
      ,[ID_NBR]
      ,[SCH_NBR]
      ,[SCH_YR]
      ,[SCORE_1]
      ,[SCORE_2]
      ,[SCORE_3]
      ,[TEST_DT]
      ,[TEST_ID]
      ,[TEST_SUB]
	  ,CASE
		WHEN SCORE_1 = '0' THEN 'Incomplete'
		WHEN SCORE_1 = '1' THEN 'Beginning'
		WHEN SCORE_1 = '2' THEN 'Early Intermediate'
		WHEN SCORE_1 = '3' THEN 'Intermediate'
		WHEN SCORE_1 = '4' THEN 'Early Advanced'
		WHEN SCORE_1 IN ('5', '6') THEN 'Advanced'
	END AS 'PROFICIENCY LEVEL'
  FROM [PR].[DBTSIS].[GS055] AS PROF

  WHERE TEST_SUB = 'ELPA'