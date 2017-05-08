

SELECT
	[STUDENT ID]
	,[TEST DATE]
	,SY
	,SCH.SCHOOL_CODE
	,SCHOOL_NAME
	,GRADE
	,TEST_TYPE
      ,CASE WHEN [Read] = '1' THEN 'A24YR'
	        WHEN [Read] = '2' THEN 'APSAP'
			WHEN [Read] = '3' THEN 'MIL'
			WHEN [Read] = '4' THEN 'FINAL'
			WHEN [Read] = '5' THEN 'DUAL'
			WHEN [Read] = '6' THEN 'METPR'
			WHEN [Read] = '7' THEN 'IEP'
			WHEN [Read] = '8' THEN 'OSTAT'
	  END AS [ADC APS Reading]
      ,CASE WHEN Math = '1' THEN 'A24YR'
	        WHEN Math = '2' THEN 'APSAP'
			WHEN Math = '3' THEN 'MIL'
			WHEN Math = '4' THEN 'FINAL'
			WHEN Math = '5' THEN 'DUAL'
			WHEN Math = '6' THEN 'METPR'
			WHEN Math = '7' THEN 'IEP'
			WHEN Math = '8' THEN 'OSTAT'
	  END AS [ADC APS Math]
      ,CASE WHEN Write = '1' THEN 'A24YR'
	        WHEN Write = '2' THEN 'APSAP'
			WHEN Write = '3' THEN 'MIL'
			WHEN Write = '4' THEN 'FINAL'
			WHEN Write = '5' THEN 'DUAL'
			WHEN Write = '6' THEN 'METPR'
			WHEN Write = '7' THEN 'IEP'
			WHEN Write = '8' THEN 'OSTAT'
	  END AS [ADC APS WRITING]
      ,CASE WHEN Sci = '1' THEN 'A24YR'
	        WHEN Sci = '2' THEN 'APSAP'
			WHEN Sci = '3' THEN 'MIL'
			WHEN Sci = '4' THEN 'FINAL'
			WHEN Sci = '5' THEN 'DUAL'
			WHEN Sci = '6' THEN 'METPR'
			WHEN Sci = '7' THEN 'IEP'
			WHEN Sci = '8' THEN 'OSTAT'
	  END AS [ADC APS SCIENCE]
      ,CASE WHEN Soc = '1' THEN 'A24YR'
	        WHEN Soc = '2' THEN 'APSAP'
			WHEN Soc = '3' THEN 'MIL'
			WHEN Soc = '4' THEN 'FINAL'
			WHEN Soc = '5' THEN 'DUAL'
			WHEN Soc = '6' THEN 'METPR'
			WHEN Soc = '7' THEN 'IEP'
			WHEN Soc = '8' THEN 'OSTAT'
	  END AS [ADC APS SOCIAL STUDIES]
	  ,TEST_TYPE
	  ,ADMIN_DATE
FROM
(
SELECT 
	  STU.SIS_NUMBER AS 'STUDENT ID'
	  ,REPLACE(CONVERT(CHAR(10),ADMIN_DATE, 101),'-','') AS 'TEST DATE'
	  ,'2016' AS SY
	  ,'' AS LOCATION
	  ,CASE WHEN SCHOOL_NAME IN ('1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20') THEN LU.VALUE_DESCRIPTION
	        ELSE ADC.SCHOOL_NAME
	  END AS SCHOOL_NAME
	  ,GRADE
	  ,'' AS 'STUDENT TEST ID'
      ,[TEST_NAME]
      ,[PERFORMANCE_LEVEL]
      ,[TEST_TYPE]
	  ,ADMIN_DATE
  FROM [ST_Production].[rev].[UD_ADC_TESTS] ADC

  JOIN
  REV.EPC_STU STU
  ON STU.STUDENT_GU = ADC.STUDENT_GU

  LEFT JOIN
  rev.SIF_22_Common_GetLookupValues('REVELATION.UD.ADCTESTS', 'SCHOOL_NAME')  LU
  ON LU.VALUE_CODE = ADC.SCHOOL_NAME

  WHERE 
  ADC.ADD_DATE_TIME_STAMP > '2016-12-13 10:50:00'
) AS XY
PIVOT
	(max([PERFORMANCE_LEVEL]) FOR TEST_NAME IN ([Read],[Sci],[Write],[Math],[Soc])) AS UP1

JOIN
REV.REV_ORGANIZATION ORG
ON ORG.ORGANIZATION_NAME = SCHOOL_NAME

JOIN
REV.EPC_SCH SCH
ON SCH.ORGANIZATION_GU = ORG.ORGANIZATION_GU
WHERE 1 = 1
AND MATH > 0
ORDER BY [STUDENT ID]
