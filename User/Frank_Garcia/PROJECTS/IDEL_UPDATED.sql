USE SchoolNet
GO
/****
 
 * $LastChangedBy: Frank Garcia
 * $LastChangedDate: 1/13/2015 $
 *
 * Request By: SchoolNet
 * InitialRequestDate: 
 * 
 * Initial Request:
 * IDEL - PARENT CHILD
 * 
	
--****/
TRUNCATE TABLE dbo.test_result_IDEL
--GO

DECLARE @WINDOW varchar (50) = 'EOY';
DECLARE @TEST_DATE varchar (50) = '2015-04-01';

INSERT INTO dbo.test_result_IDEL
SELECT	
	student_code
	,school_year
	,school_code
	,test_date_code
	,test_type_code
	,test_type_name
	,test_section_name AS test_section_code
	,test_section_name AS test_section_name
	--,CASE WHEN test_section_name = '' THEN IR ELSE ''END AS TESTSCTIONNAME
	,parent_test_section_code
	,low_test_level_code
	,high_test_level_code
	,test_level_name
	,version_code
	,CASE WHEN test_section_name = '' THEN IR ELSE score_group_name
	END AS score_group_name
	,CASE WHEN test_section_name = '' THEN IR ELSE score_group_code
	END AS score_group_code
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
	ROW_NUMBER () OVER (PARTITION BY student_code, test_section_name ORDER BY student_code DESC) AS RN
	,student_code AS student_code
	,LEFT (school_year, 4) AS school_year
	,school_code AS school_code
	,@TEST_DATE AS test_date_code
	,'mCLASSD' AS test_type_code
	,'IDEL' AS test_type_name
	,CASE
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en Nombrar Letras-Score' THEN 'FNL'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en la SegmentaciAn de Fonemas-Score' THEN 'FSF'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en las Palabras sin Sentido-Score' THEN 'FPS'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en la Lectura Oral-Score' THEN 'FLO'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en el Uso de las Palabras-Score' THEN 'FUP'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en el Relato Oral-Score' THEN 'FRO'
	ELSE ''
	END  AS test_section_code
	--,PROFICIENCY_LEVEL AS PL
	,CASE
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en Nombrar Letras-Score' THEN 'FNL'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en la SegmentaciAn de Fonemas-Score' THEN 'FSF'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en las Palabras sin Sentido-Score' THEN 'FPS'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en la Lectura Oral-Score' THEN 'FLO'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en el Uso de las Palabras-Score' THEN 'FUP'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en el Relato Oral-Score' THEN 'FRO'
	ELSE ''
	END  AS test_section_name
	,'Instructional Recommendation' AS parent_test_section_code
	,'K' AS low_test_level_code
	,'5' AS high_test_level_code
	,CASE WHEN test_level_name = 'K' THEN 'K' 
		ELSE RIGHT('00'+ test_level_name,2)
	END AS test_level_name
	,'' AS version_code
	,CASE
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en Nombrar Letras-Score' THEN [Assessment Measure-Fluidez en Nombrar Letras-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en la SegmentaciAn de Fonemas-Score' THEN [Assessment Measure-Fluidez en la SegmentaciAn de Fonemas-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en las Palabras sin Sentido-Score' THEN [Assessment Measure-Fluidez en las Palabras sin Sentido-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en la Lectura Oral-Score' THEN [Assessment Measure-Fluidez en la Lectura Oral-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en el Uso de las Palabras-Score' THEN 'N/A'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en el Relato Oral-Score' THEN 'N/A'
	ELSE '?'
	END  AS score_group_name
	,CASE
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en Nombrar Letras-Score' THEN [Assessment Measure-Fluidez en Nombrar Letras-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en la SegmentaciAn de Fonemas-Score' THEN [Assessment Measure-Fluidez en la SegmentaciAn de Fonemas-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en las Palabras sin Sentido-Score' THEN [Assessment Measure-Fluidez en las Palabras sin Sentido-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en la Lectura Oral-Score' THEN [Assessment Measure-Fluidez en la Lectura Oral-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en el Uso de las Palabras-Score' THEN 'N/A'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en el Relato Oral-Score' THEN 'N/A'
	ELSE '?'
	END  AS score_group_code
	,'Performance Level' AS score_group_label
	,last_name AS last_name
	,first_name AS first_name
	/*Dates are to be YYYY-MM-DD  date of birth*/
	, CONVERT(VARCHAR(10), DOB, 120) AS dob
	,'' AS raw_score
	,CASE WHEN TEST_SECTION_NAME = 'Assessment Measure-Instructional Recommendation-Levels' THEN '' ELSE PROFICIENCY_LEVEL 
	END AS scaled_score
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
	,CASE WHEN TEST_SECTION_NAME = 'Assessment Measure-Instructional Recommendation-Levels' THEN PROFICIENCY_LEVEL 
	END AS IR
FROM
	(
	SELECT 
		   [School Year] AS school_year
		  ,[Student Last Name] AS last_name
		  ,[Student First Name] AS first_name
		  ,[Student Middle Name] AS MI
		  ,[Grade] AS test_level_name
		  ,[Date of Birth] AS DOB
		  ,[Assessment Edition] AS test_type_name
		  ,[Assessment] AS test_type_code
		  --,[Assessment Measure-Instructional Recommendation-Levels]
		  ,[Assessment Measure-Fluidez en Nombrar Letras-Levels]
		  ,[Assessment Measure-Fluidez en la SegmentaciAn de Fonemas-Levels]
		  ,[Assessment Measure-Fluidez en las Palabras sin Sentido-Levels]
		  ,[Assessment Measure-Fluidez en la Lectura Oral-Levels]
		  ,PROFICIENCY_LEVEL
		  ,TEST_SECTION_NAME
		  ,[Student ID (District ID)] AS student_code
		  ,CASE
				WHEN [Student ID (School ID)] = '' THEN ''
				WHEN [Student ID (School ID)] > '900' THEN ''
				ELSE [Student ID (School ID)]
		  END AS school_code
	  FROM [dbo].IDEL_Summary
	  UNPIVOT
		(PROFICIENCY_LEVEL FOR TEST_SECTION_NAME IN
		   (
			  [Assessment Measure-Fluidez en Nombrar Letras-Score]
			  ,[Assessment Measure-Fluidez en la SegmentaciAn de Fonemas-Score]
			  ,[Assessment Measure-Fluidez en las Palabras sin Sentido-Score]
			  ,[Assessment Measure-Fluidez en la Lectura Oral-Score]
			  ,[Assessment Measure-Fluidez en el Uso de las Palabras-Score]
			  ,[Assessment Measure-Fluidez en el Relato Oral-Score]
		  )
	) AS UP1
	WHERE [Benchmark Period] = @WINDOW
	--AND [Student ID (District ID)]='980002981'
) AS T1
WHERE PROFICIENCY_LEVEL != ''
AND student_code != ''
AND student_code NOT LIKE 'K%'
--AND school_code LIKE '%%%'
--AND school_code != ''
) AS T2
--WHERE RN = 1
--ORDER BY student_code

UNION

SELECT	
	student_code
	,school_year
	,school_code
	,test_date_code
	,test_type_code
	,test_type_name
	,test_section_name AS test_section_code
	,test_section_name AS test_section_name
	--,CASE WHEN test_section_name = '' THEN IR ELSE ''END AS TESTSCTIONNAME
	,parent_test_section_code
	,low_test_level_code
	,high_test_level_code
	,test_level_name
	,version_code
	,CASE WHEN score_group_name = '?' THEN IR ELSE score_group_name
	END AS score_group_name
	,CASE WHEN score_group_name = '?' THEN IR ELSE score_group_code
	END AS score_group_code
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
	ROW_NUMBER () OVER (PARTITION BY student_code, test_section_name ORDER BY student_code DESC) AS RN
	,student_code AS student_code
	,LEFT (school_year, 4) AS school_year
	,school_code AS school_code
	,@TEST_DATE AS test_date_code
	,'mCLASSD' AS test_type_code
	,'IDEL' AS test_type_name
	,'Instructional Recommendation' AS test_section_code
	--,PROFICIENCY_LEVEL AS PL
	,'Instructional Recommendation' AS test_section_name
	,'0' AS parent_test_section_code
	,'K' AS low_test_level_code
	,'5' AS high_test_level_code
	,CASE WHEN test_level_name = 'K' THEN 'K' 
		ELSE RIGHT('00'+ test_level_name,2)
	END AS test_level_name
	,'' AS version_code
	,CASE
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en Nombrar Letras-Score' THEN [Assessment Measure-Fluidez en Nombrar Letras-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en la SegmentaciAn de Fonemas-Score' THEN [Assessment Measure-Fluidez en la SegmentaciAn de Fonemas-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en las Palabras sin Sentido-Score' THEN [Assessment Measure-Fluidez en las Palabras sin Sentido-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en la Lectura Oral-Score' THEN [Assessment Measure-Fluidez en la Lectura Oral-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en el Uso de las Palabras-Score' THEN 'N/A'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en el Relato Oral-Score' THEN 'N/A'
	ELSE '?'
	END  AS score_group_name
	,CASE
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en Nombrar Letras-Score' THEN [Assessment Measure-Fluidez en Nombrar Letras-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en la SegmentaciAn de Fonemas-Score' THEN [Assessment Measure-Fluidez en la SegmentaciAn de Fonemas-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en las Palabras sin Sentido-Score' THEN [Assessment Measure-Fluidez en las Palabras sin Sentido-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en la Lectura Oral-Score' THEN [Assessment Measure-Fluidez en la Lectura Oral-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en el Uso de las Palabras-Score' THEN 'N/A'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Fluidez en el Relato Oral-Score' THEN 'N/A'

	ELSE '?'
	END  AS score_group_code
	,'Performance Level' AS score_group_label
	,last_name AS last_name
	,first_name AS first_name
	/*Dates are to be YYYY-MM-DD  date of birth*/
	, CONVERT(VARCHAR(10), DOB, 120) AS dob
	,'' AS raw_score
	,CASE WHEN TEST_SECTION_NAME = 'Assessment Measure-Instructional Recommendation-Levels' THEN '' ELSE PROFICIENCY_LEVEL 
	END AS scaled_score
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
	,CASE WHEN TEST_SECTION_NAME = 'Assessment Measure-Instructional Recommendation-Levels' THEN PROFICIENCY_LEVEL 
	END AS IR
FROM
	(
	SELECT 
		   [School Year] AS school_year
		  ,[Student Last Name] AS last_name
		  ,[Student First Name] AS first_name
		  ,[Student Middle Name] AS MI
		  ,[Grade] AS test_level_name
		  ,[Date of Birth] AS DOB
		  ,[Assessment Edition] AS test_type_name
		  ,[Assessment] AS test_type_code
		  --,[Assessment Measure-Instructional Recommendation-Levels]
		  ,[Assessment Measure-Fluidez en Nombrar Letras-Levels]
		  ,[Assessment Measure-Fluidez en la SegmentaciAn de Fonemas-Levels]
		  ,[Assessment Measure-Fluidez en las Palabras sin Sentido-Levels]
		  ,[Assessment Measure-Fluidez en la Lectura Oral-Levels]
		  ,PROFICIENCY_LEVEL
		  ,TEST_SECTION_NAME
		  ,[Student ID (District ID)] AS student_code
		  ,CASE
				WHEN [Student ID (School ID)] = '' THEN ''
				WHEN [Student ID (School ID)] > '900' THEN ''
				ELSE [Student ID (School ID)]
		  END AS school_code
	  FROM [dbo].IDEL_Summary
	  UNPIVOT
		(PROFICIENCY_LEVEL FOR TEST_SECTION_NAME IN
		   (
			  [Assessment Measure-Instructional Recommendation-Levels]
		  )
	) AS UP1
	WHERE [Benchmark Period] = @WINDOW
	--AND [Student ID (District ID)]='980002981'
) AS T1
WHERE PROFICIENCY_LEVEL != ''
AND student_code != ''
AND student_code NOT LIKE 'K%'
--AND school_code LIKE '%%%'
--AND school_code != ''
) AS T2
ORDER BY test_level_name
