USE ST_Production
GO
--BEGIN TRAN
      INSERT INTO REV.UD_ADC_TESTS
	  SELECT
	  CONVERT(UNIQUEIDENTIFIER,[UDADC_TESTS_GU]) AS [UDADC_TESTS_GU]
      ,[PERFORMANCE_LEVEL]
      ,[ADD_DATE_TIME_STAMP]
      ,[ADD_ID_STAMP]
      ,[ADMIN_DATE]
      ,[CHANGE_DATE_TIME_STAMP]
      ,CONVERT(UNIQUEIDENTIFIER,[CHANGE_ID_STAMP]) AS [CHANGE_ID_STAMP]
      ,[GRADE]
      ,[SCHOOL_NAME]
      ,[SCHOOL_YEAR]
      ,CONVERT (UNIQUEIDENTIFIER,[STUDENT_GU]) AS [STUDENT_GU]
      ,[TEST_NAME]
      ,[TEST_TYPE]
      ,[COUNSELOR]
FROM
--select * from
(

SELECT 
	   ROW_NUMBER () OVER (PARTITION BY SIS_NUMBER ORDER BY SIS_NUMBER DESC) AS RN
	  ,NEWID() AS UDADC_TESTS_GU
      ,CASE WHEN [ADC APS Reading] = '1' THEN 'A24YR'
	        WHEN [ADC APS Reading] = '2' THEN 'APSAP'
			WHEN [ADC APS Reading] = '3' THEN 'MIL'
			WHEN [ADC APS Reading] = '4' THEN 'FINAL'
			WHEN [ADC APS Reading] = '5' THEN 'DUAL'
			WHEN [ADC APS Reading] = '6' THEN 'METPR'
			WHEN [ADC APS Reading] = '7' THEN 'IEP'
			WHEN [ADC APS Reading] = '8' THEN 'OSTAT'
	  END AS PERFORMANCE_LEVEL
   --   ,CASE WHEN [ADC APS Math] = '1' THEN 'A24YR'
	  --      WHEN [ADC APS Math] = '2' THEN 'APSAP'
			--WHEN [ADC APS Math] = '3' THEN 'MIL'
			--WHEN [ADC APS Math] = '4' THEN 'FINAL'
			--WHEN [ADC APS Math] = '5' THEN 'DUAL'
			--WHEN [ADC APS Math] = '6' THEN 'METPR'
			--WHEN [ADC APS Math] = '7' THEN 'IEP'
			--WHEN [ADC APS Math] = '8' THEN 'OSTAT'
	  --END AS PERFORMANCE_LEVEL
   --   ,CASE WHEN [ADC APS Writing] = '1' THEN 'A24YR'
	  --      WHEN [ADC APS Writing] = '2' THEN 'APSAP'
			--WHEN [ADC APS Writing] = '3' THEN 'MIL'
			--WHEN [ADC APS Writing] = '4' THEN 'FINAL'
			--WHEN [ADC APS Writing] = '5' THEN 'DUAL'
			--WHEN [ADC APS Writing] = '6' THEN 'METPR'
			--WHEN [ADC APS Writing] = '7' THEN 'IEP'
			--WHEN [ADC APS Writing] = '8' THEN 'OSTAT'
	  --END AS PERFORMANCE_LEVEL
   --   ,CASE WHEN [ADC APS Science] = '1' THEN 'A24YR'
	  --      WHEN [ADC APS Science] = '2' THEN 'APSAP'
			--WHEN [ADC APS Science] = '3' THEN 'MIL'
			--WHEN [ADC APS Science] = '4' THEN 'FINAL'
			--WHEN [ADC APS Science] = '5' THEN 'DUAL'
			--WHEN [ADC APS Science] = '6' THEN 'METPR'
			--WHEN [ADC APS Science] = '7' THEN 'IEP'
			--WHEN [ADC APS Science] = '8' THEN 'OSTAT'
	  --END AS PERFORMANCE_LEVEL
   --   ,CASE WHEN [ADC APS Social Studies] = '1' THEN 'A24YR'
	  --      WHEN [ADC APS Social Studies] = '2' THEN 'APSAP'
			--WHEN [ADC APS Social Studies] = '3' THEN 'MIL'
			--WHEN [ADC APS Social Studies] = '4' THEN 'FINAL'
			--WHEN [ADC APS Social Studies] = '5' THEN 'DUAL'
			--WHEN [ADC APS Social Studies] = '6' THEN 'METPR'
			--WHEN [ADC APS Social Studies] = '7' THEN 'IEP'
			--WHEN [ADC APS Social Studies] = '8' THEN 'OSTAT'
	  --END AS PERFORMANCE_LEVEL
	  ,GETDATE() AS ADD_DATE_TIME_STAMP
	  ,NEWID() AS ADD_ID_STAMP
      ,'2016-05-02 00:00:00' AS ADMIN_DATE
	  ,NULL AS CHANGE_DATE_TIME_STAMP
	  ,NULL AS CHANGE_ID_STAMP
      ,'12' AS GRADE
      ,[School Name] AS SCHOOL_NAME
	  ,'2016' AS SCHOOL_YEAR
	  ,STUD.STUDENT_GU AS STUDENT_GU
	  ,'ADC APS Reading' AS TEST_NAME
      ,'ADC' AS TEST_TYPE
	  ,'SIS' AS COUNSELOR
	  --,[Student Test ID]
   --   ,[SY 2016]
   --   ,[Location #]
   --   ,[Student ID]
   --   ,[ADC APS Reading]
   --   ,[ADC APS Math]
   --   ,[ADC APS Writing]
   --   ,[ADC APS Science]
   --   ,[ADC APS Social Studies]
  FROM [RDAVM.APS.EDU.ACTD].ASSESSMENTS.[dbo].[ADC_STUDENT_TESTS] ADC
  --LEFT JOIN
  --[SYNERGYDBDC].ST_PRODUCTION.REV.EPC_STU AS STUD
  --ON ADC.[Student ID] = STUD.SIS_NUMBER
  LEFT JOIN
  REV.EPC_STU AS STUD
  ON ADC.[Student ID] = STUD.SIS_NUMBER

  WHERE 1 = 1
        AND ADC.[ADC APS Reading] != ''
) READING
WHERE STUDENT_GU IS NOT NULL
AND RN = 1
--and STUDENT_GU IS NOT NULL
--order by STUDENT_GU
--ROLLBACK


