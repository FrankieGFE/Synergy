USE [SchoolNet]
GO
/****** Object:  StoredProcedure [dbo].[TEST_RESULT_ACCESS_sp]    Script Date: 2/18/2015 11:48:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[TEST_RESULT_ACCESS_sp] AS
/****
 
 * $LastChangedBy: Terri Christiansen
 * $LastChangedDate: 5/29/2013 $
 *
 * Request By: SchoolNet
 * InitialRequestDate: 
 * 
 * Initial Request:
 * ACCESS test
 * Tables Referenced:  Experiment with a Standardized test layout.
	In this case, ACCESS
****/
TRUNCATE TABLE dbo.TEST_RESULT
--GO
INSERT INTO dbo.TEST_RESULT
/* This requires a pivot, so experiment with syntax */

--Child Portion of ACCESS
SELECT
	student_code 
	,school_year
	,school_code
	,test_date_code
	,test_type_code
	,test_type_name
	,test_section_code = 
	CASE test_section_name	 
		WHEN 'Listening Proficiency Level' THEN '13802'
		WHEN 'Reading Proficiency Level'  THEN '13801' 
		WHEN 'Speaking Proficiency Level' THEN '13804' 
		WHEN 'Writing Proficiency Level' THEN '13803' 
		WHEN 'Comprehension Proficiency Level'THEN '13806'
		WHEN 'Literacy Proficiency Level' THEN'13807'
		WHEN 'Oral Proficiency Level' THEN '13808'
	ELSE test_section_name
	END 
	,test_section_name =
	CASE test_section_name
		WHEN'Listening Proficiency Level' THEN 'Listening'
		WHEN 'Reading Proficiency Level' THEN 'Reading'
		WHEN 'Speaking Proficiency Level' THEN 'Speaking'
		WHEN 'Writing Proficiency Level' THEN 'Writing' 
		WHEN 'Comprehension Proficiency Level' THEN 'Comprehension = 70% Reading + 30% Listening'
		WHEN 'Oral Proficiency Level' THEN 'Oral Language  = 50% Listening + 50% Speaking'
		WHEN 'Literacy Proficiency Level' THEN 'Literacy = 50% Reading + 50% Writing'
	ELSE test_section_name
	END 
	,parent_test_section_code =
	CASE test_section_name	 
		WHEN 'Listening Proficiency Level' THEN '13800'
		WHEN 'Reading Proficiency Level'  THEN '13800' 
		WHEN 'Speaking Proficiency Level' THEN '13800' 
		WHEN 'Writing Proficiency Level' THEN '13800' 
		WHEN 'Comprehension Proficiency Level'THEN '13800'
		WHEN 'Literacy Proficiency Level' THEN'13800'
		WHEN 'Oral Proficiency Level' THEN '13800'
	ELSE test_section_name
	END 
	,low_test_level_code
	,high_test_level_code
	,test_level_name
	,version_code
	, 
	CASE 
		WHEN proficiency_level >= '1' AND proficiency_level <= '1.9' THEN 'Entering'
		WHEN proficiency_level >= '2' AND proficiency_level <= '2.9' THEN 'Emerging'
		WHEN proficiency_level >= '3' AND proficiency_level <= '3.9' THEN 'Developing'
		WHEN proficiency_level >= '4' AND proficiency_level <= '4.9' THEN 'Expanding'
		WHEN proficiency_level >= '5' AND proficiency_level <= '5.9' THEN 'Bridging'
		WHEN proficiency_level = '6'  THEN 'Reaching'

	ELSE 'Incomplete'
	END score_group_name
	,CASE 
		WHEN proficiency_level >= '1' AND proficiency_level <= '1.9' THEN 'Ent'
		WHEN proficiency_level >= '2' AND proficiency_level <= '2.9' THEN 'Emer'
		WHEN proficiency_level >= '3' AND proficiency_level <= '3.9' THEN 'Dev'
		WHEN proficiency_level >= '4' AND proficiency_level <= '4.9' THEN 'Exp'
		WHEN proficiency_level >= '5' AND proficiency_level <= '5.9' THEN 'Bri'
		WHEN proficiency_level = '6'  THEN 'Rea'
	ELSE 'Inc'
	END score_group_code
	,score_group_label
	,last_name
	,first_name
	,DOB
	,raw_score
	/*If the student didn't complete a test, set the scaled score to zero*/
	,scaled_score =
	CASE test_section_name	 
		WHEN 'Listening Proficiency Level' THEN [Listening Scale Score]
		WHEN 'Reading Proficiency Level'  THEN [Reading Scale Score] 
		WHEN 'Speaking Proficiency Level' THEN [Speaking Scale Score]
		WHEN 'Writing Proficiency Level' THEN [Writing Scale Score]
		WHEN 'Comprehension Proficiency Level'THEN [Comprehension Score]
		WHEN 'Literacy Proficiency Level' THEN [Literacy Scale Score]
		WHEN 'Oral Proficiency Level' THEN [Oral Scale Score]
		WHEN 'Comprehension Proficiency Level' THEN [Comprehension Score]
	ELSE test_section_name
	END 
	,nce_score
	,percentile_score
	,score_1
	,score_2
	,proficiency_Level AS score_3
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
--INTO AS_ACCESS
 FROM
	(SELECT
		[District Student ID]  AS student_code
		,'2013' AS school_year
		,[School Number] AS school_code
		,'2014-01-01' AS test_date_code
		,'1000' AS test_type_code
		,'ACCESS' AS test_type_name
		/* Need the Test Section info for the pivot*/
		,[Listening Proficiency Level]
		,[Speaking Proficiency Level]
		,[Reading Proficiency Level]
		,[Writing Proficiency Level]
		,[Comprehension Proficiency Level]
		,[Oral Proficiency Level]
		,[Literacy Proficiency Level]
		,'0' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,RIGHT('00'+ CONVERT(VARCHAR,[GRADE]),2)  AS test_level_name
		,'' AS version_code
		,'Performance Level' AS score_group_label
		,[Student Last Name] AS last_name
		,[Student First Name] AS first_name
		/*concatenate the year, month and day--*/
		,'' AS DOB
		--Needed for Scale score
		,CAST([Listening Scale Score] AS nvarchar) AS [Listening Scale Score]
		,CAST([Reading Scale Score] AS nvarchar) AS [Reading Scale Score]
		,CAST([Speaking Scale Score] AS nvarchar) AS [Speaking Scale Score]
		,CAST([Writing Scale Score] AS nvarchar) AS [Writing Scale Score]
		,CAST([Comprehension Score] AS nvarchar) AS [Comprehension Score]
		,CAST([Oral Scale Score] AS nvarchar) AS [Oral Scale Score]
		,CAST([Literacy Scale Score] AS nvarchar) AS [Literacy Scale Score]
		--,'' AS DOB
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
		,'Proficiency Level' AS score_3_name
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

	FROM [SchoolNet].[dbo].[CCR_ACCESS] AS ACCESS
	WHERE SCH_YR = '2013-2014'
	--WHERE [APS ID] = 109607 -- test student
) AS T1
/*proficiency_level is the column name we used in the main select) 
test_section_name will return the original column headers  */
UNPIVOT (proficiency_Level FOR test_section_name IN ([Listening Proficiency Level]
		,[Speaking Proficiency Level]
		,[Reading Proficiency Level]
		,[Writing Proficiency Level]
		,[Comprehension Proficiency Level]
		,[Oral Proficiency Level]
		,[Literacy Proficiency Level]
		)) AS Unpvt
