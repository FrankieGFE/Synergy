USE [SchoolNet]
GO

--TRUNCATE TABLE dbo.test_result_IREADY
--GO
--INSERT INTO dbo.test_result_IREADY

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
      ,'MATH'[test_section_name]
      ,[parent_test_section_code]
      ,[low_test_level_code]
      ,[high_test_level_code]
      ,[test_level_name]
      ,[version_code]
      ,[score_group_name]
      ,[score_group_code]
      ,[score_group_label]
      ,[last name]
      ,[first name]
      ,[dob]
      ,'' AS [raw_score]
      ,[scaled_score]
      ,[nce_score]
      ,'' AS [percentile_score]
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
		[Student ID]  AS student_code
		,'2014' AS school_year
		,STUD1.school_code AS school_code
		,'10-01-2014' AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'MATH' AS test_section_code
		,'0' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic  Overall Placement (1)] AS score_group_name
		,[Diagnostic  Overall Placement (1)] AS score_group_code
		,'Overall Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		/*concatenate the year, month and day--*/
		,STUD1.DOB AS DOB
		--,PT1.proficiency_measure
		--,PT1.proficiency_score
		--,CW.low_test_level_code
		--,CW.high_test_level_code
		,[Diagnostic  Overall Scale Score (1)] AS scaled_score
		,'' AS raw_score
		,'' AS nce_score
		,'' AS percentile_score
		,[Diagnostic  Rush Flag (see Student Profile) (1)] AS score_1
		,[Diagnostic Gain] AS score_2
		,[How many Diagnostic Assessments did this student complete during the time frame?] AS score_3
		,[Diagnostic  Completion Date (1)] AS score_4
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
		,'' AS score_raw_name
		,'Scaled Score' AS score_scaled_name
		,'' AS score_nce_name
		,'' AS score_percentile_name
		,'Rush Flag' AS score_1_name
		,'Gain' AS score_2_name
		,'Number of Assessments' AS score_3_name
		,'Completion Date' AS score_4_name
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
		,PT1.[Last Name]
		,PT1.[First Name]

	FROM [SchoolNet].[dbo].[iReady] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic  Overall Scale Score (1)] > '1')
) AS T1
--WHERE scaled_score > '1'
--ORDER BY scaled_score desc

UNION

SELECT
	  student_code
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,'Numbers and Operations'[test_section_name]
      ,[parent_test_section_code]
      ,[low_test_level_code]
      ,[high_test_level_code]
      ,[test_level_name]
      ,[version_code]
      ,[score_group_name]
      ,[score_group_code]
      ,[score_group_label]
      ,[last name]
      ,[first name]
      ,[dob]
      ,'' AS [raw_score]
      ,[scaled_score]
      ,[nce_score]
      ,'' AS [percentile_score]
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
		[Student ID]  AS student_code
		,'2014' AS school_year
		,STUD1.school_code AS school_code
		,'10-01-2014' AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'NumbOps' AS test_section_code
		,'MATH' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic  Number and Operations Placement (1)] AS score_group_name
		,[Diagnostic  Number and Operations Placement (1)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		/*concatenate the year, month and day--*/
		,STUD1.DOB AS DOB
		--,PT1.proficiency_measure
		--,PT1.proficiency_score
		--,CW.low_test_level_code
		--,CW.high_test_level_code
		,[Diagnostic  Number and Operations Scale Score (1)] AS scaled_score
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
		,'' AS score_raw_name
		,'Scaled Score' AS score_scaled_name
		,'' AS score_nce_name
		,'' AS score_percentile_name
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
		,PT1.[Last Name]
		,PT1.[First Name]

	FROM [SchoolNet].[dbo].[iReady] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic  Number and Operations Scale Score (1)] > '1')
) AS NumbOp


UNION

