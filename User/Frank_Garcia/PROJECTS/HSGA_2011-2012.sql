


USE [SchoolNet]
GO

--/****** Object:  StoredProcedure [dbo].[test_result_HSGA_sp]    Script Date: 11/27/2013 12:15:15 ******/
--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[test_result_HSGA_sp]') AND type in (N'P', N'PC'))
--DROP PROCEDURE [dbo].[test_result_HSGA_sp]
--GO

--USE [SchoolNet]
--GO

--/****** Object:  StoredProcedure [dbo].[test_result_HSGA_sp]    Script Date: 11/27/2013 12:15:15 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE Procedure  [dbo].[test_result_HSGA_sp] AS

/****
 
 * $LastChangedBy: Terri Christiansen
 * $LastChangedDate: 7/18/2013 $
 *
 * Request By: SchoolNet
 * InitialRequestDate: 
 * 
 * Initial Request:
 * SAT test
 * Tables Referenced:  Experiment with a Standardized test layout.
	In this case, PSAT 
****/
--TRUNCATE TABLE test_result_HSGA

--INSERT INTO dbo.test_result_HSGA
/* This requires a pivot, so experiment with syntax */
SELECT
	*
FROM

(	
SELECT
	student_code
	,school_year
	,school_code
	,test_date_code
	,test_type_code
	,test_type_name
	,CASE
		WHEN section_name = 'Fall Reading' THEN 'Read'
		WHEN section_name = 'Fall Math' THEN 'Math'
		WHEN section_name = 'High Combo' THEN 'Comp'
	END
	AS test_section_code
	,CASE
		WHEN section_name = 'Fall Reading' THEN 'READING'
		WHEN section_name = 'Fall Math' THEN 'MATH'
		WHEN section_name = 'High Combo' THEN 'COMPOSITE'
	END
	AS test_section_name

	,parent_test_section_code 
	,low_test_level_code
	,high_test_level_code
	,test_level_name
	,version_code
	,CASE	
		WHEN section_name = 'High Combo' THEN 
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
				WHEN section_name = 'Fall Reading' AND	scaled_score IS NULL OR scaled_score = '' OR scaled_score = '0' THEN 'N/A'
				WHEN section_name = 'Fall Reading' AND	scaled_score <= 1128 THEN 'BEGINNING'
				WHEN section_name = 'Fall Reading' AND	scaled_score BETWEEN 1129 AND 1139 THEN 'NEARING'
				WHEN section_name = 'Fall Reading' AND	scaled_score BETWEEN 1140 AND 1150 THEN 'PROFICIENT'
				WHEN section_name = 'Fall Reading' AND	scaled_score >= 1151 THEN 'ADVANCED'
				WHEN section_name = 'Fall Math' AND	scaled_score IS NULL OR scaled_score = '' OR scaled_score = '0' THEN 'N/A'
				WHEN section_name = 'Fall Math' AND	scaled_score <= 1126 THEN 'BEGINNING'
				WHEN section_name = 'Fall Math' AND	scaled_score BETWEEN 1127 AND 1139 THEN 'NEARING'
				WHEN section_name = 'Fall Math' AND	scaled_score BETWEEN 1140 AND 1150 THEN 'PROFICIENT'
				WHEN section_name = 'Fall Math' AND	scaled_score >= 1151 THEN 'ADVANCED'
				END			
	END AS score_group_name 
	,CASE	
		WHEN section_name = 'High Combo' THEN 
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
				WHEN section_name = 'Fall Reading' AND	scaled_score IS NULL OR scaled_score = '' OR scaled_score = '0' THEN 'N/A'
				WHEN section_name = 'Fall Reading' AND	scaled_score <= 1128 THEN 'BEG'
				WHEN section_name = 'Fall Reading' AND	scaled_score BETWEEN 1129 AND 1139 THEN 'NEA'
				WHEN section_name = 'Fall Reading' AND	scaled_score BETWEEN 1140 AND 1150 THEN 'PRO'
				WHEN section_name = 'Fall Reading' AND	scaled_score >= 1151 THEN 'ADV'
				WHEN section_name = 'Fall Math' AND	scaled_score <= 1126 THEN 'BEG'
				WHEN section_name = 'Fall Math' AND	scaled_score BETWEEN 1127 AND 1139 THEN 'NEA'
				WHEN section_name = 'Fall Math' AND	scaled_score BETWEEN 1140 AND 1150 THEN 'PRO'
				WHEN section_name = 'Fall Math' AND	scaled_score >= 1151 THEN 'ADV'
				END			
			
	END AS score_group_code
	,score_group_label
	,last_name
	,first_name
	,DOB
	,raw_score
	/*If the student didn't complete a test, set the scaled score to zero*/
	,CASE
		WHEN section_name = 'Fall Reading' AND scaled_score != '' THEN scaled_score
		WHEN section_name = 'Fall Math' AND scaled_score != '' THEN scaled_score
		WHEN section_name = 'High Combo' THEN scaled_score
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
	(SELECT
		CAST ([SIS ID (by StateID, DOB, Last Name)] AS INT) AS student_code
		,'2011' AS school_year
		,RIGHT ([LocationID],3) AS school_code
		,'2011-10-01' AS test_date_code
		,'EOY' AS test_type_code
		,'HSGA-Composite' AS test_type_name
		/* Need the Test Section info for the pivot*/
		,[Fall Reading]
		,[Fall Math]
		,[High Combo]
		--,CAST ((CAST (SS_MATH_FALL_2013 AS INT)+ 11) + (CAST (SS_READ_FALL_2013 AS INT) + 11) AS VARCHAR) AS COMPOSITE
		,CASE 
			WHEN [Fall Math] > 1 AND [Fall Reading] > 1 THEN
			CAST (([Fall Math])AS INT) + CAST (([Fall Reading])AS INT) 
		END	AS COMPOSITE
		,'0' AS parent_test_section_code
		,'' AS score_group_code
		,'' AS score_group_name
		,CASE	
			WHEN [Fall Math] BETWEEN 1 AND 27 AND [Fall Reading] BETWEEN 1 AND 29 THEN 'FMFR'
			WHEN [Fall Math] BETWEEN 1 AND 27 AND [Fall Reading] > 28 THEN 'FMPR'
			WHEN [Fall Math] > 26 AND [Fall Reading] BETWEEN 1 AND 29 THEN 'PMFR'
			WHEN [Fall Math] > 26 AND [Fall Reading] > 28 THEN 'PMPR'
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
		--,'' AS DOB
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

	FROM [SchoolNet].[dbo].[HSGA_2011-2012] AS HSGA
	WHERE [Fall Reading] > 1
	OR [Fall Math] > 1
) AS T1

/*proficiency_level is the column name we used in the main select) 
test_section_name will return the original column headers  */
UNPIVOT (scaled_score FOR section_name IN ([Fall Reading], [Fall Math], [High Combo])) AS Unpvt
--WHERE test_section_name = 'COMPOSITE'		
--WHERE student_code = '970098608'
--where last_name = 'tsosie'
) AS T2
WHERE score_group_name != 'N/A'
AND student_code > 1
ORDER BY score_group_name



