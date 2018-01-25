USE [Assessments]
GO
/****** Object:  StoredProcedure [dbo].EXECUTE [test_result_IREADY_ELA_sp]    Script Date: 9/24/2015 9:49:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[test_result_IREADY_ELA_sp] as
/****
 
 * $LastChangedBy: Frank Garcia
 * $LastChangedDate: 5/29/2015 $
 *
 * Request By: SchoolNet
 * InitialRequestDate: 
 * 
 * Initial Request:
 * IREADY
 * 
	
****/


TRUNCATE TABLE dbo.test_result_IREADY

DECLARE @TEST1 VARCHAR (10) = '10-01-2015'
DECLARE @TEST2 VARCHAR (10) = '02-01-2016'
DECLARE @TEST3 VARCHAR (10) = '04-01-2016'
DECLARE @SCHOOL_YEAR VARCHAR (50) = '2015'
DECLARE @ACADEMIC_YEAR VARCHAR (50) = '2015-2016'

INSERT INTO dbo.test_result_IREADY



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
      ,'ELA (1)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'T1_ELA' AS test_section_code
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
		,STUD1.DOB AS DOB
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
		,'OVERALL GAIN' AS score_2_name
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic  Overall Scale Score (1)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
) AS T1

UNION

SELECT
	  student_code
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,'Phonological Awareness (1)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'T1_Phono_Awar' AS test_section_code
		,'T1_ELA' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic Phonological Awareness Placement (1)] AS score_group_name
		,[Diagnostic Phonological Awareness Placement (1)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		,STUD1.DOB AS DOB
		,[Diagnostic Phonological Awareness Scale Score (1)] AS scaled_score
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic Phonological Awareness Scale Score (1)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
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
      ,'Phonics (1)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'T1_Phonics' AS test_section_code
		,'T1_ELA' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic Phonics Placement (1)] AS score_group_name
		,[Diagnostic Phonics Placement (1)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		,STUD1.DOB AS DOB
		,[Diagnostic Phonics Scale Score (1)] AS scaled_score
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic Phonics Scale Score (1)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
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
      ,'High-Frequency Words (1)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'T1_HFW' AS test_section_code
		,'T1_ELA' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic High-Frequency Words Placement (1)] AS score_group_name
		,[Diagnostic High-Frequency Words Placement (1)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		,STUD1.DOB AS DOB
		,[Diagnostic High-Frequency Words Scale Score (1)] AS scaled_score
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic High-Frequency Words Scale Score (1)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
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
      ,'Vocabulary (1)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'T1_Vocab' AS test_section_code
		,'T1_ELA' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic Vocabulary Placement (1)] AS score_group_name
		,[Diagnostic Vocabulary Placement (1)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		,STUD1.DOB AS DOB
		,[Diagnostic Vocabulary Scale Score (1)] AS scaled_score
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic Vocabulary Scale Score (1)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
) AS Vocab

UNION

SELECT
	  student_code
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,'Literature (1)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'T1_Lit' AS test_section_code
		,'T1_ELA' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic Reading Comprehension  Literature Placement (1)] AS score_group_name
		,[Diagnostic Reading Comprehension  Literature Placement (1)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		,STUD1.DOB AS DOB
		,[Diagnostic Reading Comprehension  Literature Scale Score (1)] AS scaled_score
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic Reading Comprehension  Literature Scale Score (1)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
) AS Lit

UNION

SELECT
	  student_code
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,'Informational Text (1)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'T1_IT' AS test_section_code
		,'T1_ELA' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic Reading Comprehension  Informational Text Placement (1)] AS score_group_name
		,[Diagnostic Reading Comprehension  Informational Text Placement (1)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		,STUD1.DOB AS DOB
		,[Diagnostic Reading Comprehension  Informational Text Scale Score (1)] AS scaled_score
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic Reading Comprehension  Informational Text Scale Score (1)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
) AS IT

UNION

SELECT
	  student_code
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,'ELA (2)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'T2_ELA' AS test_section_code
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
		,STUD1.DOB AS DOB
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
		,'OVERALL GAIN' AS score_2_name
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic  Overall Scale Score (1)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
) AS T1

UNION

