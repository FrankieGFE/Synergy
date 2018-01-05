BEGIN TRAN

SELECT
	ETHNICI
	,[GENDER]
	,test_section_name
	,score
	,COUNT (student_code) AS TOTALS
FROM	
	(
	SELECT
		DISTINCT student_code
		,test_section_name
		,score
		,CASE	
			WHEN ETHNICITY IS NULL THEN STARS.[ETHNIC CODE SHORT] ELSE ETHNICITY END AS ETHNICI
		,CASE 
			WHEN T1.[GENDER CODE] IS NULL THEN STARS.[GENDER CODE] ELSE T1.[GENDER CODE] END AS GENDER
		,STARS.[ALTERNATE STUDENT ID]
	FROM
		(
		SELECT
			EOC.student_code
			,EOC.test_section_name
			,CASE
				WHEN test_section_name = 'READING' AND scaled_score >= '1137' THEN 'PASS'
				WHEN test_section_name = 'MATH' AND scaled_score >= '1137' THEN 'PASS'
				WHEN test_section_name = 'SCIENCE' AND scaled_score >= '1138' THEN 'PASS'
				ELSE 'FAIL'
			END AS score	
			,CASE
				WHEN STARS.[HISPANIC INDICATOR] = 'Y' THEN 'H'
				ELSE STARS.[ETHNIC CODE SHORT]
			END AS ETHNICITY
			,STARS.[GENDER CODE]
			,STARS.[ETHNIC CODE SHORT]
			,STARS.[HISPANIC INDICATOR]
		FROM
			[180-SMAXODS-01].SchoolNet.dbo.[SBA] AS EOC
		LEFT JOIN
			[046-WS02].[db_STARS_History].[dbo].[STUDENT] AS STARS
			ON
			RIGHT ('000000'+EOC.student_code,9) = STARS.[ALTERNATE STUDENT ID]
			AND STARS.SY = '2013'
			AND STARS.PERIOD = '2013-06-01'
		WHERE test_level_name = 'H3'
		AND EOC.test_section_name IN ('READING', 'MATH', 'SCIENCE')
			) AS T1
	LEFT JOIN
		[046-WS02].[db_STARS_History].[dbo].[STUDENT] AS STARS
		ON
		student_code = STARS.[ALTERNATE STUDENT ID]

		WHERE STARS.[ALTERNATE STUDENT ID] IS NOT NULL
	)AS T2
GROUP BY
	[GENDER]
	,ETHNICI
	,test_section_name
	,score
ORDER BY ETHNICI, [GENDER], test_section_name	
		
ROLLBACK