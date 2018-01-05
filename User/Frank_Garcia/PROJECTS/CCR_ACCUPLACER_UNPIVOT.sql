USE ASSESSMENTS


BEGIN TRAN

INSERT INTO CCR_ACCUPLACER

SELECT
	  [STID]
      ,[FName]
      ,[MI]
      ,[LName]
      ,[DOB]
      ,[SUBTEST]
      ,[TEST]
      ,[SCORE]
      ,[APS_ID]
      ,[test_level_name]
      ,[test_date_code]
      ,[school_code]
      ,[SCH_YR]
      ,'' AS [GSY]
FROM
(
SELECT
ROW_NUMBER () OVER (PARTITION BY STUD.[STUDENT ID],T1.[Last Name],T1.[First Name], T1.SUBTEST, T1.[Test Date],SCORE ORDER BY STUD.[STUDENT ID],T1.[Last Name],T1.[First Name], T1.SUBTEST, T1.[Test Date], SCORE ) AS RN
,STUD.[STUDENT ID] AS STID
,T1.[First Name] AS FName
,STUD.[MIDDLE INITIAL] AS MI
,T1.[Last Name] AS LName
,STUD.[BIRTHDATE] AS DOB
,(RIGHT ([Birth Date],4))+ '-' + LEFT ([Birth Date],2)+'-'+ (SUBSTRING([Birth Date],4,2)) AS 'ACCU_BDAY'
,T1.SUBTEST AS SUBTEST
,'ACCU' AS TEST
,SCORE
,STUD.[ALTERNATE STUDENT ID] AS APS_ID
,STUD.[CURRENT GRADE LEVEL] AS test_level_name
,T1.[Test Date] AS test_date_code
,STUD.[LOCATION CODE] AS school_code
,T1.[High School] AS LOCATION
,'2014-2015' AS SCH_YR
FROM
(
SELECT [Last Name]
      ,[First Name]
      ,[Middle Initial]
      ,[Birth Date]
      ,[Student ID]
      ,[Test Date]
      ,[High School]
	  ,SCORE
	  ,SUBTEST
	  ,SCH_YR
	  --,LOC.fld_LocNum
      --,[Reading Comprehension]
      --,[Sentence Skills]
      --,[Arithmetic]
      --,[Elementary Algebra]
      --,[College Level Math]
  FROM [180-SMAXODS-01].SCHOOLNET.[dbo].[CCR_APS non-charter accuplacer] ACCU
  UNPIVOT (SCORE FOR SUBTEST IN ([Reading Comprehension], [Sentence Skills], [Arithmetic], [Elementary Algebra], [College Level Math])) AS UNPIV
  WHERE SCH_YR = '2014-2015'
  ) AS T1
  LEFT JOIN
  [046-WS02].DB_STARS_HISTORY.DBO.STUDENT AS STUD
  ON [Last Name] = STUD.[LAST NAME LONG]
  AND [First Name] = STUD.[FIRST NAME LONG]
  AND (RIGHT ([Birth Date],4))+ '-' + LEFT ([Birth Date],2)+'-'+ (SUBSTRING([Birth Date],4,2)) = STUD.[BIRTHDATE]
  AND STUD.SY = '2015'
  AND [DISTRICT CODE] = '001'
  --AND STUD.PERIOD = '2015-06-01'
WHERE SCORE >'1'

) AS T3
WHERE RN = 1
AND STID IS NOT NULL
ORDER BY STID, LName, FName, SUBTEST, test_date_code


ROLLBACK

--1999-07-22