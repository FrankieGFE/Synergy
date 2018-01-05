USE [Assessments]
GO
/****** Object:  StoredProcedure [dbo].EXECUTE [test_result_AP_sp]    Script Date: 8/17/2015 4:07:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[test_result_AP_sp] AS
/****
 
 * $LastChangedBy: Frank Garcia
 * $LastChangedDate: 7/27/2015 $
 *
 * Request By: SchoolNet
 * InitialRequestDate: 
 * 
 * Initial Request:
 * SchoolNet
 * test_result_ib
	
****/
TRUNCATE TABLE test_result_AP

DECLARE @TEST_DATE VARCHAR(50) = '2015-05-01'
DECLARE @SCH_YR VARCHAR(50) = '2014'
INSERT INTO test_result_AP

SELECT
student_code
,school_year
,school_code
,test_date_code
,test_type_code
,'AP Exam' AS test_type_name
--,CODE
--,SUBTEST
,CASE 
	WHEN CODE = '7' THEN '30'
	WHEN CODE = '38' THEN '13'
	WHEN CODE = '20' THEN '1'
	WHEN CODE = '22' THEN '99'
	WHEN CODE = '25' THEN '4'
	WHEN CODE = '28' THEN '36'
	WHEN CODE = '31' THEN '5'
	WHEN CODE = '33' THEN '38'
	WHEN CODE = '34' THEN '39'
	WHEN CODE = '35' THEN '6'
	WHEN CODE = '36' THEN '7'
	WHEN CODE = '37' THEN '8'
	WHEN CODE = '40' THEN '9'
	WHEN CODE = '43' THEN '10'
	WHEN CODE = '48' THEN '11'
	WHEN CODE = '53' THEN '15'
	WHEN CODE = '57' THEN '29'
	WHEN CODE = '58' THEN '93'
	WHEN CODE = '60' THEN '40'
	WHEN CODE = '62' THEN '16'
	WHEN CODE = '64' THEN '37'
	WHEN CODE = '66' THEN '2'
	WHEN CODE = '68' THEN '3'
	WHEN CODE = '69' THEN '62'
	WHEN CODE = '75' THEN '20'
	WHEN CODE = '76' THEN '60'
	WHEN CODE = '77' THEN '61'
	WHEN CODE = '80' THEN '23'
	WHEN CODE = '82' THEN '22'
	WHEN CODE = '78' THEN '21'
	WHEN CODE = '83' THEN '97'
	WHEN CODE = '84' THEN '96'
	WHEN CODE = '85' THEN '24'
	WHEN CODE = '87' THEN '25'
	WHEN CODE = '89' THEN '26'
	WHEN CODE = '90' THEN '27'
	WHEN CODE = '93' THEN '31'
	WHEN CODE = '16' THEN '34'
	WHEN CODE = '15' THEN '33'
	WHEN CODE = '14' THEN '35'
	WHEN CODE = '55' THEN '13'
	WHEN CODE = '13' THEN '38'
