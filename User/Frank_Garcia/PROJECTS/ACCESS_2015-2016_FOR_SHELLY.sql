SELECT
	*
FROM
(
SELECT 
      ROW_NUMBER () OVER (PARTITION BY [StateStudentID] ORDER BY [StateStudentID] DESC) AS RN
	  ,[StateStudentID] AS STATE_ID
      ,[DistrictStudentID] AS APS_ID
      ,[LastName] AS LAST_NAME
      ,[FirstName] AS FIRST_NAME
      ,[Birth Date] AS DATE_OF_BIRTH
      ,[Gender] AS GENDER
	  ,[SchoolName] AS SCHOOL
      ,[SchoolCode] AS LOC_NUM
      ,[Grade] AS GRADE_LEVEL
	  ,RDA.fld_LNCH_FLG AS LUNCH_STATUS
	  ,CASE WHEN RDA.fld_PRIM_DISAB = 'GI' THEN 'Y' ELSE 'N'
	  END AS GIFTED
	  ,RDA.fld_SPED AS SPED
	  --,CAST ([BIRTH DATE] AS DATE)
      ,[EthnicityHispanicLatino] AS HISP_LAT
      ,[RaceAmericanIndianAlaskaNative]
      ,[RaceAsian]
      ,[RaceBlack]
      ,[RacePacificIslander]
      ,[RaceWhite]
      ,[ScaleScoreL] AS LISTENING_SS
      ,[ScaleScoreS] AS SPEAKING_SS
      ,[ScaleScoreR] AS READING_SS
      ,[ScaleScoreW] AS WRITING_SS
      ,[ComprehensionScore] AS COMPREHENSION
      ,[OralScaleScore] AS ORAL_SS
      ,[LiteracyScaleScore] AS LITERACY_SS
      ,[CompositeScaleScore] AS COMPOSITE_SS
      ,[ListeningPerformanceLevel] AS LISTENING_PL
      ,[SpeakingPerformanceLevel] AS SPEAKING_PL
      ,[ReadingPerformanceLevel] AS READING_PL
      ,[WritingPerformanceLevel] AS WRITING_PL
      ,[ComprehensionPerformanceLevel] AS COMPREHENSION_PL
      ,[OralPerformanceLevel] AS ORAL_PL
      ,[LiteracyPerformanceLevel] AS LITERACY_PL
      ,[PerformanceLevelComposite] AS COMPOSITE_PL
      ,[Date of Testing]
      ,[SCH_YR]
  FROM [Assessments].[dbo].[CCR_ACCESS_2015-2016] AS CCR
  LEFT JOIN
  Assessments.DBO.RDA_STUDENTS AS RDA
  ON CCR.DistrictStudentID = RDA.fld_ID_NBR
  ) AS T1
  WHERE RN = 1