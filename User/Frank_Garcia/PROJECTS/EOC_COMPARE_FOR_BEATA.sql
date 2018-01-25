USE [Assessments]
GO

SELECT
	*
FROM
(
SELECT
	  RN
	  ,[Subtest_Identifier1]
      ,[DISTRICT_Count_of_EOCs]
      ,[TEST_ENVIRONMNT_CD1]
      ,[DISTRICT_Count_of_BlackBoard]
      ,[District_Code]
      ,[District_Name]
      ,[Location_ID]
      ,[Full_Location_Name]
      ,[Student_ID_1]
	  ,student_code
      ,[Student_Name]
      ,[Assessment_ID]
      ,[Subtest_Identifier]
      ,[Date_Description]
      ,[RAW_SCORE]
      ,[MAX_SCORE_VALUE]
      ,[OPTIMUM_SCORE_VALUE]
      ,[ITEM_SCORE_TYPE]
      ,[SCORE_TYPE]
      ,[TEST_ENVIRONMNT_CD]
FROM
(
SELECT 
	  ROW_NUMBER () OVER (PARTITION BY [Student_ID_1], [Subtest_Identifier],[Date_Description]  ORDER BY [Student_ID_1]) AS RN
	  ,CASE 
		    WHEN LTRIM(RTRIM([Subtest_Identifier1])) = 'KEYBOARDING 6 8 V003' THEN 'Keyboarding 6 8 V001 3'
			WHEN LTRIM(RTRIM([Subtest_Identifier1])) = 'ALGEBRA II 9 12 V006' THEN 'Algebra II 10 12 V006'
	        WHEN LTRIM(RTRIM([Subtest_Identifier1])) = 'ANATOMY AND PHYSIOLOGY 9 12 V002' THEN 'Anatomy Physiology 11 12 V002'
			WHEN LTRIM(RTRIM([Subtest_Identifier1])) = 'ELA III READING 9 12 V006' THEN 'English Language Arts III Reading 11 11 V006'
			WHEN LTRIM(RTRIM([Subtest_Identifier1])) = 'ENGLISH III WRITING 9 12 V006' THEN 'English Language Arts III Writing 11 11 V006'
			WHEN LTRIM(RTRIM([Subtest_Identifier1])) = 'ELA IV READING 9 12 V003' THEN 'English Language Arts IV Reading 11 11 V003'
			WHEN LTRIM(RTRIM([Subtest_Identifier1])) = 'ENGLISH IV WRITING 9 12 V003' THEN 'English Language Arts IV Writing 12 12 V003'
			WHEN LTRIM(RTRIM([Subtest_Identifier1])) = 'ENVIRONMENTAL SCIENCE 9 12 V001' THEN 'Environmental Science 10 12 V001'
			WHEN LTRIM(RTRIM([Subtest_Identifier1])) = 'HEALTH 9 12 V002' THEN 'Health Education 6 12 V002'
			WHEN LTRIM(RTRIM([Subtest_Identifier1])) = 'SCIENCE 8 8 V002' THEN 'Integrated General Science 6 8 V002'
			WHEN LTRIM(RTRIM([Subtest_Identifier1])) = 'ART 4 5 V002' THEN 'Introduction to Art 4 5 V002'
			WHEN LTRIM(RTRIM([Subtest_Identifier1])) = 'ART 6 8 V002' THEN 'Introduction to Art 6 8 V002'
			WHEN LTRIM(RTRIM([Subtest_Identifier1])) = 'ART 9 12 V002' THEN 'Introduction to Art 9 12 V001 V002'
			WHEN LTRIM(RTRIM([Subtest_Identifier1])) = 'NEW MEXICO HISTORY 9 12 V004' THEN 'New Mexico 7 12 History V004'
			WHEN LTRIM(RTRIM([Subtest_Identifier1])) = 'PE 4 5 V002' THEN 'Physical Education 4 5 V002'
			WHEN LTRIM(RTRIM([Subtest_Identifier1])) = 'PHYSICAL EDUCATION  6 8 V002' THEN 'Physical Education 6 8 V002'
			WHEN LTRIM(RTRIM([Subtest_Identifier1])) = 'PHYSICAL EDUCATION 9 12 V002' THEN 'Physical Education 9 12 V002'
			WHEN LTRIM(RTRIM([Subtest_Identifier1])) = 'SPANISH 1 9 12 V003' THEN 'Spanish I 7 12 V003'
			WHEN LTRIM(RTRIM([Subtest_Identifier1])) = 'Family and Consumer Science 6 8 V004' THEN 'Family and Consumer Science 6 8 V003'
			WHEN LTRIM(RTRIM([Subtest_Identifier1])) = 'CULINARY ARTS I 9 12 V001' THEN 'Culinary Arts I 9 12 V003'
			WHEN LTRIM(RTRIM([Subtest_Identifier1])) = 'English Language Arts III Writing 11 11 V006' THEN 'English Language Arts III Writing 11 11 V006'
			WHEN LTRIM(RTRIM([Subtest_Identifier1])) = 'CERAMICS 9 12 V001' THEN 'Ceramics 9 12 V003'
			WHEN LTRIM(RTRIM([Subtest_Identifier1])) = 'Introduction to Art 9 12 V002' THEN 'Introduction to Art 9 12 V001 V002'
			WHEN LTRIM(RTRIM([Subtest_Identifier1])) = 'New Mexico 7 12 History V004' AND LTRIM(RTRIM(Date_Description)) = '2015-04-27' THEN 'New Mexico 7 12 History V001'
			WHEN LTRIM(RTRIM([Subtest_Identifier1])) = 'DRIVERS EDUCATION 9 12 V002' THEN 'DRIVERS EDUCATION 9 12 V002'
			WHEN LTRIM(RTRIM([Subtest_Identifier1])) = 'Family and Consumer Science 6 8 V004' THEN 'Family and Consumer Science 6 8 V003'
			WHEN LTRIM(RTRIM([Subtest_Identifier1])) = '' THEN ''
			ELSE Subtest_Identifier1
	END AS SUBTEST_IDENTIFIER1
	  --,SUBTEST_IDENTIFIER1
      ,[DISTRICT_Count_of_EOCs]
      ,[TEST_ENVIRONMNT_CD1]
      ,[DISTRICT_Count_of_BlackBoard]
      ,[District_Code]
      ,[District_Name]
      ,[Location_ID]
      ,[Full_Location_Name]
      ,[Student_ID_1]
	  ,STU.student_code
      ,[Student_Name]
      ,[Assessment_ID]
      ,[Subtest_Identifier]
      ,CASE	WHEN LTRIM(RTRIM(Date_Description)) = '2015-06-30' THEN '2015-07-15' 
	        WHEN LTRIM(RTRIM(Date_Description)) = '2015-05-11' THEN '2015-05-11' 
	  ELSE LTRIM(RTRIM(Date_Description))
	  END AS [Date_Description]
      ,[RAW_SCORE]
      ,[MAX_SCORE_VALUE]
      ,[OPTIMUM_SCORE_VALUE]
      ,[ITEM_SCORE_TYPE]
      ,[SCORE_TYPE]
      ,[TEST_ENVIRONMNT_CD]
  FROM [dbo].[TRASH_14-15_EOC_detail_4.27.16] AS PED
  LEFT JOIN
  allstudents_ALL AS STU
  ON PED.Student_ID_1 = STU.state_id

  --WHERE 
  --STU.school_year = '2014'
) AS T1
WHERE RN = 1  
--ORDER BY SUBTEST_IDENTIFIER1
) AS T2
LEFT JOIN
EOC_BACKUP AS EOC
ON LTRIM(RTRIM(EOC.[ID Number])) = LTRIM(RTRIM(student_code))
AND LTRIM(RTRIM(EOC.Subtest)) = LTRIM(RTRIM(Subtest_Identifier1))
AND LTRIM(RTRIM([TEST DATE])) = LTRIM(RTRIM(Date_Description))
WHERE 
	1 = 1
AND [District Number] IS NULL
--AND student_code = '104283510'
AND STUDENT_CODE IS  NULL
ORDER BY SUBTEST_IDENTIFIER1
GO


