USE [Assessments]
GO
SELECT
	*
FROM
(
SELECT 
	  ROW_NUMBER () OVER (PARTITION BY [State Student ID] ORDER BY [State Student ID] DESC) AS RN
      ,[State Student ID] AS STATE_ID
	  ,[District Student ID] AS APS_ID
      ,[Student Last Name] AS LAST_NAME
      ,[Student First Name] AS FIRST_NAME
      ,[Birth Date] AS DATE_OF_BIRTH
      ,[Gender] AS GENDER
      ,[School Name] AS SCHOOL
      ,[School Number] AS LOC_NUM
      ,[Grade] AS GRADE_level
	  ,RDA.fld_LNCH_FLG AS LUNCH_STATUS
	  ,CASE WHEN RDA.fld_PRIM_DISAB = 'GI' THEN 'Y' ELSE 'N'
	  END AS GIFTED
	  ,RDA.fld_SPED AS SPED
      ,[Ethnicity] AS HISP_LAT
      ,[Race - American Indian Alaskan Native] AS RaceAmericanIndianAlaskaNative
      ,[Race - Asian ] RaceAsian
      ,[Race - Black African American ] RaceBlack
      ,[Race - Pacific Islander Hawaiian ] RacePacificIslander
      ,[Race - White ] RaceWhite
      ,[Listening Scale Score] AS LISTENING_SS
      ,[Speaking Scale Score] AS SPEAKING_SS
      ,[Reading Scale Score] AS READING_SS
      ,[Writing Scale Score] AS WRITING_SS
      ,[Comprehension Score] AS COMPREHENSION
      ,[Oral Scale Score] AS ORAL_SS
      ,[Literacy Scale Score] AS LITERACY_SS
      ,[Composite (Overall) Scale Score] AS COMPOSTITE_SS
      ,[Listening Proficiency Level] AS LISTENING_PL
      ,[Speaking Proficiency Level] AS SPEAKING_PL
      ,[Reading Proficiency Level] AS READING_PL
      ,[Writing Proficiency Level] AS WRITING_PL
      ,[Comprehension Proficiency Level] AS COMPREHENSION_PL
      ,[Oral Proficiency Level] AS ORAL_PL
      ,[Literacy Proficiency Level] AS LITERACY_PL
      ,[Composite (Overall) Proficiency Level] AS COMPOSITE_PL
      ,[Date of Testing]
      ,[SCH_YR]
  FROM [dbo].[CCR_ACCESS] AS CCR
  LEFT JOIN
  Assessments.DBO.RDA_STUDENTS AS RDA
  ON CCR.[District Student ID] = RDA.fld_ID_NBR
  --AND CCR.[School Number] = RDA.fld_SCH_NBR

  WHERE CCR.SCH_YR = '2014-2015'
) AS T1
WHERE RN = 1
AND APS_ID > 1
--ORDER BY LUNCH_STATUS

GO


