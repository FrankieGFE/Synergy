SELECT
      [GRDE]
      ,[ID_NBR]
      ,[SCH_NBR]
      ,[SCH_YR]
      ,[SCORE_1]
      ,Level
      ,[SCORE_3]
      ,[TEST_DT]
      ,[TEST_ID]
      ,[TEST_SUB]
	  --,[PROFICIENCY LEVEL]
FROM
(
SELECT 
	  ROW_NUMBER () OVER (PARTITION BY [ID_NBR] ORDER BY [TEST_ID] DESC) AS RN 
      ,[GRDE]
      ,[ID_NBR]
      ,[SCH_NBR]
      ,[SCH_YR]
      ,[SCORE_1]
      ,[SCORE_2]
      ,'' AS [SCORE_3]
      ,[TEST_DT]
      ,[TEST_ID]
      ,[TEST_SUB]
	  ,SCORE.Level
	--  ,CASE
	--	WHEN SCORE_1 BETWEEN 1 AND 1.9 THEN 'Beginning' 
	--	WHEN SCORE_1 BETWEEN 2 AND 2.9 THEN 'Early Intermediate'
	--	WHEN SCORE_1 BETWEEN 3 AND 3.9 THEN 'Intermediate'
	--	WHEN SCORE_1 BETWEEN 4 AND 4.9 THEN 'Proficient'
	--	WHEN SCORE_1 BETWEEN 5 AND 6.9 THEN  'Above Proficient'
	--	--WHEN SCORE_1 IN ('5', '6') THEN 'Advanced'
	--END AS 'PROFICIENCY LEVEL'
	--,'' as 'PROFICIENCY LEVEL'
  FROM [PR].[DBTSIS].[GS055] AS PROF
  LEFT JOIN
  APS.LCETestLevels AS SCORE
  ON PROF.SCORE_1 BETWEEN SCORE.ValueFrom AND SCORE.ValueTo
  AND Test = 'WAPT'

  WHERE TEST_SUB = 'WAPT'
  --AND SCORE_1 NOT IN ('FSP','LSP','NSP','0')
) AS T1
--where [ID_NBR] = '970064430'

WHERE RN = 1
ORDER BY SCORE_1, GRDE
