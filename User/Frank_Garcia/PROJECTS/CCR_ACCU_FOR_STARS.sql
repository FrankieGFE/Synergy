USE Assessments
GO

BEGIN TRAN

INSERT INTO [CCR_FOR_STARS]

SELECT
	[DISTRICT CODE]
	,[TEST DESCRIPTION]
	,[ASSESSMENT SCHOOL YEAR DATE]
	,[ITEM DESCRIPTION CODE]
	,[TEST DATE]
	,[STUDENT ID]
	,[LOCATION CODE]
	,[RAW SCORE]

FROM
(
SELECT 
	  '001' AS [DISTRICT CODE]
	  ,'ACCU' AS [TEST DESCRIPTION]
	  ,'2015-06-30' AS [ASSESSMENT SCHOOL YEAR DATE]
	  ,CASE	
		WHEN [test_section_name] = 'Elementary Algebra' THEN 'ELEMENTARY ALGEBRA'
		WHEN [test_section_name] = 'Reading Comprehension' THEN 'READING COMPREHENSION'
		WHEN [test_section_name] = 'Sentence Skills' THEN 'SENTENCE SKILLS'
		WHEN [test_section_name] = 'College Level Math' THEN 'COLLEGE-LEVEL MATH'
		WHEN [test_section_name] = 'WRITEPLACER' THEN 'WRITEPLACER'
	END AS 'ITEM DESCRIPTION CODE'
	,test_date_code AS 'TEST DATE'
	,CASE WHEN STUD.state_id IS NULL THEN CCR.student_code ELSE STUD.state_id
	END AS 'STUDENT ID'
	,CASE WHEN STUD.school_code IS NULL THEN CCR.school_code ELSE STUD.school_code
	END AS 'LOCATION CODE'
	,[scaled_score] AS 'RAW SCORE'
  FROM [test_result_ACCUPLACER] AS CCR
  --LEFT JOIN
  --[046-WS02].DB_STARS_HISTORY.DBO.STUDENT AS STUD
  --ON
  --CCR.student_code = STUD.[ALTERNATE STUDENT ID]
  --AND STUD.SY = '2015'
  --AND STUD.PERIOD = '2015-03-01'
  LEFT JOIN
  allstudents_ALL AS STUD
  ON CCR.student_code = STUD.student_code
  AND STUD.school_year = '2014'
  --AND STUD.school_code NOT IN ('533')
  AND STUD.school_code = CCR.school_code
  WHERE [test_section_name] IN ('Elementary Algebra','Reading Comprehension','Sentence Skills','College Level Math','WRITEPLACER')
  --AND SCH_YR = '2013-2014'
  AND CCR.school_year = '2014'
) AS T1
--WHERE [LOCATION CODE] != 'NULL' AND [LOCATION CODE] IS NOT NULL
--WHERE RN = 1

ORDER BY [STUDENT ID]

ROLLBACK