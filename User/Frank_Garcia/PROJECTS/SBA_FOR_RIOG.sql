USE [SchoolNet]
GO

SELECT
	T3.student_code
	,T3.state_id
	,T3.last_name
	,T3.first_name
	--,T3.dob
	--,T3.grade_level
	--,T3.SBA_grade_level
	--,T3.test_date_code
	,T3.test_type_name
	,T4.Math_SS
	,T3.Math_PL
	,T4.Reading_SS
	,T3.Reading_PL
	,T4.Science_SS
	,T3.Science_PL
FROM
	(
	SELECT
	student_code
	,state_id
	,last_name
	,first_name
	,dob
	,grade_level
	,SBA_grade_level
	,test_date_code
	,test_type_name
	,Math AS Math_PL
	,Reading AS Reading_PL
	,Science AS Science_PL
FROM
(
SELECT [student_code]
      ,[test_date_code]
      ,[test_type_name]
      ,[test_section_name]
      ,[test_level_name] AS SBA_grade_level
      ,[score_group_name]
      ,[last_name]
      ,[first_name]
	  ,[dob]
      ,[score_15] AS grade_level
      ,[score_16] AS state_id
  FROM [dbo].[SBA]
  where school_year = '2013'
  AND test_section_name IN ('READING','MATH','SCIENCE')
  --AND student_code = '100003672'
) T1
pivot
(max([score_group_name]) FOR test_section_name IN ([Math], [Reading], [Science])) AS UP1
) AS T3
LEFT JOIN
(SELECT
	student_code
	,state_id
	,last_name
	,first_name
	,dob
	,grade_level
	,SBA_grade_level
	,test_date_code
	,test_type_name
	,Math AS Math_SS
	,Reading AS Reading_SS
	,Science AS Science_SS
FROM
(
SELECT [student_code]
      ,[test_date_code]
      ,[test_type_name]
      ,[test_section_name]
      ,[test_level_name] AS SBA_grade_level
      ,[last_name]
      ,[first_name]
	  ,[dob]
      ,[scaled_score]
      ,[score_15] AS grade_level
      ,[score_16] AS state_id
  FROM [dbo].[SBA]
  where school_year = '2013'
  AND test_section_name IN ('READING','MATH','SCIENCE')
  --AND student_code = '100003672'
) AS T2
pivot
(max([scaled_score]) FOR test_section_name IN ([Math], [Reading], [Science])) AS UP2
) AS T4
ON T3.student_code = T4.student_code
ORDER BY student_code
