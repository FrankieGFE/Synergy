/****
 
 * $LastChangedBy: Terri Christiansen
 * $LastChangedDate: 9/23/2013 $
 *
 * Request By: SchoolNet
 * InitialRequestDate: 
 * 
 * Initial Request:
 * SBA-ALT test
 * Tables Referenced:  Experiment with a Standardized test layout.
	In this case, SBA-ALT 2009-2010
****/
TRUNCATE TABLE dbo.test_result_ALT_SBA
GO
INSERT INTO dbo.test_result_ALT_SBA
--/* This requires a pivot, so experiment with syntax */

SELECT
	SUBSTRING(student_code, PATINDEX('%[^0]%', student_code), LEN(student_code)) AS student_code
	,school_year
	,school_code
	,test_date_code
	,test_type_code
	,test_type_name
	,test_section_code = 
	CASE test_section_name
		WHEN 'MathProficiencyLevel' THEN '12500'
		WHEN 'ReadingProficiencyLevel' THEN '12501'
		WHEN 'ScienceProficiencyLevel' THEN '12502'
		WHEN 'WritingProficiencyLevel' THEN '12503'
	END
	,test_section_name = 
	CASE test_section_name
		WHEN 'MathProficiencyLevel' THEN 'MATH'
		WHEN 'ReadingProficiencyLevel' THEN 'READING'
		WHEN 'ScienceProficiencyLevel' THEN 'SCIENCE'
		WHEN 'WritingProficiencyLevel' THEN 'WRITING'
	END
	,parent_test_section_code
	,low_test_level_code
	,high_test_level_code
	,test_level_name
	,version_code
	/*For Reading, Math and Science 1 = Begin, 2 = Near, 3 = Prof, 4 = Adv
		For Writing 1 = Near, 2 = Prof
		Five = No Score */
	,score_group_name =
	CASE test_section_name
		WHEN  'WritingProficiencyLevel' THEN 
			CASE proficiency_Level
				WHEN '1' THEN 'Nearing Proficient'
				WHEN '2' THEN 'Proficient'
				ELSE 'No Score'
			END		
		ELSE 
			CASE proficiency_Level
				WHEN '1' THEN 'Beginning Step'
				WHEN '2' THEN 'Nearing Proficient'
				WHEN '3' THEN 'Proficient'
				WHEN '4' THEN 'Advanced'
				ELSE 'No Score'
			END
	END
	,score_group_code = 
	CASE test_section_name
		WHEN  'WritingProficiencyLevel' THEN 
			CASE proficiency_Level
				WHEN '1' THEN 'NPW'
				WHEN '2' THEN 'PW'
				ELSE 'No Score'
			END		
		ELSE 
			CASE proficiency_Level
				WHEN '1' THEN 'BS'
				WHEN '2' THEN 'NP'
				WHEN '3' THEN 'PRO'
				WHEN '4' THEN 'ADV'
				ELSE 'N/A'
			END
	END
	,score_group_label
	,last_name
	,first_name
	, DOB
	,raw_score
	/*If the student didn't complete a test, set the scaled score to zero*/
	,scaled_score = 
	CASE test_section_name
		WHEN 'MATHProficiencyLevel' THEN 
			CASE 
				WHEN MathScaleScore < 900 
				THEN MathScaleScore ELSE 0  
			END 
		WHEN 'READingProficiencyLevel' THEN 
		CASE 
			WHEN ReadingScaleScore < 900 
			THEN ReadingScaleScore ELSE 0  
		 END 	
		WHEN 'ScienceProficiencyLevel' THEN 
			CASE 
				WHEN ScienceScaleScore < 900 
				THEN ScienceScaleScore ELSE 0  
			 END 
		WHEN 'WritingProficiencyLevel' THEN 
			CASE 
				WHEN WritingScaleScore < 900 
				THEN WritingScaleScore ELSE 0  
			 END 
	END
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
--INTO SBA_alt
 FROM
	(SELECT
		LTRIM(RTRIM(NASISID)) AS student_code
		,'2013' AS school_year
		,Right(SchoolCode,3) AS school_code
		,'2014-04-01' AS test_date_code
		,'125' AS test_type_code
		,'SBA-Alt' AS test_type_name
		/* Need the Proficiency Level for the pivot*/
		,MathProficiencyLevel
		,ReadingProficiencyLevel
		,ScienceProficiencyLevel
		,WritingProficiencyLevel
		,'0' AS parent_test_section_code
		,'03' AS low_test_level_code
	,'12' AS high_test_level_code
	/*Pad the grade with a zero for grades less than 10th */
	--,RIGHT('0'+ CONVERT(VARCHAR,Grade),2)AS test_level_name
	--,CONVERT (VARCHAR, STUD.[CURRENT GRADE LEVEL],2) AS other_test_level_name
	,CASE 
		WHEN GRADE < '1' THEN CONVERT (VARCHAR, STUD.[CURRENT GRADE LEVEL],2) 
		ELSE RIGHT('0'+ CONVERT(VARCHAR,Grade),2)
	END AS test_level_name
	,TestLanguage AS version_code
	,'Performance Level' AS score_group_label
	,lastname AS last_name
	,firstname AS first_name
	/*concatenate the year, month and day--padding month and day less than 10
		column header got changed  comment out
	,CAST(Byear AS varchar) + '-' +
		RIGHT('0'+ CONVERT(VARCHAR,BMonth),2) + '-' +
		RIGHT('0'+ CONVERT(VARCHAR,BDay),2) AS DOB*/
	,'' AS DOB
	,'' AS raw_score
	/* Need the Scale score for each subject*/
	 ,MathScaleScore
	 ,ReadingScaleScore
	 ,ScienceScaleScore
	 ,WritingScaleScore
	,'' AS nce_score
	,'' AS percentile_score
	,TestLanguage AS score_1
	,'' AS score_2
	,SchoolFAY AS score_3
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
	,'Language Version' AS score_1_name
	,'' AS score_2_name
	,'Full Academic Year (FAY)' AS score_3_name
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

	FROM [180-SMAXODS-01].[SchoolNet].[dbo].[ALT_SBA] AS SBA_Alt
	LEFT JOIN
	[046-WS02].DB_STARS_HISTORY.DBO.STUDENT AS STUD
	ON SBA_ALT.StudentID = STUD.[ALTERNATE STUDENT ID]
	AND STUD.SY = '2014'
	AND STUD.PERIOD = '2014-03-01'
) AS T1

/*proficiency_level is the column name we used in the main select) 
test_section_name will return the original column headers  */
UNPIVOT (proficiency_Level FOR test_section_name IN (MathProficiencyLevel,ReadingProficiencyLevel,ScienceProficiencyLevel,WritingProficiencyLevel)) AS Unpvt
--WHERE test_level_name > 1
ORDER BY test_level_name
