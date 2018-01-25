--BEGIN TRAN
USE [SchoolNet]
GO

--/****** Object:  StoredProcedure [dbo].[test_result_HSGA_sp]    Script Date: 11/27/2013 12:15:15 ******/
--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[test_result_HSGA_sp]') AND type in (N'P', N'PC'))
--DROP PROCEDURE [dbo].[test_result_HSGA_sp]
--GO

--USE [SchoolNet]
--GO

/****** Object:  StoredProcedure [dbo].[test_result_HSGA_sp]    Script Date: 11/27/2013 12:15:15 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE Procedure  [dbo].[test_result_HSGA_sp] AS

/****
 
 * $LastChangedBy: Terri Christiansen
 * $LastChangedDate: 7/18/2014 $
 *
 * Request By: SchoolNet
 * InitialRequestDate: 
 * 
 * Initial Request:
 * SAT test
 * Tables Referenced:  Experiment with a Standardized test layout.
	In this case, PSAT 
****/
TRUNCATE TABLE test_result_HSGA

INSERT INTO dbo.test_result_HSGA
/* This requires a pivot, so experiment with syntax */
SELECT
	*
FROM

(	
SELECT
	student_code
	--,APS_ID
	,school_year
	,school_code
	,test_date_code
	,test_type_code
	,test_type_name
	,CASE
		WHEN section_name = 'SS_READ_FALL_2014' THEN 'Read'
		WHEN section_name = 'SS_MATH_FALL_2014' THEN 'Math'
		WHEN section_name = 'SS_SCIENCE_FALL_2014' THEN 'SCIENCE'
		WHEN section_name = 'BEST_COMPOSITE_SUM' THEN 'Comp'
	END
	AS test_section_code
	,CASE
		WHEN section_name = 'SS_READ_FALL_2014' THEN 'READING'
		WHEN section_name = 'SS_MATH_FALL_2014' THEN 'MATH'
		WHEN section_name = 'SS_SCIENCE_FALL_2014' THEN 'SCIENCE'
		WHEN section_name = 'BEST_COMPOSITE_SUM' THEN 'COMPOSITE'
	END
	AS test_section_name

	,parent_test_section_code 
	,low_test_level_code
	,high_test_level_code
	,test_level_name
	,version_code
	,CASE	
		WHEN section_name = 'BEST_COMPOSITE_SUM' THEN 
			CASE	
				WHEN COMPOSITE >= 2273 AND PASSFAIL = 'PMPR' THEN 'PASSED (Math Reading)'
				WHEN COMPOSITE < 2273 AND PASSFAIL = 'PMFR' THEN 'FAILED (Composite SS & Reading PL)'
				WHEN COMPOSITE < 2273 AND PASSFAIL = 'FMPR' THEN 'FAILED (Composite SS & Math PL)'
				WHEN COMPOSITE < 2273 AND PASSFAIL = 'FMFR' THEN 'FAILED (Composite SS & Reading/Math PLs)'
				WHEN COMPOSITE < 2273 AND PASSFAIL = 'PMPR' THEN 'FAILED (Composite SS)'
				WHEN COMPOSITE >= 2273 AND PASSFAIL = 'PMFR' THEN 'FAILED (Reading PL)'
				WHEN COMPOSITE >= 2273 AND PASSFAIL = 'FMPR' THEN 'FAILED (Math PL)'
				WHEN PASSFAIL = 'N/A' THEN 'N/A'
				END
		ELSE 
			CASE
				WHEN section_name = 'SS_READ_FALL_2014' AND	scaled_score IS NULL OR scaled_score = '' OR scaled_score = '0' THEN 'N/A'
				WHEN section_name = 'SS_READ_FALL_2014' AND	scaled_score <= 28 THEN 'BEGINNING'
				WHEN section_name = 'SS_READ_FALL_2014' AND	scaled_score BETWEEN 29 AND 39 THEN 'NEARING'
				WHEN section_name = 'SS_READ_FALL_2014' AND	scaled_score BETWEEN 40 AND 50 THEN 'PROFICIENT'
				WHEN section_name = 'SS_READ_FALL_2014' AND	scaled_score >= 51 THEN 'ADVANCED'
				WHEN section_name = 'SS_MATH_FALL_2014' AND	scaled_score IS NULL OR scaled_score = '' OR scaled_score = '0' THEN 'N/A'
				WHEN section_name = 'SS_MATH_FALL_2014' AND	scaled_score <= 26 THEN 'BEGINNING'
				WHEN section_name = 'SS_MATH_FALL_2014' AND	scaled_score BETWEEN 27 AND 39 THEN 'NEARING'
				WHEN section_name = 'SS_MATH_FALL_2014' AND	scaled_score BETWEEN 40 AND 50 THEN 'PROFICIENT'
				WHEN section_name = 'SS_MATH_FALL_2014' AND	scaled_score >= 51 THEN 'ADVANCED'
				WHEN section_name = 'SS_SCIENCE_FALL_2014' AND	scaled_score IS NULL OR scaled_score = '' OR scaled_score = '0' THEN 'N/A'
				WHEN section_name = 'SS_SCIENCE_FALL_2014' AND	scaled_score <= 29 THEN 'BEGINNING'
				WHEN section_name = 'SS_SCIENCE_FALL_2014' AND	scaled_score BETWEEN 30 AND 39 THEN 'NEARING'
				WHEN section_name = 'SS_SCIENCE_FALL_2014' AND	scaled_score BETWEEN 40 AND 51 THEN 'PROFICIENT'
				WHEN section_name = 'SS_SCIENCE_FALL_2014' AND	scaled_score >= 52 THEN 'ADVANCED'
				END			
	END AS score_group_name 
	,CASE	
		WHEN section_name = 'BEST_COMPOSITE_SUM' THEN 
			CASE	
				WHEN COMPOSITE >= 2273 AND PASSFAIL = 'PMPR' THEN 'PASMathading'
				WHEN COMPOSITE < 2273 AND PASSFAIL = 'PMFR' THEN 'FAICompngPL'
				WHEN COMPOSITE < 2273 AND PASSFAIL = 'FMPR' THEN 'FAICompthPL'
				WHEN COMPOSITE < 2273 AND PASSFAIL = 'FMFR' THEN 'FAIComphPLs'
				WHEN COMPOSITE < 2273 AND PASSFAIL = 'PMPR' THEN 'FAICompteSS'
				WHEN COMPOSITE >= 2273 AND PASSFAIL = 'PMFR' THEN 'FAIReadngPL'
				WHEN COMPOSITE >= 2273 AND PASSFAIL = 'FMPR' THEN 'FAIMaththPL'
				WHEN PASSFAIL = 'N/A' THEN 'N/A'
				END
		ELSE
			CASE
				WHEN section_name = 'SS_READ_FALL_2014' AND	scaled_score IS NULL OR scaled_score = '' OR scaled_score = '0' THEN 'N/A'
				WHEN section_name = 'SS_READ_FALL_2014' AND	scaled_score <= 28 THEN 'BEG'
				WHEN section_name = 'SS_READ_FALL_2014' AND	scaled_score BETWEEN 29 AND 39 THEN 'NEA'
				WHEN section_name = 'SS_READ_FALL_2014' AND	scaled_score BETWEEN 40 AND 50 THEN 'PRO'
				WHEN section_name = 'SS_READ_FALL_2014' AND	scaled_score >= 51 THEN 'ADV'
				WHEN section_name = 'SS_MATH_FALL_2014' AND	scaled_score <= 26 THEN 'BEG'
				WHEN section_name = 'SS_MATH_FALL_2014' AND	scaled_score BETWEEN 27 AND 39 THEN 'NEA'
				WHEN section_name = 'SS_MATH_FALL_2014' AND	scaled_score BETWEEN 40 AND 50 THEN 'PRO'
				WHEN section_name = 'SS_MATH_FALL_2014' AND	scaled_score >= 51 THEN 'ADV'
				WHEN section_name = 'SS_SCIENCE_FALL_2014' AND	scaled_score <= 29 THEN 'BEG'
				WHEN section_name = 'SS_SCIENCE_FALL_2014' AND	scaled_score BETWEEN 30 AND 39 THEN 'NEA'
				WHEN section_name = 'SS_SCIENCE_FALL_2014' AND	scaled_score BETWEEN 40 AND 51 THEN 'PRO'
				WHEN section_name = 'SS_SCIENCE_FALL_2014' AND	scaled_score >= 52 THEN 'ADV'
				END			
			
	END AS score_group_code
	,score_group_label
	,last_name
	,first_name
	,DOB
	,raw_score
	/*If the student didn't complete a test, set the scaled score to zero*/
	,CASE
		WHEN section_name = 'SS_READ_FALL_2014' AND scaled_score != '' THEN '11' + scaled_score
		WHEN section_name = 'SS_MATH_FALL_2014' AND scaled_score != '' THEN '11' + scaled_score
		WHEN section_name = 'SS_SCIENCE_FALL_2014' AND scaled_score != '' THEN '11' + scaled_score
		WHEN section_name = 'BEST_COMPOSITE_SUM' THEN COMPOSITE
		--ELSE scaled_score
	END AS scaled_score
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
	,score_20
	,score_21
	,score_raw_name
	,score_scaled_name
	,score_nce_name
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
	,score_18_name
	,score_19_name
	,score_20_name
	,score_21_name
FROM	
	(
	SELECT
		CAST (APS_ID AS INT) AS student_code
		,APS_ID
		,'2014' AS school_year
		,RIGHT ([SCHNUMB],3) AS school_code
		,'2014-10-01' AS test_date_code
		,'EOY' AS test_type_code
		,'HSGA-Composite' AS test_type_name
		/* Need the Test Section info for the pivot*/
		,READ_FALL_2014
		,MATH_FALL_2014
		,SCIENCE_FALL_2014
		,BEST_COMPOSITE_SCORE
		,SS_READ_FALL_2014
		,SS_MATH_FALL_2014
		,SS_SCIENCE_FALL_2014
		--,CAST ((CAST (SS_MATH_FALL_2014 AS INT)+ 11) + (CAST (SS_READ_FALL_2014 AS INT) + 11) AS VARCHAR) AS COMPOSITE
		,CASE 
			WHEN SS_MATH_FALL_2014 > 1 AND SS_READ_FALL_2014 > 1 THEN
			CAST ('11' + (SS_MATH_FALL_2014)AS INT) + CAST ('11' + (SS_READ_FALL_2014)AS INT) 
		END	AS COMPOSITE
		,BEST_COMPOSITE_SUM
		,'0' AS parent_test_section_code
		,'' AS score_group_code
		,'' AS score_group_name
		,CASE	
			WHEN SS_MATH_FALL_2014 BETWEEN 1 AND 27 AND SS_READ_FALL_2014 BETWEEN 1 AND 29 THEN 'FMFR'
			WHEN SS_MATH_FALL_2014 BETWEEN 1 AND 27 AND SS_READ_FALL_2014 > 28 THEN 'FMPR'
			WHEN SS_MATH_FALL_2014 > 26 AND SS_READ_FALL_2014 BETWEEN 1 AND 29 THEN 'PMFR'
			WHEN SS_MATH_FALL_2014 > 26 AND SS_READ_FALL_2014 > 28 THEN 'PMPR'
			ELSE 'N/A'
		END AS PASSFAIL	
		,'03' AS low_test_level_code
		,'H4' AS high_test_level_code
		,'H3' AS test_level_name
		,'' AS version_code
		,'Performance Level' AS score_group_label
		,LastName AS last_name
		,FirstName AS first_name
		/*concatenate the year, month and day--*/
		--,LEFT(STR(DOB,8,4),4)+ '-' +
		--SUBSTRING ( STR(DOB,8,4) , 5 , 2 ) + '-' +
		--RIGHT (STR(DOB,8,4),2) AS DOB
		,'' AS DOB
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
		,'Scale Score' AS score_scaled_name
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

	FROM [SchoolNet].[dbo].[HSGA_Pass_Fail_Report_2012-2013-2014 No Charters] AS HSGA
	--WHERE SS_READ_FALL_2014 > 1
	----OR SS_SCIENCE_FALL_2014 > 1
	--OR SS_MATH_FALL_2014 > 1
) AS T1

/*proficiency_level is the column name we used in the main select) 
test_section_name will return the original column headers  */
UNPIVOT (scaled_score FOR section_name IN (SS_SCIENCE_FALL_2014, SS_READ_FALL_2014, SS_MATH_FALL_2014, BEST_COMPOSITE_SUM)) AS Unpvt
--WHERE test_section_name = 'COMPOSITE'		
--WHERE student_code = '103450474'
--where last_name = 'tsosie'
) AS T2
WHERE score_group_name != 'N/A'
--AND student_code > 1

ORDER BY last_name,test_section_name

--ROLLBACK