SELECT
	  student_code
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,'Phonological Awareness (2)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'T2_Phono_Awar' AS test_section_code
		,'T2_ELA' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic Phonological Awareness Placement (2)] AS score_group_name
		,[Diagnostic Phonological Awareness Placement (2)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		,STUD1.DOB AS DOB
		,[Diagnostic Phonological Awareness Scale Score (2)] AS scaled_score
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic Phonological Awareness Scale Score (2)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
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
      ,'Phonics (2)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'T2_Phonics' AS test_section_code
		,'T2_ELA' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic Phonics Placement (2)] AS score_group_name
		,[Diagnostic Phonics Placement (2)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		,STUD1.DOB AS DOB
		,[Diagnostic Phonics Scale Score (2)] AS scaled_score
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic Phonics Scale Score (2)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
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
      ,'High-Frequency Words (2)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'T2_HFW' AS test_section_code
		,'T2_ELA' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic High-Frequency Words Placement (2)] AS score_group_name
		,[Diagnostic High-Frequency Words Placement (2)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		,STUD1.DOB AS DOB
		,[Diagnostic High-Frequency Words Scale Score (2)] AS scaled_score
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic High-Frequency Words Scale Score (2)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
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
      ,'Vocabulary (2)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'T2_Vocab' AS test_section_code
		,'T2_ELA' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic Vocabulary Placement (2)] AS score_group_name
		,[Diagnostic Vocabulary Placement (2)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		,STUD1.DOB AS DOB
		,[Diagnostic Vocabulary Scale Score (2)] AS scaled_score
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic Vocabulary Scale Score (2)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
) AS Vocab

UNION

SELECT
	  student_code
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,'Literature (2)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'T2_Lit' AS test_section_code
		,'T2_ELA' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic Reading Comprehension  Literature Placement (2)] AS score_group_name
		,[Diagnostic Reading Comprehension  Literature Placement (2)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		,STUD1.DOB AS DOB
		,[Diagnostic Reading Comprehension  Literature Scale Score (2)] AS scaled_score
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic Reading Comprehension  Literature Scale Score (2)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
) AS Lit

UNION

SELECT
	  student_code
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,'Informational Text (2)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'T2_IT' AS test_section_code
		,'T2_ELA' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic Reading Comprehension  Informational Text Placement (2)] AS score_group_name
		,[Diagnostic Reading Comprehension  Informational Text Placement (2)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		,STUD1.DOB AS DOB
		,[Diagnostic Reading Comprehension  Informational Text Scale Score (2)] AS scaled_score
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic Reading Comprehension  Informational Text Scale Score (2)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
) AS IT


UNION

SELECT
	  student_code
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,'ELA (3)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'T3_ELA' AS test_section_code
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
		,STUD1.DOB AS DOB
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
		,'OVERALL GAIN' AS score_2_name
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic  Overall Scale Score (1)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
) AS T1

UNION

SELECT
	  student_code
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,'Phonological Awareness (3)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'T3_Phono_Awar' AS test_section_code
		,'T3_ELA' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic Phonological Awareness Placement (3)] AS score_group_name
		,[Diagnostic Phonological Awareness Placement (3)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		,STUD1.DOB AS DOB
		,[Diagnostic Phonological Awareness Scale Score (3)] AS scaled_score
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic Phonological Awareness Scale Score (3)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
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
      ,'Phonics (3)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'T3_Phonics' AS test_section_code
		,'T3_ELA' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic Phonics Placement (3)] AS score_group_name
		,[Diagnostic Phonics Placement (3)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		,STUD1.DOB AS DOB
		,[Diagnostic Phonics Scale Score (3)] AS scaled_score
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic Phonics Scale Score (3)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
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
      ,'High-Frequency Words (3)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'T3_HFW' AS test_section_code
		,'T3_ELA' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic High-Frequency Words Placement (3)] AS score_group_name
		,[Diagnostic High-Frequency Words Placement (3)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		,STUD1.DOB AS DOB
		,[Diagnostic High-Frequency Words Scale Score (3)] AS scaled_score
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic High-Frequency Words Scale Score (3)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
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
      ,'Vocabulary (3)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'T3_Vocab' AS test_section_code
		,'T3_ELA' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic Vocabulary Placement (3)] AS score_group_name
		,[Diagnostic Vocabulary Placement (3)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		,STUD1.DOB AS DOB
		,[Diagnostic Vocabulary Scale Score (3)] AS scaled_score
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic Vocabulary Scale Score (3)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
) AS Vocab

UNION

SELECT
	  student_code
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,'Literature (3)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'T3_Lit' AS test_section_code
		,'T3_ELA' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic Reading Comprehension  Literature Placement (3)] AS score_group_name
		,[Diagnostic Reading Comprehension  Literature Placement (3)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		,STUD1.DOB AS DOB
		,[Diagnostic Reading Comprehension  Literature Scale Score (3)] AS scaled_score
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic Reading Comprehension  Literature Scale Score (3)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
) AS Lit

UNION

SELECT
	  student_code
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,'Informational Text (3)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'T3_IT' AS test_section_code
		,'T3_ELA' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic Reading Comprehension  Informational Text Placement (3)] AS score_group_name
		,[Diagnostic Reading Comprehension  Informational Text Placement (3)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		,STUD1.DOB AS DOB
		,[Diagnostic Reading Comprehension  Informational Text Scale Score (3)] AS scaled_score
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic Reading Comprehension  Informational Text Scale Score (3)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
) AS IT


