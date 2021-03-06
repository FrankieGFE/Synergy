/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [STATE_ID]
      ,[APS_ID]
      ,[APS Sch Code]
      ,'PSAT' AS [TEST]
      ,[Grade] AS TEST_LEVEL
      ,[CriticalReadingCRScore] AS 'CRITICAL_READING'
	  ,CASE
		WHEN GSY <= '2016' OR GSY IS NULL THEN
			CASE
				WHEN CriticalReadingCRScore < '50' THEN 'FAIL' 
				ELSE 'PASS'
			END 
		ELSE
			CASE
				WHEN CriticalReadingCRScore < '45' THEN 'FAIL'
				ELSE 'PASS'
			END
	   END AS CRITICAL_READING_PL
	  --,GSY
      ,[CritReadgNatlPercentile] AS CR_NAT_PERCENTILE
      ,[MathMScore] AS MATH
	  ,CASE
		WHEN MathMScore < '50' THEN 'FAIL' ELSE 'PASS'
	  END AS MATH_PL
      ,[MathNatlPercentile] AS MATH_NAT_PERCENTILE
      ,[WritingSkillsWScore] AS WRITING
	  ,CASE
		WHEN WritingSkillsWScore < '49' THEN 'FAIL' ELSE 'PASS'
	  END AS WRITING_PL
      ,[WrtgNatlPercentile] AS WRITING_NAT_PERCENTILE
      ,[SCH_YR]
  FROM [SchoolNet].[dbo].[CCR_PSAT]
  where SCH_YR = '2012-2013' AND APS_ID > '1'
  ORDER BY [APS Sch Code]