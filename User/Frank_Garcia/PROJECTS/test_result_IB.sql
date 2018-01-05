USE [Assessments]
GO
/****** Object:  StoredProcedure [dbo].EXECUTE [test_result_IB_sp]    Script Date: 7/27/2015 10:37:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[test_result_IB_sp] AS
/****
 
 * $LastChangedBy: Frank Garcia
 * $LastChangedDate: 7/27/2015 $
 *
 * Request By: SchoolNet
 * InitialRequestDate: 
 * 
 * Initial Request:
 * SchoolNet
 * test_result_ib
	
****/
TRUNCATE TABLE test_result_IB

DECLARE @TEST_DATE VARCHAR(50) = '2015-05-01'
DECLARE @SCH_YR VARCHAR(50) = '2014'
INSERT INTO test_result_IB

SELECT
		APS_ID AS student_code
		,@SCH_YR AS school_year
		,LOCATION AS school_code
		,@TEST_DATE AS test_date_code
		,'IB' AS test_type_code
		,'IB' AS test_type_name
		,SUBJECT AS test_section_code
		,SUBJECT AS test_section_name
		,'0' AS parent_test_section_code
		,'12' AS low_test_level_code
		,'11' AS high_test_level_code
		,GRADE AS test_level_name
		,'' AS version_code
		,'N/A' AS score_group_name
		,'N/A' AS score_group_code
		,'Performance Level' AS score_group_label
		,REPLACE (lastname,'"', '') AS last_name
		,REPLACE (firstname,'"', '') AS first_name
		,DOB AS DOB
		,'' AS raw_score
		,'' AS scaled_code
		,'' AS nce_score
		,'' AS percentile_score
		,Category AS score_1
		,Lvl AS score_2
		,[Subject Grade] AS score_3
		,[Total Points] AS score_4
		,[Result Code] AS score_5
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
		,'' AS score_scaled_name
		,'' AS score_nce_name
		,'' AS score_percentile_name
		,'CATEGORY' AS score_1_name
		,'LEVEL' AS score_2_name
		,'SUBJECT GRADE' AS score_3_name
		,'TOTAL POINTS' AS score_4_name
		,'RESULT CODE' AS score_5_name
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

	FROM CCR_IB AS IB
	WHERE [School Name] = 'Sandia High School' 
	AND Lvl != 'EE'

UNION


SELECT
		student_code
		,school_year
		,school_code
		,test_date_code
		,test_type_code
		,test_type_name
		,test_section_code
		,test_section_name
		,parent_test_section_code
		,low_test_level_code
		,high_test_level_code
		,test_level_name
		,version_code
		,score_group_name
		,score_group_code
		,score_group_label
		,last_name
		,first_name
		,DOB
		,raw_score
		,scaled_code
		,nce_score
		,percentile_score
		,score_1
		,score_2
		,score_3
		,score_4
		,score_5
		,score_6
		,score_7
		,score_8
		,score_9
		,score_10
		,score_11
		,score_12
		,score_13
		,score_14
		,score_15
		,score_16
		,score_17
		,score_18
		,score_19
		, score_20
		,score_21
		,score_raw_name
		,score_scaled_name
		, score_nce_name
		,score_percentile_name
		,score_1_name
		,score_2_name
		,score_3_name
		,score_4_name
		,score_5_name
		,score_6_name
		,score_7_name
		,score_8_name
		,score_9_name
		,score_10_name
		,score_11_name
		,score_12_name
		,score_13_name
		,score_14_name
		,score_15_name
		,score_16_name
		,score_17_name
		, score_18_name
		,score_19_name
		,score_20_name
		, score_21_name
FROM
(
SELECT
		APS_ID AS student_code
		,@SCH_YR AS school_year
		,LOCATION AS school_code
		,@TEST_DATE AS test_date_code
		,'IB' AS test_type_code
		,'IB' AS test_type_name
		,SUBJECT AS test_section_code
		,SUBJECT AS test_section_name
		,CASE 
			WHEN RN = 1 THEN '0' ELSE Subject
		END AS parent_test_section_code
		,'12' AS low_test_level_code
		,'11' AS high_test_level_code
		,GRADE AS test_level_name
		,'' AS version_code
		,'N/A' AS score_group_name
		,'N/A' AS score_group_code
		,'Performance Level' AS score_group_label
		,REPLACE (lastname,'"', '') AS last_name
		,REPLACE (firstname,'"', '') AS first_name
		,DOB AS DOB
		,'' AS raw_score
		,'' AS scaled_code
		,'' AS nce_score
		,'' AS percentile_score
		,Category AS score_1
		,Lvl AS score_2
		,[Subject Grade] AS score_3
		,[Total Points] AS score_4
		,[Result Code] AS score_5
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
		,'' AS score_scaled_name
		,'' AS score_nce_name
		,'' AS score_percentile_name
		,'CATEGORY' AS score_1_name
		,'LEVEL' AS score_2_name
		,'SUBJECT GRADE' AS score_3_name
		,'TOTAL POINTS' AS score_4_name
		,'RESULT CODE' AS score_5_name
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

	FROM 
		(
		SELECT 
			  ROW_NUMBER () OVER (PARTITION BY [APS_ID], [Subject] ORDER BY [Lvl] DESC) AS RN
			  ,*

		  FROM [Assessments].[dbo].[CCR_IB]
		  WHERE [School Name] = 'Sandia High School'
		  --AND Lvl = 'EE'
		  ) AS T1
		  WHERE LVL = 'EE'
) AS T2
		




