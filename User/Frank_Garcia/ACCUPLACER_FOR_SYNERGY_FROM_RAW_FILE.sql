/****** Script for SelectTopNRows command from SSMS  ******/

SELECT
	APS_ID
	,[Test_Date]
	,LOC_NUM
	,COLLEGE_LEVEL_MATH
	,PL_COLLEGE_LEVEL_MATH 

FROM
(
SELECT 
	  ROW_NUMBER () OVER (PARTITION BY APS_ID, [College Level Math] ORDER BY [Test Date] DESC) AS RN
	  ,[Last Name]
      ,[First Name]
      ,APS_ID
      ,CONVERT(DATE, REPLACE([Test Date],'-',''), 101) AS TEST_DATE
      ,LOC_NUM
      --,[Reading] AS READING_COMPREHENSION
      --,[English] AS SENTENCE_SKILLS
      --,[Elementary Algebra] AS ELEMENTARY_ALGEBRA
      --,[Arith] AS ARITHMETIC
      ,[College Level Math] AS COLLEGE_LEVEL_MATH
	  --,CASE WHEN Reading >= '82' THEN 'PASS' ELSE 'FAIL'
	  --END AS PL_READING_COMPREHENSION
	  --,CASE WHEN English >= '82' THEN 'PASS' ELSE 'FAIL'
	  --END AS PL_SENTENCE_SKILS
	  --,CASE WHEN [Elementary Algebra] >= '80' THEN 'PASS' ELSE 'FAIL'
	  --END AS PL_ELEMENTARY_AGLGEBRA
	  --,CASE WHEN ARITH >= '82' THEN 'PASS' ELSE 'FAIL'
	  --END AS PL_ARITH
	  ,CASE WHEN [College Level Math] >= '50' THEN 'PASS' ELSE 'FAIL'
	  END AS PL_COLLEGE_LEVEL_MATH
  FROM [Assessments].[dbo].[ACCUPLACER_2015-2016_V2]
  WHERE
  1 = 1
  AND [College Level Math] != ''
  AND APS_ID > 0
)AS T2
WHERE 1 = 1
AND RN = 1