USE SchoolNet
GO
/****
 
 * $LastChangedBy: Frank Garcia
 * $LastChangedDate: 9/10/2014 $
 *
 * Request By: SchoolNet
 * InitialRequestDate: 
 * 
 * Initial Request:
 * DIBELS
 * 
	
--****/
TRUNCATE TABLE dbo.test_result_DIBELS
--GO
DECLARE @WINDOW varchar (50) = 'EOY';
DECLARE @TEST_DATE varchar (50) = '2015-04-01';
INSERT INTO dbo.test_result_DIBELS
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
	ROW_NUMBER () OVER (PARTITION BY student_code, test_section_name ORDER BY student_code DESC) AS RN
	,student_code AS student_code
	,LEFT (school_year, 4) AS school_year
	,school_code AS school_code
	,@TEST_DATE AS test_date_code
	,'mCLASS' AS test_type_code
	,'DIBELS Next' AS test_type_name
	,CASE
		WHEN TEST_SECTION_NAME = 'Assessment Measure-FSF-Score' THEN 'FSF'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-LNF-Score' THEN 'LNF'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-PSF-Score' THEN 'PSF'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-NWF (CLS)-Score' THEN 'NWF (CLS)'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-NWF (WWR)-Score' THEN 'NWF (WWR)'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-DORF (Fluency)-Score' THEN 'DORF (Fluency)'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-DORF (Accuracy)-Score' THEN 'DORF (Accuracy)'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-DORF (Retell)-Score' THEN 'DORF (Retell)'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-DORF (Retell Quality)-Score' THEN 'DORF (Retell Quality)'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Daze-Score' THEN 'Daze'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Daze (Correct)-Score' THEN 'Daze (Correct)'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Daze (Incorrect)-Score' THEN 'Daze (Incorrect)'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-DORF (Errors)-Score' THEN 'DORF (Errors)'
	ELSE ''
	END  AS test_section_code
	--,PROFICIENCY_LEVEL AS PL
	,CASE
		WHEN TEST_SECTION_NAME = 'Assessment Measure-FSF-Score' THEN 'FSF'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-LNF-Score' THEN 'LNF'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-PSF-Score' THEN 'PSF'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-NWF (CLS)-Score' THEN 'NWF (CLS)'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-NWF (WWR)-Score' THEN 'NWF (WWR)'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-DORF (Fluency)-Score' THEN 'DORF (Fluency)'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-DORF (Accuracy)-Score' THEN 'DORF (Accuracy)'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-DORF (Retell)-Score' THEN 'DORF (Retell)'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-DORF (Retell Quality)-Score' THEN 'DORF (Retell Quality)'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Daze-Score' THEN 'Daze'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Daze (Correct)-Score' THEN 'Daze (Correct)'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Daze (Incorrect)-Score' THEN 'Daze (Incorrect)'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-DORF (Errors)-Score' THEN 'DORF (Errors)'
	ELSE ''
	END  AS test_section_name
	,'Composite' AS parent_test_section_code
	,'K' AS low_test_level_code
	,'5' AS high_test_level_code
	,CASE WHEN test_level_name = 'K' THEN 'K' 
		ELSE RIGHT('00'+ test_level_name,2)
	END AS test_level_name
	,'' AS version_code
	,CASE
		WHEN TEST_SECTION_NAME = 'Assessment Measure-FSF-Score' THEN [Assessment Measure-FSF-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-LNF-Score' THEN [Assessment Measure-LNF-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-PSF-Score' THEN [Assessment Measure-PSF-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-NWF (CLS)-Score' THEN [Assessment Measure-NWF (CLS)-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-NWF (WWR)-Score' THEN [Assessment Measure-NWF (WWR)-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-DORF (Fluency)-Score' THEN [Assessment Measure-DORF (Fluency)-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-DORF (Accuracy)-Score' THEN [Assessment Measure-DORF (Accuracy)-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-DORF (Retell)-Score' THEN [Assessment Measure-DORF (Retell)-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-DORF (Retell Quality)-Score' THEN [Assessment Measure-DORF (Retell Quality)-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Daze-Score' THEN [Assessment Measure-Daze-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Daze (Correct)-Score' THEN 'N/A'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Daze (Incorrect)-Score' THEN 'N/A'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-DORF (Errors)-Score' THEN 'N/A'
	ELSE ''
	END  AS score_group_name
	,CASE
		WHEN TEST_SECTION_NAME = 'Assessment Measure-FSF-Score' THEN [Assessment Measure-FSF-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-LNF-Score' THEN [Assessment Measure-LNF-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-PSF-Score' THEN [Assessment Measure-PSF-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-NWF (CLS)-Score' THEN [Assessment Measure-NWF (CLS)-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-NWF (WWR)-Score' THEN [Assessment Measure-NWF (WWR)-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-DORF (Fluency)-Score' THEN [Assessment Measure-DORF (Fluency)-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-DORF (Accuracy)-Score' THEN [Assessment Measure-DORF (Accuracy)-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-DORF (Retell)-Score' THEN [Assessment Measure-DORF (Retell)-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-DORF (Retell Quality)-Score' THEN [Assessment Measure-DORF (Retell Quality)-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Daze-Score' THEN [Assessment Measure-Daze-Levels]
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Daze (Correct)-Score' THEN 'N/A'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Daze (Incorrect)-Score' THEN 'N/A'
		WHEN TEST_SECTION_NAME = 'Assessment Measure-DORF (Errors)-Score' THEN 'N/A'
	ELSE ''
	END  AS score_group_code
	,'Performance Level' AS score_group_label
	,last_name AS last_name
	,first_name AS first_name
	/*Dates are to be YYYY-MM-DD  date of birth*/
	,DOB AS dob
	,'' AS raw_score
	,PROFICIENCY_LEVEL AS scaled_score
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
		  ,[Assessment Measure-Composite Score-Levels]
		  ,[Assessment Measure-FSF-Levels]
		  ,[Assessment Measure-LNF-Levels]
		  ,[Assessment Measure-PSF-Levels]
		  ,[Assessment Measure-NWF (CLS)-Levels]
		  ,[Assessment Measure-NWF (WWR)-Levels]
		  ,[Assessment Measure-DORF (Fluency)-Levels]
		  ,[Assessment Measure-DORF (Accuracy)-Levels]
		  ,[Assessment Measure-DORF (Retell)-Levels]
		  ,[Assessment Measure-DORF (Retell Quality)-Levels]
		  ,[Assessment Measure-Daze-Levels]
		  ,PROFICIENCY_LEVEL
		  ,TEST_SECTION_NAME
		  ,[Student ID (District ID)] AS student_code
		  ,CASE
				WHEN [Student ID (School ID)] = '' THEN ''
				WHEN [Student ID (School ID)] > '900' THEN ''
				ELSE [Student ID (School ID)]
		  END AS school_code
	  FROM [dbo].[DIBBLES_Summary]
	  UNPIVOT
		(PROFICIENCY_LEVEL FOR TEST_SECTION_NAME IN
		   (
		   --[Assessment Measure-Composite Score-Levels]
		  --[Assessment Measure-Composite Score-Score]
		  --,[Assessment Measure-FSF-Levels]
		  [Assessment Measure-FSF-Score]
		  --,[Assessment Measure-LNF-Levels]
		  ,[Assessment Measure-LNF-Score]
		  --,[Assessment Measure-PSF-Levels]
		  ,[Assessment Measure-PSF-Score]
		  --,[Assessment Measure-NWF (CLS)-Levels]
		  ,[Assessment Measure-NWF (CLS)-Score]
		  --,[Assessment Measure-NWF (WWR)-Levels]
		  ,[Assessment Measure-NWF (WWR)-Score]
		  --,[Assessment Measure-DORF (Fluency)-Levels]
		  ,[Assessment Measure-DORF (Fluency)-Score]
		  --,[Assessment Measure-DORF (Accuracy)-Levels]
		  ,[Assessment Measure-DORF (Accuracy)-Score]
		  --,[Assessment Measure-DORF (Retell)-Levels]
		  ,[Assessment Measure-DORF (Retell)-Score]
		  --,[Assessment Measure-DORF (Retell Quality)-Levels]
		  ,[Assessment Measure-DORF (Retell Quality)-Score]
		  ,[Assessment Measure-DORF (Errors)-Score]
		  --,[Assessment Measure-Daze-Levels]
		  ,[Assessment Measure-Daze-Score]
		  ,[Assessment Measure-Daze (Correct)-Score]
		  ,[Assessment Measure-Daze (Incorrect)-Score]
		  )
		  
	) AS UP1
	WHERE [Benchmark Period] = @WINDOW
) AS T1
WHERE PROFICIENCY_LEVEL != ''
AND student_code > '4000'
AND student_code NOT LIKE 'K%'
AND (school_code IS NOT NULL OR school_code != '')
--AND student_code = '970092870'

) AS T2
--WHERE RN = 1

--ORDER BY school_code

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
	,'mCLASS' AS test_type_code
	,'DIBELS Next' AS test_type_name
	,CASE
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Composite Score-Score' THEN 'Composite'
	ELSE ''
	END  AS test_section_code
	--,PROFICIENCY_LEVEL AS PL
	,CASE
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Composite Score-Score' THEN 'Composite'
	ELSE ''
	END  AS test_section_name
	,'0' AS parent_test_section_code
	,'K' AS low_test_level_code
	,'5' AS high_test_level_code
	,CASE WHEN test_level_name = 'K' THEN 'K' 
		ELSE RIGHT('00'+ test_level_name,2)
	END AS test_level_name
	,'' AS version_code
	,CASE
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Composite Score-Score' THEN [Assessment Measure-Composite Score-Levels]
	ELSE ''
	END  AS score_group_name
	,CASE
		WHEN TEST_SECTION_NAME = 'Assessment Measure-Composite Score-Score' THEN [Assessment Measure-Composite Score-Levels]
	ELSE ''
	END  AS score_group_code
	,'Performance Level' AS score_group_label
	,last_name AS last_name
	,first_name AS first_name
	/*Dates are to be YYYY-MM-DD  date of birth*/
	,DOB AS dob
	,'' AS raw_score
	,PROFICIENCY_LEVEL AS scaled_score
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
FROM
	(
	SELECT 
		   [School Year] AS school_year
		  ,[Student Last Name] AS last_name
		  ,[Student First Name] AS first_name
		  ,[Student Middle Name] AS MI
		  ,[Grade] AS test_level_name
		  ,[Date of Birth] AS DOB
		  --,CONVERT (DATETIME, [Date of Birth], 105) as DOB
		  ,[Assessment Edition] AS test_type_name
		  ,[Assessment] AS test_type_code
		  ,[Assessment Measure-Composite Score-Levels]
		  ,[Assessment Measure-FSF-Levels]
		  ,[Assessment Measure-LNF-Levels]
		  ,[Assessment Measure-PSF-Levels]
		  ,[Assessment Measure-NWF (CLS)-Levels]
		  ,[Assessment Measure-NWF (WWR)-Levels]
		  ,[Assessment Measure-DORF (Fluency)-Levels]
		  ,[Assessment Measure-DORF (Accuracy)-Levels]
		  ,[Assessment Measure-DORF (Retell)-Levels]
		  ,[Assessment Measure-DORF (Retell Quality)-Levels]
		  ,[Assessment Measure-Daze-Levels]
		  ,PROFICIENCY_LEVEL
		  ,TEST_SECTION_NAME
		  ,[Student ID (District ID)] AS student_code
		  ,CASE
				WHEN [Student ID (School ID)] = '' THEN ''
				WHEN [Student ID (School ID)] > '900' THEN ''
				ELSE [Student ID (School ID)]
		  END AS school_code
	  FROM [dbo].[DIBBLES_Summary]
	  UNPIVOT
		(PROFICIENCY_LEVEL FOR TEST_SECTION_NAME IN
		   (
		   --[Assessment Measure-Composite Score-Levels]
		  [Assessment Measure-Composite Score-Score]
		  )
		  
	) AS UP1
	WHERE [Benchmark Period] = @WINDOW
) AS T1
WHERE PROFICIENCY_LEVEL != ''
AND student_code > '4000'
AND student_code NOT LIKE 'K%'
AND (school_code IS NOT NULL OR school_code != '')
--AND student_code = '970092870'

) AS T2
ORDER BY test_level_name


