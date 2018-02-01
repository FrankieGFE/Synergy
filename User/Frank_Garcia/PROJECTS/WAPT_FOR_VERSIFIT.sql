SELECT
	[XTBL_TEST_ADMIN.DISTRICT_CODE]
	,[XTBL_TEST_ADMIN.PROD_TEST_ID]
	,[XTBL_TEST_ADMIN.TEST_ADMIN_PERIOD]
	,[XTBL_TEST_ADMIN.DISTRICT_SCHOOL_ID]
	,[XTBL_TEST_ADMIN.DISTRICT_STUDENT_ID]	
	,[XTBL_TEST_ADMIN.STUDENT_FIRST_NAME]
	,[XTBL_TEST_ADMIN.STUDENT_LAST_NAME]	
	,[XTBL_TEST_ADMIN.TEST_ADMIN_DATE_STR]	
	,[XTBL_TEST_ADMIN.TEST_STUDENT_GRADE]	
	,[XTBL_TEST_SCORES.TEST_NUMBER]	
	,[XTBL_TEST_SCORES.TEST_SCALE_SCORE]	
	,[XTBL_TEST_SCORES.TEST_RAW_SCORE]	
	,[XTBL_TEST_SCORES.TEST_SCORE_VALUE]	
	,[XTBL_TEST_SCORES.TEST_PRIMARY_RESULT_CODE]	
	,[XTBL_TEST_SCORES.TEST_PRIMARY_RESULT]
	FROM
	(
	SELECT
		'001' AS [XTBL_TEST_ADMIN.DISTRICT_CODE]
		,'WAPT_'+WAPT.IDNum+'_'+WAPT.[Test Date] AS [XTBL_TEST_ADMIN.PROD_TEST_ID]
		,'' AS [XTBL_TEST_ADMIN.TEST_ADMIN_PERIOD]
		,WAPT.School AS [XTBL_TEST_ADMIN.DISTRICT_SCHOOL_ID]
		,WAPT.IDNum AS [XTBL_TEST_ADMIN.DISTRICT_STUDENT_ID]	
		,WAPT.[First] AS [XTBL_TEST_ADMIN.STUDENT_FIRST_NAME]
		,WAPT.[Last] AS [XTBL_TEST_ADMIN.STUDENT_LAST_NAME]
		,WAPT.[Test Date] AS [XTBL_TEST_ADMIN.TEST_ADMIN_DATE_STR]	
		,WAPT.Grade AS [XTBL_TEST_ADMIN.TEST_STUDENT_GRADE]
		,'WAPT' AS [XTBL_TEST_SCORES.TEST_NUMBER]
		,WAPT.Score1 AS [XTBL_TEST_SCORES.TEST_SCALE_SCORE]	
		,WAPT.Score1 AS [XTBL_TEST_SCORES.TEST_RAW_SCORE]
		,WAPT.Score1 AS [XTBL_TEST_SCORES.TEST_SCORE_VALUE]
		,WAPT.Score2 AS [XTBL_TEST_SCORES.TEST_PRIMARY_RESULT_CODE]
		,WAPT.Score2 AS [XTBL_TEST_SCORES.TEST_PRIMARY_RESULT]


	FROM
		WAPT
	) AS WPT