BEGIN TRAN

USE Assessments
GO
/****** Object:  StoredProcedure [dbo].execute [End_of_Course_FromSN_sp]    Script Date: 05/01/2014 10:53:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--ALTER Procedure [dbo].[End_of_Course_FromSN_sp] AS
/****
 
 * $LastChangedBy: Frank Garcia
 * $LastChangedDate: 05/01/2014 $
 *
 * Request By: SchoolNet
 * InitialRequestDate: 
 * 
 * Initial Request:
 * EoC on a daily bases
 * Tables Referenced:  EOC 
****/
TRUNCATE TABLE [SUMMER_EoC_]
GO
--DELETE
--FROM EOC_
--WHERE [test Date] = '2014-04-01'
DECLARE @SchoolYear nchar(10) = '2015'
DECLARE @Period nchar(10) = '2015-06-01'
INSERT INTO
	[SUMMER_EoC_]
	(
	[District Number]
	,[ID Number]
	,[Test ID]
	,[Subtest]
	,[School Year]
	,[test Date]
	,[School]
	,[Grade]
	,[Score1]
	,[Score2]
	,[Score3]
	,[DOB]
	,[last_name]
	,[first_name]
	,[SCH_YR]
	,full_name
	,assessment_id
	)
	

SELECT
	[District Number]
	,[ID Number]
	,[Test ID]
	,[Subtest]
	,[School Year]
	,[test date]
	,[School]
	,[Grade]
	,[Score1]
	,CASE
		WHEN cut_score IS NULL OR cut_score = '' THEN 'NO CUT SCORE'
		WHEN Score1 >= cut_score THEN 'PASS'
		ELSE 'FAIL'
	END  AS [Score2]
	,[Score3]
	,[DOB]
	,[last_name]
	,[first_name]
	,[SCH_YR]
	,full_name
	,assessment_id
FROM
(					
	SELECT 
		  ROW_NUMBER () OVER (PARTITION BY EOC.student_id, EOC.assessment_id ORDER BY CUT.assessment_test_date) AS RN
		  ,'001' AS [District Number]
		   ,EOC.student_id AS [ID Number]
		   ,'EOC' AS [Test ID]
		   ,CUT.STARS_name AS [Subtest]
		   ,CUT.assessment_test_date AS [test Date]
		   ,CUT.assessmnet_school_year AS [School Year]
		   ,STUD.school_code AS [School]
		   ,RIGHT ('00'+STUD.grade,2) AS [Grade]
		   ,RIGHT ('00' + PARSENAME (proficiency_score,2),2) AS Score1
		   ,proficiency_score AS SCORE11
		   --,RIGHT ('0'+LEFT ([proficiency_score], CHARINDEX ('.',[proficiency_score]) -1),1) AS [Score1]
		   --,RIGHT (PROFICIENCY_SCORE, CHARINDEX('.',proficiency_score)-1) AS Score1
		   --,CAST (proficiency_score AS VARCHAR (50)) as 'score'
		   --,REPLACE(RTRIM(LTRIM(REPLACE(proficiency_score,'00','.'))),'.','00') SCORE1
		   ,'' [Score2]
		   ,'' AS [Score3]
		   ,STUD.DOB AS DOB
		   ,STUD.last_name AS [last_name]
		   ,STUD.first_name AS [first_name]
		   ,CUT.assessmnet_school_year AS SCH_YR
		   ,EOC.student_name AS full_name
		   ,EOC.proficiency_score
		   ,CUT.cut_score
		   ,EOC.assessment_id
	  FROM [SUMMER_EOC] AS EOC
	  --LEFT JOIN
	  --[046-WS02].[db_STARS_History].dbo.STUDENT AS STUD
	  --ON
	  -- EOC.student_id = STUD.[ALTERNATE STUDENT ID]
	  -- AND STUD.Period = @Period
	  LEFT JOIN
	  allstudents_ALL AS STUD
	  ON STUD.student_code = EOC.student_id
	  AND STUD.school_year = '2014'
	  --AND STUD.school_code != '533'
	 LEFT JOIN
	 [EoC_Cut_Scores] AS CUT
		ON
		EOC.assessment_id = CUT.assessment_id
	  WHERE EOC.proficiency_measure = 'Overall Exam Score'
	  --AND EOC.assessment_id IN  ('8371', '8193', '8365', '8201', '8195','8374','8202','8373','8362','8368')
	  --and EOC.student_id = '104090774'
	  --and cut.assessment_name = 'NM History'
	  
) AS TI	  
WHERE RN = 1
--WHERE [ID Number] = '100003771'
ORDER BY Score1

ROLLBACK