BEGIN TRAN


USE [AIMS]
GO
/****** Object:  StoredProcedure [dbo].[test_result_9P_sp]    Script Date: 02/21/2014 08:41:34 ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--CREATE Procedure [dbo].[test_result_9P_sp] AS
/****
 
 * $LastChangedBy: Terri Christiansen
 * $LastChangedDate: 9/3/2013 $
 *
 * Request By: SchoolNet
 * InitialRequestDate: 
 * 
 * Initial Request:
 * Exit Exam Status test
 * Tables Referenced:  Experiment with a Standardized test layout.
	In this case, Exit Exam Status
****/
TRUNCATE TABLE dbo.test_result_9P
INSERT INTO dbo.test_result_9P
/* This requires a pivot, so experiment with syntax */
SELECT 
	DISTINCT
	student_code
	,school_year 
	,school_code
	,test_date_code
	,test_type_code
	,test_type_name
	,'9GrPL' AS test_section_code
	--,LEFT (Score, 3) AS test_section_name
	,'9th Grade Placement' AS test_section_name
	,'0' AS parent_test_section_code
	,'08' AS low_test_level_code
	,'09' AS high_test_level_code
	,test_level_name
	,'' AS version_code
	,CASE
		WHEN test_section_name = 'School #' THEN (SCORE)
		WHEN test_section_name = 'School Name' THEN (SCORE)
		WHEN test_section_name = 'Course' THEN (SCORE)
		WHEN test_section_name = 'Description' THEN (SCORE)
		WHEN test_section_name = 'Course Grade' THEN (SCORE)
		WHEN test_section_name = 'Total Absences' THEN (SCORE)
		WHEN test_section_name = 'HS' THEN 'TO' + ' ' + LEFT (Score, 3)
		ELSE 'N/A'
	END AS score_group_name
	,CASE
		WHEN test_section_name = 'School #' THEN 'MSL'
		WHEN test_section_name = 'School Name' THEN 'MSN'
		WHEN test_section_name = 'Course' THEN 'CoNu'
		WHEN test_section_name = 'Description' THEN 'CoNa'
		WHEN test_section_name = 'Course Grade' THEN 'CoGr'
		WHEN test_section_name = 'Total Absences' THEN 'ToAb'
		WHEN test_section_name = 'HS' THEN LEFT (Score, 3)
	END AS score_group_code
	,CASE
		WHEN test_section_name = 'School #' THEN 'MS Location'
		WHEN test_section_name = 'School Name' THEN 'MS Name'
		WHEN test_section_name = 'Course' THEN 'Course Number'
		WHEN test_section_name = 'Description' THEN 'Course Name'
		WHEN test_section_name = 'Course Grade' THEN 'Course Grade'
		WHEN test_section_name = 'Total Absences' THEN 'Total Absences'
		WHEN test_section_name = 'HS' THEN 'TO' + ' ' + LEFT (Score, 3)
	END AS score_group_label
	,last_name
	,first_name
	,'' AS DOB
	/*Dates are to be YYYY-MM-DD  DOB */
	--,Substring(CAST(DOB_new AS NCHAR),1,4) + '-' +
	--	Substring(CAST(DOB_new AS NCHAR),5,2) + '-' +
	--	Substring(CAST(DOB_new AS NCHAR),7,2) AS DOB
	,'' AS raw_score
	,'' AS scaled_score
	,'' nce_score
	,'' percentile_score
	,'' AS  score_1
	,'' AS score_2
	,'' AS score_3
	,'' AS score_4
	,'' AS score_5
	,'' AS score_6
	,'' AS score_7
	,'' score_8
	,'' score_9
	,'' score_10
	,'' score_11
	,'' score_12
	,'' score_13
	,'' score_14
	,'' score_15
	,'' score_16
	,'' score_17
	,'' score_18
	,'' score_19
	,'' score_20
	,'' score_21
	,'' score_raw_name
	,'' score_scaled_name
	,'' score_nce_name
	,'' score_percentile_name
	,'' AS  score_1_name
	,'' score_2_name
	,'' score_3_name
	,'' score_4_name
	,'' score_5_name
	,'' score_6_name
	,'' score_7_name
	,'' score_8_name
	,'' score_9_name
	,'' score_10_name
	,'' score_11_name
	,'' score_12_name
	,'' score_13_name
	,'' score_14_name
	,'' score_15_name
	,'' score_16_name
	,'' score_17_name
	,'' score_18_name
	,'' score_19_name
	,'' score_20_name
	,'' score_21_name

FROM 
	(
	SELECT
		CAST([ID #] AS INT) AS student_code
		,'2013' AS school_year
		,[School #] AS school_code
		,'2014-02-01' AS test_date_code
		,'9P' AS test_type_code
		,'9th Grade Placement' AS test_type_name
		,[Last Name] AS last_name
		,[First Name] AS first_name
		,[Grade Level] AS test_level_name
		,[Grade Level]
		,[School Name]
		,[Course]
		,[Description]
		,[Course Grade]
		,[Total Absences]
		,[School #]
		,[HS]
	FROM
		[AIMS].[dbo].[9thEnglishPlacement] AS [9P]
			
	) AS PLACEMENT
UNPIVOT (score for test_section_name IN ([School #], [School Name], [Course], [Description], [Course Grade], [Total Absences], [HS])) AS Unpvt

--WHERE STUDENT_CODE = '100029107'



ROLLBACK