UNION

SELECT
	  student_code
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,'ELA (Most Recent)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'TM_ELA' AS test_section_code
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
		,STUD1.DOB AS DOB
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
		,'OVERALL GAIN' AS score_2_name
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic  Overall Scale Score (1)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
) AS T1

UNION

SELECT
	  student_code
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,'Phonological Awareness (Most Recent)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'TM_Phono_Awar' AS test_section_code
		,'TM_ELA' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic Phonological Awareness Placement (Most Recent)] AS score_group_name
		,[Diagnostic Phonological Awareness Placement (Most Recent)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		,STUD1.DOB AS DOB
		,[Diagnostic Phonological Awareness Scale Score (Most Recent)] AS scaled_score
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic Phonological Awareness Scale Score (Most Recent)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
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
      ,'Phonics (Most Recent)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'TM_Phonics' AS test_section_code
		,'TM_ELA' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic Phonics Placement (Most Recent)] AS score_group_name
		,[Diagnostic Phonics Placement (Most Recent)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		,STUD1.DOB AS DOB
		,[Diagnostic Phonics Scale Score (Most Recent)] AS scaled_score
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic Phonics Scale Score (Most Recent)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
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
      ,'High-Frequency Words (Most Recent)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'TM_HFW' AS test_section_code
		,'TM_ELA' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic High-Frequency Words Placement (Most Recent)] AS score_group_name
		,[Diagnostic High-Frequency Words Placement (Most Recent)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		,STUD1.DOB AS DOB
		,[Diagnostic High-Frequency Words Scale Score (Most Recent)] AS scaled_score
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic High-Frequency Words Scale Score (Most Recent)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
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
      ,'Vocabulary (Most Recent)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'TM_Vocab' AS test_section_code
		,'TM_ELA' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic Vocabulary Placement (Most Recent)] AS score_group_name
		,[Diagnostic Vocabulary Placement (Most Recent)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		,STUD1.DOB AS DOB
		,[Diagnostic Vocabulary Scale Score (Most Recent)] AS scaled_score
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic Vocabulary Scale Score (Most Recent)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
) AS Vocab

UNION

SELECT
	  student_code
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,'Literature (Most Recent)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'TM_Lit' AS test_section_code
		,'TM_ELA' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic Reading Comprehension  Literature Placement (Most Recent)] AS score_group_name
		,[Diagnostic Reading Comprehension  Literature Placement (Most Recent)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		,STUD1.DOB AS DOB
		,[Diagnostic Reading Comprehension  Literature Scale Score (Most Recent)] AS scaled_score
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic Reading Comprehension  Literature Scale Score (Most Recent)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
) AS Lit

UNION

SELECT
	  student_code
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,'Informational Text (Most Recent)'[test_section_name]
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
		,@SCHOOL_YEAR AS school_year
		,STUD1.school_code AS school_code
		,CASE	
			WHEN [Diagnostic  Completion Date (1)] < '2015-12-30' THEN @TEST1 
			WHEN [Diagnostic  Completion Date (1)] > '2015-12-30' AND [Diagnostic  Completion Date (1)] < '2016-04-01' THEN @TEST2
			WHEN [Diagnostic  Completion Date (1)] > '2016-04-01' AND [Diagnostic  Completion Date (1)] < '2016-06-01' THEN @TEST3
		END AS test_date_code
		,'i-Ready' AS test_type_code
		,'i-Ready' AS test_type_name
		,'TM_IT' AS test_section_code
		,'TM_ELA' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,STUD1.grade_code  AS test_level_name
		,'' AS version_code
		,[Diagnostic Reading Comprehension  Informational Text Placement (Most Recent)] AS score_group_name
		,[Diagnostic Reading Comprehension  Informational Text Placement (Most Recent)] AS score_group_code
		,'Placement' AS score_group_label
		,STUD1.last_name AS last_name
		,STUD1.first_name AS first_name
		,STUD1.DOB AS DOB
		,[Diagnostic Reading Comprehension  Informational Text Scale Score (Most Recent)] AS scaled_score
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

	FROM [iReady_ELA] AS PT1
	LEFT JOIN
	ALLSTUDENTS AS STUD1
	ON PT1.[Student ID] = STUD1.student_code
WHERE ([Diagnostic Reading Comprehension  Informational Text Scale Score (Most Recent)] > '1')
AND [Academic Year] = @ACADEMIC_YEAR
) AS IT

) AS iReady_ELA




WHERE test_level_name IS NOT NULL
ORDER BY TEST_DATE_CODE, test_section_name