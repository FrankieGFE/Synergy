USE Assessments
GO
/****
 
 * $LastChangedBy: Terri Christiansen
 * $LastChangedDate: 8/19/2013 $
 *
 * Request By: SchoolNet
 * InitialRequestDate: 
 * 
 * Initial Request:
 * SAT test
 * Tables Referenced:  Experiment with a Standardized test layout.
	In this case, EOC 
****/
TRUNCATE TABLE test_result_EOC
GO
INSERT INTO test_result_EOC
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
	,dob
	,raw_score
	,scaled_score
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
		ROW_NUMBER () OVER (PARTITION BY [ID Number], CS.[ASSESSMENT_ID], [test Date] ORDER BY [School] DESC) AS RN
		,[ID Number] AS student_code
		,EOC.[School Year] AS school_year
		,[School] AS school_code
		,[test Date] AS test_date_code
		,[Test ID] AS test_type_code
		,[Test ID] AS test_type_name
		,Subtest AS test_section_code
		--,CS.SM_name AS test_section_code
		,Subtest AS test_section_name
		,'0' AS parent_test_section_code
		,CS.LOW_GRADE AS low_test_level_code
		,CS.HIGH_GRADE AS high_test_level_code
		,STUD.grade_code AS test_level_name
		,'' AS version_code
		,Score2 AS score_group_name
		,Score2 AS score_group_code
		,'Performance Level' AS score_group_label
		--,Last_Name AS last_name
		,REPLACE (STUD.last_name,'"', '') AS last_name
		--,First_Name AS first_name
		,REPLACE (STUD.first_name,'"', '') AS first_name
		/*concatenate the year, month and day--*/
		--,LEFT(STR(DOB,8,4),4)+ '-' +
		--SUBSTRING ( STR(DOB,8,4) , 5 , 2 ) + '-' +
		--RIGHT (STR(DOB,8,4),2)
		,STUD.DOB AS DOB
		--,'' AS DOB
		,Score1 AS raw_score
		,'' AS scaled_score
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

	FROM [EOC_Senior_Retakes_2015-2016] AS EOC
	--FROM [SPRING_EOC_] AS EOC
	LEFT JOIN
		EoC_Cut_Scores AS CS
		ON EOC.assessment_id = CS.assessment_id

    LEFT JOIN
		ALLSTUDENTS AS STUD
		ON EOC.[ID Number] = STUD.student_code

	--WHERE EOC.assessment_id IN ('8780', '8787', '8789', '8790')
--	WHERE EOC.assessment_id IN
--	(
--	'8720',
--	'8721',
--	'8722',
--	'8723',
--	'8727',
--	'8716',
--	'8717',
--	'8718',
--	'8719',
--	'8712',
--	'8734',
--	'8724',
--	'8713',
--	'8709',
--	'8711',
--	'8725',
--	'8728',
--	'8714',
--	'8715',	

---- SPRING EOCs

--	'8623',
--	'8622',
--	'8621',
--	'8624',
--	'8187',
--	'8204',
--	'8203',
--	'8655',
--	'8681',
--	'8215',
--	'8213',
--	'8669',
--	'8208',
--	'8657',
--	'8210',
--	'8652',
--	'8670',
--	'8663',
--	'8653',
--	'8639',
--	'8196',
--	'8641',
--	'8198',
--	'8643',
--	'8656',
--	'8677',
--	'8654',
--	'8668',
--	'8664',
--	'8659',
--	'8678',
--	'8192',
--	'8680',
--	'8214',
--	'8651',
--	'8660',
--	'8191',
--	'8189',
--	'8212',
--	'8661',
--	'8662',
--	'8676',
--	'8666',
--	'8673',
--	'8675',
--	'8207',
--	'8645',
--	'8646',
--	'8658',
--	'8200',
--	'8194 '
--)

	--WHERE EOC.assessment_id IN ('8196','8198','8203','8207')
	--WHERE EOC.assessment_id LIKE '90%'
	--AND [test Date] != ''
--	AND (EOC.Grade IS NOT NULL OR EOC.GRADE != '')
--	AND EOC.[ID Number] > '1'
--	--WHERE assessment_id IN ('8193', '8195', '8201', '8202', '8362','8363','8365','8367','8368','8371','8373','8374','8375','8376')
--	--AND [ID Number] = 970091387 -- test student
--	--AND [ID Number] = '970041776'
) AS EOC
--	WHERE RN = 1
	order by student_code, test_section_name




