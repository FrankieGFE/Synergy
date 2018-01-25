USE [SchoolNet]
GO

TRUNCATE TABLE dbo.test_result_PERFORMANCE_TASKS
GO
INSERT INTO dbo.test_result_PERFORMANCE_TASKS
SELECT * FROM
(
SELECT * FROM
(
SELECT
	student_code
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,'Reading-Comprehension of Key Ideas and Details'[test_section_name]
      ,[parent_test_section_code]
      ,[low_test_level_code]
      ,[high_test_level_code]
      ,[test_level_name]
      ,[version_code]
      ,CASE 
		WHEN [Reading-Comprehension of Key Ideas and Details Proficiency Level Text] IS NOT NULL THEN [Reading-Comprehension of Key Ideas and Details Proficiency Level Text]
		WHEN [Reading Comprehension of Key Ideas and Details Proficiency Level Text] IS NOT NULL THEN [Reading Comprehension of Key Ideas and Details Proficiency Level Text]
		WHEN [Reading- Comprehension of Key Ideas and Details Proficiency Level Text] IS NOT NULL THEN [Reading- Comprehension of Key Ideas and Details Proficiency Level Text]
	  END AS [score_group_name]
      ,CASE 
		WHEN [Reading-Comprehension of Key Ideas and Details Proficiency Level Text] IS NOT NULL THEN [Reading-Comprehension of Key Ideas and Details Proficiency Level Text]
		WHEN [Reading Comprehension of Key Ideas and Details Proficiency Level Text] IS NOT NULL THEN [Reading Comprehension of Key Ideas and Details Proficiency Level Text]
		WHEN [Reading- Comprehension of Key Ideas and Details Proficiency Level Text] IS NOT NULL THEN [Reading- Comprehension of Key Ideas and Details Proficiency Level Text]
	  END AS [score_group_code]
      ,[score_group_label]
      ,[last_name]
	  ,REPLACE (first_name, '"', '') AS fist_name
   --   ,CASE WHEN STUDENT_CODE = '970041776' THEN 'John' ELSE [first_name]
	  --END AS first_name
      ,[dob]
      ,CASE 
		WHEN [Reading-Comprehension of Key Ideas and Details Score] IS NOT NULL THEN [Reading-Comprehension of Key Ideas and Details Score]
		WHEN [Reading Comprehension of Key Ideas and Details Score] IS NOT NULL THEN [Reading Comprehension of Key Ideas and Details Score]
		WHEN [Reading- Comprehension of Key Ideas and Details Score] IS NOT NULL THEN [Reading- Comprehension of Key Ideas and Details Score]
	  END AS [raw_score]
      ,[scaled_score]
      ,[nce_score]
      ,CASE 
		WHEN [Reading-Comprehension of Key Ideas and Details Percent Score] IS NOT NULL THEN [Reading-Comprehension of Key Ideas and Details Percent Score]
		WHEN [Reading Comprehension of Key Ideas and Details Percent Score] IS NOT NULL THEN [Reading Comprehension of Key Ideas and Details Percent Score]
		WHEN [Reading- Comprehension of Key Ideas and Details Percent Score] IS NOT NULL THEN [Reading- Comprehension of Key Ideas and Details Percent Score]
	  END AS [percentile_score]
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
		,'13801'+ test_section_code AS test_section_code
		,test_section_code AS parent_test_section_code
		,CASE
			WHEN low_test_level_code = 'K' THEN 'K'
			ELSE RIGHT('0'+ low_test_level_code,2)
		END AS low_test_level_code
		,CASE
			WHEN high_test_level_code = 'K' THEN 'K'
			ELSE RIGHT('0' + high_test_level_code,2)
		END AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,'Performance Level' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		/*concatenate the year, month and day--*/
		,STUD1.DOB AS DOB
		,PT1.proficiency_measure
		,PT1.proficiency_score
		--,CW.low_test_level_code
		--,CW.high_test_level_code
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
	
	WHERE PT1.assessment_name LIKE '%ELA%'
	AND proficiency_measure IN ('Reading-Comprehension of Key Ideas and Details Proficiency Level Text','Reading-Comprehension of Key Ideas and Details Percent Score','Reading-Comprehension of Key Ideas and Details Score','Reading- Comprehension of Key Ideas and Details Score','Reading- Comprehension of Key Ideas and Details Proficiency Level Text','Reading- Comprehension of Key Ideas and Details Percent Score','Reading Comprehension of Key Ideas and Details Score','Reading Comprehension of Key Ideas and Details Proficiency Level Text','Reading Comprehension of Key Ideas and Details Percent Score')
	AND STUDENT_ID IS NOT NULL
	--AND student_id = '970113378'
) AS T1
PIVOT
(max([proficiency_score]) FOR proficiency_measure IN ([Reading-Comprehension of Key Ideas and Details Proficiency Level Text],[Reading-Comprehension of Key Ideas and Details Percent Score],[Reading-Comprehension of Key Ideas and Details Score],[Reading- Comprehension of Key Ideas and Details Score],[Reading- Comprehension of Key Ideas and Details Proficiency Level Text],[Reading- Comprehension of Key Ideas and Details Percent Score],[Reading Comprehension of Key Ideas and Details Score],[Reading Comprehension of Key Ideas and Details Proficiency Level Text],[Reading Comprehension of Key Ideas and Details Percent Score])) AS PVT1
)AS READING


 UNION

