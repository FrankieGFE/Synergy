USE [SchoolNet]
GO

SELECT
	SS.student_code
	,PSAT.STATE_ID
	,SS.school_year
	,SS.school_code
	,SS.test_level_name
	,SS.last_name
	,SS.first_name
	,SS.DOB
	,SS.Mathematics_SS
	,PS.Mathematics_PS
	,PL.Mathematics_PL
	,SS.CR_SS
	,PS.CR_PS
	,PL.CR_PL
	,PS.Writing_PS
	,SS.Writing_SS
	,PL.Writing_PL
FROM

	(
	SELECT
		student_code
		,school_year
		,school_code
		,test_level_name
		,LAST_NAME
		,FIRST_NAME
		,DOB
		,[Critical Reading] AS CR_SS
		,Mathematics AS Mathematics_SS
		,Writing AS Writing_ss
	FROM
	(
	SELECT 
		 [student_code]
		  ,[school_year]
		  ,[school_code]
		  ,[test_date_code]
		  ,[test_type_name]
		  ,[test_section_name]
		  ,[test_level_name]
		  ,[last_name]
		  ,[first_name]
		  ,[DOB]
		  ,[scaled_score]
	  FROM [dbo].[test_result_PSAT]
	  WHERE school_code > '1'
	) AS T1
	PIVOT (max ([scaled_score]) FOR test_section_name IN ([Critical Reading], [Mathematics], [Writing])) AS UNPIV
	) SS
	LEFT JOIN
		(
	SELECT
		student_code
		,school_year
		,school_code
		,test_level_name
		,LAST_NAME
		,FIRST_NAME
		,DOB
		,[Critical Reading] AS CR_PS
		,Mathematics AS Mathematics_PS
		,Writing AS Writing_PS
	FROM
	(
	SELECT 
		 [student_code]
		  ,[school_year]
		  ,[school_code]
		  ,[test_date_code]
		  ,[test_type_name]
		  ,[test_section_name]
		  ,[test_level_name]
		  ,[last_name]
		  ,[first_name]
		  ,[DOB]
		  ,[percentile_score]
	  FROM [dbo].[test_result_PSAT]
	  WHERE school_code > '1'
	) AS T1
	PIVOT (max ([PERCENTILE_score]) FOR test_section_name IN ([Critical Reading], [Mathematics], [Writing])) AS UNPIV
	) PS
	ON 
	SS.student_code = PS.student_code

	LEFT JOIN
		(
	SELECT
		student_code
		,school_year
		,school_code
		,test_level_name
		,LAST_NAME
		,FIRST_NAME
		,DOB
		,[Critical Reading] AS CR_PL
		,Mathematics AS Mathematics_PL
		,Writing AS Writing_PL
	FROM
	(
	SELECT 
		 [student_code]
		  ,[school_year]
		  ,[school_code]
		  ,[test_date_code]
		  ,[test_type_name]
		  ,[test_section_name]
		  ,[test_level_name]
		  ,[last_name]
		  ,[first_name]
		  ,[DOB]
		  ,[score_group_name]
	  FROM [dbo].[test_result_PSAT]
	  WHERE school_code > '1'
	) AS T1
	PIVOT (max ([SCORE_GROUP_NAME]) FOR test_section_name IN ([Critical Reading], [Mathematics], [Writing])) AS UNPIV
	) PL
	ON 
	SS.student_code = PL.student_code

	LEFT JOIN
	CCR_PSAT AS PSAT
	ON SS.STUDENT_CODE = PSAT.APS_ID 
	AND PSAT.SCH_YR = '2014-2015'

ORDER BY student_code