SELECT
*
FROM
(

SELECT
	student_code
	,school_year
	,school_code
	,test_date_code
	,test_type_code
	,test_type_name
	,test_section_code
	,version_code
    ,CASE
			WHEN test_section_ = 'REASCALEDSCORE' THEN 'Reading'
			WHEN test_section_ = 'MatScaledScore' THEN 'Math'
			WHEN test_section_ = 'SciScaledScore' THEN 'Science'
			WHEN test_section_ = 'ElaScaledScore' THEN 'Language Arts'
			WHEN test_section_ = 'SocScaledScore' THEN 'Social Studies'
			WHEN test_section_ = 'WriScaledScore' THEN 'Composition'
	END AS test_section_name
	,parent_test_section_code
	,low_test_level_code
	,high_test_level_code
	,test_level_name
	,scaled_score
	--,CASE	
	--	WHEN
	--END AS 'raw_score'
	,CASE 
		WHEN test_section_ = 'REASCALEDSCORE' THEN ReaPerfLevel
		WHEN test_section_= 'ELASCALEDSCORE' THEN ElaPerfLevel
		WHEN test_section_= 'MatScaledScore' THEN MatPerfLevel
		WHEN test_section_= 'SciScaledScore' THEN SciPerfLevel
		WHEN test_section_= 'SocScaledScore' THEN SocPerfLevel
		WHEN test_section_= 'WriScaledScore' THEN WriPerfLevel
	END AS performance_level
    ,[SCH_YR]
    ,[TEST_DATE]

FROM
(
SELECT 
	StudentId AS student_code
	,LEFT (SCH_YR,4) AS school_year
	,schCode AS school_code
	,TEST_DATE AS test_date_code
	,'NMHSCE' AS test_type_code
	,'NMHSCE' AS test_type_name
	,'' AS test_section_code
	,'' AS parent_test_section_code
	,'09' AS low_test_level_code
	,'12' AS high_test_level_code
	,Grade AS test_level_name
	,TestLanguage AS version_code
    ,[SCH_YR]
    ,[TEST_DATE]
	,[REASCALEDSCORE]
	,[ELASCALEDSCORE]
	,[MATSCALEDSCORE]
	,[SCISCALEDSCORE]
	,[SOCSCALEDSCORE]
	,[WRISCALEDSCORE]
	,[ReaPerfLevel]
	,[ElaPerfLevel]
	,[MatPerfLevel]
	,[SciPerfLevel]
	,[SocPerfLevel]
	,[WriPerfLevel]

  FROM [SchoolNet].[dbo].[NMHSCE_RAW] AS NMHSCE
) as tt

  UNPIVOT
	(scaled_score FOR test_section_ in
	([REASCALEDSCORE]
	,[ELASCALEDSCORE]
	,[MATSCALEDSCORE]
	,[SCISCALEDSCORE]
	,[SOCSCALEDSCORE]
	,[WRISCALEDSCORE])
	) AS UNPIV

)  AS TSTS
WHERE performance_level > 1
AND student_code > '1'
AND SCH_YR = '2012-2013'
ORDER BY student_code