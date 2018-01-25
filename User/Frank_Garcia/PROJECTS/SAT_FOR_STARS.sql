BEGIN TRAN

USE Assessments
GO

      
INSERT INTO [CCR_FOR_STARS]
SELECT 
	[DISTRICT CODE]
	,[TEST DESCRIPTION]
	,[ASSESSMENT SCHOOL YEAR DATE]
	,[ITEM DESCRITPION CODE]
	,[TEST DATE]
	,[STUDENT ID]
	,[LOCATION CODE]
	,[RAW SCORE]

FROM
(
SELECT
	ROW_NUMBER () OVER (PARTITION BY STATE_ID, [test_section_name], [test_date_code] ORDER BY [test_date_code]) AS RN
	,'001' AS [DISTRICT CODE]
	,'CCRSAT' AS [TEST DESCRIPTION]
	,'2015-06-30' AS [ASSESSMENT SCHOOL YEAR DATE]
	,CASE WHEN test_section_name = 'Critical Reading' THEN 'CRITICAL READING'
		  WHEN test_section_name = 'Writing' THEN 'WRITING'
		  WHEN test_section_name = 'Mathematics' THEN 'MATH'
	END AS [ITEM DESCRITPION CODE]
	,test_date_code AS [TEST DATE]
	,CASE WHEN stud.STATE_ID IS NULL THEN SAT.student_code ELSE STUD.state_id
	END AS [STUDENT ID]
	--,SAT.student_code
	,SAT.school_code AS [LOCATION CODE]
	,scaled_score AS [RAW SCORE]
FROM
	test_result_SAT AS SAT
	JOIN
	allstudents_ALL AS STUD
	ON
	SAT.student_code = STUD.student_code
	AND STUD.school_year = '2014'
	AND STUD.school_code != '533'
	
	LEFT JOIN
	[State School Number] AS SSN
	ON 
	SAT.school_code = SSN.SCH_NBR
WHERE
	test_section_name IN ('Critical Reading','MATHEMATICS','Writing')
	AND SAT.school_year = '2014'
	--AND SAT.school_code > '500'
) AS T1
WHERE RN = 1
ORDER BY [STUDENT ID], [ITEM DESCRITPION CODE]

ROLLBACK