--ORDER BY test_section_name

--Parent Section of ACCESS
UNION

SELECT
	[District Student ID] AS student_code 
	,'2013' AS school_year
	,[School Number] AS school_code
	,'2014-01-01' AS test_date_code
	,'1000' AS test_type_code
	,'ACCESS' AS test_type_name
	,'13800' AS test_section_code 
	,'Overall Score = 35% Reading + 35% Writing + 15% Listening + 15% Speaking' AS test_section_name
	,'0' AS parent_test_section_code
	,'K' AS low_test_level_code
	,'12' AS high_test_level_code
	,RIGHT('00'+ CONVERT(VARCHAR,[GRADE]),2)  AS test_level_name
	,'' AS version_code
	, 
	CASE 
		WHEN [Composite (Overall) Proficiency Level] >= '1' AND [Composite (Overall) Proficiency Level] <= '1.9' THEN 'Entering'
		WHEN [Composite (Overall) Proficiency Level] >= '2' AND [Composite (Overall) Proficiency Level] <= '2.9' THEN 'Emerging'
		WHEN [Composite (Overall) Proficiency Level] >= '3' AND [Composite (Overall) Proficiency Level] <= '3.9' THEN 'Developing'
		WHEN [Composite (Overall) Proficiency Level] >= '4' AND [Composite (Overall) Proficiency Level] <= '4.9' THEN 'Expanding'
		WHEN [Composite (Overall) Proficiency Level] >= '5' AND [Composite (Overall) Proficiency Level] <= '5.9' THEN 'Bridging'
		WHEN [Composite (Overall) Proficiency Level] = '6'  THEN 'Reaching'
	ELSE 'Incomplete'
	END score_group_name
	,CASE 
		WHEN [Composite (Overall) Proficiency Level] >= '1' AND [Composite (Overall) Proficiency Level] <= '1.9' THEN 'Ent'
		WHEN [Composite (Overall) Proficiency Level] >= '2' AND [Composite (Overall) Proficiency Level] <= '2.9' THEN 'Emer'
		WHEN [Composite (Overall) Proficiency Level] >= '3' AND [Composite (Overall) Proficiency Level] <= '3.9' THEN 'Dev'
		WHEN [Composite (Overall) Proficiency Level] >= '4' AND [Composite (Overall) Proficiency Level] <= '4.9' THEN 'Exp'
		WHEN [Composite (Overall) Proficiency Level] >= '5' AND [Composite (Overall) Proficiency Level] <= '5.9' THEN 'Bri'
		WHEN [Composite (Overall) Proficiency Level] = '6'  THEN 'Rea'
	ELSE 'Inc'
	END score_group_code
	,'Overall Composite' AS score_group_label
	,[Student Last Name] AS last_name
	,[Student First Name] AS first_name
	, '' AS DOB
	,''  AS raw_score
	/*If the student didn't complete a test, set the scaled score to zero*/
	,[Composite (Overall) Scale Score] AS scaled_score
,'' AS nce_score
		,'' AS percentile_score
		,Tier AS score_1
		,CAST([Composite (Overall) Proficiency Level] AS varchar) AS score_2
		,[Composite (Overall) Proficiency Level] AS score_3
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
		,'Tier' AS score_1_name
		,'Overall Composite Performance Value' AS score_2_name
		,'Proficiency Level' AS score_3_name
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
FROM SchoolNet.dbo.CCR_ACCESS AS ACCESS2
WHERE SCH_YR = '2013-2014'
	--WHERE [APS ID] = 109607 -- test student

