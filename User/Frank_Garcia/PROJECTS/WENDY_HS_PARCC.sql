USE 
Assessments
GO

SELECT
	DISTINCT [SCHOOL YEAR]
	,[APS STUDENT ID]
	,CASE 
	      WHEN [APS STUDENT ID] = '970060459' THEN '529612699'
		  WHEN [STATE STUDENT ID] IS NULL THEN STUD.state_id
		  ELSE [STATE STUDENT ID]
	END AS 'STATE STUDENT ID'
	,[TEST TYPE NAME]
	,[TEST SECTION NAME]
	,[SCORE GROUP CODE]
	,[SCORE GROUP NAME]
	,[SCALED SCORE]
FROM
(
SELECT 
	 '2014-2015' AS 'SCHOOL YEAR'
	 ,PARC.[student_code] AS 'APS STUDENT ID'
	 ,STUD.state_id AS 'STATE STUDENT ID'
	 ,'PARCC' AS 'TEST TYPE NAME'
	 ,CASE WHEN test_section_name = 'ELA' OR test_section_name = 'MATH' THEN test_section_name +' '+ test_level_name
	       ELSE test_section_name
	  END AS 'TEST SECTION NAME'
	  ,score_group_code AS 'SCORE GROUP CODE'
	  ,score_group_name AS 'SCORE GROUP NAME'
	  ,scaled_score AS 'SCALED SCORE'
  FROM [Assessments].[dbo].[test_result_PARCC] AS PARC
  LEFT JOIN
  allstudents_ALL AS STUD
  ON PARC.student_code = STUD.student_code
  AND PARC.school_code = STUD.school_code
  AND STUD.school_year = '2014'
) AS T1

LEFT JOIN
allstudents_ALL AS STUD
ON T1.[APS STUDENT ID] = STUD.student_code
AND STUD.school_year = '2014'

  ORDER BY [STATE STUDENT ID]