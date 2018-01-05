USE [SchoolNet]
GO

SELECT [ID_NUMBER]
	  ,SC.LAST_NAME
	  ,SC.FIRST_NAME
	  ,SC.GRADE_LEVEL
	  ,SC.ELL
	  ,SC.SPED
	  ,SC.FRPL
	  ,SC.ETHNICITY
	  ,SC.HISPLAT
      ,[ELEMENTARY_COURSE] AS ELEM_COURSE
      ,[ELEM_TEACHER]
      ,[ELA] AS ELA_COURSE
      ,[ELA_TEACHER]
      ,SC.[MATH] AS MATH_COURSE
      ,[MATH_TEACHER]
      ,SC.[SCIENCE] AS SCIENCE_COURSE
      ,[SCIENCE_TEACHER]
	  ,SFR.Math_SS AS SBA_MATH_SS
	  ,SFR.Math_PL AS SBA_MATH_PL
	  ,SFR.Reading_SS AS SBA_READING_SS
	  ,SFR.Reading_PL AS SBA_READING_PL
	  ,SFR.Science_SS AS SBA_SCIENCE_SS
	  ,SFR.Science_PL AS SBA_SCIENCE_PL
	  ,CASE WHEN EOCS.[Algebra I 7 12 V001] IS NULL THEN ''
	    WHEN EOCS.[Algebra I 7 12 V001]  = 'NULL' THEN ''
		ELSE EOCS.[Algebra I 7 12 V001]  END AS 'Algebra I 7 12 V001 SS'
	  ,CASE 
		WHEN EOCS.[Algebra I 7 12 V001] IS NULL THEN ''
		WHEN EOCS.[Algebra I 7 12 V001] = 'NULL' THEN ''
		WHEN EOCS.[Algebra I 7 12 V001] < 18 THEN 'FAIL' ELSE 'PASS' END AS 'Algebra I 7 12 V001 PL'
      ,CASE WHEN EOCS.[Algebra II 10 12 V002] IS NULL THEN ''
	    WHEN EOCS.[Algebra II 10 12 V002] = 'NULL' THEN ''
		ELSE EOCS.[Algebra II 10 12 V002] END AS 'Algebra II 10 12 V002 SS'
	  ,CASE WHEN EOCS.[Algebra II 10 12 V002] IS NULL THEN ''
	    WHEN EOCS.[Algebra II 10 12 V002] = 'NULL' THEN ''
		WHEN EOCS.[Algebra II 10 12 V002] < 14 THEN 'FAIL' ELSE 'PASS' END AS 'Algebra II 10 12 V002 PL'
      ,CASE WHEN EOCS.[Biology 9 12 V002] IS NULL THEN ''
		WHEN EOCS.[Biology 9 12 V002] = 'NULL' THEN ''
		ELSE EOCS.[Biology 9 12 V002] END AS 'Biology 9 12 V002 SS'
	  ,CASE WHEN EOCS.[Biology 9 12 V002] IS NULL THEN ''
		WHEN EOCS.[Biology 9 12 V002] = 'NULL' THEN ''
		WHEN EOCS.[Biology 9 12 V002] < 22 THEN 'FAIL' ELSE 'PASS' END AS 'Biology 9 12 V002 PL'
      ,CASE WHEN EOCS.[Biology 9 12 V003] IS NULL THEN ''
		WHEN EOCS.[Biology 9 12 V003] = 'NULL' THEN ''
		ELSE EOCS.[Biology 9 12 V003] END AS 'Biology 9 12 V003 SS'
	  ,CASE WHEN EOCS.[Biology 9 12 V003] IS NULL THEN ''
		WHEN EOCS.[Biology 9 12 V003] = 'NULL' THEN ''
		WHEN EOCS.[Biology 9 12 V003] < 27 THEN 'FAIL' ELSE 'PASS' END AS 'Biology 9 12 V003 PL'
      ,CASE WHEN EOCS.[Chemistry 9 12 V002] IS NULL THEN ''
		WHEN EOCS.[Chemistry 9 12 V002] = 'NULL' THEN ''
		ELSE EOCS.[Chemistry 9 12 V002] END AS 'Chemistry 9 12 V002 SS'
	  ,CASE WHEN EOCS.[Chemistry 9 12 V002] IS NULL THEN ''
		WHEN EOCS.[Chemistry 9 12 V002] = 'NULL' THEN ''
		WHEN EOCS.[Chemistry 9 12 V002] < 13 THEN 'FAIL' ELSE 'PASS' END AS 'Chemistry 9 12 V002 PL'
      ,CASE WHEN EOCS.[Chemistry 9 12 V003] IS NULL THEN ''
		WHEN EOCS.[Chemistry 9 12 V003] = 'NULL' THEN ''
		ELSE EOCS.[Chemistry 9 12 V003] END AS 'Chemistry 9 12 V003 SS'
	  ,CASE WHEN EOCS.[Chemistry 9 12 V003] IS NULL THEN ''
		WHEN EOCS.[Chemistry 9 12 V003] = 'NULL' THEN ''
		WHEN EOCS.[Chemistry 9 12 V003] < 24 THEN 'FAIL' ELSE 'PASS' END AS 'Chemistry 9 12 V003 PL'
      ,CASE WHEN EOCS.[English Language Arts III Reading 11 11 V001] IS NULL THEN ''
		WHEN EOCS.[English Language Arts III Reading 11 11 V001] = 'NULL' THEN ''
		ELSE EOCS.[English Language Arts III Reading 11 11 V001] END AS 'English Language Arts III Reading 11 11 V001 SS'
	  ,CASE  
	   WHEN EOCS.[English Language Arts III Reading 11 11 V001] IS NULL THEN ''
	   WHEN EOCS.[English Language Arts III Reading 11 11 V001] = 'NULL' THEN ''
	   WHEN EOCS.[English Language Arts III Reading 11 11 V001] < '25' THEN 'FAIL' ELSE 'PASS' END AS 'English Language Arts III Reading 11 11 V001 PL'
      ,CASE WHEN EOCS.[English Language Arts III Reading 11 11 V002] IS NULL THEN ''
		WHEN EOCS.[English Language Arts III Reading 11 11 V002] = 'NULL' THEN ''
		ELSE EOCS.[English Language Arts III Reading 11 11 V002] END AS 'English Language Arts III Reading 11 11 V002 SS'
	  ,CASE WHEN EOCS.[English Language Arts III Reading 11 11 V002] IS NULL THEN ''
		WHEN EOCS.[English Language Arts III Reading 11 11 V002] = 'NULL' THEN ''
		WHEN EOCS.[English Language Arts III Reading 11 11 V002] < 14 THEN 'FAIL' ELSE 'PASS' END AS 'English Language Arts III Reading 11 11 V002 PL'
      ,CASE WHEN EOCS.[English Language Arts III Writing 11 11 V001] IS NULL THEN ''
		WHEN EOCS.[English Language Arts III Writing 11 11 V001] = 'NULL' THEN ''
		ELSE EOCS.[English Language Arts III Writing 11 11 V001] END AS 'English Language Arts III Writing 11 11 V001 SS'
	  ,CASE WHEN EOCS.[English Language Arts III Writing 11 11 V001] IS NULL THEN ''
		WHEN EOCS.[English Language Arts III Writing 11 11 V001] = 'NULL' THEN ''
		WHEN EOCS.[English Language Arts III Writing 11 11 V001] < 15 THEN 'FAIL' ELSE 'PASS' END AS 'English Language Arts III Writing 11 11 V001 PL'
      ,CASE WHEN EOCS.[English Language Arts III Writing 11 11 V002] IS NULL THEN ''
		WHEN EOCS.[English Language Arts III Writing 11 11 V002] = 'NULL' THEN ''
		ELSE EOCS.[English Language Arts III Writing 11 11 V002] END AS 'English Language Arts III Writing 11 11 V002 SS'
	  ,CASE WHEN EOCS.[English Language Arts III Writing 11 11 V002] IS NULL THEN ''
		WHEN EOCS.[English Language Arts III Writing 11 11 V002] = 'NULL' THEN ''
		WHEN EOCS.[English Language Arts III Writing 11 11 V002] < 24 THEN 'FAIL' ELSE 'PASS' END AS 'English Language Arts III Writing 11 11 V002 PL'
      ,CASE WHEN EOCS.[English Language Arts IV Reading 12 12 V001] IS NULL THEN ''
		WHEN EOCS.[English Language Arts IV Reading 12 12 V001] = 'NULL' THEN ''
		ELSE EOCS.[English Language Arts IV Reading 12 12 V001] END AS 'English Language Arts IV Reading 12 12 V001 SS'
	  ,CASE WHEN EOCS.[English Language Arts IV Reading 12 12 V001] IS NULL THEN ''
		WHEN EOCS.[English Language Arts IV Reading 12 12 V001] = 'NULL' THEN ''
		WHEN EOCS.[English Language Arts IV Reading 12 12 V001] < 15 THEN 'FAIL' ELSE 'PASS' END AS 'English Language Arts IV Reading 12 12 V001 PL'
      ,CASE WHEN EOCS.[English Language Arts IV Writing 12 12 V001] IS NULL THEN ''
		WHEN EOCS.[English Language Arts IV Writing 12 12 V001] = 'NULL' THEN ''
		ELSE EOCS.[English Language Arts IV Writing 12 12 V001] END AS 'English Language Arts IV Writing 12 12 V001 SS'
	  ,CASE WHEN EOCS.[English Language Arts IV Writing 12 12 V001] IS NULL THEN ''
		WHEN EOCS.[English Language Arts IV Writing 12 12 V001] = 'NULL' THEN ''
		WHEN EOCS.[English Language Arts IV Writing 12 12 V001] < 26 THEN 'FAIL' ELSE 'PASS' END AS 'English Language Arts IV Writing 12 12 V001 PL'
      ,CASE WHEN EOCS.[Spanish Language Arts III Reading 11 11 V001] IS NULL THEN ''
		WHEN EOCS.[Spanish Language Arts III Reading 11 11 V001] = 'NULL' THEN ''
		ELSE EOCS.[Spanish Language Arts III Reading 11 11 V001] END AS 'Spanish Language Arts III Reading 11 11 V001 SS'
	  ,CASE WHEN EOCS.[Spanish Language Arts III Reading 11 11 V001] IS NULL THEN ''
		WHEN EOCS.[Spanish Language Arts III Reading 11 11 V001] = 'NULL' THEN ''
		WHEN EOCS.[Spanish Language Arts III Reading 11 11 V001] < 25 THEN 'FAIL' ELSE 'PASS' END AS 'Spanish Language Arts III Reading 11 11 V001 PL'
      ,CASE WHEN EOCS.[Spanish Language Arts III Writing 11 11 V001] IS NULL THEN ''
		WHEN EOCS.[Spanish Language Arts III Writing 11 11 V001] = 'NULL' THEN ''
		ELSE EOCS.[Spanish Language Arts III Writing 11 11 V001] END AS 'Spanish Language Arts III Writing 11 11 V001 SS'
	  ,CASE WHEN EOCS.[Spanish Language Arts III Writing 11 11 V001] IS NULL THEN ''
		WHEN EOCS.[Spanish Language Arts III Writing 11 11 V001] = 'NULL' THEN ''
		WHEN EOCS.[Spanish Language Arts III Writing 11 11 V001] < 15 THEN 'FAIL' ELSE 'PASS' END AS 'Spanish Language Arts III Writing 11 11 V001 PL'
      ,CASE WHEN EOCS.[New Mexico History 7 12 V001] IS NULL THEN ''
		WHEN EOCS.[New Mexico History 7 12 V001] = 'NULL' THEN ''
		ELSE EOCS.[New Mexico History 7 12 V001] END AS 'New Mexico History 7 12 V001 SS'
	  ,CASE WHEN EOCS.[New Mexico History 7 12 V001] IS NULL THEN ''
		WHEN EOCS.[New Mexico History 7 12 V001] = 'NULL' THEN ''
		WHEN EOCS.[New Mexico History 7 12 V001] < 18 THEN 'FAIL' ELSE 'PASS' END AS 'New Mexico History 7 12 V001 PL'
      ,CASE WHEN EOCS.[US Government Comprehensive 9 12 V001] IS NULL THEN ''
		WHEN EOCS.[US Government Comprehensive 9 12 V001] = 'NULL' THEN ''
		ELSE EOCS.[US Government Comprehensive 9 12 V001] END AS 'US Government Comprehensive 9 12 V001 SS'
	  ,CASE WHEN EOCS.[US Government Comprehensive 9 12 V001] IS NULL THEN ''
		WHEN EOCS.[US Government Comprehensive 9 12 V001] = 'NULL' THEN ''
		WHEN EOCS.[US Government Comprehensive 9 12 V001] < 24 THEN 'FAIL' ELSE 'PASS' END AS 'US Government Comprehensive 9 12 V001 PL'
      ,CASE WHEN EOCS.[US Government Comprehensive 9 12 V002] IS NULL THEN ''
		WHEN EOCS.[US Government Comprehensive 9 12 V002] = 'NULL' THEN ''
		ELSE EOCS.[US Government Comprehensive 9 12 V002] END AS 'US Government Comprehensive 9 12 V001 SS'
	  ,CASE WHEN EOCS.[US Government Comprehensive 9 12 V002] IS NULL THEN ''
		WHEN EOCS.[US Government Comprehensive 9 12 V002] = 'NULL' THEN ''
		WHEN EOCS.[US Government Comprehensive 9 12 V002] < 24 THEN 'FAIL' ELSE 'PASS' END AS 'US Government Comprehensive 9 12 V001 PL'
      ,CASE WHEN EOCS.[US History 9 12 V002] IS NULL THEN ''
		WHEN EOCS.[US History 9 12 V002] = 'NULL' THEN ''
		ELSE EOCS.[US History 9 12 V002] END AS 'US History 9 12 V002 SS'
	  ,CASE WHEN EOCS.[US History 9 12 V002] IS NULL THEN ''
		WHEN EOCS.[US History 9 12 V002] = 'NULL' THEN ''
		WHEN EOCS.[US History 9 12 V002] < 31 THEN 'FAIL' ELSE 'PASS' END AS 'US History 9 12 V002 PL'
      ,CASE WHEN EOCS.[Economics 9 12 V001] IS NULL THEN ''
		WHEN EOCS.[Economics 9 12 V001] = 'NULL' THEN ''
		ELSE EOCS.[Economics 9 12 V001] END AS 'Economics 9 12 V001 SS'
	  ,CASE WHEN EOCS.[Economics 9 12 V001] IS NULL THEN ''
		WHEN EOCS.[Economics 9 12 V001] = 'NULL' THEN ''
		WHEN EOCS.[Economics 9 12 V001] < 23 THEN 'FAIL' ELSE 'PASS' END AS 'Economics 9 12 V001 PL'
      ,CASE WHEN EOCS.[US History 9 12 V001] IS NULL THEN ''
		WHEN EOCS.[US History 9 12 V001] = 'NULL' THEN ''
		ELSE EOCS.[US History 9 12 V001] END AS 'US History 9 12 V001 SS'
	  ,CASE WHEN EOCS.[US History 9 12 V001] IS NULL THEN ''
		WHEN EOCS.[US History 9 12 V001] = 'NULL' THEN ''
		WHEN EOCS.[US History 9 12 V001] < 26 THEN 'FAIL' ELSE 'PASS' END AS 'US History 9 12 V001 PL'
      ,CASE WHEN EOCS.[World History And Geography 9 12 V001] IS NULL THEN ''
		WHEN EOCS.[World History And Geography 9 12 V001] = 'NULL' THEN ''
		ELSE EOCS.[World History And Geography 9 12 V001] END AS 'World History And Geography 9 12 V001 SS'
	  ,CASE WHEN EOCS.[World History And Geography 9 12 V001] IS NULL THEN ''
		WHEN EOCS.[World History And Geography 9 12 V001] = 'NULL' THEN ''
		WHEN EOCS.[World History And Geography 9 12 V001] < 25 THEN 'FAIL' ELSE 'PASS' END AS 'World History And Geography 9 12 V001 PL'
      ,CASE WHEN EOCS.[NM History 7 12 V001] IS NULL THEN ''
		WHEN EOCS.[NM History 7 12 V001] = 'NULL' THEN ''
		ELSE EOCS.[NM History 7 12 V001] END AS 'NM History 7 12 V001 SS'
	  ,CASE WHEN EOCS.[NM History 7 12 V001] IS NULL THEN ''
		WHEN EOCS.[NM History 7 12 V001] = 'NULL' THEN ''
		WHEN EOCS.[NM History 7 12 V001] < 18 THEN 'FAIL' ELSE 'PASS' END AS 'NM History 7 12 V001 PL'
  FROM [dbo].[STUDENT_COURSES] SC
  LEFT JOIN
  SBA_FOR_RIGO SFR
  ON SC.ID_NUMBER = SFR.student_code
  LEFT JOIN
  [EOC_AIMS_SBA_AND_EOC] AS EOC
  ON SC.ID_NUMBER = EOC.ID_NBR
  LEFT JOIN
  EOC_SCORES EOCS
  ON SC.ID_NUMBER = EOCS.[ID Number]

  --WHERE  SC.ELEMENTARY_COURSE != 'NULL'
  
  ORDER BY GRADE_LEVEL,ELEM_TEACHER, MATH_TEACHER, SCIENCE_TEACHER, ELA_TEACHER, ID_NUMBER
GO


