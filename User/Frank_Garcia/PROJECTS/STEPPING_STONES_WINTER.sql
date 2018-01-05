USE [SchoolNet]
GO

--TRUNCATE TABLE dbo.test_result_SteppingStones
--GO
INSERT INTO dbo.test_result_SteppingStones
SELECT
	student_code
	,school_year
	,school_code
	,test_date_code
	,'Math_Quarterly' AS test_type_code
	,'Stepping Stones' AS test_type_name
	,'Math Quarterly Test - Modules 4-6' AS test_section_code
	,CASE WHEN assessment_name = '2014-2015 Winter Grade K Math Quarterly Test 3- Modules 4-6' THEN 'Math Quarterly Test - Modules 4-6'
		  WHEN assessment_name = '2014-2015 Winter Grade 1 Math Quarterly Test 1- Modules 4-6' THEN 'Math Quarterly Test - Modules 4-6'
		  WHEN assessment_name = '2014-2015 Winter Grade 2 Math Quarterly Test 4- Modules 4-6' THEN 'Math Quarterly Test - Modules 4-6'
		  WHEN assessment_name = '2014-2015 Winter Grade 3 Math Quarterly Test- Modules 4-6' THEN 'Math Quarterly Test - Modules 4-6'
		  WHEN assessment_name = '2014-2015 Winter Grade 4 Math Quarterly Test- Modules 4-6' THEN 'Math Quarterly Test - Modules 4-6'
		  WHEN assessment_name = '2014-2015 Winter Grade 5 Math Quarterly Test- Modules 4-6' THEN 'Math Quarterly Test - Modules 4-6'
	END AS test_section_name
	,'0' parent_test_section_code
	,CASE WHEN '0'+ SUBSTRING(assessment_name,24,1) = '0K' THEN 'K' 
		ELSE '0'+ SUBSTRING(assessment_name,24,1)
	END AS low_test_level_code
	,grade_code AS high_test_level_code
	,grade_code AS test_level_name
	,'' version_code
	/*For Reading, Math and Science 1 = Begin, 2 = Near, 3 = Prof, 4 = Adv
		For Writing 1 = Near, 2 = Prof
		Five = No Score */
	,[Overall Exam Proficiency Level Text] AS score_group_name 
	,[Overall Exam Proficiency Level] AS score_group_code
	,'Performance Level' AS score_group_label
	,last_name
	,REPLACE (first_name,'"', '')  AS first_name
	--,CASE WHEN STUDENT_CODE = '970041776' THEN 'John' ELSE first_name
	--END AS first_name
	, DOB
	,[Overall Exam Score] AS raw_score
	/*If the student didn't complete a test, set the scaled score to zero*/
	,'' scaled_score
	,'' nce_score
	,[Overall Exam Percent Score] AS percentile_score
	,'' score_1
	,'' score_2
	,'' score_3
	,'' score_4
	,'' score_5
	,'' score_6
	,'' score_7
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
	,'Number of Points' score_raw_name
	,'' score_scaled_name
	,'' score_nce_name
	,'Percent' score_percentile_name
	,'' score_1_name
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
	  [assessment_id]
      ,[assessment_name]
      ,[assessment_date] AS test_date_code
      ,[student_id] AS student_code
      ,[student_name]
	  ,ALS.last_name
	  ,ALS.first_name
	  ,ALS.DOB
	  ,ALS.SCHOOL_YEAR AS school_year
	  ,ALS.school_code
	  ,ALS.grade_code
      ,[proficiency_measure]
      ,[proficiency_score]
  FROM [dbo].[STEPPING_STONES] SS
  LEFT JOIN	
	 ALLSTUDENTS AS ALS
	 ON SS.student_id = ALS.student_code
  --WHERE assessment_id IN ('8326','8328','8330','8408','8415','8416')
  ) AS T1
  PIVOT (MAX([proficiency_score]) FOR proficiency_measure IN (
		 [Overall Exam Percent Score]
		,[Overall Exam Score]
		,[Overall Exam Proficiency Level Text]
		,[Overall Exam Proficiency Level]
		)) AS pvt
  --WHERE last_name IS NOT NULL
  --and school_code = '203'
  WHERE assessment_id IN ('8326','8328','8330','8408','8415','8416')
  AND grade_code IS NOT NULL
			
  ORDER BY test_section_code

GO


