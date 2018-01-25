USE Assessments
GO
/****
 
 * $LastChangedBy: Frank Garcia
 * $LastChangedDate: 4/22/2015 $
 *
 * Request By: SchoolNet
 * InitialRequestDate: 
 * 
 * Initial Request:
 * N2Y
 * 
	
****/
TRUNCATE TABLE dbo.test_result_N2Y
--GO


INSERT INTO dbo.test_result_N2Y
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
	--ROW_NUMBER () OVER (PARTITION BY student_code, test_section_name ORDER BY student_code DESC) AS RN
	student_code AS student_code
	,SchoolYear -1 AS school_year
	,school_code AS school_code
	,CASE
		WHEN Substring(CAST(n2y.DateCreated AS NCHAR),6,2) = '07' THEN CAST(SchoolYear - 1 AS VARCHAR) + '-10-01' --July = Fall
		WHEN Substring(CAST(n2y.DateCreated AS NCHAR),6,2) = '08' THEN CAST(SchoolYear - 1 AS VARCHAR) + '-10-01' --August = Fall
		WHEN Substring(CAST(n2y.DateCreated AS NCHAR),6,2) = '09' THEN CAST(SchoolYear - 1 AS VARCHAR) + '-10-01' --September = Fall
		WHEN Substring(CAST(n2y.DateCreated AS NCHAR),6,2) = '10' THEN CAST(SchoolYear - 1 AS VARCHAR) + '-10-01' --October = Fall
		WHEN Substring(CAST(n2y.DateCreated AS NCHAR),6,2) = '11' THEN CAST(SchoolYear - 1 AS VARCHAR) + '-10-01' --November = Fall 
		WHEN Substring(CAST(n2y.DateCreated AS NCHAR),6,2) = '12' THEN CAST(SchoolYear - 1 AS VARCHAR) + '-10-01' --December = Fall
		WHEN Substring(CAST(n2y.DateCreated AS NCHAR),6,2) = '01' THEN CAST(SchoolYear AS VARCHAR) + '-01-01' --January = Winter
		WHEN Substring(CAST(n2y.DateCreated AS NCHAR),6,2) = '02' THEN CAST(SchoolYear AS VARCHAR) + '-01-01' --February = Winter
		WHEN Substring(CAST(n2y.DateCreated AS NCHAR),6,2) = '03' THEN CAST(SchoolYear AS VARCHAR) + '-01-01' --March = Winter
		WHEN Substring(CAST(n2y.DateCreated AS NCHAR),6,2) = '04' THEN CAST(SchoolYear AS VARCHAR) + '-04-01' --April = Spring
		WHEN Substring(CAST(n2y.DateCreated AS NCHAR),6,2) = '05' THEN CAST(SchoolYear AS VARCHAR) + '-04-01' --May = Spring
		WHEN Substring(CAST(n2y.DateCreated AS NCHAR),6,2) = '06' THEN CAST(SchoolYear AS VARCHAR) + '-04-01' --June = Spring
	END test_date_code
	,'Unique' AS test_type_code
	,'N2Y' AS test_type_name
	,N2Y.TestID  AS test_section_code
	--,PROFICIENCY_LEVEL AS PL
	,N2Y.TestName  AS test_section_name
	,'0' AS parent_test_section_code
	,'K' AS low_test_level_code
	,'12' AS high_test_level_code
	,CASE WHEN STUD.grade_code = 'K' THEN 'K' 
		ELSE RIGHT('00'+ grade_code,2)
	END AS test_level_name
	,'' AS version_code
	,CASE
		WHEN TotalScore BETWEEN 15 AND 18 THEN 'Mastery'  
		WHEN TotalScore BETWEEN 10 AND 14 THEN 'Instructional'
		WHEN TotalScore BETWEEN  6 AND  9 THEN 'Emerging'
		WHEN TotalScore BETWEEN  0 AND  5 THEN 'Review/Revise'
		WHEN TotalScore BETWEEN 95 AND 100 THEN 'Independent'
		WHEN TotalScore BETWEEN 90 AND 94 THEN 'Instructional'
		WHEN TotalScore BETWEEN 19 AND 93 THEN 'Frustration'
		ELSE 'N/A'
	END AS score_group_name
	,CASE
		WHEN TotalScore BETWEEN 15 AND 18 THEN 'Mastery'  
		WHEN TotalScore BETWEEN 10 AND 14 THEN 'Instructional'
		WHEN TotalScore BETWEEN  6 AND  9 THEN 'Emerging'
		WHEN TotalScore BETWEEN  0 AND  5 THEN 'Review/Revise'
		WHEN TotalScore BETWEEN 95 AND 100 THEN 'Independent'
		WHEN TotalScore BETWEEN 90 AND 94 THEN 'Instructional'
		WHEN TotalScore BETWEEN 19 AND 93 THEN 'Frustration'
		ELSE 'N/A'	END AS score_group_code
	,'Performance Level' AS score_group_label
	,REPLACE (lname,'"', '') AS last_name
	,REPLACE (fname, '"','') AS first_name
	/*Dates are to be YYYY-MM-DD  date of birth*/
	,STUD.DOB AS dob
	,'' AS raw_score
	,TotalScore AS scaled_score
	,'' AS nce_score
	,'' AS percentile_score
	,N2Y.possiblescore AS score_1
	,n2y.DateCreated AS score_2
	,n2y.percentage_Total_Score AS score_3
	,n2y.difflevel AS score_4
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
	,'Total Score' AS score_scaled_name
	,'' AS score_nce_name
	,'' AS score_percentile_name
	,'Possible Score' AS score_1_name
	,'Date Created' AS score_2_name
	,'Percentage' AS score_3_name
	,'Diff Level' AS score_4_name
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
FROM dbo.[N2Y_benchmarks] AS N2Y
LEFT JOIN
	ALLSTUDENTS AS STUD
	ON N2Y.IntStudentID = STUD.student_code
--WHERE IntStudentID = '970069111'

) T2
WHERE student_code IS NOT NULL
ORDER BY school_year, student_code
	