END AS test_section_code
,CASE 
	WHEN CODE = '7' THEN 'United States History'
	WHEN CODE = '13' THEN 'Art History'
	WHEN CODE = '20' THEN 'Biology'
	WHEN CODE = '22' THEN 'Seminar'
	WHEN CODE = '25' THEN 'Chemistry'
	WHEN CODE = '28' THEN 'Chinese Language and Culture'
	WHEN CODE = '31' THEN 'Computer Science A'
	WHEN CODE = '33' THEN 'Computer Science AB'
	WHEN CODE = '34' THEN 'Microeconomics'
	WHEN CODE = '35' THEN 'Macroeconomics'
	WHEN CODE = '36' THEN 'English Language and Composition'
	WHEN CODE = '37' THEN 'English Literature and Composition'
	WHEN CODE = '40' THEN 'Environmental Science'
	WHEN CODE = '43' THEN 'European History'
	WHEN CODE = '48' THEN 'French Language and Culture'
	WHEN CODE = '53' THEN 'Human Geography'
	WHEN CODE = '57' THEN 'United States Government and Politics'
	WHEN CODE = '58' THEN 'Comparative Government and Politics'
	WHEN CODE = '60' THEN 'Latin'
	WHEN CODE = '62' THEN 'Italian Language and Culture'
	WHEN CODE = '64' THEN 'Japanese Language and Culture'
	WHEN CODE = '66' THEN 'Calculus AB'
	WHEN CODE = '68' THEN 'Calculus BC'
	WHEN CODE = '69' THEN 'Calculus BC: AB Subscore'
	WHEN CODE = '75' THEN 'Music Theory'
	WHEN CODE = '76' THEN 'Music Aural Subscore'
	WHEN CODE = '77' THEN 'Music Non-Aural Subscore'
	WHEN CODE = '80' THEN 'Physics C: Mechanics'
	WHEN CODE = '82' THEN 'Physics C: Electricity and Magnetism'
	WHEN CODE = '78' THEN 'Physics B'
	WHEN CODE = '83' THEN 'Physics 1'
	WHEN CODE = '84' THEN 'Physics 2'
	WHEN CODE = '85' THEN 'Psychology'
	WHEN CODE = '87' THEN 'Spanish Language and Culture'
	WHEN CODE = '89' THEN 'Spanish Literature and Culture'
	WHEN CODE = '90' THEN 'Statistics'
	WHEN CODE = '93' THEN 'World History'
	WHEN CODE = '16' THEN 'Studio Art: 3-D Design Portfolio'
	WHEN CODE = '15' THEN 'Studio Art: 2-D Design Portfolio'
	WHEN CODE = '14' THEN 'Studio Art: Drawing Portfolio'
	WHEN CODE = '55' THEN 'German Language and Culture'
	WHEN CODE = '13' THEN '38'
END AS test_section_name
,'0' AS parent_test_section_code
,'09' AS low_test_level_code
,'12' AS high_test_level_code
,grade AS test_level_name
,version_code
,CASE 
	WHEN scaled_score IN ('3','4','5') THEN 'PASS'
	WHEN scaled_score IN ('1','2') THEN 'FAIL'
	ELSE 'N/A'
END AS score_group_name
,CASE 
	WHEN scaled_score IN ('3','4','5') THEN 'P'
	WHEN scaled_score IN ('1','2') THEN 'F'
	ELSE 'N/A'
END AS score_group_code
,score_group_lable
,last_name
,first_name
,DOB

,raw_score
,scaled_score
,[nce_score]
,[percentile_score]
,[score_1]
,[score_2]
,[score_3]
,[score_4]
,[score_5]
,[score_6]
,[score_7]
,[score_8]
,[score_9]
,[score_10]
,[score_11]
,[score_12]
,[score_13]
,[score_14]
,[score_15]
,[score_16]
,[score_17]
,[score_18]
,[score_19]
,[score_20]
,[score_21]
,[score_raw_name]
,[score_scaled_name]
,[score_nce_name]
,[score_percentile_name]
,[score_1_name]
,[score_2_name]
,[score_3_name]
,[score_4_name]
,[score_5_name]
,[score_6_name]
,[score_7_name]
,[score_8_name]
,[score_9_name]
,[score_10_name]
,[score_11_name]
,[score_12_name]
,[score_13_name]
,[score_14_name]
,[score_15_name]
,[score_16_name]
,[score_17_name]
,[score_18_name]
,[score_19_name]
,[score_20_name]
,[score_21_name]

