USE
Assessments
GO

SELECT
	   [State Abbreviation]
      ,[Testing District Code]
      ,[Testing School Code]
      ,[Responsible District Code]
      ,[Responsible School Code]
      ,[State Student Identifier]
      ,[Local Student Identifier]
      ,[PARCC Student ID]
      ,[Last or Surname]
      ,[First Name]
      ,[Middle Name]
      ,[Birthdate]
      ,[Sex]
      ,[State Field 1]
      ,[Grade Level When Assessed]
      ,[Hispanic or Latino Ethnicity]
      ,[American Indian or Alaska Native]
      ,[Asian]
      ,[Black or African American]
      ,[Native Hawaiian or Other Pacific Islander]
      ,[White]
      ,[filler field ]
      ,[Two or More Races]
      ,[English Learner  (EL)]
      ,[Title III Limited English Proficient Participation Status]
      ,[Gifted and Talented]
      ,[Migrant Status]
      ,[Economic Disadvantage Status]
      ,[Student With Disabilities ]
      ,[Primary Disability Type]
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
      ,[Administration Directions Clarified in Studentâ€™s Native Language ]
      ,[Administration Directions Read Aloud in Studentâ€™s Native Language]
      ,[Mathematics Response - EL]
      ,[Translation of the Mathematics Assessment]
      ,[Word to Word Dictionary (English Native Language)]
      ,[Text-to-Speech]
      ,[Human Reader or Human Signer]
      ,[Unique Accommodation  ]
      ,[Emergency Accommodation]
      ,[Extended Time]
	  
	  
	  
	  
	  ,PARCK.student_code
	  ,PARCC_STUDENT_ID
	  ,Subtest
	  ,PL
	  ,SBA.test_section_name
	  ,SBA.scaled_score
	  ,SBA.score_15 AS SBA_GRADE
   --   ,[Retest]
   --   ,[EL Accommodation ]
FROM
(
SELECT 
	  ROW_NUMBER () OVER (PARTITION BY [State Student Identifier], [Test Code] ORDER BY [Test Code]) AS RN
	  ,[State Abbreviation]
      ,[Testing School Code]
      ,[Responsible School Code]
      ,[State Student Identifier]
	  ,STUD.student_code
      ,[Local Student Identifier]
	  ,PARCC.StudentID AS PARCC_STUDENT_ID
      ,[Last or Surname]
      ,[First Name]
      ,[Middle Name]
      ,[Birthdate]
      ,[Sex]
      ,[State Field 1]
      ,[Grade Level When Assessed]
      ,[Test Code]
      ,[Test Format ]
	  ,PARCC.Subtest
	  ,PARCC.PL
      ,[Responsible District Code]
      ,[Testing District Code]
      ,[PARCC Student ID]
      ,[Hispanic or Latino Ethnicity]
      ,[American Indian or Alaska Native]
      ,[Asian]
      ,[Black or African American]
      ,[Native Hawaiian or Other Pacific Islander]
      ,[White]
      ,[filler field ]
      ,[Two or More Races]
      ,[English Learner  (EL)]
      ,[Title III Limited English Proficient Participation Status]
      ,[Gifted and Talented]
      ,[Migrant Status]
      ,[Economic Disadvantage Status]
      ,[Student With Disabilities ]
      ,[Primary Disability Type]
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
      ,[Retest]
      ,[EL Accommodation ]
      ,[Frequent Breaks]
      ,[Separate Alternate Location]
      ,[Small Testing Group]
      ,[Specialized Equipment or Furniture]
      ,[Specified Area or Setting]
      ,[Time of Day]
      ,[Answer Masking]
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
      ,[Administration Directions Clarified in Studentâ€™s Native Language ]
      ,[Administration Directions Read Aloud in Studentâ€™s Native Language]
      ,[Mathematics Response - EL]
      ,[Translation of the Mathematics Assessment]
      ,[Word to Word Dictionary (English Native Language)]
      ,[Text-to-Speech]
      ,[Human Reader or Human Signer]
      ,[Unique Accommodation  ]
      ,[Emergency Accommodation]
      ,[Extended Time]

  FROM [Assessments].[dbo].[PARCC_StudentRegistration_Export_10-23] AS SPARK
  LEFT JOIN
  Preliminary_2015_PARCC AS PARCC
  ON SPARK.[State Student Identifier] = PARCC.StudentID
  AND
  (
   (SPARK.[Test Code] = 'GEO01' AND PARCC.Subtest = 'GEOMETRY')
  OR (SPARK.[Test Code] = 'ALG02' AND PARCC.Subtest = 'ALGEBRA 2')
  OR (SPARK.[Test Code] = 'ELA11' AND PARCC.Subtest = 'English Language Arts 11th Grade')
  )
  LEFT JOIN
  allstudents_ALL AS STUD
  ON STUD.state_id = SPARK.[State Student Identifier]
  AND STUD.school_year = '2014'
  AND STUD.school_code = SPARK.[Testing School Code]
) AS PARCK
LEFT JOIN
SBA
ON PARCK.[student_code] = SBA.student_code
AND SBA.school_year = '2013'
AND
  (
   (PARCK.[Test Code] = 'GEO01' AND SBA.test_section_name = 'MATH')
  OR (PARCK.[Test Code] = 'ALG02' AND SBA.test_section_name = 'MATH')
  OR (PARCK.[Test Code] = 'ELA11' AND SBA.test_section_name = 'READING' OR PARCK.[Test Code] = 'ELA11' AND SBA.test_section_name = 'WRITING')
  )
WHERE RN = 1
ORDER BY PARCK.PARCC_STUDENT_ID, [Test Code]