SELECT * FROM
(
 SELECT
	student_code
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,'Writing- Knowledge of Language and Conventions'[test_section_name]
      ,[parent_test_section_code]
      ,[low_test_level_code]
      ,[high_test_level_code]
      ,[test_level_name]
      ,[version_code]
      ,[Writing Knowledge of Language and Conventions Proficiency Level Text] AS [score_group_name]
      ,[Writing Knowledge of Language and Conventions Proficiency Level Text] AS [score_group_code]
      ,[score_group_label]
      ,[last_name]
	  ,REPLACE (first_name, '"', '') AS first_name
   --   ,CASE WHEN STUDENT_CODE = '970041776' THEN 'John' ELSE [first_name]
	  --END AS first_name
      ,[dob]
      ,[Writing Knowledge of Language and Conventions Score] AS [raw_score]
      ,[scaled_score]
      ,[nce_score]
      ,[Writing Knowledge of Language and Conventions Percent Score] AS [percentile_score]
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
		,'PBT'  AS test_type_code
		,'Performance Based Task' AS test_type_name
		,'13802' + test_section_code AS test_section_code
		,test_section_code AS parent_test_section_code
		,CASE
			WHEN low_test_level_code = 'K' THEN 'K'
			ELSE RIGHT('0'+ low_test_level_code,2)
		END AS low_test_level_code
		,CASE
			WHEN high_test_level_code = 'K' THEN 'K'
			ELSE RIGHT('0' + high_test_level_code,2)
		END AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,'Performance Level' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		/*concatenate the year, month and day--*/
		,STUD1.DOB AS DOB
		,PT1.proficiency_measure
		,PT1.proficiency_score
		--,CW.high_test_level_code
		--,CW.low_test_level_code
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
	
	WHERE PT1.assessment_name LIKE '%ELA%'
	AND proficiency_measure IN ('Writing Knowledge of Language and Conventions Percent Score','Writing Knowledge of Language and Conventions Proficiency Level Text','Writing Knowledge of Language and Conventions Score')
	AND STUDENT_ID IS NOT NULL
) AS T1
PIVOT
(max([proficiency_score]) FOR proficiency_measure IN ([Writing Knowledge of Language and Conventions Percent Score],[Writing Knowledge of Language and Conventions Proficiency Level Text],[Writing Knowledge of Language and Conventions Score])) AS PVT1
) AS WRITING


UNION

SELECT * FROM
(
SELECT
	student_code
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,'Writing- Written Expression (Development of Ideas)'[test_section_name]
      ,[parent_test_section_code]
      ,[low_test_level_code]
      ,[high_test_level_code]
      ,[test_level_name]
      ,[version_code]
      ,CASE WHEN  [Writing Written Expression Proficiency Level Text] IS NOT NULL THEN [Writing Written Expression Proficiency Level Text]
		ELSE [Writing Written Expression  Proficiency Level Text]
	  END AS [score_group_name]
      ,CASE WHEN [Writing Written Expression Proficiency Level Text] IS NOT NULL THEN [Writing Written Expression Proficiency Level Text]
		ELSE [Writing Written Expression  Proficiency Level Text]
	  END AS [score_group_code]
      ,[score_group_label]
      ,[last_name]
	  ,REPLACE (first_name, '"', '') AS first_name
   --   ,CASE WHEN STUDENT_CODE = '970041776' THEN 'John' ELSE [first_name]
	  --END AS first_name
      ,[dob]
      ,CASE WHEN [Writing Written Expression Score] IS NOT NULL THEN [Writing Written Expression Score]
		ELSE [Writing Written Expression  Score]
	  END AS [raw_score]
      ,[scaled_score]
      ,[nce_score]
      ,CASE WHEN [Writing Written Expression Percent Score] IS NOT NULL THEN [Writing Written Expression Percent Score]
		ELSE [Writing Written Expression  Percent Score]
	   END AS [percentile_score]
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
		,'13803' + test_section_code AS test_section_code
		,test_section_code AS parent_test_section_code
		,CASE
			WHEN low_test_level_code = 'K' THEN 'K'
			ELSE RIGHT('0'+ low_test_level_code,2)
		END AS low_test_level_code
		,CASE
			WHEN high_test_level_code = 'K' THEN 'K'
			ELSE RIGHT('0' + high_test_level_code,2)
		END AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,'Performance Level' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		/*concatenate the year, month and day--*/
		,STUD1.DOB AS DOB
		,PT1.proficiency_measure
		,PT1.proficiency_score
		--,CW.high_test_level_code
		--,CW.low_test_level_code
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
	
	WHERE PT1.assessment_name LIKE '%ELA%'
	AND proficiency_measure IN ('Writing Written Expression  Percent Score','Writing Written Expression  Proficiency Level Text','Writing Written Expression  Score','Writing Written Expression Percent Score','Writing Written Expression Proficiency Level Text','Writing Written Expression Score')
	AND STUDENT_ID IS NOT NULL
) AS T1
PIVOT
(max([proficiency_score]) FOR proficiency_measure IN ([Writing Written Expression  Percent Score],[Writing Written Expression  Proficiency Level Text],[Writing Written Expression  Score],[Writing Written Expression Percent Score],[Writing Written Expression Proficiency Level Text],[Writing Written Expression Score])) AS PVT1
) AS WRITTEN

