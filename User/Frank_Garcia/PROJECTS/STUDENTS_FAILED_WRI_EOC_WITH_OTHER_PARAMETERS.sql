USE [SchoolNet]
GO
SELECT
	T2.[ID Number]
	,T2.[Test ID]
	,T2.Subtest
	,T2.school_code
	,T2.grade_code
	,T2.last_name
	,T2.first_name
	,T2.fail
	,EES.score_1 AS 'EOC REQUIREMENTS'
	,EES.score_2 AS 'SBA REQUIREMENTS'
	,EES.score_6 AS 'SCIENCE FD'
FROM
(
SELECT
	*
FROM
(
SELECT 
      [ID Number]
      ,[Test ID]
	  ,'WRITING' AS Subtest
      --,[Subtest]
      --,[School Year]
      --,[test Date]
      --,[School]
	  ,STUD.school_code
	  ,STUD.grade_code
	  ,score1
      ,[Score2]
      ,EOC.[last_name]
      ,EOC.[first_name]
  FROM [dbo].[EOC_] AS EOC
  LEFT JOIN
  [180-SMAXODS-01].SCHOOLNET.dbo.ALLSTUDENTS AS STUD
  ON EOC.[ID Number] = STUD.student_code
  AND STUD.grade_code = '12'

  WHERE EOC.Subtest LIKE '%WRITING%'
  --AND EOC.SCORE2 = 'FAIL'
  AND STUD.grade_code = '12'
) AS T1
pivot
(max([score1]) FOR score2 IN ([pass],[fail])) AS UP1

WHERE fail IS NOT NULL
AND pass IS NULL
) AS T2

LEFT JOIN
[180-SMAXODS-01].SCHOOLNETDEVELOPMENT.[dbo].[test_result_EES] AS EES
ON T2.[ID Number] = EES.student_code
AND EES.test_section_name = 'Passed All Required Tests'

WHERE
	score_1 != 'WRI'

ORDER BY [ID Number]
GO


