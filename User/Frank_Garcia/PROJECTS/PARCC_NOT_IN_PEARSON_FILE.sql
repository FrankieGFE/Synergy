USE [Assessments]
GO
SELECT 
	  'NM' AS [State Abbreviation]
      ,'1' AS [Testing District Code]
      ,[Testing School Code]
      ,'1' AS [Responsible District Code]
      ,[Responsible School Code]
      ,[State Student Identifier]
      ,[Local Student Identifier]
      ,[PARCC Student ID]
      ,[Last or Surname]
      ,[First Name]
      ,[Middle Name]
      ,CONVERT (VARCHAR, BIRTH_DATE,110) AS [Birthdate]
      ,GENDER AS [Sex]
      ,[State Field 1]
      ,STUD.[grade_code]  AS 'GRADE LEVEL WHEN ASSESSED'
      ,CASE WHEN HISPANIC_INDICATOR = 'Y' THEN 'Y' ELSE 'N' END AS [Hispanic or Latino Ethnicity]
      ,CASE WHEN RACE_1 = 'Native American' THEN 'Y' ELSE 'N' END AS [American Indian or Alaska Native]
      ,CASE WHEN RACE_1 = 'Asian' THEN 'Y' ELSE 'N' END AS [Asian]
      ,CASE WHEN RACE_1 = 'African-American' THEN 'Y' ELSE 'N' END AS [Black or African American]
      ,CASE WHEN RACE_1 = 'Pacific Islander' THEN 'Y' ELSE 'N' END AS [Native Hawaiian or Other Pacific Islander]
      ,CASE WHEN RACE_1 = 'White' THEN 'Y' ELSE 'N' END AS [White]
      ,'' AS [filler field_ ] 
      ,CASE WHEN RESOLVED_RACE = 'Two or More' THEN 'Y' ELSE 'N' END AS [Two or More Races]
      ,CASE WHEN ELL_STATUS = 'Y' THEN 'Y' ELSE 'N' END AS [English Learner  (EL)]
      ,CASE WHEN ELL_STATUS = 'Y' THEN 'Y' ELSE 'N' END AS [Title III Limited English Proficient Participation Status]
      ,CASE WHEN GIFTED_STATUS = 'Y' THEN 'Y' ELSE 'N' END AS [Gifted and Talented]
      ,'N' AS [Migrant Status]
      ,CASE WHEN LUNCH_STATUS IN ('R','2','F') THEN 'Y' ELSE 'N' END AS [Economic Disadvantage Status]
      ,CASE WHEN PRIMARY_DISABILITY_CODE = 'NULL' OR PRIMARY_DISABILITY_CODE IS NULL THEN 'N' ELSE 'IEP' END AS [Student With Disabilities ]
      ,CASE WHEN PRIMARY_DISABILITY_CODE = 'NULL' OR PRIMARY_DISABILITY_CODE IS NULL THEN '' ELSE PRIMARY_DISABILITY_CODE END AS [Primary Disability Type]
      ,[State Field 2]
      ,[State Field 3]
      ,[State Field 4]
      ,[State Field 5]
      ,[State Field 6]
      ,[State Field 7]
      ,[State Field 8]
      ,[State Field 9]
      ,[State Field 10]
      ,[State Field 11]
      ,[State Field 12]
      ,[Session Name]
      ,[Class Name]
      ,[Test Administrator ]
      ,[Staff Member Identifier]
      ,[Test Code]
      ,[Test Format ]
      ,[Retest]
      ,[EL Accommodation ]
      ,[Frequent Breaks]
      ,[Separate Alternate Location]
      ,[Small Testing Group]
      ,[Specialized Equipment or Furniture]
      ,[Specified Area or Setting]
      ,[Time of Day]
      ,[Answer Masking]
      ,[Filler Field]
      ,[Color Contrast]
      ,[ASL Video]
      ,[Assistive Technology - Screen Reader]
      ,[Assistive Technology - Non-Screen Reader ]
      ,[Closed Captioning for ELA L]
      ,[Refreshable Braille Display for ELA L]
      ,[Alternate Representation - Paper Test]
      ,[Large Print]
      ,[Braille with Tactile Graphics]
      ,[Student Reads Assessment Aloud to Themselves]
      ,[Human Signer for Test Directions]
      ,[Answers Recorded in Test Book]
      ,[Braille Response]
      ,[Calculation Device and Mathematics Tools]
      ,[ELA L Constructed Response]
      ,[ELA L Selected Response or Technology Enhanced Items]
      ,[Mathematics Response]
      ,[Monitor Test Response]
      ,[Word Prediction]
      ,'' AS 'Administration Directions Clarified in Student’s Native Language '
      ,''AS 'Administration Directions Read Aloud in Student’s Native Language'
      ,[Mathematics Response - EL]
      ,[Translation of the Mathematics Assessment]
      ,[Word to Word Dictionary (English Native Language)]
      ,[Text-to-Speech]
      ,[Human Reader or Human Signer]
      ,[Unique Accommodation  ]
      ,[Emergency Accommodation]
      ,[Extended Time]
	  --,PARCC.STATE_ID
  FROM [dbo].[Copy of 515_Student Registration Export 2015-11-05T17_25_10.103+0000] PARCC
  LEFT JOIN
  BASIC_STUDENT_WITH_MORE_INFORMATION AS BS
  ON
  LTRIM(RTRIM(PARCC.[State Student Identifier])) = BS.STATE_STUDENT_NUMBER

  LEFT JOIN
  allstudents AS STUD
  ON LTRIM(RTRIM(PARCC.[State Student Identifier])) = LTRIM(RTRIM(STUD.state_id))
  --where [State Student Identifier] != 'NULL'
  AND GENDER IS NOT NULL
  ORDER BY [GRADE LEVEL WHEN ASSESSED]
  

GO