FROM
(

SELECT
 student_code
,'2014' AS school_year
,school_code
,'2015-05-01' AS test_date_code
,'AP Exam' AS test_type_code
,'AP Exam' AS test_type_name
,grade AS test_level_name
,'' AS version_code

,'Performance Level' AS score_group_lable
,LAST_NAME AS last_name
,FIRST_NAME AS first_name
,grade
,DOB
,CODE
,'' AS raw_score
,CASE	
	WHEN SUBTEST = 'Exam Code 01' THEN [Exam Grade 01]
	WHEN SUBTEST = 'Exam Code 02' THEN [Exam Grade 02]
	WHEN SUBTEST = 'Exam Code 03' THEN [Exam Grade 03]
	WHEN SUBTEST = 'Exam Code 04' THEN [Exam Grade 04]
	WHEN SUBTEST = 'Exam Code 05' THEN [Exam Grade 05]
	WHEN SUBTEST = 'Exam Code 06' THEN [Exam Grade 06]
	WHEN SUBTEST = 'Exam Code 07' THEN [Exam Grade 07]
	WHEN SUBTEST = 'Exam Code 08' THEN [Exam Grade 08]
	WHEN SUBTEST = 'Exam Code 08' THEN [Exam Grade 09]
	WHEN SUBTEST = 'Exam Code 08' THEN [Exam Grade 10]
	WHEN SUBTEST = 'Exam Code 08' THEN [Exam Grade 11]
	WHEN SUBTEST = 'Exam Code 08' THEN [Exam Grade 12]
	WHEN SUBTEST = 'Exam Code 08' THEN [Exam Grade 13]
	WHEN SUBTEST = 'Exam Code 08' THEN [Exam Grade 14]
	WHEN SUBTEST = 'Exam Code 08' THEN [Exam Grade 15]
	WHEN SUBTEST = 'Exam Code 08' THEN [Exam Grade 16]
	WHEN SUBTEST = 'Exam Code 08' THEN [Exam Grade 17]
	WHEN SUBTEST = 'Exam Code 08' THEN [Exam Grade 18]
	WHEN SUBTEST = 'Exam Code 06' THEN [Exam Grade 19]
	WHEN SUBTEST = 'Exam Code 07' THEN [Exam Grade 20]
	WHEN SUBTEST = 'Exam Code 08' THEN [Exam Grade 21]
	WHEN SUBTEST = 'Exam Code 08' THEN [Exam Grade 22]
	WHEN SUBTEST = 'Exam Code 08' THEN [Exam Grade 23]
	WHEN SUBTEST = 'Exam Code 08' THEN [Exam Grade 24]
	WHEN SUBTEST = 'Exam Code 08' THEN [Exam Grade 25]
	WHEN SUBTEST = 'Exam Code 08' THEN [Exam Grade 26]
	WHEN SUBTEST = 'Exam Code 08' THEN [Exam Grade 27]
	WHEN SUBTEST = 'Exam Code 08' THEN [Exam Grade 28]
	WHEN SUBTEST = 'Exam Code 08' THEN [Exam Grade 29]
	WHEN SUBTEST = 'Exam Code 08' THEN [Exam Grade 30]
	ELSE ''
END AS scaled_score
--,'' AS scaled_score
,'' AS [nce_score]
,'' AS [percentile_score]
,'' AS [score_1]
,'' AS [score_2]
,'' AS [score_3]
,'' AS [score_4]
,'' AS [score_5]
,'' AS [score_6]
,'' AS [score_7]
,'' AS [score_8]
,'' AS [score_9]
,'' AS [score_10]
,'' AS [score_11]
,'' AS [score_12]
,'' AS [score_13]
,'' AS [score_14]
,'' AS [score_15]
,'' AS [score_16]
,'' AS [score_17]
,'' AS [score_18]
,'' AS [score_19]
,'' AS [score_20]
,'' AS [score_21]
,'' AS [score_raw_name]
,'Scale Score' AS [score_scaled_name]
,'' AS [score_nce_name]
,'' AS [score_percentile_name]
,'' AS [score_1_name]
,'' AS [score_2_name]
,'' AS [score_3_name]
,'' AS [score_4_name]
,'' AS [score_5_name]
,'' AS [score_6_name]
,'' AS [score_7_name]
,'' AS [score_8_name]
,'' AS [score_9_name]
,'' AS [score_10_name]
,'' AS [score_11_name]
,'' AS [score_12_name]
,'' AS [score_13_name]
,'' AS [score_14_name]
,'' AS [score_15_name]
,'' AS [score_16_name]
,'' AS [score_17_name]
,'' AS [score_18_name]
,'' AS [score_19_name]
,'' AS [score_20_name]
,'' AS [score_21_name]
,SUBTEST
FROM
--select * from
(
SELECT 
      [Date of Birth]
	  ,STUD.DOB
	  ,grade_code AS grade
      ,school_code
	  ,student_code
	  ,first_name
	  ,last_name

	  ,[Exam Code 01]
      ,[Exam Code 02]
      ,[Exam Code 03]
      ,[Exam Code 04]
      ,[Exam Code 05]
      ,[Exam Code 06]
      ,[Exam Code 08]
      ,[Exam Code 07]
      ,[Exam Code 09]
      ,[Exam Code 10]
      ,[Exam Code 11]
      ,[Exam Code 12]
      ,[Exam Code 13]
      ,[Exam Code 14]
      ,[Exam Code 15]
      ,[Exam Code 16]
      ,[Exam Code 17]
      ,[Exam Code 18]
      ,[Exam Code 19]
      ,[Exam Code 20]
      ,[Exam Code 21]
      ,[Exam Code 22]
      ,[Exam Code 23]
      ,[Exam Code 24]
      ,[Exam Code 25]
      ,[Exam Code 26]
      ,[Exam Code 27]
      ,[Exam Code 28]
      ,[Exam Code 29]
      ,[Exam Code 30]
	  ,[Exam Grade 01]
	  ,[Exam Grade 02]
	  ,[Exam Grade 03]
	  ,[Exam Grade 04]
	  ,[Exam Grade 05]
	  ,[Exam Grade 06]
	  ,[Exam Grade 07]
	  ,[Exam Grade 08]
	  ,[Exam Grade 09]
	  ,[Exam Grade 10]
	  ,[Exam Grade 11]
	  ,[Exam Grade 12]
	  ,[Exam Grade 13]
	  ,[Exam Grade 14]
	  ,[Exam Grade 15]
	  ,[Exam Grade 16]
	  ,[Exam Grade 17]
	  ,[Exam Grade 18]
	  ,[Exam Grade 19]
	  ,[Exam Grade 20]
	  ,[Exam Grade 21]
	  ,[Exam Grade 22]
	  ,[Exam Grade 23]
	  ,[Exam Grade 24]
	  ,[Exam Grade 25]
	  ,[Exam Grade 26]
	  ,[Exam Grade 27]
	  ,[Exam Grade 28]
	  ,[Exam Grade 29]
	  ,[Exam Grade 30]

  FROM AP AS AP
  LEFT JOIN
  ALLSTUDENTS AS STUD
  ON AP.[Student Identifier] = STUD.student_code

  
  ) AS T1
  UNPIVOT (CODE FOR SUBTEST IN 
	(
	   [Exam Code 01]
      ,[Exam Code 02]
      ,[Exam Code 03]
      ,[Exam Code 04]
      ,[Exam Code 05]
      ,[Exam Code 06]
      ,[Exam Code 07]
      ,[Exam Code 08]
      ,[Exam Code 09]
      ,[Exam Code 10]
      ,[Exam Code 11]
      ,[Exam Code 12]
      ,[Exam Code 13]
      ,[Exam Code 14]
      ,[Exam Code 15]
      ,[Exam Code 16]
      ,[Exam Code 17]
      ,[Exam Code 18]
      ,[Exam Code 19]
      ,[Exam Code 20]
      ,[Exam Code 21]
      ,[Exam Code 22]
      ,[Exam Code 23]
      ,[Exam Code 24]
      ,[Exam Code 25]
      ,[Exam Code 26]
      ,[Exam Code 27]
      ,[Exam Code 28]
      ,[Exam Code 29]
      ,[Exam Code 30]

	)) AS UPVT
  where CODE is not null and CODE != ''
) AS T2

WHERE student_code IS NOT NULL
AND scaled_score IS NOT NULL OR scaled_score != ''
ORDER BY scaled_score
  --LEFT JOIN
  --AP_Questions AS APQ
  --ON T2.SUBTEST = APQ.test_section_name
  --where student_code = '100039858'
  --where student_code > '1'

  --) AS T3
  --ORDER BY CODE