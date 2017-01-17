USE [Assessments]
GO

SELECT 
	  [Student ID]
      ,'2016-05-02'[Test Date]
      ,'2015'[SY 2016]
      ,[Location #]
      ,[School Name]
      ,[Grade Level]
      ,[Student Test ID]
      ,CASE WHEN [ADC APS Reading] = '1' THEN 'A24YR'
	        WHEN [ADC APS Reading] = '2' THEN 'APSAP'
			WHEN [ADC APS Reading] = '3' THEN 'MIL'
			WHEN [ADC APS Reading] = '4' THEN 'FINAL'
			WHEN [ADC APS Reading] = '5' THEN 'DUAL'
			WHEN [ADC APS Reading] = '6' THEN 'METPR'
			WHEN [ADC APS Reading] = '7' THEN 'IEP'
			WHEN [ADC APS Reading] = '8' THEN 'OSTAT'
	  END AS [ADC APS Reading]
      ,CASE WHEN [ADC APS Math] = '1' THEN 'A24YR'
	        WHEN [ADC APS Math] = '2' THEN 'APSAP'
			WHEN [ADC APS Math] = '3' THEN 'MIL'
			WHEN [ADC APS Math] = '4' THEN 'FINAL'
			WHEN [ADC APS Math] = '5' THEN 'DUAL'
			WHEN [ADC APS Math] = '6' THEN 'METPR'
			WHEN [ADC APS Math] = '7' THEN 'IEP'
			WHEN [ADC APS Math] = '8' THEN 'OSTAT'
	  END AS [ADC APS Math]
      ,CASE WHEN [ADC APS Writing] = '1' THEN 'A24YR'
	        WHEN [ADC APS Writing] = '2' THEN 'APSAP'
			WHEN [ADC APS Writing] = '3' THEN 'MIL'
			WHEN [ADC APS Writing] = '4' THEN 'FINAL'
			WHEN [ADC APS Writing] = '5' THEN 'DUAL'
			WHEN [ADC APS Writing] = '6' THEN 'METPR'
			WHEN [ADC APS Writing] = '7' THEN 'IEP'
			WHEN [ADC APS Writing] = '8' THEN 'OSTAT'
	  END AS [ADC APS Writing]
      ,CASE WHEN [ADC APS Science] = '1' THEN 'A24YR'
	        WHEN [ADC APS Science] = '2' THEN 'APSAP'
			WHEN [ADC APS Science] = '3' THEN 'MIL'
			WHEN [ADC APS Science] = '4' THEN 'FINAL'
			WHEN [ADC APS Science] = '5' THEN 'DUAL'
			WHEN [ADC APS Science] = '6' THEN 'METPR'
			WHEN [ADC APS Science] = '7' THEN 'IEP'
			WHEN [ADC APS Science] = '8' THEN 'OSTAT'
	  END AS [ADC APS Science]
      ,CASE WHEN [ADC APS Social Studies] = '1' THEN 'A24YR'
	        WHEN [ADC APS Social Studies] = '2' THEN 'APSAP'
			WHEN [ADC APS Social Studies] = '3' THEN 'MIL'
			WHEN [ADC APS Social Studies] = '4' THEN 'FINAL'
			WHEN [ADC APS Social Studies] = '5' THEN 'DUAL'
			WHEN [ADC APS Social Studies] = '6' THEN 'METPR'
			WHEN [ADC APS Social Studies] = '7' THEN 'IEP'
			WHEN [ADC APS Social Studies] = '8' THEN 'OSTAT'
	  END AS [ADC APS Social Studies]
      ,[Test Type]
  FROM [dbo].[ADC_STUDENT_TESTS]
  WHERE [ADC APS Social Studies] > '0' 
  --AND [Student TEST ID] = '100015270'
  ORDER BY [ADC_STUDENT_TESTS].[ADC APS Social Studies]
GO


