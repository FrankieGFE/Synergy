USE [ST_Production]
GO

SELECT 
	  COUNSELOR
	  ,CASE WHEN SCHOOL_NAME IN ('1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20') THEN LU.VALUE_DESCRIPTION
	        ELSE ADC.SCHOOL_NAME
	  END AS SCHOOL_NAME
	  ,GRADE
	  ,REPLACE(CONVERT(CHAR(10),ADMIN_DATE, 101),'-','') 'ADMIN DATE'
	  ,LU2.VALUE_DESCRIPTION AS TEST_NAME
	  ,TEST_TYPE
	  ,CASE WHEN ADC.PERFORMANCE_LEVEL IN ('1','2','3','4','5','6','7','8') THEN LU3.VALUE_DESCRIPTION
	        ELSE ADC.PERFORMANCE_LEVEL
	  END AS 'ADC METHOD'
	  ,STU.SIS_NUMBER
	  ,PER.LAST_NAME
	  ,PER.FIRST_NAME
	  --,ADC.SCHOOL_YEAR
  FROM [rev].[UD_ADC_TESTS] ADC
  JOIN
  REV.EPC_STU STU
  ON STU.STUDENT_GU = ADC.STUDENT_GU
  JOIN
  REV.REV_PERSON PER
  ON PER.PERSON_GU = ADC.STUDENT_GU

  LEFT JOIN
  rev.SIF_22_Common_GetLookupValues('REVELATION.UD.ADCTESTS', 'SCHOOL_NAME')  LU
  ON LU.VALUE_CODE = ADC.SCHOOL_NAME

  LEFT JOIN
  rev.SIF_22_Common_GetLookupValues('REVELATION.UD.ADCTESTS', 'TEST_NAME')  LU2
  ON LU2.VALUE_CODE = ADC.TEST_NAME

  LEFT JOIN
  rev.SIF_22_Common_GetLookupValues('REVELATION.UD.ADCTESTS', 'ADC_METHOD') LU3
  ON LU3.VALUE_CODE = ADC.PERFORMANCE_LEVEL

  WHERE 
  ADC.ADD_DATE_TIME_STAMP > '2016-12-13 10:50:00'
  order by SCHOOL_NAME, ADC.ADMIN_DATE
GO

--SELECT * FROM rev.SIF_22_Common_GetLookupValues('REVELATION.UD.ADCTESTS', 'ADC_METHOD') 