UNION

SELECT * FROM
(
 SELECT
	student_code
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,'Multiple Choice'[test_section_name]
      ,[parent_test_section_code]
      ,[low_test_level_code]
      ,[high_test_level_code]
      ,[test_level_name]
      ,[version_code]
      ,[Multiple Choice Conversion Score Proficiency Level Text] AS [score_group_name]
      ,[Multiple Choice Conversion Score Proficiency Level Text] AS [score_group_code]
      ,[score_group_label]
      ,[last_name]
	  ,REPLACE (first_name, '"', '') AS first_name
   --   ,CASE WHEN STUDENT_CODE = '970041776' THEN 'John' ELSE [first_name]
	  --END AS first_name
      ,[dob]
      ,[Multiple Choice Conversion Score Score] AS [raw_score]
      ,[scaled_score]
      ,[nce_score]
      ,[Multiple Choice Conversion Score Percent Score] AS [percentile_score]
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
		,'PBT'  AS test_type_code
		,'Performance Based Task' AS test_type_name
		,'13899' + test_section_code AS test_section_code
		,test_section_code AS parent_test_section_code
		,CASE
			WHEN low_test_level_code = 'K' THEN 'K'
			ELSE RIGHT('0'+ low_test_level_code,2)
		END AS low_test_level_code
		,CASE
			WHEN high_test_level_code = 'K' THEN 'K'
			ELSE RIGHT('0' + high_test_level_code,2)
		END AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,'Performance Level' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		/*concatenate the year, month and day--*/
		,STUD1.DOB AS DOB
		,PT1.proficiency_measure
		,PT1.proficiency_score
		--,CW.high_test_level_code
		--,CW.low_test_level_code
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
	
	WHERE PT1.assessment_name LIKE '%ELA%'
	AND proficiency_measure IN ('Multiple Choice Conversion Score Percent Score','Multiple Choice Conversion Score Proficiency Level Text','Multiple Choice Conversion Score Score')
	AND STUDENT_ID IS NOT NULL
) AS T1
PIVOT
(max([proficiency_score]) FOR proficiency_measure IN ([Multiple Choice Conversion Score Percent Score],[Multiple Choice Conversion Score Proficiency Level Text],[Multiple Choice Conversion Score Score])) AS PVT1
) AS MC


UNION

