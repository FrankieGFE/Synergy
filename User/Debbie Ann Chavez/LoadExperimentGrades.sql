
/*
USE ST_Experiment
GO

CREATE TABLE [dbo].[ExperimentGrades](
	ORGANIZATION_NAME [varchar](100) ,
	SIS_NUMBER [varchar] (100), 

	STUDENT_LAST_NAME[varchar](100) ,
	STUDENT_FIRST_NAME [varchar](100) ,
	--	GRADE [varchar](100) )
	COURSE_ID [varchar](100) ,
	SECTION_ID [varchar](100) ,
	COURSE_TITLE [varchar](100),
	
	TEACHER_AIDE [varchar](100) ,
	TEACHER_LAST_NAME [varchar](100) ,
	TEACHER_FIRST_NAME [varchar](100) ,
	EMAIL [varchar](100) ,
	[PERIOD] [varchar](100) ,
	GRADE_AS_OF_JAN9TH [varchar](100) ,
	VALUE [VARCHAR] (100) ,
	[SCHOOLYEAR] [varchar](100) ,
	COURSE_GU [varchar](100) ,
	SECTION_GU [varchar](100) ,
	PERSON_GU [varchar](100) 
	)
*/

DECLARE @GRADETEMP TABLE(
	MARK VARCHAR(5)
	,VALUE INT
)

INSERT INTO
	@GRADETEMP 
VALUES
('A+',100)
,('A',99)
,('A-',98)
,('B+',97)
,('B',96)
,('B-',95)
,('C+',94)
,('C',93)
,('C-',92)
,('D+',91)
,('D',90)
,('D-',89)
,('E',88)
,('P',87)

,('F',86)
,('WF',86)

,('N/A',85)
,('N',85)
,('I',85)
,('W',85)


INSERT INTO [ExperimentGrades]

SELECT * FROM 
(
SELECT

ORGANIZATION_NAME
,STUDENT.SIS_NUMBER

,PERSON.LAST_NAME AS STUDENT_LAST_NAME
,PERSON.FIRST_NAME AS STUDENT_FIRST_NAME

--,[GradeLevel].[VALUE_DESCRIPTION] AS GRADE

,COURSE_ID
,SECTION.SECTION_ID
, COURSE_TITLE
,CASE WHEN Class.TEACHER_AIDE = 'Y' AND MANUALSCORE = 'N/A' THEN 'DONTWANT' ELSE Class.TEACHER_AIDE END AS STU_TEACHER_AIDE

,STAFF.LAST_NAME AS TEACHER_LAST_NAME
,STAFF.FIRST_NAME AS TEACHER_FIRST_NAME
,STAFF.EMAIL

,[PERIOD]
--,[CALCULATEDSCORE]
,[MANUALSCORE] AS GRADE_AS_OF_JAN9TH
,MARKS.VALUE 

,[SCHOOLYEAR]
,CRS.COURSE_GU
,GRADES.SECTION_GU
,GRADES.PERSON_GU


  FROM [rev].[EGB_VIEWSTUDENTSECTIONMARK] AS GRADES
  INNER JOIN
  rev.REV_PERSON AS PERSON
  ON
  GRADES.PERSON_GU = PERSON.PERSON_GU
  INNER JOIN
  rev.EPC_STU AS STUDENT
  ON
  PERSON.PERSON_GU = STUDENT.STUDENT_GU
  INNER JOIN
  rev.EPC_SCH_YR_SECT AS SECTION
  ON
  GRADES.SECTION_GU = SECTION.SECTION_GU
  INNER JOIN
  rev.EPC_SCH_YR_CRS AS CRSYR
  ON
  SECTION.SCHOOL_YEAR_COURSE_GU = CRSYR.SCHOOL_YEAR_COURSE_GU
  INNER JOIN
  rev.EPC_CRS AS CRS
  ON
  CRSYR.COURSE_GU = CRS.COURSE_GU

  INNER JOIN
  rev.REV_ORGANIZATION_YEAR AS ORGYR
  ON
  ORGYR.ORGANIZATION_YEAR_GU = CRSYR.ORGANIZATION_YEAR_GU
  INNER JOIN
  rev.REV_ORGANIZATION AS ORG
  ON
  ORGYR.ORGANIZATION_GU = ORG.ORGANIZATION_GU
  
  INNER JOIN
  @GRADETEMP AS MARKS
  ON
  MARKS.MARK = GRADES.MANUALSCORE
  
  INNER JOIN
  rev.EPC_STU_SCH_YR AS SSY
  ON
  CRSYR.ORGANIZATION_YEAR_GU = SSY.ORGANIZATION_YEAR_GU
  AND SSY.STUDENT_GU = STUDENT.STUDENT_GU

  INNER JOIN
  rev.EPC_STAFF_SCH_YR AS STFYR
  ON
 SECTION.STAFF_SCHOOL_YEAR_GU = STFYR.STAFF_SCHOOL_YEAR_GU

  INNER JOIN
  rev.REV_PERSON AS STAFF
  ON
  STFYR.STAFF_GU = STAFF.PERSON_GU

 INNER JOIN
APS.LookupTable('K12','Grade') AS [GradeLevel]
ON
[SSY].[GRADE] = [GradeLevel].[VALUE_CODE]

 INNER JOIN
  APS.BasicSchedule AS SCH
  ON
  STUDENT.STUDENT_GU = SCH.STUDENT_GU
  AND SSY.STUDENT_SCHOOL_YEAR_GU = SCH.STUDENT_SCHOOL_YEAR_GU
  AND CRS.COURSE_GU = SCH.COURSE_GU
  AND SECTION.SECTION_GU = SCH.SECTION_GU
  
   INNER JOIN
  	rev.[EPC_STU_CLASS] AS [Class]
	ON
	Class.STUDENT_CLASS_GU = SCH.STUDENT_CLASS_GU
	
    
  WHERE
 --PERSON.PERSON_GU = 'A33C78F4-2C03-4434-8113-6280F7802499'
 --AND 
  SCHOOLYEAR = '2014-2015'
  AND PERIOD IN ('1st 6 Wk', '2nd 6 Wk', '3rd 6 Wk', 'S1 Exam', 'S1 Grade', 
  
  '1st 6 Wks', 'EXPL Q1 Exam', 'EXPL Q2 or S1 Exam', 'P1', 'P2', 'Q1', 'Q1 Exam', 'Q2', 'Q2 Exam', 'Sem Exam'
  )
  ) AS T1
  
  WHERE 
STU_TEACHER_AIDE ! = 'DONTWANT'
--  PERSON_GU = '1C9F7DB4-B486-411E-BC17-6CBC31684AE8'
 
