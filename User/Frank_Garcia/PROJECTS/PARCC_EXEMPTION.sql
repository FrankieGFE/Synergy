USE [AIMS]
GO

SELECT [State Abbreviation]
      ,[Testing District]
      ,[Testing School]
      ,[Responsible District Identifier]
      ,[School Institution Identifier]
      ,[State Student Identifier]
      ,[Local Student Identifier]
      ,[PARCC Student Identifier]
      ,[Last or Surname]
      ,[First Name]
      ,[Middle Name]
      ,[Birthdate]
      ,[Sex]
      ,[Optional State Data 1]
      ,[Grade Level When Assessed]
      ,[Hispanic or Latino Ethnicity]
      ,[American Indian or Alaska Native]
      ,[Asian]
      ,[Black or African American]
      ,[Native Hawaiian or Other Pacific Islander]
      ,[White]
      ,[English Learner  (EL)]
      ,[Title III Limited English Proficient Participation Status]
      ,[Gifted and Talented]
      ,[Migrant Status]
      ,[Economic Disadvantage Status]
      ,[Student With Disabilities ]
      ,[Primary Disability Type]
      ,[Optional State Data 2]
      ,[Optional State Data 3]
      ,[Optional State Data 4]
      ,[Optional State Data 5]
      ,[Optional State Data 6]
      ,[Optional State Data 7]
      ,[Optional State Data 8]
      ,[Assessment Session Location]
      ,[Assessment Session Test Administrator Identifier]
      ,[Classroom Identifier]
      ,[Staff Member Identifier]
      ,[Test Code]
      ,[Test Format ]
      ,[Retest]
      ,[Assessment Accommodation   English learner (EL)]
      ,[Assessment Accommodation  504 ]
      ,[Assessment Accommodation  Individualized Educational Plan (IEP)]
      ,[Alternate Representation - Paper Test]
      ,[Translation of the Mathematics Assessment in Paper]
      ,[Human Reader or Human Signer]
      ,[Large Print]
      ,[Braille with Tactile Graphics]
      ,[Frequent Breaks]
      ,[Separate Alternate Location]
      ,[Small Testing Group]
      ,[Specialized Equipment or Furniture]
      ,[Specified Area or Setting]
      ,[Time Of Day]
      ,[Answer Masking]
      ,[Color Contrast]
      ,[Text-to-Speech for Mathematics ]
      ,[Human Reader or Human Signer for Mathematics]
      ,[ASL Video ]
      ,[Screen Reader OR other Assistive Technology (AT) Application]
      ,[Closed Captioning for ELA L  ]
      ,[Human Reader or Human Signer for ELA L]
      ,[Refreshable Braille Display for ELA L]
      ,[Tactile Graphics ]
      ,[Text-to-Speech for ELA L ]
      ,[Answers Recorded in Test Book]
      ,[Braille Response]
      ,[Calculation Device and Mathematics Tools]
      ,[ELA L Constructed Response]
      ,[ELA L Selected Response or Technology Enhanced Items]
      ,[Mathematics Response]
      ,[Monitor Test Response]
      ,[Word Prediction]
      ,[General Administration Directions Clarified in Student’s Native Language (by test administrator)]
      ,[General Administration Directions Read Aloud and Repeated as Needed in Student’s Native Language (by test administrator)]
      ,[Mathematics Response - EL]
      ,[Translation of the Mathematics Assessment in Text-to-Speech]
      ,[Translation of the Mathematics Assessment Online]
      ,[Word to Word Dictionary (English Native Language)]
      ,[Extended Time]
      ,[Total Test Items]
      ,[Test Attemptedness Flag]
      ,[Total Test Items Attempted]
      ,[Unit 1 Total Numbers of Items]
      ,[Unit 1 Number of Attempted Items]
      ,[Unit 2 Total Numbers of Items]
      ,[Unit 2 Number of Attempted Items]
      ,[Unit 3 Total Numbers of Items]
      ,[Unit 3 Number of Attempted Items]
      ,[Unit 4 Total Numbers of Items]
      ,[Unit 4 Number of Attempted Items]
      ,[Unit 5 Total Numbers of Items]
      ,[Unit 5 Number of Attempted Items]
      ,[Student Test UUID]
      ,[Student Test Status]
      ,[Not Tested Code]
      ,[Not Tested Reason]
      ,[Void PBA EOY Score  Code]
      ,[Void PBA EOY Score  Reason]
      ,[End of Record]
	  ,CASE WHEN T1.Assessment IS NULL THEN ''
		ELSE 'X'
	  END AS 'PARCC EXEMPTION'
  FROM [dbo].[Student Test Update Export 2015-03-30] STUD
  LEFT JOIN
	(SELECT	
		APS_ID
		,ASSESSMENT
	FROM
		(
		SELECT
			ROW_NUMBER () OVER (PARTITION BY APS_ID ORDER BY APS_ID DESC) AS RN
			,APS_ID
			,ASSESSMENT
		FROM
			Program_Assessment_Exemptions AS AE
		WHERE 
			SCH_YR = '2014-2015'
			AND ASSESSMENT = 'PARCC'
		) AS PARCC
		WHERE RN = 1
	) AS T1
	ON T1.APS_ID = STUD.[Local Student Identifier]




  --Program_Assessment_Exemptions AS AE
  --ON STUD.[Local Student Identifier] = AE.APS_ID
  --AND AE.Assessment = 'PARCC'
  --AND AE.SCH_YR = '2014-2015'
GO


