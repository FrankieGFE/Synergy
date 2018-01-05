BEGIN TRAN

SELECT
	student_code
	,school_year
	,school_code
	,test_date_code
	,test_type_code
	,test_type_name 
	,test_section_code
	,CASE
		WHEN section_name = 'READ_FALL_2013' THEN 'READING'
		WHEN section_name = 'MATH_FALL_2013' THEN 'MATH'
		WHEN section_name = 'SCIENCE_FALL_2013' THEN 'SCIENCE'
		WHEN section_name = 'BEST_COMPOSITE_SCORE' THEN 'COMPOSITE'
		END
		AS test_section_name 
	,parent_test_section_code 
	,low_test_level_code
	,high_test_level_code
	,test_level_name
	,version_code
	,score_group_name 
	,'NA' AS score_group_code
	,score_group_label
	,last_name
	,first_name
	,DOB
	,raw_score
	/*If the student didn't complete a test, set the scaled score to zero*/
	,CASE
		WHEN section_name = 'READ_FALL_2013' THEN '12'+ SS_READ_FALL_2013 
		WHEN section_name = 'MATH_FALL_2013' THEN '12' + SS_MATH_FALL_2013 
		WHEN section_name = 'SCIENCE_FALL_2013' THEN '12' + SS_SCIENCE_FALL_2013 
		ELSE '12' + BEST_COMPOSITE_SUM
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
		CAST (APS_ID AS INT) AS student_code
		,'2013' AS school_year
		,RIGHT ([SCHNUMB],3) AS school_code
		,'2013-10-01' AS test_date_code
		,'EOY' AS test_type_code
		,'HSGA-Composite' AS test_type_name
		/* Need the Test Section info for the pivot*/
		,READ_FALL_2013
		,MATH_FALL_2013
		,SCIENCE_FALL_2013
		,BEST_COMPOSITE_SCORE
		,BEST_COMPOSITE_SUM
		,SS_READ_FALL_2013
		,SS_MATH_FALL_2013
		,SS_SCIENCE_FALL_2013
		,'0' AS parent_test_section_code
		,'3' AS low_test_level_code
		,'H4' AS high_test_level_code
		,'H3' AS test_level_name
		,'' AS version_code
		,'' AS test_section_code
		,'' AS test_section_name
		,'Performance Level' AS score_group_label
		,LastName AS last_name
		,FirstName AS first_name
		/*concatenate the year, month and day--*/
		--,LEFT(STR(DOB,8,4),4)+ '-' +
		--SUBSTRING ( STR(DOB,8,4) , 5 , 2 ) + '-' +
		--RIGHT (STR(DOB,8,4),2) AS DOB
		--,'' AS DOB
		,'' AS DOB
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

	FROM [SchoolNet].[dbo].[HSGA_Pass_Fail_Report_1213] AS HSGA
	--WHERE [APS_ID] In ('000090499','000096667') -- test student
			

) AS T1

/*proficiency_level is the column name we used in the main select) 
test_section_name will return the original column headers  */
UNPIVOT (score_group_name FOR section_name IN (READ_FALL_2013, MATH_FALL_2013, SCIENCE_FALL_2013, BEST_COMPOSITE_SCORE


		)) AS Unpvt
		where student_code = '82988'
		--WHERE student_code > '1'
ORDER BY student_code


ROLLBACK