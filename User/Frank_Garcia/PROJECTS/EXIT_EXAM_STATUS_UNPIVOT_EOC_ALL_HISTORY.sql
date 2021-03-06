USE Assessments
GO
--BEGIN TRAN

TRUNCATE TABLE [EOC_AIMS_FROM_EOC_]
INSERT INTO [EOC_AIMS_FROM_EOC_]

SELECT
	*
FROM
(
SELECT
--ROW_NUMBER () OVER (PARTITION BY [ID Number] ORDER BY [ID Number] DESC) AS RN 
[ID Number]
,CASE  WHEN [Algebra I 7 12 V001] IS NULL THEN '' ELSE [Algebra I 7 12 V001] END AS [Algebra I 7 12 V001]
,CASE  WHEN [Algebra I 7 12 V003] IS NULL THEN '' ELSE [Algebra I 7 12 V003] END AS [Algebra I 7 12 V003]
,CASE WHEN [Algebra II 10 12 V002] IS NULL THEN '' ELSE [Algebra II 10 12 V002] END AS [Algebra II 10 12 V002]
,CASE WHEN [Algebra II 10 12 V006] IS NULL THEN '' ELSE [Algebra II 10 12 V006] END AS [Algebra II 10 12 V006]
,CASE WHEN [Anatomy Physiology 11 12 V002] IS NULL THEN '' ELSE [Anatomy Physiology 11 12 V002] END AS [Anatomy Physiology 11 12 V002]
,CASE WHEN [Biology 9 12 V002] IS NULL THEN '' ELSE [Biology 9 12 V002] END AS [Biology 9 12 V002]
,CASE WHEN [Biology 9 12 V003] IS NULL THEN '' ELSE [Biology 9 12 V003] END AS [Biology 9 12 V003]
,CASE WHEN [Biology 9 12 V007] IS NULL THEN '' ELSE [Biology 9 12 V007] END AS [Biology 9 12 V007]
,CASE WHEN [Chemistry 9 12 V001] IS NULL THEN '' ELSE [Chemistry 9 12 V001] END AS [Chemistry 9 12 V001]
,CASE WHEN [Chemistry 9 12 V002] IS NULL THEN '' ELSE [Chemistry 9 12 V002] END AS [Chemistry 9 12 V002]
,CASE WHEN [Chemistry 9 12 V003] IS NULL THEN '' ELSE [Chemistry 9 12 V003] END AS [Chemistry 9 12 V003]
,CASE WHEN [Chemistry 9 12 V008] IS NULL THEN '' ELSE [Chemistry 9 12 V008] END AS [Chemistry 9 12 V008]
,CASE WHEN [Economics 9 12 V001] IS NULL THEN '' ELSE [Economics 9 12 V001] END AS[Economics 9 12 V001]
,CASE WHEN [Economics 9 12 V004] IS NULL THEN '' ELSE [Economics 9 12 V004] END AS[Economics 9 12 V004]
,CASE WHEN [English Language Arts III Reading 11 11 V001] IS NULL THEN '' ELSE [English Language Arts III Reading 11 11 V001] END AS[English Language Arts III Reading 11 11 V001]
,CASE WHEN [English Language Arts III Reading 11 11 V002] IS NULL THEN '' ELSE [English Language Arts III Reading 11 11 V002] END AS[English Language Arts III Reading 11 11 V002]
,CASE WHEN [English Language Arts III Reading 11 11 V006] IS NULL THEN '' ELSE [English Language Arts III Reading 11 11 V006] END AS[English Language Arts III Reading 11 11 V006]

,CASE WHEN [English Language Arts III Writing 11 11 V001] IS NULL THEN '' ELSE [English Language Arts III Writing 11 11 V001] END AS[English Language Arts III Writing 11 11 V001]
,CASE WHEN [English Language Arts III Writing 11 11 V002] IS NULL THEN '' ELSE [English Language Arts III Writing 11 11 V002] END AS[English Language Arts III Writing 11 11 V002]
,CASE WHEN [English Language Arts III Writing 11 11 V006] IS NULL THEN '' ELSE [English Language Arts III Writing 11 11 V006] END AS[English Language Arts III Writing 11 11 V006]
,CASE WHEN [English Language Arts IV Reading 11 11 V003] IS NULL THEN '' ELSE [English Language Arts IV Reading 11 11 V003] END AS[English Language Arts IV Reading 11 11 V003]
,CASE WHEN [English Language Arts IV Reading 12 12 V001] IS NULL THEN '' ELSE [English Language Arts IV Reading 12 12 V001] END AS[English Language Arts IV Reading 12 12 V001]
,CASE WHEN [English Language Arts IV Writing 12 12 V001] IS NULL THEN '' ELSE [English Language Arts IV Writing 12 12 V001] END AS[English Language Arts IV Writing 12 12 V001]
,CASE WHEN [English Language Arts IV Writing 12 12 V003] IS NULL THEN '' ELSE [English Language Arts IV Writing 12 12 V003] END AS[English Language Arts IV Writing 12 12 V003]

,CASE WHEN [Health Education 6 12 V001] IS NULL THEN '' ELSE [Health Education 6 12 V001] END AS[Health Education 6 12 V001]
,CASE WHEN [Health Education 6 12 V002] IS NULL THEN '' ELSE [Health Education 6 12 V002] END AS[Health Education 6 12 V002]
,CASE WHEN [Geometry 9 12 V003] IS NULL THEN '' ELSE [Geometry 9 12 V003] END AS[Geometry 9 12 V003]
,CASE WHEN [New Mexico History 7 12 V001] IS NULL THEN '' ELSE [New Mexico History 7 12 V001] END AS[New Mexico History 7 12 V001]
,CASE WHEN [New Mexico 7 12 History V004] IS NULL THEN '' ELSE [New Mexico 7 12 History V004] END AS[New Mexico 7 12 History V004]
,CASE WHEN [New Mexico 7 12 History V001] IS NULL THEN '' ELSE [New Mexico 7 12 History V001] END AS [New Mexico 7 12 History V001]
,CASE WHEN [Physics 9 12 V003] IS NULL THEN '' ELSE [Physics 9 12 V003] END AS[Physics 9 12 V003]
,CASE WHEN [Pre-Calculus 9 12 V004] IS NULL THEN '' ELSE [Pre-Calculus 9 12 V004] END AS[Pre-Calculus 9 12 V004]
,CASE WHEN [Spanish Language Arts III Reading 11 11 V001] IS NULL THEN '' ELSE [Spanish Language Arts III Reading 11 11 V001] END AS[Spanish Language Arts III Reading 11 11 V001]
,CASE WHEN [Spanish Language Arts III Writing 11 11 V001] IS NULL THEN '' ELSE [Spanish Language Arts III Writing 11 11 V001] END AS[Spanish Language Arts III Writing 11 11 V001]
,CASE WHEN [US Government Comprehensive 9 12 V001] IS NULL THEN '' ELSE [US Government Comprehensive 9 12 V001] END AS[US Government Comprehensive 9 12 V001]
,CASE WHEN [US Government Comprehensive 9 12 V002] IS NULL THEN '' ELSE [US Government Comprehensive 9 12 V002] END AS[US Government Comprehensive 9 12 V002]
,CASE WHEN [US Government Comprehensive 9 12 V005] IS NULL THEN '' ELSE [US Government Comprehensive 9 12 V005] END AS[US Government Comprehensive 9 12 V005]
,CASE WHEN [US History 9 12 V001] IS NULL THEN '' ELSE [US History 9 12 V001] END AS[US History 9 12 V001]
,CASE WHEN [US History 9 12 V002] IS NULL THEN '' ELSE [US History 9 12 V002] END AS[US History 9 12 V002]
,CASE WHEN [US History 9 12 V007] IS NULL THEN '' ELSE [US History 9 12 V007] END AS[US History 9 12 V007]
,CASE WHEN [World History And Geography 9 12 V001] IS NULL THEN '' ELSE [World History And Geography 9 12 V001] END AS[World History And Geography 9 12 V001]
,CASE WHEN [World History And Geography 9 12 V003] IS NULL THEN '' ELSE [World History And Geography 9 12 V003] END AS[World History And Geography 9 12 V003]
,CASE WHEN [Environmental Science 10 12 V001] IS NULL THEN '' ELSE [Environmental Science 10 12 V001] END AS [Environmental Science 10 12 V001]
,CASE WHEN [Financial Literacy 9 12 V003] IS NULL THEN '' ELSE [Financial Literacy 9 12 V003] END AS [Financial Literacy 9 12 V003]

--,Score1
--,[Subtest]
--,assessment_id
--,Score2
--,SCORE22

FROM
(
SELECT 
	 ROW_NUMBER () OVER (PARTITION BY [ID Number], [Subtest] ORDER BY [Score1] DESC) AS RN 
     ,[ID Number]
      --,[Test ID]
      ,[Subtest]
      --,[School Year]
      --,[test Date]
      --,[School]
      --,[Grade]
      --,[Score1]
      ,[Score2]
      --,[Score3]
      --,[DOB]
      --,[last_name]
      --,[first_name]
      --,[SCH_YR]
      --,[full_name]
	  --,assessment_id
  FROM EOC_
  --where [School Year] = '2014'
) AS T1
pivot
 (max([Score2]) FOR subtest IN ([Algebra I 7 12 V001],[Algebra II 10 12 V002],[Algebra I 7 12 V003],[Algebra II 10 12 V006],[Anatomy Physiology 11 12 V002],[Biology 9 12 V002],[Biology 9 12 V003],[Biology 9 12 V007],[Chemistry 9 12 V001],[Chemistry 9 12 V002],[Chemistry 9 12 V003],[Chemistry 9 12 V008],[Economics 9 12 V001],[Economics 9 12 V004],[English Language Arts III Reading 11 11 V001],[English Language Arts III Reading 11 11 V002],[English Language Arts III Reading 11 11 V006],[English Language Arts III Writing 11 11 V001],[English Language Arts III Writing 11 11 V006],
 [English Language Arts III Writing 11 11 V002],[English Language Arts IV Reading 12 12 V001],[English Language Arts IV Reading 11 11 V003],[English Language Arts IV Writing 12 12 V001],[English Language Arts IV Writing 12 12 V003],[Environmental Science 10 12 V001],[Geometry 9 12 V003],[Financial Literacy 9 12 V003],[Health Education 6 12 V001],[Health Education 6 12 V002],[Integrated General Science 6 8 V001],[Introduction to Art 4 5 V001],[Introduction to Art 6 8 V001],[Introduction to Art 9 12 V001],[Music 4 5 V001],[Music 9 12 V001],
 [English III Writing V1],[English IV Reading V1],[Health V1],[Music 4-5  V1],[Music 9-12 V1],[NM History V1],[Physics 9 12 V003],[Pre-Calculus 9 12 V004],[Spanish I V1],[Spanish Language Arts III Reading V1],[Spanish Language Arts III Writing V1],
 [New Mexico History 7 12 V001],[NM History 7 12 V001],[New Mexico 7 12 History V001],[New Mexico 7 12 History V004],[Physical Education 4 5 V001],[Physical Education 6 8 V001],[Physical Education 9 12 V001],[Social Studies 6 6 V001],[Spanish I 7 12 V001],[Spanish Language Arts III Reading 11 11 V001],[Spanish Language Arts III Writing 11 11 V001],[US Government Comprehensive 9 12 V001],[US Government Comprehensive 9 12 V002],[US Government Comprehensive 9 12 V005],[US History 9 12 V001],[US History 9 12 V002],[US History 9 12 V007],[World History And Geography 9 12 V001],[World History And Geography 9 12 V003])) AS UP1
WHERE RN = 1
) AS EOC
 --ORDER BY [ID Number]
 --WHERE [ID nUMBER] = '102738911'
 --ROLLBACK
