USE Assessments

BEGIN TRAN
TRUNCATE TABLE [CCR_FOR_STARS]
INSERT INTO [CCR_FOR_STARS]
SELECT * FROM 
(
SELECT
	'001' AS 'DISTRICT CODE'
	,'SATSUB' AS 'TEST DESCRIPTION'
	,'2015-06-30' AS 'ASSESSMENT SCHOOL YEAR DATE'
	,SUBTEST_1 AS 'ITEM DESCRIPTION CODE'
	,SUBSTRING ([SAT_Subj_Test_Date],5,4)+'-'+ SUBSTRING ([SAT_Subj_Test_Date],1,2) +'-' + SUBSTRING ([SAT_Subj_Test_Date], 3,2) AS 'TEST DATE'
	,STATE_ID AS 'STUDENT ID'
	,LOCATION_CODE AS 'LOCATION CODE'
	,Subj_Test1_Score AS 'RAW SCORE'
FROM
(	
SELECT [STATE_ID]
	  ,SAT_Subj_Test_Date
	  ,LOCATION_CODE
      ,CASE WHEN [SAT_Subj_Ed_Level] = '2' THEN '08'
                  WHEN [SAT_Subj_Ed_Level] = '3' THEN '09'
                  WHEN [SAT_Subj_Ed_Level] = '4' THEN '10'
                  WHEN [SAT_Subj_Ed_Level] = '5' THEN '11'
            ELSE '12'
            END
            AS GRADE                
      ,CASE WHEN [Subj_Test1] = 'EB' THEN 'ECOLOGICAL BIOLOGY'
                  WHEN [Subj_Test1] = 'MB' THEN 'MOLECULAR BIOLOGY'
                  WHEN [Subj_Test1] = 'CH' THEN 'CHEMISTRY'
                  WHEN [Subj_Test1] = 'CL' THEN 'CHINESE WITH LISTENING'
                  WHEN [Subj_Test1] = 'FL' THEN 'FRENCH WITH LISTENING'
                  WHEN [Subj_Test1] = 'FR' THEN 'FRENCH'
                  WHEN [Subj_Test1] = 'GL' THEN 'GERMAN WITH LISTENING'
                  WHEN [Subj_Test1] = 'GM' THEN 'GERMAN'
                  WHEN [Subj_Test1] = 'IT' THEN 'ITALIAN'
                  WHEN [Subj_Test1] = 'JL' THEN 'JAPANESE WITH LISTENING'
                  WHEN [Subj_Test1] = 'KL' THEN 'KOREAN WITH LISTENING'
                  WHEN [Subj_Test1] = 'LR' THEN 'LITERATURE'
                  WHEN [Subj_Test1] = 'LT' THEN 'LATIN'
                  WHEN [Subj_Test1] = 'M1' THEN 'MATH LEVEL 1'
                  WHEN [Subj_Test1] = 'M2' THEN 'MATH LEVEL 2'
                  WHEN [Subj_Test1] = 'MH' THEN 'MODERN HEBREW'
                  WHEN [Subj_Test1] = 'PH' THEN 'PHYSICS'
                  WHEN [Subj_Test1] = 'SL' THEN 'SPANISH WITH LISTENING'
                  WHEN [Subj_Test1] = 'SP' THEN 'SPANISH'
                  WHEN [Subj_Test1] = 'UH' THEN 'US HISTORY'
                  WHEN [Subj_Test1] = 'WH' THEN 'WORLD HISTORY'
                  
            ELSE [Subj_Test1]
            END
            AS SUBTEST_1                  
      ,[Subj_Test1_Score] AS Subj_Test1_Score
  FROM [CCR_SAT]
  where Subj_Test1_Score > '1'
  AND SCH_YR = '2014-2015'
UNION
SELECT [STATE_ID]
	  ,SAT_Subj_Test_Date
	  ,LOCATION_CODE
      ,CASE WHEN [SAT_Subj_Ed_Level] = '2' THEN '08'
                  WHEN [SAT_Subj_Ed_Level] = '3' THEN '09'
                  WHEN [SAT_Subj_Ed_Level] = '4' THEN '10'
				  WHEN [SAT_Subj_Ed_Level] = '5' THEN '11'
            ELSE '12'
            END
            AS GRADE                

      ,CASE WHEN [Subj_Test2] = 'EB' THEN 'ECOLOGICAL BIOLOGY'
                  WHEN [Subj_Test2] = 'MB' THEN 'MOLECULAR BIOLOGY'
                  WHEN [Subj_Test2] = 'CH' THEN 'CHEMISTRY'
                  WHEN [Subj_Test2] = 'CL' THEN 'CHINESE WITH LISTENING'
                  WHEN [Subj_Test2] = 'FL' THEN 'FRENCH WITH LISTENING'
                  WHEN [Subj_Test2] = 'FR' THEN 'FRENCH'
                  WHEN [Subj_Test2] = 'GL' THEN 'GERMAN WITH LISTENING'
                  WHEN [Subj_Test2] = 'GM' THEN 'GERMAN'
                  WHEN [Subj_Test2] = 'IT' THEN 'ITALIAN'
                  WHEN [Subj_Test2] = 'JL' THEN 'JAPANESE WITH LISTENING'
                  WHEN [Subj_Test2] = 'KL' THEN 'KOREAN WITH LISTENING'
                  WHEN [Subj_Test2] = 'LR' THEN 'LITERATURE'
                  WHEN [Subj_Test2] = 'LT' THEN 'LATIN'
                  WHEN [Subj_Test2] = 'M1' THEN 'MATH LEVEL 1'
                  WHEN [Subj_Test2] = 'M2' THEN 'MATH LEVEL 2'
                  WHEN [Subj_Test2] = 'MH' THEN 'MODERN HEBREW'
                  WHEN [Subj_Test2] = 'PH' THEN 'PHYSICS'
                  WHEN [Subj_Test2] = 'SL' THEN 'SPANISH WITH LISTENING'
                  WHEN [Subj_Test2] = 'SP' THEN 'SPANISH'
                  WHEN [Subj_Test2] = 'UH' THEN 'US HISTORY'
                  WHEN [Subj_Test2] = 'WH' THEN 'WORLD HISTORY'
                  
            ELSE [Subj_Test2]
            END
            AS SUBTEST_1                  
      ,[Subj_Test2_Score] AS Subj_Test1_Score
  FROM [CCR_SAT]
  where Subj_Test2_Score > '1'
  AND SCH_YR = '2014-2015'
UNION
SELECT [STATE_ID]
	  ,SAT_Subj_Test_Date
	  ,LOCATION_CODE
      ,CASE WHEN [SAT_Subj_Ed_Level] = '2' THEN '08'
                  WHEN [SAT_Subj_Ed_Level] = '3' THEN '09'
                  WHEN [SAT_Subj_Ed_Level] = '4' THEN '10'
				  WHEN [SAT_Subj_Ed_Level] = '5' THEN '11'
            ELSE '12'
            END
            AS GRADE                

      ,CASE WHEN [Subj_Test3] = 'EB' THEN 'ECOLOGICAL BIOLOGY'
                  WHEN [Subj_Test3] = 'MB' THEN 'MOLECULAR BIOLOGY'
                  WHEN [Subj_Test3] = 'CH' THEN 'CHEMISTRY'
                  WHEN [Subj_Test3] = 'CL' THEN 'CHINESE WITH LISTENING'
                  WHEN [Subj_Test3] = 'FL' THEN 'FRENCH WITH LISTENING'
                  WHEN [Subj_Test3] = 'FR' THEN 'FRENCH'
                  WHEN [Subj_Test3] = 'GL' THEN 'GERMAN WITH LISTENING'
                  WHEN [Subj_Test3] = 'GM' THEN 'GERMAN'
                  WHEN [Subj_Test3] = 'IT' THEN 'ITALIAN'
                  WHEN [Subj_Test3] = 'JL' THEN 'JAPANESE WITH LISTENING'
                  WHEN [Subj_Test3] = 'KL' THEN 'KOREAN WITH LISTENING'
                  WHEN [Subj_Test3] = 'LR' THEN 'LITERATURE'
                  WHEN [Subj_Test3] = 'LT' THEN 'LATIN'
                  WHEN [Subj_Test3] = 'M1' THEN 'MATH LEVEL 1'
                  WHEN [Subj_Test3] = 'M2' THEN 'MATH LEVEL 2'
                  WHEN [Subj_Test3] = 'MH' THEN 'MODERN HEBREW'
                  WHEN [Subj_Test3] = 'PH' THEN 'PHYSICS'
                  WHEN [Subj_Test3] = 'SL' THEN 'SPANISH WITH LISTENING'
                  WHEN [Subj_Test3] = 'SP' THEN 'SPANISH'
                  WHEN [Subj_Test3] = 'UH' THEN 'US HISTORY'
                  WHEN [Subj_Test3] = 'WH' THEN 'WORLD HISTORY'
                  
            ELSE [Subj_Test3]
            END
            AS SUBTEST_1                  
      ,[Subj_Test3_Score] AS Subj_Test1_Score
  FROM [CCR_SAT]
  where Subj_Test3_Score > '1'
  AND SCH_YR = '2014-2015'
) AS CCR
) AS T2
--WHERE [TEST DATE] > '2014-06-07'
--LEFT JOIN
--	[046-WS02].DB_STARS_HISTORY.DBO.STUDENT AS STUD
--	ON
--	CAST (LTRIM(RTRIM(CCR.STATE_ID)) AS VARCHAR (50)) = LTRIM(RTRIM(STUD.[ALTERNATE STUDENT ID]))
--	AND STUD.SY = '2014'
ORDER BY [LOCATION CODE]

ROLLBACK