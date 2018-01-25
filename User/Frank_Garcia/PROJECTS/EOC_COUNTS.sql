USE Assessments
GO

--BEGIN TRAN

TRUNCATE TABLE EOC_COUNTS
INSERT INTO EOC_COUNTS

SELECT 
	[ID Number] AS ID_NBR
	,'1' AS DST_NBR 
	,Grade AS GRDE
	,STUD.grade_code
	,School AS SCH_NBR
	,''AS SCHOOL_CODE
	,[School Year]  AS SCH_YR
	,Score1 AS SCORE_11
	,Score2 AS SCORE_2
	,[test Date] AS TEST_DT
	,'EOC' AS TEST_ID
	,CASE WHEN Subtest LIKE '%HIST%' OR Subtest LIKE '%GOVER%' OR Subtest LIKE '%ECON%'  THEN 'SS'
		  WHEN Subtest LIKE '%WRIT%' THEN 'WRITING'

	END AS TEST_SUB
	--,assessment_id

FROM   EOC_ AS EOC_
LEFT JOIN
ALLSTUDENTS AS STUD
ON  EOC_.[ID Number] = STUD.student_code
WHERE  [ID Number] IN (SELECT student_code 
                  FROM   ALLSTUDENTS) 
       AND Grade IN ('09', '10', '11', '12', 
                     'C1', 'C2', 'C3', 'C4', 
                     'T1', 'T2', 'T3', 'T4', 'H1', 'H2','H3','H4','H5','H6','H7','H8','H9','H0') 
	  AND (Subtest LIKE '%HIST%' OR Subtest LIKE '%WRIT%' OR Subtest LIKE '%GOVER%' OR Subtest LIKE '%ECON%')
	  AND Score1 IS NOT NULL 
--and [ID Number] = '102726999'	  
--AND Score2 = 'NO CUT SCORE'
ORDER BY TEST_SUB


--ROLLBACK