SELECT * FROM
(
SELECT
	student_code
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,[test_section_name]
      ,[parent_test_section_code]
      ,[low_test_level_code]
      ,[high_test_level_code]
      ,[test_level_name]
      ,[version_code]
      ,[Overall Exam Proficiency Level Text] AS [score_group_name]
      ,[Overall Exam Proficiency Level Text] AS [score_group_code]
      ,[score_group_label]
      ,[last_name]
	  ,REPLACE (first_name, '"', '') AS first_name
   --   ,CASE WHEN STUDENT_CODE = '970041776' THEN 'John' ELSE [first_name]
	  --END AS first_name
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
		,test_section_code AS test_section_code
		,'0' AS parent_test_section_code
		,CASE
			WHEN low_test_level_code = 'K' THEN 'K'
			ELSE RIGHT ('0'+ low_test_level_code,2)
		END AS low_test_level_code
		,CASE
			WHEN high_test_level_code = 'K' THEN 'K'
			ELSE RIGHT('0'+ high_test_level_code,2)
		END AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,'Performance Level' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		/*concatenate the year, month and day--*/
		,STUD1.DOB AS DOB
		,PT1.proficiency_measure
		,PT1.proficiency_score
		,CW.test_section_name
		--,CW.high_test_level_code
		--,CW.low_test_level_code
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

	WHERE PT1.assessment_name LIKE '%ELA%'
	AND proficiency_measure IN ('Overall Exam Percent Score','Overall Exam Proficiency Level Text','Overall Exam Score')
	AND STUDENT_ID IS NOT NULL
) AS T1
PIVOT
(max([proficiency_score]) FOR proficiency_measure IN ([Overall Exam Percent Score],[Overall Exam Proficiency Level Text],[Overall Exam Score])) AS PVT1
) AS ELA



UNION

SELECT
	*
FROM
(
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
	  ,REPLACE (first_name, '"', '') AS first_name
   --   ,CASE WHEN STUDENT_CODE = '970041776' THEN 'John' ELSE [first_name]
	  --END AS first_name
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
		,test_section_code AS test_section_code
		,'0' AS parent_test_section_code
		,CASE
			WHEN low_test_level_code = 'K' THEN 'K'
			ELSE RIGHT('0'+ low_test_level_code,2)
		END AS low_test_level_code
		,CASE
			WHEN high_test_level_code = 'K' THEN 'K'
			ELSE RIGHT('0' + high_test_level_code,2)
		END AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,'Performance Level' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		/*concatenate the year, month and day--*/
		,STUD1.DOB AS DOB
		,PT1.proficiency_measure
		,PT1.proficiency_score
		,CW.TEST_SECTION_NAME
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
	AND STUDENT_ID IS NOT NULL

	--AND STUDENT_ID = '100505148'
) AS T1
PIVOT
(max([proficiency_score]) FOR proficiency_measure IN ([Overall Exam Percent Score],[Overall Exam Proficiency Level Text],[Overall Exam Score])) AS PVT1
) AS MATH

UNION

SELECT
	*
FROM
(
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
      ,[Algebra I Performance Task Score Proficiency Level Text] AS [score_group_name]
      ,[Algebra I Performance Task Score Proficiency Level Text] AS [score_group_code]
      ,[score_group_label]
      ,[last_name]
	  ,REPLACE (first_name, '"', '') AS first_name
   --   ,CASE WHEN STUDENT_CODE = '970041776' THEN 'John' ELSE [first_name]
	  --END AS first_name
      ,[dob]
      ,[Algebra I Performance Task Score Score] AS [raw_score]
      ,[scaled_score]
      ,[nce_score]
      ,[Algebra I Performance Task Score Percent Score] AS [percentile_score]
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
		,test_section_code AS test_section_code
		,'0' AS parent_test_section_code
		,CASE
			WHEN low_test_level_code = 'K' THEN 'K'
			ELSE RIGHT('0'+ low_test_level_code,2)
		END AS low_test_level_code
		,CASE
			WHEN high_test_level_code = 'K' THEN 'K'
			ELSE RIGHT('0' + high_test_level_code,2)
		END AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,'Performance Level' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		/*concatenate the year, month and day--*/
		,STUD1.DOB AS DOB
		,PT1.proficiency_measure
		,PT1.proficiency_score
		,CW.TEST_SECTION_NAME
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

	WHERE PT1.assessment_name LIKE '%ALGEBRA%'
	AND proficiency_measure IN ('Algebra I Performance Task Score Percent Score','Algebra I Performance Task Score Proficiency Level Text','Algebra I Performance Task Score Score')
	AND STUDENT_ID IS NOT NULL
	--AND STUDENT_ID = '100505148'
) AS T1
PIVOT
(max([proficiency_score]) FOR proficiency_measure IN ([Algebra I Performance Task Score Percent Score],[Algebra I Performance Task Score Proficiency Level Text],[Algebra I Performance Task Score Score])) AS PVT1
) AS ALG

) AS PT
WHERE school_code IS NOT NULL 
--AND school_code NOT IN ('415','418','416','485','455','475')
--OR test_level_name IS NOT NULL
--OR student_code IS NOT NULL

--and student_code = '185189'
--ORDER BY test_section_name
ORDER BY test_section_code, test_section_name
--AND TEST_SECTION_NAME = 'MATH Task 2 - Algebra 1'
--WHERE test_section_name = 'Writing- Knowledge of Language and Conventions'
--ORDER BY test_type_name

--WHERE test_type_name IS NULL
