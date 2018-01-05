USE [SchoolNetDevelopment]
GO
/****** Object:  StoredProcedure [dbo].execute execute [test_result_SP-LAS-LINKS_sp]    Script Date: 1/12/2015 1:29:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER procedure [dbo].[test_result_SP-LAS-LINKS_sp] as

truncate table test_result_SPPRO;

DECLARE @SchoolYear int = 2015;
DECLARE @TestDate varchar(50) = '2014-04-01';


--insert into test_result

/**
 * 
 * $LastChangedBy: Frank Garcia
 * $LastChangedDate: 1/12/2015 $
 *
 * Request By: SchoolNet
 * InitialRequestDate: 
 * 
 * Initial Request:
 * Version 12.5 Standardized Assessment Data Loading Worksheet
 *		SP_LAS_LINKS_sp
 * Tables Referenced:  (GS055_V
						CE020 for first name, last name and DOB
						SY075_V current year )
 */
 INSERT into test_result_SPPRO
SELECT
	student_code 
	,school_year
	,school_code
	,test_date_code
	,'SPPRO' AS test_type_code
	,'SP-LAS-LINKS' AS test_type_name
	,CASE
		WHEN test_section_name = 'SPEAKING SCALE SCORE' THEN 'SPE'
		WHEN test_section_name = 'LISTENING SCALE SCORE' THEN 'LIST'
		WHEN test_section_name = 'WRITING  SCALE SCORE' THEN 'WRI'
		WHEN test_section_name = 'COMPREHENSION SCALE SCORE' THEN 'COMP'
		WHEN test_section_name = 'ORAL SCALE SCORE' THEN 'ORA'
		WHEN test_section_name = 'READING  SCALE SCORE' THEN 'REA'
	END AS test_section_code
	,CASE	
		WHEN test_section_name = 'SPEAKING SCALE SCORE' THEN 'SPEAKING'
		WHEN test_section_name = 'LISTENING SCALE SCORE' THEN 'LISTENING'
		WHEN test_section_name = 'WRITING  SCALE SCORE' THEN 'WRITING'
		WHEN test_section_name = 'COMPREHENSION SCALE SCORE' THEN 'COMPREHENSION'
		WHEN test_section_name = 'ORAL SCALE SCORE' THEN 'ORAL'
		WHEN test_section_name = 'READING  SCALE SCORE' THEN 'READING'
		END
	AS test_section_name
	,'OVERALL' as parent_test_section_name
	--,CASE
	--	WHEN test_section_name = 'SPEAKING SCALE SCORE' THEN 'SPLAS'
	--	WHEN test_section_name = 'LISTENING SCALE SCORE' THEN 'SPLAS'
	--	WHEN test_section_name = 'WRITING  SCALE SCORE' THEN 'SPLAS'
	--	WHEN test_section_name = 'COMPREHENSION SCALE SCORE' THEN 'SPLAS'
	--	WHEN test_section_name = 'ORAL SCALE SCORE' THEN 'SPLAS'
	--	WHEN test_section_name = 'READING  SCALE SCORE' THEN 'SPLAS'
	--END AS parent_test_section_code
	,low_test_level_code
	,high_test_level_code
	,test_level_name
	,version_code
	,CASE
		WHEN test_section_name = 'SPEAKING SCALE SCORE' THEN 
			CASE 
				WHEN [SPEAKING  PROFICIENCY LEVEL] = '1' THEN 'BEGINNING'
				WHEN [SPEAKING  PROFICIENCY LEVEL] = '2' THEN 'EARLY INTERMEDIATE'
				WHEN [SPEAKING  PROFICIENCY LEVEL] = '3' THEN 'INTERMEDIATE'
				WHEN [SPEAKING  PROFICIENCY LEVEL] = '4' THEN 'PROFICIENT'
				WHEN [SPEAKING  PROFICIENCY LEVEL] = '5' THEN 'ABOVE PROFICIENT'
				ELSE 'Not Applicable'
				END
		WHEN test_section_name = 'LISTENING SCALE SCORE' THEN 
			CASE 
				WHEN [LISTENING PROFICIENCY LEVEL] = '1' THEN 'BEGINNING'
				WHEN [LISTENING PROFICIENCY LEVEL] = '2' THEN 'EARLY INTERMEDIATE'
				WHEN [LISTENING PROFICIENCY LEVEL] = '3' THEN 'INTERMEDIATE'
				WHEN [LISTENING PROFICIENCY LEVEL] = '4' THEN 'PROFICIENT'
				WHEN [LISTENING PROFICIENCY LEVEL] = '5' THEN 'ABOVE PROFICIENT'
				ELSE 'Not Applicable'
				END
		WHEN test_section_name = 'WRITING  SCALE SCORE' THEN 
			CASE 
				WHEN [WRITING PROFICIENCY  LEVEL] = '1' THEN 'BEGINNING'
				WHEN [WRITING PROFICIENCY  LEVEL] = '2' THEN 'EARLY INTERMEDIATE'
				WHEN [WRITING PROFICIENCY  LEVEL] = '3' THEN 'INTERMEDIATE'
				WHEN [WRITING PROFICIENCY  LEVEL] = '4' THEN 'PROFICIENT'
				WHEN [WRITING PROFICIENCY  LEVEL] = '5' THEN 'ABOVE PROFICIENT'
				ELSE 'Not Applicable'
				END
		WHEN test_section_name = 'COMPREHENSION SCALE SCORE' THEN 
			CASE 
				WHEN [COMPREHENSION PROFICIENCY LEVEL] = '1' THEN 'BEGINNING'
				WHEN [COMPREHENSION PROFICIENCY LEVEL] = '2' THEN 'EARLY INTERMEDIATE'
				WHEN [COMPREHENSION PROFICIENCY LEVEL] = '3' THEN 'INTERMEDIATE'
				WHEN [COMPREHENSION PROFICIENCY LEVEL] = '4' THEN 'PROFICIENT'
				WHEN [COMPREHENSION PROFICIENCY LEVEL] = '5' THEN 'ABOVE PROFICIENT'
				ELSE 'Not Applicable'
				END
		WHEN test_section_name = 'ORAL SCALE SCORE' THEN 
			CASE 
				WHEN [ORAL PROFICIENCY LEVEL] = '1' THEN 'BEGINNING'
				WHEN [ORAL PROFICIENCY LEVEL] = '2' THEN 'EARLY INTERMEDIATE'
				WHEN [ORAL PROFICIENCY LEVEL] = '3' THEN 'INTERMEDIATE'
				WHEN [ORAL PROFICIENCY LEVEL] = '4' THEN 'PROFICIENT'
				WHEN [ORAL PROFICIENCY LEVEL] = '5' THEN 'ABOVE PROFICIENT'
				ELSE 'Not Applicable'
				END
		WHEN test_section_name = 'READING  SCALE SCORE' THEN
			CASE 
				WHEN [READING PROFICIENCY LEVEL] = '1' THEN 'BEGINNING'
				WHEN [READING PROFICIENCY LEVEL] = '2' THEN 'EARLY INTERMEDIATE'
				WHEN [READING PROFICIENCY LEVEL] = '3' THEN 'INTERMEDIATE'
				WHEN [READING PROFICIENCY LEVEL] = '4' THEN 'PROFICIENT'
				WHEN [READING PROFICIENCY LEVEL] = '5' THEN 'ABOVE PROFICIENT'
				ELSE 'Not Applicable'
				END
		ELSE 'Not Applicable'
	END AS score_group_name
	,CASE
		WHEN test_section_name = 'SPEAKING SCALE SCORE' THEN 
			CASE 
				WHEN [SPEAKING  PROFICIENCY LEVEL] = '1' THEN '1'
				WHEN [SPEAKING  PROFICIENCY LEVEL] = '2' THEN '2'
				WHEN [SPEAKING  PROFICIENCY LEVEL] = '3' THEN '3'
				WHEN [SPEAKING  PROFICIENCY LEVEL] = '4' THEN '4'
				WHEN [SPEAKING  PROFICIENCY LEVEL] = '5' THEN '5'
				ELSE 'N/A'
				END
		WHEN test_section_name = 'LISTENING SCALE SCORE' THEN 
			CASE 
				WHEN [LISTENING PROFICIENCY LEVEL] = '1' THEN '1'
				WHEN [LISTENING PROFICIENCY LEVEL] = '2' THEN '2'
				WHEN [LISTENING PROFICIENCY LEVEL] = '3' THEN '3'
				WHEN [LISTENING PROFICIENCY LEVEL] = '4' THEN '4'
				WHEN [LISTENING PROFICIENCY LEVEL] = '5' THEN '5'
				ELSE 'N/A'
				END
		WHEN test_section_name = 'WRITING  SCALE SCORE' THEN 
			CASE 
				WHEN [WRITING PROFICIENCY  LEVEL] = '1' THEN '1'
				WHEN [WRITING PROFICIENCY  LEVEL] = '2' THEN '2'
				WHEN [WRITING PROFICIENCY  LEVEL] = '3' THEN '3'
				WHEN [WRITING PROFICIENCY  LEVEL] = '4' THEN '4'
				WHEN [WRITING PROFICIENCY  LEVEL] = '5' THEN '5'
				ELSE 'N/A'
				END
		WHEN test_section_name = 'COMPREHENSION SCALE SCORE' THEN 
			CASE 
				WHEN [COMPREHENSION PROFICIENCY LEVEL] = '1' THEN '1'
				WHEN [COMPREHENSION PROFICIENCY LEVEL] = '2' THEN '2'
				WHEN [COMPREHENSION PROFICIENCY LEVEL] = '3' THEN '3'
				WHEN [COMPREHENSION PROFICIENCY LEVEL] = '4' THEN '4'
				WHEN [COMPREHENSION PROFICIENCY LEVEL] = '5' THEN '5'
				ELSE 'N/A'
				END
		WHEN test_section_name = 'ORAL SCALE SCORE' THEN 
			CASE 
				WHEN [ORAL PROFICIENCY LEVEL] = '1' THEN '1'
				WHEN [ORAL PROFICIENCY LEVEL] = '2' THEN '2'
				WHEN [ORAL PROFICIENCY LEVEL] = '3' THEN '3'
				WHEN [ORAL PROFICIENCY LEVEL] = '4' THEN '4'
				WHEN [ORAL PROFICIENCY LEVEL] = '5' THEN '5'
				ELSE 'N/A'
				END
		WHEN test_section_name = 'READING  SCALE SCORE' THEN
			CASE 
				WHEN [READING PROFICIENCY LEVEL] = '1' THEN '1'
				WHEN [READING PROFICIENCY LEVEL] = '2' THEN '2'
				WHEN [READING PROFICIENCY LEVEL] = '3' THEN '3'
				WHEN [READING PROFICIENCY LEVEL] = '4' THEN '4'
				WHEN [READING PROFICIENCY LEVEL] = '5' THEN '5'
				ELSE 'N/A'
				END
		ELSE 'N/A'
	END AS score_group_code
	,'Performance Level' AS score_group_label
	,last_name
	,first_name
	,'' AS DOB
	,'' AS raw_score
	,CASE	
		WHEN test_section_name = 'SPEAKING SCALE SCORE' THEN scale_score
		WHEN test_section_name = 'LISTENING SCALE SCORE' THEN scale_score
		WHEN test_section_name = 'WRITING  SCALE SCORE' THEN scale_score
		WHEN test_section_name = 'COMPREHENSION SCALE SCORE' THEN scale_score
		WHEN test_section_name = 'ORAL SCALE SCORE' THEN scale_score
		WHEN test_section_name = 'READING  SCALE SCORE' THEN scale_score
		ELSE 'N/A'
	END AS scaled_score	
	,'' AS nce_score
	,'' AS percentile_score
	,'' AS score_1
	,'' AS score_2
	,CASE
		WHEN test_section_name = 'SPEAKING SCALE SCORE' THEN 
			CASE 
				WHEN [SPEAKING  PROFICIENCY LEVEL] = '1' THEN '1'
				WHEN [SPEAKING  PROFICIENCY LEVEL] = '2' THEN '2'
				WHEN [SPEAKING  PROFICIENCY LEVEL] = '3' THEN '3'
				WHEN [SPEAKING  PROFICIENCY LEVEL] = '4' THEN '4'
				WHEN [SPEAKING  PROFICIENCY LEVEL] = '5' THEN '5'
				ELSE 'N/A'
				END
		WHEN test_section_name = 'LISTENING SCALE SCORE' THEN 
			CASE 
				WHEN [LISTENING PROFICIENCY LEVEL] = '1' THEN '1'
				WHEN [LISTENING PROFICIENCY LEVEL] = '2' THEN '2'
				WHEN [LISTENING PROFICIENCY LEVEL] = '3' THEN '3'
				WHEN [LISTENING PROFICIENCY LEVEL] = '4' THEN '4'
				WHEN [LISTENING PROFICIENCY LEVEL] = '5' THEN '5'
				ELSE 'N/A'
				END
		WHEN test_section_name = 'WRITING  SCALE SCORE' THEN 
			CASE 
				WHEN [WRITING PROFICIENCY  LEVEL] = '1' THEN '1'
				WHEN [WRITING PROFICIENCY  LEVEL] = '2' THEN '2'
				WHEN [WRITING PROFICIENCY  LEVEL] = '3' THEN '3'
				WHEN [WRITING PROFICIENCY  LEVEL] = '4' THEN '4'
				WHEN [WRITING PROFICIENCY  LEVEL] = '5' THEN '5'
				ELSE 'N/A'
				END
		WHEN test_section_name = 'COMPREHENSION SCALE SCORE' THEN 
			CASE 
				WHEN [COMPREHENSION PROFICIENCY LEVEL] = '1' THEN '1'
				WHEN [COMPREHENSION PROFICIENCY LEVEL] = '2' THEN '2'
				WHEN [COMPREHENSION PROFICIENCY LEVEL] = '3' THEN '3'
				WHEN [COMPREHENSION PROFICIENCY LEVEL] = '4' THEN '4'
				WHEN [COMPREHENSION PROFICIENCY LEVEL] = '5' THEN '5'
				ELSE 'N/A'
				END
		WHEN test_section_name = 'ORAL SCALE SCORE' THEN 
			CASE 
				WHEN [ORAL PROFICIENCY LEVEL] = '1' THEN '1'
				WHEN [ORAL PROFICIENCY LEVEL] = '2' THEN '2'
				WHEN [ORAL PROFICIENCY LEVEL] = '3' THEN '3'
				WHEN [ORAL PROFICIENCY LEVEL] = '4' THEN '4'
				WHEN [ORAL PROFICIENCY LEVEL] = '5' THEN '5'
				ELSE 'N/A'
				END
		WHEN test_section_name = 'READING  SCALE SCORE' THEN
			CASE 
				WHEN [READING PROFICIENCY LEVEL] = '1' THEN '1'
				WHEN [READING PROFICIENCY LEVEL] = '2' THEN '2'
				WHEN [READING PROFICIENCY LEVEL] = '3' THEN '3'
				WHEN [READING PROFICIENCY LEVEL] = '4' THEN '4'
				WHEN [READING PROFICIENCY LEVEL] = '5' THEN '5'
				ELSE 'N/A'
				END
		ELSE 'N/A'
	END AS score_3
	,score_4
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
	,score_3_name
	,score_4_name
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
	[LINKS].[STUDENT #] AS student_code
	,@SchoolYear - 1 AS school_year
	,[LINKS].[LOC NUMBER] AS school_code
	/*To keep within the standard dates
	July through December use October 1
	January through March use January 1
	April through June use April 1*/
	,CASE
		WHEN Substring(CAST([LINKS].[TEST DATE] AS NCHAR),5,2) = '07' THEN CAST(@SchoolYear - 1 AS VARCHAR) + '-10-01' --July = Fall
		WHEN Substring(CAST([LINKS].[TEST DATE] AS NCHAR),5,2) = '08' THEN CAST(@SchoolYear - 1 AS VARCHAR) + '-10-01' --August = Fall
		WHEN Substring(CAST([LINKS].[TEST DATE] AS NCHAR),5,2) = '09' THEN CAST(@SchoolYear - 1 AS VARCHAR) + '-10-01' --September = Fall
		WHEN Substring(CAST([LINKS].[TEST DATE] AS NCHAR),5,2) = '10' THEN CAST(@SchoolYear - 1 AS VARCHAR) + '-10-01' --October = Fall
		WHEN Substring(CAST([LINKS].[TEST DATE] AS NCHAR),5,2) = '11' THEN CAST(@SchoolYear - 1 AS VARCHAR) + '-10-01' --November = Fall 
		WHEN Substring(CAST([LINKS].[TEST DATE] AS NCHAR),5,2) = '12' THEN CAST(@SchoolYear - 1 AS VARCHAR) + '-10-01' --December = Fall
		WHEN Substring(CAST([LINKS].[TEST DATE] AS NCHAR),5,2) = '01' THEN CAST(@SchoolYear AS VARCHAR) + '-01-01' --January = Winter
		WHEN Substring(CAST([LINKS].[TEST DATE] AS NCHAR),5,2) = '02' THEN CAST(@SchoolYear AS VARCHAR) + '-01-01' --February = Winter
		WHEN Substring(CAST([LINKS].[TEST DATE] AS NCHAR),5,2) = '03' THEN CAST(@SchoolYear AS VARCHAR) + '-01-01' --March = Winter
		WHEN Substring(CAST([LINKS].[TEST DATE] AS NCHAR),5,2) = '04' THEN CAST(@SchoolYear AS VARCHAR) + '-04-01' --April = Spring
		WHEN Substring(CAST([LINKS].[TEST DATE] AS NCHAR),5,2) = '05' THEN CAST(@SchoolYear AS VARCHAR) + '-04-01' --May = Spring
		WHEN Substring(CAST([LINKS].[TEST DATE] AS NCHAR),5,2) = '06' THEN CAST(@SchoolYear AS VARCHAR) + '-04-01' --June = Spring
	END AS test_date_code
	,'SPPRO' AS test_type_code
	,'SP-LAS-LINKS' AS test_type_name
	,'SPPRO' AS test_section_code
	--, '' AS test_section_name
	,'0' AS parent_test_section_code
	,'K' AS low_test_level_code
	,'12' AS high_test_level_code
	,CASE
		WHEN GRADE = 'K' THEN 'K'
		ELSE RIGHT ('00' + GRADE,2) 
	END AS test_level_name
	,'' AS version_code
	--When the student is in Kindergarten then their score group is ELL, etc. Otherwise don't use ELL
	,''  score_group_name
	,'' AS score_group_code
	,'Proficiency Level' AS score_group_label
	,[LAST NAME] AS last_name
	,[FIRST NAME] AS first_name
	/*Dates are to be YYYY-MM-DD  birth date */
	--,Substring(CAST(BRTH_DT AS NCHAR),1,4) + '-' +
	--	Substring(CAST(BRTH_DT AS NCHAR),5,2) + '-' +
	--	Substring(CAST(BRTH_DT AS NCHAR),7,2) AS dob
	,'' AS raw_score
	,'' AS scaled_score
	,'' AS nce_score
	,'' AS percentile_score
	,'' AS score_1
	,'' AS score_2
	,'' AS score_3
	/*Dates are to be YYYY-MM-DD  actual date taken */
	,Substring(CAST([TEST DATE] AS NCHAR),1,4) + '-' +
		Substring(CAST([TEST DATE] AS NCHAR),5,2) + '-' +
		Substring(CAST([TEST DATE] AS NCHAR),7,2) AS score_4
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
	,'Proficiency Level' AS score_3_name
	,'Acutal Test Date' AS score_4_name
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
	,[SPEAKING SCALE SCORE]
	,[LISTENING SCALE SCORE]
	,[READING  SCALE SCORE]
	,[WRITING  SCALE SCORE]
	,[COMPREHENSION SCALE SCORE]
	,[ORAL SCALE SCORE]
	,[SPEAKING  PROFICIENCY LEVEL]
	,[LISTENING PROFICIENCY LEVEL]
	,[READING PROFICIENCY LEVEL]
	,[WRITING PROFICIENCY  LEVEL]
	,[COMPREHENSION PROFICIENCY LEVEL]
	,[ORAL PROFICIENCY LEVEL]
	,[OVERALL PROFICIENCY LEVEL]
	,[OVER ALL SCALE SCORE]
	
	
FROM SP_LAS_LINKS AS [LINKS]
WHERE SCH_YR = '2014-2015'
--AND [LINKS].[STUDENT #] = '970061092'
)AS T1
UNPIVOT (scale_score for test_section_name in 
		([SPEAKING SCALE SCORE]
	,[LISTENING SCALE SCORE]
	,[READING  SCALE SCORE]
	,[WRITING  SCALE SCORE]
	,[COMPREHENSION SCALE SCORE]
	,[ORAL SCALE SCORE]
	--,[SPEAKING  PROFICIENCY LEVEL]
	--,[LISTENING PROFICIENCY LEVEL]
	--,[READING PROFICIENCY LEVEL]
	--,[WRITING PROFICIENCY  LEVEL]
	--,[COMPREHENSION PROFICIENCY LEVEL]
	--,[ORAL PROFICIENCY LEVEL]
	--,[OVERALL PROFICIENCY LEVEL] 
	)
	) AS Unpvt
--order by student_code, test_section_name

UNION

--DECLARE @SchoolYear int = 2014;

SELECT
	student_code 
	,school_year
	,school_code
	,test_date_code
	,'SPPRO' AS test_type_code
	,'SP-LAS-LINKS' AS test_type_name
	,CASE
		WHEN test_section_name = 'OVER ALL SCALE SCORE' THEN 'OVERALL'

	END AS test_section_code
	,CASE	
		WHEN test_section_name = 'OVER ALL SCALE SCORE' THEN 'OVERALL'
		END
	AS test_section_name
	,CASE
		WHEN test_section_name = 'OVER ALL SCALE SCORE' THEN '0'
	END AS parent_test_section_code
	,low_test_level_code
	,high_test_level_code
	,test_level_name
	,version_code
	,CASE
		WHEN test_section_name = 'OVER ALL SCALE SCORE' THEN
			CASE 
				WHEN [OVERALL PROFICIENCY LEVEL] = '1' THEN 'BEGINNING'
				WHEN [OVERALL PROFICIENCY LEVEL] = '2' THEN 'EARLY INTERMEDIATE'
				WHEN [OVERALL PROFICIENCY LEVEL] = '3' THEN 'INTERMEDIATE'
				WHEN [OVERALL PROFICIENCY LEVEL] = '4' THEN 'PROFICIENT'
				WHEN [OVERALL PROFICIENCY LEVEL] = '5' THEN 'ABOVE PROFICIENT'
				ELSE 'Not Applicable'
				END
		ELSE 'Not Applicable'
	END AS score_group_name
	,CASE
		WHEN test_section_name = 'OVER ALL SCALE SCORE' THEN
			CASE 
				WHEN [OVERALL PROFICIENCY LEVEL] = '1' THEN '1'
				WHEN [OVERALL PROFICIENCY LEVEL] = '2' THEN '2'
				WHEN [OVERALL PROFICIENCY LEVEL] = '3' THEN '3'
				WHEN [OVERALL PROFICIENCY LEVEL] = '4' THEN '4'
				WHEN [OVERALL PROFICIENCY LEVEL] = '5' THEN '5'
				ELSE 'N/A'
				END
		ELSE 'N/A'
	END AS score_group_code
	,'Performance Level' AS score_group_label
	,last_name
	,first_name
	,'' AS DOB
	,'' AS raw_score
	,CASE	
		WHEN test_section_name = 'OVER ALL SCALE SCORE' THEN scale_score
		ELSE 'N/A'
	END AS scaled_score	
	,'' AS nce_score
	,'' AS percentile_score
	,'' AS score_1
	,'' AS score_2
	,[OVERALL PROFICIENCY LEVEL] AS score_3
	,score_4
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
	,'Proficiency Level' AS score_3_name
	,score_4_name
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
	[LINKS].[STUDENT #] AS student_code
	,@SchoolYear - 1 AS school_year
	,[LINKS].[LOC NUMBER] AS school_code
	/*To keep within the standard dates
	July through December use October 1
	January through March use January 1
	April through June use April 1*/
	,CASE
		WHEN Substring(CAST([LINKS].[TEST DATE] AS NCHAR),5,2) = '07' THEN CAST(@SchoolYear - 1 AS VARCHAR) + '-10-01' --July = Fall
		WHEN Substring(CAST([LINKS].[TEST DATE] AS NCHAR),5,2) = '08' THEN CAST(@SchoolYear - 1 AS VARCHAR) + '-10-01' --August = Fall
		WHEN Substring(CAST([LINKS].[TEST DATE] AS NCHAR),5,2) = '09' THEN CAST(@SchoolYear - 1 AS VARCHAR) + '-10-01' --September = Fall
		WHEN Substring(CAST([LINKS].[TEST DATE] AS NCHAR),5,2) = '10' THEN CAST(@SchoolYear - 1 AS VARCHAR) + '-10-01' --October = Fall
		WHEN Substring(CAST([LINKS].[TEST DATE] AS NCHAR),5,2) = '11' THEN CAST(@SchoolYear - 1 AS VARCHAR) + '-10-01' --November = Fall 
		WHEN Substring(CAST([LINKS].[TEST DATE] AS NCHAR),5,2) = '12' THEN CAST(@SchoolYear - 1 AS VARCHAR) + '-10-01' --December = Fall
		WHEN Substring(CAST([LINKS].[TEST DATE] AS NCHAR),5,2) = '01' THEN CAST(@SchoolYear AS VARCHAR) + '-01-01' --January = Winter
		WHEN Substring(CAST([LINKS].[TEST DATE] AS NCHAR),5,2) = '02' THEN CAST(@SchoolYear AS VARCHAR) + '-01-01' --February = Winter
		WHEN Substring(CAST([LINKS].[TEST DATE] AS NCHAR),5,2) = '03' THEN CAST(@SchoolYear AS VARCHAR) + '-01-01' --March = Winter
		WHEN Substring(CAST([LINKS].[TEST DATE] AS NCHAR),5,2) = '04' THEN CAST(@SchoolYear AS VARCHAR) + '-04-01' --April = Spring
		WHEN Substring(CAST([LINKS].[TEST DATE] AS NCHAR),5,2) = '05' THEN CAST(@SchoolYear AS VARCHAR) + '-04-01' --May = Spring
		WHEN Substring(CAST([LINKS].[TEST DATE] AS NCHAR),5,2) = '06' THEN CAST(@SchoolYear AS VARCHAR) + '-04-01' --June = Spring
	END AS test_date_code
	,'SPPRO' AS test_type_code
	,'SP-LAS-LINKS' AS test_type_name
	,'SPPRO' AS test_section_code
	--, '' AS test_section_name
	,'0' AS parent_test_section_code
	,'K' AS low_test_level_code
	,'12' AS high_test_level_code
	,CASE
		WHEN GRADE = 'K' THEN 'K'
		ELSE RIGHT ('00' + GRADE,2) 
	END AS test_level_name
	,'' AS version_code
	--When the student is in Kindergarten then their score group is ELL, etc. Otherwise don't use ELL
	,''  score_group_name
	,'' AS score_group_code
	,'Proficiency Level' AS score_group_label
	,[LAST NAME] AS last_name
	,[FIRST NAME] AS first_name
	/*Dates are to be YYYY-MM-DD  birth date */
	--,Substring(CAST(BRTH_DT AS NCHAR),1,4) + '-' +
	--	Substring(CAST(BRTH_DT AS NCHAR),5,2) + '-' +
	--	Substring(CAST(BRTH_DT AS NCHAR),7,2) AS dob
	,'' AS raw_score
	,'' AS scaled_score
	,'' AS nce_score
	,'' AS percentile_score
	,'' AS score_1
	,'' AS score_2
	--,scale_score AS score_3
	/*Dates are to be YYYY-MM-DD  actual date taken */
	,Substring(CAST([TEST DATE] AS NCHAR),1,4) + '-' +
		Substring(CAST([TEST DATE] AS NCHAR),5,2) + '-' +
		Substring(CAST([TEST DATE] AS NCHAR),7,2) AS score_4
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
	,'Proficiency Level' AS score_3_name
	,'Acutal Test Date' AS score_4_name
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
	,[SPEAKING SCALE SCORE]
	,[LISTENING SCALE SCORE]
	,[READING  SCALE SCORE]
	,[WRITING  SCALE SCORE]
	,[COMPREHENSION SCALE SCORE]
	,[ORAL SCALE SCORE]
	,[SPEAKING  PROFICIENCY LEVEL]
	,[LISTENING PROFICIENCY LEVEL]
	,[READING PROFICIENCY LEVEL]
	,[WRITING PROFICIENCY  LEVEL]
	,[COMPREHENSION PROFICIENCY LEVEL]
	,[ORAL PROFICIENCY LEVEL]
	,[OVERALL PROFICIENCY LEVEL]
	,[OVER ALL SCALE SCORE]
	
	
FROM SP_LAS_LINKS AS [LINKS]
WHERE SCH_YR = '2014-2015'
--AND [LINKS].[STUDENT #] = '970061092'
)AS T1
UNPIVOT (scale_score for test_section_name in 
		(
	--[SPEAKING SCALE SCORE]
	--,[LISTENING SCALE SCORE]
	--,[READING  SCALE SCORE]
	--,[WRITING  SCALE SCORE]
	--,[COMPREHENSION SCALE SCORE]
	--,[ORAL SCALE SCORE]
	----,[SPEAKING  PROFICIENCY LEVEL]
	----,[LISTENING PROFICIENCY LEVEL]
	----,[READING PROFICIENCY LEVEL]
	----,[WRITING PROFICIENCY  LEVEL]
	----,[COMPREHENSION PROFICIENCY LEVEL]
	----,[ORAL PROFICIENCY LEVEL]
	--[OVERALL PROFICIENCY LEVEL] 
	[OVER ALL SCALE SCORE]
	)
	) AS Unpvt
	--WHERE student_code = '100018522'
order by student_code,test_section_name

