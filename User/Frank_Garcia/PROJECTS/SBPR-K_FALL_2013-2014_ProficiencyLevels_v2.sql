BEGIN TRAN
USE
db_DRA
GO
SELECT
	student_code
	--,prof
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
	,'Not Applicable' AS score_group_name 
	,'NA' AS score_group_code
	,score_group_label
	,last_name
	,first_name
	, DOB
	,raw_score
	/*If the student didn't complete a test, set the scaled score to zero*/
	,scaled_score
	,nce_score
	,percentile_score
	,score_1
	,score_2
	,score_3
	,score_4
	--CASE test_section_name
	--	WHEN 'Favorite Book' THEN [Pct_UsageMech]
	--	WHEN 'RhetSkills' THEN [Pct_RhetSkills]
	--	WHEN 'ElemAlg' THEN [Pct_ElemAlg]
	--	WHEN 'Alg_CoordGeom' THEN [Pct_Alg_CoordGeom]
	--	WHEN 'PlaneGeom_Trig' THEN [Pct_PlaneGeom_Trig]
	--	WHEN 'SocStud_Science' THEN [Pct_SocStud_Science]
	--	WHEN 'Arts_Lit' THEN [Pct_Arts_Lit]
	--	WHEN 'Writing' THEN [Pct_Combo_Wrtg_Eng]
	--	ELSE test_section_name
	--END
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
		distinct fld_ID_NBR AS student_code
		,'2013' AS school_year
		,fld_TestLoc AS school_code
		,'01/01/2013' AS test_date_code
		,'DRA' AS test_type_code
		,'DRA' AS test_type_name
		--,'' as test_section_code
		--,'' as test_section_name
		,QDD.test_section_code
		,QDD.fld_CategoryName AS test_section_name
		,fld_Score_Sect1_1
		,fld_Score_Sect1_2
		,fld_Score_Sect1_3
		,fld_Score_Sect2_1
		,fld_Score_Sect2_2
		,fld_Score_Sect2_3
		,fld_Score_Sect2_4
		,fld_Score_Sect3_1
		,fld_Score_Sect3_2
		,fld_Score_Sect3_3
		,fld_Score_Sect3_4
		,fld_Score_Sect3_5
		,fld_Score_Sect3_6
		,fld_Score_Sect3_7
		,fld_category_sortorder
		,fld_header_sortorder
		,dra.fld_Level
		,fld_Total_Sect1
		,fld_Total_Sect2
		,fld_Total_Sect3
		--,'' AS parent_test_section_code
		,QDD.parent_test_section_code AS parent_test_section_code
		,'K' AS low_test_level_code
		,'05' AS high_test_level_code
		/*Pad the grade with a zero for grades less than 10th */
		,fld_GRDE AS test_level_name
		,'' AS version_code
		,'Score Group' AS score_group_label
		,fld_LST_NME AS last_name
		,fld_FRST_NME AS first_name
		/*concatenate the year, month and day--*/
		,SUBSTRING (CAST (fld_BRTH_DT AS NVARCHAR (10)), 1,4)+'-'+SUBSTRING (CAST (fld_BRTH_DT AS NVARCHAR (10)), 5,2)+'-'+SUBSTRING (CAST (fld_BRTH_DT AS NVARCHAR (10)), 7,8)  AS DOB
		,'' AS raw_score
		,'' AS scaled_score
		,'' AS nce_score
		,'' AS percentile_score
		,'' AS score_1
		,'' AS score_2
		,'' AS score_3
		--,'' AS score_4
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
		,'' AS score_scaled_name
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

	FROM results AS DRA
	INNER JOIN
	[Question_Dropdowns_DRA] AS QDD
	ON
	DRA.fld_Assessment_Used = QDD.fld_Assessment
	AND	DRA.fld_Level = QDD.fld_Level
	AND DRA.fld_story = QDD.fld_levelTitles
	WHERE
	fld_AssessmentWindow = 'Fall' 
	)AS DRA
UNPIVOT
(score_4 FOR some_score In
	(	
		fld_Score_Sect1_1
		,fld_Score_Sect1_2
		,fld_Score_Sect1_3
		,fld_Score_Sect2_1
		,fld_Score_Sect2_2
		,fld_Score_Sect2_3
		,fld_Score_Sect2_4
		,fld_Score_Sect3_1
		,fld_Score_Sect3_2
		,fld_Score_Sect3_3
		,fld_Score_Sect3_4
		,fld_Score_Sect3_5
		,fld_Score_Sect3_6
		,fld_Score_Sect3_7
		--,fld_category_sortorder
		--,fld_header_sortorder
		
	) )as unpvt
		
		where student_code = '970091518'
		--order by fld_header_sortorder
		--,fld_category_sortorder
		
ROLLBACK