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
	  ,[PROFICIENCY LEVEL]
FROM
(
SELECT 
	  ROW_NUMBER () OVER (PARTITION BY [ID_NBR] ORDER BY [ID_NBR] DESC) AS RN 
      ,[GRDE]
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
		WHEN SCORE_1 = 'NEP' THEN 'Non-English Proficent'
		WHEN SCORE_1 LIKE 'LEP%' THEN 'Limited English Proficient'
		WHEN SCORE_1 = 'FEP' THEN 'Fully English Proficient'
		--WHEN SCORE_1 = '3' THEN 'Intermediate'
		--WHEN SCORE_1 = '4' THEN 'Early Advanced'
		--WHEN SCORE_1 IN ('5', '6') THEN 'Advanced'
	END AS 'PROFICIENCY LEVEL'
  FROM [PR].[DBTSIS].[GS055] AS PROF

  WHERE TEST_SUB = 'WAPT'
) AS T1
WHERE RN = 1
ORDER BY TEST_DT