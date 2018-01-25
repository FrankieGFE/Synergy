USE [SchoolNet]
GO
SELECT
	[SIS_NUMBER]
	,StudentLastName
	,StudentFirstName
	,StudentMiddleName
	,GradeLevel
	,SBA_MATH
	,SBA_READING
	,DRA2
FROM
(
SELECT 
	  ROW_NUMBER () OVER (PARTITION BY [SIS_NUMBER] ORDER BY [SIS_NUMBER]) AS RN
	  ,[SIS_NUMBER]
      ,[StudentLastName]
      ,[StudentFirstName]
      ,[StudentMiddleName]
      ,[GradeLevel]
      ,CASE
		WHEN GradeLevel != '03' THEN MATH ELSE ''
	  END AS [SBA_MATH]
      ,CASE	
		WHEN GradeLevel != '03' THEN READING ELSE ''
	  END AS [SBA_READING]
      ,CASE
		WHEN GradeLevel = '03' THEN [fld_Performance_Lvl] 
		ELSE ''
	  END AS [DRA2]
  FROM [180-SMAXODS-01].SCHOOLNET.[dbo].[Copy of SBA and DRA needed] AS REQUEST
  LEFT JOIN
  [046-WS02].db_DRA.dbo.Results_1314 AS DRA
  ON REQUEST.SIS_NUMBER = DRA.FLD_ID_NBR
  AND DRA.FLD_ASSESSMENTWINDOW = 'SPRING'
  AND DRA.FLD_ASSESSMENT_USED = 'DRA'

  LEFT JOIN
--  [180-SMAXODS-01].SCHOOLNET.[dbo].SBA AS SBA
--  ON SBA.student_code = REQUEST.SIS_NUMBER
--  AND SBA.school_year = '2013'
--  AND test_section_name IN ('READING', 'MATH')
--  ) AS T1
(
SELECT
	STUDENT_CODE
	,MATH
	,READING
	,SCHOOL_YEAR
FROM
(
SELECT	
STUDENT_CODE
,SCHOOL_YEAR
,SCORE_GROUP_NAME
,TEST_SECTION_NAME
FROM

	[180-SMAXODS-01].SCHOOLNET.[dbo].SBA AS SBA
  
  WHERE SBA.school_year = '2013'
  AND test_section_name IN ('READING', 'MATH')
  ) AS T1
pivot
(max([SCORE_GROUP_NAME]) FOR test_section_name IN ([MATH],[READING])) AS UP1
) AS SBA2

ON SBA2.student_code = REQUEST.[SIS_NUMBER]

) AS SBA3
WHERE RN = 1
ORDER BY GradeLevel, SIS_NUMBER