SELECT
	  student_code
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,'Algebra and Algebraic Thinking'[test_section_name]
      ,[parent_test_section_code]
      ,[low_test_level_code]
      ,[high_test_level_code]
      ,[test_level_name]
      ,[version_code]
      ,[score_group_name]
      ,[score_group_code]
      ,[score_group_label]
      ,[last name]
      ,[first name]
      ,[dob]
      ,'' AS [raw_score]
      ,[scaled_score]
      ,[nce_score]
      ,'' AS [percentile_score]
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
		[Student ID]  AS student_code
		,'2014' AS school_year
		,STUD1.school_code AS school_code
		,'10-01-2014' AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'Algeb' AS test_section_code
		,'MATH' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic  Algebra and Algebraic Thinking Placement (1)] AS score_group_name
		,[Diagnostic  Algebra and Algebraic Thinking Placement (1)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		/*concatenate the year, month and day--*/
		,STUD1.DOB AS DOB
		--,PT1.proficiency_measure
		--,PT1.proficiency_score
		--,CW.low_test_level_code
		--,CW.high_test_level_code
		,[Diagnostic  Algebra and Algebraic Thinking Scale Score (1)] AS scaled_score
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
		,'' AS score_raw_name
		,'Scaled Score' AS score_scaled_name
		,'' AS score_nce_name
		,'' AS score_percentile_name
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
		,PT1.[Last Name]
		,PT1.[First Name]

	FROM [SchoolNet].[dbo].[iReady] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic  Algebra and Algebraic Thinking Scale Score (1)] > '1')
) AS ALG

UNION

SELECT
	  student_code
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,'Measurement and Data'[test_section_name]
      ,[parent_test_section_code]
      ,[low_test_level_code]
      ,[high_test_level_code]
      ,[test_level_name]
      ,[version_code]
      ,[score_group_name]
      ,[score_group_code]
      ,[score_group_label]
      ,[last name]
      ,[first name]
      ,[dob]
      ,'' AS [raw_score]
      ,[scaled_score]
      ,[nce_score]
      ,'' AS [percentile_score]
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
		[Student ID]  AS student_code
		,'2014' AS school_year
		,STUD1.school_code AS school_code
		,'10-01-2014' AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'MeasData' AS test_section_code
		,'MATH' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic  Measurement and Data Placement (1)] AS score_group_name
		,[Diagnostic  Measurement and Data Placement (1)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		/*concatenate the year, month and day--*/
		,STUD1.DOB AS DOB
		--,PT1.proficiency_measure
		--,PT1.proficiency_score
		--,CW.low_test_level_code
		--,CW.high_test_level_code
		,[Diagnostic  Measurement and Data Scale Score (1)] AS scaled_score
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
		,'' AS score_raw_name
		,'Scaled Score' AS score_scaled_name
		,'' AS score_nce_name
		,'' AS score_percentile_name
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
		,PT1.[Last Name]
		,PT1.[First Name]

	FROM [SchoolNet].[dbo].[iReady] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic  Measurement and Data Scale Score (1)] > '1')
) AS MeasData


UNION

SELECT
	  student_code
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,'Geometry'[test_section_name]
      ,[parent_test_section_code]
      ,[low_test_level_code]
      ,[high_test_level_code]
      ,[test_level_name]
      ,[version_code]
      ,[score_group_name]
      ,[score_group_code]
      ,[score_group_label]
      ,[last name]
      ,[first name]
      ,[dob]
      ,'' AS [raw_score]
      ,[scaled_score]
      ,[nce_score]
      ,'' AS [percentile_score]
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
		[Student ID]  AS student_code
		,'2014' AS school_year
		,STUD1.school_code AS school_code
		,'10-01-2014' AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'Geom' AS test_section_code
		,'MATH' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic  Geometry Placement (1)] AS score_group_name
		,[Diagnostic  Geometry Placement (1)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		/*concatenate the year, month and day--*/
		,STUD1.DOB AS DOB
		--,PT1.proficiency_measure
		--,PT1.proficiency_score
		--,CW.low_test_level_code
		--,CW.high_test_level_code
		,[Diagnostic  Geometry Scale Score (1)] AS scaled_score
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
		,'' AS score_raw_name
		,'Scaled Score' AS score_scaled_name
		,'' AS score_nce_name
		,'' AS score_percentile_name
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
		,PT1.[Last Name]
		,PT1.[First Name]

	FROM [SchoolNet].[dbo].[iReady] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic  Geometry Scale Score (1)] > '1')
) AS Geom


) AS iReady
WHERE test_level_name IS NOT NULL
ORDER BY STUDENT_CODE