USE
db_DRA

SELECT
	  [SY]
      ,[SCHOOL]
      ,[ID_NBR]
      ,[LAST NAME LONG]
      ,[FIRST NAME LONG]
      ,[HISPANIC INDICATOR]
      ,[ETHNIC CODE SHORT]
      ,[GENDER CODE]
      ,[GRADE]
      ,[PHLOTE]
      ,[ENGLISH PROFICIENCY]
      ,[SBA_READ_PL]
      ,[SBA_READ_SS]
      ,[SBA_MATH_PL]
      ,[SBA_MATH_SS]
	  ,MAX (CASE WHEN FLD_ASSESSMENTWINDOW = 'FALL' THEN [fld_Performance_Lvl] ELSE ''
	  END) AS FALL_DRA
	  ,MAX (CASE WHEN FLD_ASSESSMENTWINDOW = 'WINTER' THEN [fld_Performance_Lvl] ELSE ''
	  END) AS WINTER_DRA
	  ,MAX (CASE WHEN FLD_ASSESSMENTWINDOW = 'SPRING' THEN [fld_Performance_Lvl] ELSE ''
	  END) AS SPRING_DRA
FROM
	[2_DataOfStudentsWhoReceivedALSServices] AS ALS
LEFT JOIN
	(
	SELECT
	*
	FROM
		(
		SELECT
			ROW_NUMBER () OVER (PARTITION BY FLD_ID_NBR ORDER BY [fld_Assessment_Used] DESC) AS RN
			,FLD_ID_NBR
			,[fld_AssessmentWindow]
			,[fld_Assessment_Used]
			,[fld_Performance_Lvl]
		FROM
			dbo.Results_1314 AS RESULTS
		WHERE
			FLD_ASSESSMENT_USED IN ('DRA','ELD')
		) AS DRA
		WHERE RN = 1
	) AS T2
	ON
	ALS.ID_NBR = T2.FLD_ID_NBR

	GROUP BY
	  [SY]
      ,[SCHOOL]
      ,[ID_NBR]
      ,[LAST NAME LONG]
      ,[FIRST NAME LONG]
      ,[HISPANIC INDICATOR]
      ,[ETHNIC CODE SHORT]
      ,[GENDER CODE]
      ,[GRADE]
      ,[PHLOTE]
      ,[ENGLISH PROFICIENCY]
      ,[SBA_READ_PL]
      ,[SBA_READ_SS]
      ,[SBA_MATH_PL]
      ,[SBA_MATH_SS]
