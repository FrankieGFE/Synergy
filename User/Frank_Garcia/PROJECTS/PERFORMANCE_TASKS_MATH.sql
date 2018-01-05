USE [SchoolNet]
GO

--TRUNCATE TABLE dbo.test_result_PERFORMANCE_TASKS
--GO
--INSERT INTO dbo.test_result_PERFORMANCE_TASKS
SELECT
	student_code
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,TEST_SECTION_NAME AS [test_section_name]
      ,[parent_test_section_code]
      ,[low_test_level_code]
      ,[high_test_level_code]
      ,[test_level_name]
      ,[version_code]
      ,[Overall Exam Proficiency Level Text] AS [score_group_name]
      ,[Overall Exam Proficiency Level Text] AS [score_group_code]
      ,[score_group_label]
      ,[last_name]
      ,[first_name]
      ,[dob]
      ,[Overall Exam Score] AS [raw_score]
      ,[scaled_score]
      ,[nce_score]
      ,[Overall Exam Percent Score] AS [percentile_score]
      ,[score_1]
      ,[score_2]
      ,[score_3]
      ,[score_4]
      ,[score_5]
      ,[score_6]
      ,[score_7]
      ,[score_8]
      ,[score_9]
      ,[score_10]
      ,[score_11]
      ,[score_12]
      ,[score_13]
      ,[score_14]
      ,[score_15]
      ,[score_16]
      ,[score_17]
      ,[score_18]
      ,[score_19]
      ,[score_20]
      ,[score_21]
      ,[score_raw_name]
      ,[score_scaled_name]
      ,[score_nce_name]
      ,[score_percentile_name]
      ,[score_1_name]
      ,[score_2_name]
      ,[score_3_name]
      ,[score_4_name]
      ,[score_5_name]
      ,[score_6_name]
      ,[score_7_name]
      ,[score_8_name]
      ,[score_9_name]
      ,[score_10_name]
      ,[score_11_name]
      ,[score_12_name]
      ,[score_13_name]
      ,[score_14_name]
      ,[score_15_name]
      ,[score_16_name]
      ,[score_17_name]
      ,[score_18_name]
      ,[score_19_name]
      ,[score_20_name]
      ,[score_21_name]

FROM
(
	SELECT
		student_id  AS student_code
		,'2014' AS school_year
		,STUD1.school_code AS school_code
		,assessment_date AS test_date_code
		,'PBT' AS test_type_code
		,'Performance Based Task' AS test_type_name
		,'MATH' AS test_section_code
		,'0' AS parent_test_section_code
		,'0'+ LEFT(grade,1) AS low_test_level_code
		,'0' + RIGHT(GRADE,1) AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,'Performance Level' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		,CW.test_section_name
		/*concatenate the year, month and day--*/
		,STUD1.DOB AS DOB
		,PT1.proficiency_measure
		,PT1.proficiency_score
		,'' AS scaled_score
		,'' AS raw_score
		,'' AS nce_score
		,'' AS percentile_score
		,'' AS score_1
		,'' AS score_2
		,'' AS score_3
		,'' AS score_4
		,'' AS score_5
		,'' AS score_6
		,'' AS score_7
		,'' AS score_8
		,'' AS score_9
		,'' AS score_10
		,'' AS score_11
		,'' AS score_12
		,'' AS score_13
		,'' AS score_14
		,'' AS score_15
		,'' AS score_16
		,'' AS score_17
		,'' AS score_18
		,'' AS score_19
		,'' AS score_20
		,'' AS score_21
		,'Raw Score' AS score_raw_name
		,'' AS score_scaled_name
		,'' AS score_nce_name
		,'Percent' AS score_percentile_name
		,'' AS score_1_name
		,'' AS score_2_name
		,'' AS score_3_name
		,'' AS score_4_name
		,'' AS score_5_name
		,'' AS score_6_name
		,'' AS score_7_name
		,'' AS score_8_name
		,'' AS score_9_name
		,'' AS score_10_name
		,'' AS score_11_name
		,'' AS score_12_name
		,'' AS score_13_name
		,'' AS score_14_name
		,'' AS score_15_name
		,'' AS score_16_name
		,'' AS score_17_name
		,'' AS score_18_name
		,'' AS score_19_name
		,'' AS score_20_name
		,'' AS score_21_name

	FROM [SchoolNet].[dbo].[Performance_Tasks] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.student_id = STUD1.student_code

	LEFT JOIN
	PERFORMANCE_TASKS_CROSSWALK AS CW
	ON PT1.assessment_id = CW.assessment_id

	WHERE PT1.assessment_name LIKE '%Math%'
	AND proficiency_measure IN ('Overall Exam Percent Score','Overall Exam Proficiency Level Text','Overall Exam Score')
	--AND STUDENT_ID = '100505148'
) AS T1
PIVOT
(max([proficiency_score]) FOR proficiency_measure IN ([Overall Exam Percent Score],[Overall Exam Proficiency Level Text],[Overall Exam Score])) AS PVT1

--) AS PT
--) AS MATH

WHERE school_code IS NOT NULL
AND test_level_name IS NOT NULL
AND student_code IS NOT NULL
--and student_code = '100013523'
ORDER BY school_code
