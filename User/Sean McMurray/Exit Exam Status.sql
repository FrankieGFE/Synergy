
DECLARE @STUDENTS
	TABLE
		(
		SIS_NUMBER VARCHAR (50)
		,STATE_ID VARCHAR (50)
		,SCHOOL_CODE VARCHAR (50)
		,LAST_NAME VARCHAR (50)
		,FIRST_NAME VARCHAR (501)
		,GRADE VARCHAR (50)
		)
INSERT INTO @STUDENTS
	SELECT 
	t1. 
		SIS_NUMBER
		,STATE_STUDENT_NUMBER AS STATE_ID
		,SCHOOL_CODE
		,LAST_NAME
		,FIRST_NAME
		,GRADE
	FROM
	(
SELECT * FROM (

SELECT 
	ENR.*
	,ROW_NUMBER() OVER (PARTITION BY ENR.STUDENT_GU ORDER BY ENTER_DATE DESC, EXCLUDE_ADA_ADM) AS RN
	,SIS_NUMBER
	,STATE_STUDENT_NUMBER
	,LAST_NAME
	,FIRST_NAME

 FROM 
APS.StudentEnrollmentDetails AS ENR
INNER JOIN 
rev.EPC_STU AS STU
ON
ENR.STUDENT_GU = STU.STUDENT_GU 
INNER JOIN
REV.REV_PERSON AS PER
ON PER.PERSON_GU = STU.STUDENT_GU

WHERE
SCHOOL_YEAR = (SELECT * FROM rev.SIF_22_Common_CurrentYear)
AND EXTENSION = 'R'
AND SUMMER_WITHDRAWL_CODE IS NULL
AND ENR.GRADE IN ('09', '10', '11', '12','C1', 'C2', 'C3', 'C4', 'T1', 'T2', 'T3', 'T4','H0','H1','H2','H3','H4','H5','H6','H7','H8','H9') 

) AS T1
WHERE
RN = 1 		
		
	)AS T1


DECLARE @SBA_READING
	TABLE
		(
		SIS_NUMBER VARCHAR (50)
		,TEST_NAME VARCHAR (50)
		,TEST VARCHAR (50)
		,SCALE_SCORE VARCHAR (50)
		,PL VARCHAR (50)
		
		)
INSERT INTO @SBA_READING
	

SELECT 
	SIS_NUMBER
	,TEST_NAME
	,TEST_PART AS TEST
	,SCALE_SCORE
	,PL
FROM APS.StudentTestSBA ('SBA HS 2011 Plus', 'READING')
	
DECLARE @SBA_MATH
	TABLE
		(
		SIS_NUMBER VARCHAR (50)
		,TEST_NAME VARCHAR (50)
		,TEST VARCHAR (50)
		,SCALE_SCORE VARCHAR (50)
		,PL VARCHAR (50)
		
		)
INSERT INTO @SBA_MATH
	

SELECT 
	SIS_NUMBER
	,TEST_NAME
	,TEST_PART AS TEST
	,SCALE_SCORE
	,PL
FROM APS.StudentTestSBA ('SBA HS 2011 Plus', 'MATH')

DECLARE @SBA_SCIENCE
	TABLE
		(
		SIS_NUMBER VARCHAR (50)
		,TEST_NAME VARCHAR (50)
		,TEST VARCHAR (50)
		,SCALE_SCORE VARCHAR (50)
		,PL VARCHAR (50)
		
		)
INSERT INTO @SBA_SCIENCE
	

SELECT 
	SIS_NUMBER
	,TEST_NAME
	,TEST_PART AS TEST
	,SCALE_SCORE
	,PL
FROM APS.StudentTestSBA ('SBA HS 2011 Plus', 'SCIENCE')

DECLARE @PARCC_ELA_11
	TABLE
		(
		SIS_NUMBER VARCHAR (50)
		,TEST_NAME VARCHAR (50)
		,TEST VARCHAR (50)
		,SCALE_SCORE VARCHAR (50)
		,PL VARCHAR (50)
		
		)
INSERT INTO @PARCC_ELA_11
	

SELECT 
		SIS_NUMBER
		,TEST_NAME 
		,TEST
		,SCALE_SCORE
		,PL
	
FROM
	APS.STUDENTTESTPARCC ('PARCC HS ELA/L English 11')

DECLARE @PARCC_GEOM
	TABLE
		(
		SIS_NUMBER VARCHAR (50)
		,TEST_NAME VARCHAR (50)
		,TEST VARCHAR (50)
		,SCALE_SCORE VARCHAR (50)
		,PL VARCHAR (50)
		
		)
INSERT INTO @PARCC_GEOM
	

SELECT 
		SIS_NUMBER
		,TEST_NAME 
		,TEST
		,SCALE_SCORE
		,PL
	
FROM
	APS.STUDENTTESTPARCC ('PARCC HS Geometry')

DECLARE @PARCC_ALG_II
	TABLE
		(
		SIS_NUMBER VARCHAR (50)
		,TEST_NAME VARCHAR (50)
		,TEST VARCHAR (50)
		,SCALE_SCORE VARCHAR (50)
		,PL VARCHAR (50)
		
		)
INSERT INTO @PARCC_ALG_II
	

SELECT 
	SIS_NUMBER
	,TEST_NAME
	,TEST
	,SCALE_SCORE
	,PL
	
FROM
	APS.STUDENTTESTPARCC ('PARCC HS Algebra II')

	DECLARE @SS_COUNT
		TABLE
		(
		SIS_NUMBER VARCHAR (50)
		,TEST VARCHAR (50)
		)


INSERT INTO @SS_COUNT
	

SELECT 
	 SIS_NUMBER
	,COUNT (PART_DESCRIPTION) AS TEST
FROM
(
SELECT 
	   PERSON.FIRST_NAME
       ,PERSON.LAST_NAME
       ,CAST (SIS_NUMBER AS INT) AS SIS_NUMBER
       ,TEST.TEST_NAME
	   ,PART.PART_DESCRIPTION
	   ,TEST.TEST_LEVEL
	   ,TEST.TEST_FORM
	   ,'' AS SCHOOL_YEAR
	   ,'' AS TEST_DESCRIPTION
	   ,TEST.TEST_TYPE
	   ,TEST.TEST_GROUP
	   ,TEST.TEST_DEF_CODE
       --,PART.PART_DESCRIPTION
       ,SCORE_DESCRIPTION
       ,STU_PART.PERFORMANCE_LEVEL
       ,SCORES.TEST_SCORE
       ,STUDENTTEST.ADMIN_DATE
       ,PART.PART_NUMBER
	   ,GradeLevel.ALT_CODE_2
FROM
       rev.EPC_STU_TEST AS StudentTest

       JOIN
       rev.EPC_TEST_PART AS PART
       ON StudentTest.TEST_GU = PART.TEST_GU

       JOIN
       rev.EPC_STU_TEST_PART AS STU_PART
       ON PART.TEST_PART_GU = STU_PART.TEST_PART_GU
       AND STU_PART.STUDENT_TEST_GU = StudentTest.STUDENT_TEST_GU

    INNER JOIN
    rev.EPC_STU_TEST_PART_SCORE AS SCORES
    ON
    SCORES.STU_TEST_PART_GU = STU_PART.STU_TEST_PART_GU

    LEFT JOIN
    rev.EPC_TEST_SCORE_TYPE AS SCORET
    ON
    SCORET.TEST_GU = StudentTest.TEST_GU
    AND SCORES.TEST_SCORE_TYPE_GU = SCORET.TEST_SCORE_TYPE_GU

    LEFT JOIN
    rev.EPC_TEST_DEF_SCORE AS SCORETDEF
    ON
    SCORETDEF.TEST_DEF_SCORE_GU = SCORET.TEST_DEF_SCORE_GU

       LEFT JOIN
       rev.EPC_TEST AS TEST
       ON TEST.TEST_GU = StudentTest.TEST_GU

       INNER JOIN
       rev.EPC_STU AS Student
       ON Student.STUDENT_GU = StudentTest.STUDENT_GU

       INNER JOIN
       rev.REV_PERSON AS Person
       ON Person.PERSON_GU = StudentTest.STUDENT_GU

       LEFT JOIN
       APS.PrimaryEnrollmentsAsOf(GETDATE()) AS Enroll
       ON
       StudentTest.STUDENT_GU = Enroll.STUDENT_GU

       LEFT JOIN
       rev.REV_ORGANIZATION_YEAR AS OrgYear
       ON
       Enroll.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

       LEFT JOIN
       rev.REV_ORGANIZATION AS Org
       ON
       OrgYear.ORGANIZATION_GU = Org.ORGANIZATION_GU

       LEFT JOIN
       APS.LookupTable('K12','Grade') AS GradeLevel
       ON
       Enroll.GRADE = GradeLevel.VALUE_CODE


WHERE
       TEST_NAME LIKE 'EOC%'
	   and PART_DESCRIPTION LIKE ('%HIST%') OR PART_DESCRIPTION LIKE ('%GOVER%') OR PART_DESCRIPTION LIKE ('%ECON%')


) AS T1
GROUP BY SIS_NUMBER
ORDER BY SIS_NUMBER

DECLARE @WR_CNTS
	TABLE
		(
		SIS_NUMBER VARCHAR (50)
		,TEST VARCHAR (50)

		
		)
INSERT INTO @WR_CNTS
	

SELECT 
	 SIS_NUMBER
	,COUNT (PART_DESCRIPTION) AS TEST
FROM
(
SELECT 
	   PERSON.FIRST_NAME
       ,PERSON.LAST_NAME
       ,CAST (SIS_NUMBER AS INT) AS SIS_NUMBER
       ,TEST.TEST_NAME
	   ,PART.PART_DESCRIPTION
	   ,TEST.TEST_LEVEL
	   ,TEST.TEST_FORM
	   ,'' AS SCHOOL_YEAR
	   ,'' AS TEST_DESCRIPTION
	   ,TEST.TEST_TYPE
	   ,TEST.TEST_GROUP
	   ,TEST.TEST_DEF_CODE
       --,PART.PART_DESCRIPTION
       ,SCORE_DESCRIPTION
       ,STU_PART.PERFORMANCE_LEVEL
       ,SCORES.TEST_SCORE
       ,STUDENTTEST.ADMIN_DATE
       ,PART.PART_NUMBER
	   ,GradeLevel.ALT_CODE_2
FROM
       rev.EPC_STU_TEST AS StudentTest

       JOIN
       rev.EPC_TEST_PART AS PART
       ON StudentTest.TEST_GU = PART.TEST_GU

       JOIN
       rev.EPC_STU_TEST_PART AS STU_PART
       ON PART.TEST_PART_GU = STU_PART.TEST_PART_GU
       AND STU_PART.STUDENT_TEST_GU = StudentTest.STUDENT_TEST_GU

    INNER JOIN
    rev.EPC_STU_TEST_PART_SCORE AS SCORES
    ON
    SCORES.STU_TEST_PART_GU = STU_PART.STU_TEST_PART_GU

    LEFT JOIN
    rev.EPC_TEST_SCORE_TYPE AS SCORET
    ON
    SCORET.TEST_GU = StudentTest.TEST_GU
    AND SCORES.TEST_SCORE_TYPE_GU = SCORET.TEST_SCORE_TYPE_GU

    LEFT JOIN
    rev.EPC_TEST_DEF_SCORE AS SCORETDEF
    ON
    SCORETDEF.TEST_DEF_SCORE_GU = SCORET.TEST_DEF_SCORE_GU

       LEFT JOIN
       rev.EPC_TEST AS TEST
       ON TEST.TEST_GU = StudentTest.TEST_GU

       INNER JOIN
       rev.EPC_STU AS Student
       ON Student.STUDENT_GU = StudentTest.STUDENT_GU

       INNER JOIN
       rev.REV_PERSON AS Person
       ON Person.PERSON_GU = StudentTest.STUDENT_GU

       LEFT JOIN
       APS.PrimaryEnrollmentsAsOf(GETDATE()) AS Enroll
       ON
       StudentTest.STUDENT_GU = Enroll.STUDENT_GU

       LEFT JOIN
       rev.REV_ORGANIZATION_YEAR AS OrgYear
       ON
       Enroll.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

       LEFT JOIN
       rev.REV_ORGANIZATION AS Org
       ON
       OrgYear.ORGANIZATION_GU = Org.ORGANIZATION_GU

       LEFT JOIN
       APS.LookupTable('K12','Grade') AS GradeLevel
       ON
       Enroll.GRADE = GradeLevel.VALUE_CODE
WHERE
       TEST_NAME LIKE 'EOC%'
	   and PART_DESCRIPTION LIKE ('%WRIT%')
) AS T1
GROUP BY SIS_NUMBER
ORDER BY SIS_NUMBER

DECLARE @EOC_HIST
	TABLE
		(
	SIS_NUMBER NVARCHAR (50)
	,[Algebra I 7 12 V001] NVARCHAR (50)
	,[Algebra I 7 12 V003] NVARCHAR (50)
	,[Algebra II 10 12 V002] NVARCHAR (50)
	,[Algebra II 10 12 V006] NVARCHAR (50)
	,[Anatomy Physiology 11 12 V002] NVARCHAR (50)
	,[Biology 9 12 V002] NVARCHAR (50)
	,[Biology 9 12 V003] NVARCHAR (50)
	,[Biology 9 12 V007] NVARCHAR (50)
	,[Chemistry 9 12 V001] NVARCHAR (50)
	,[Chemistry 9 12 V002] NVARCHAR (50)
	,[Chemistry 9 12 V003] NVARCHAR (50)
	,[Chemistry 9 12 V008] NVARCHAR (50)
	,[Economics 9 12 V001] NVARCHAR (50)
	,[Economics 9 12 V004] NVARCHAR (50)
	,[English Language Arts III Reading 11 11 V001] NVARCHAR (50)
	,[English Language Arts III Reading 11 11 V002] NVARCHAR (50)
	,[English Language Arts III Reading 11 11 V006] NVARCHAR (50)
	,[English Language Arts III Writing 11 11 V001] NVARCHAR (50)
	,[English Language Arts III Writing 11 11 V002] NVARCHAR (50)
	,[English Language Arts III Writing 11 11 V006] NVARCHAR (50)
	,[English Language Arts IV Reading 11 11 V003] NVARCHAR (50)
	,[English Language Arts IV Reading 12 12 V001] NVARCHAR (50)
	,[English Language Arts IV Writing 12 12 V001] NVARCHAR (50)
	,[English Language Arts IV Writing 12 12 V003] NVARCHAR (50)
	,[Geometry 9 12 V003] NVARCHAR (50)
	,[New Mexico History 7 12 V001] NVARCHAR (50)
	,[New Mexico 7 12 History V004] NVARCHAR (50)
	,[New Mexico 7 12 History V001] NVARCHAR (50)
	,[Physics 9 12 V003] NVARCHAR (50)
	,[Pre-Calculus 9 12 V004] NVARCHAR (50)
	,[Spanish Language Arts III Reading 11 11 V001] NVARCHAR (50)
	,[Spanish Language Arts III Writing 11 11 V001] NVARCHAR (50)
	,[US Government Comprehensive 9 12 V001] NVARCHAR (50)
	,[US Government Comprehensive 9 12 V002] NVARCHAR (50)
	,[US Government Comprehensive 9 12 V005] NVARCHAR (50)
	,[US History 9 12 V001] NVARCHAR (50)
	,[US History 9 12 V002] NVARCHAR (50)
	,[US History 9 12 V007] NVARCHAR (50)
	,[World History And Geography 9 12 V001] NVARCHAR (50)
	,[World History And Geography 9 12 V003] NVARCHAR (50)
	,[Environmental Science 10 12 V001] NVARCHAR (50)
	,[Financial Literacy 9 12 V003] NVARCHAR (50)

		
		)
INSERT INTO @EOC_HIST
	

SELECT
	SIS_NUMBER
	,CASE WHEN [Algebra I 7 12 V001] IS NULL THEN '' ELSE CASE WHEN [Algebra I 7 12 V001] >= '18' THEN 'PASS' ELSE 'FAIL' END END AS [Algebra I 7 12 V001]
	,CASE WHEN [Algebra I 7 12 V003] IS NULL THEN '' ELSE CASE WHEN [Algebra I 7 12 V003] >= '18' THEN 'PASS' ELSE 'FAIL' END END AS [Algebra I 7 12 v003]
	,CASE WHEN [Algebra II 10 12 V002] IS NULL THEN '' ELSE CASE WHEN  [Algebra II 10 12 V002] >= '14' THEN 'PASS' ELSE 'FAIL' END END AS [Algebra II 10 12 V002]
	,CASE WHEN [Algebra II 10 12 V006] IS NULL THEN '' ELSE CASE WHEN [Algebra II 10 12 V006] >= '14' THEN 'PASS' ELSE 'FAIL' END END AS [Algebra II 10 12 V006]
	,CASE WHEN [Anatomy Physiology 11 12 V002] IS NULL THEN '' ELSE CASE WHEN [Anatomy Physiology 11 12 V002] >= '26' THEN 'PASS' ELSE 'FAIL' END END AS [Anatomy Physiology 11 12 V002]
	,CASE WHEN [Biology 9 12 V002] IS NULL THEN '' ELSE CASE WHEN [Biology 9 12 V002] >= '22' THEN 'PASS' ELSE 'FAIL' END END AS [Biology 9 12 V002]
	,CASE WHEN [Biology 9 12 V003] IS NULL THEN '' ELSE CASE WHEN [Biology 9 12 V003] >= '27' THEN 'PASS' ELSE 'FAIL' END END AS [Biology 9 12 V003]
	,CASE WHEN [Biology 9 12 V007] IS NULL THEN '' ELSE CASE WHEN [Biology 9 12 V007] >= '27' THEN 'PASS' ELSE 'FAIL' END END AS [Biology 9 12 V007]
	,CASE WHEN [Chemistry 9 12 V001] IS NULL THEN '' ELSE CASE WHEN [Chemistry 9 12 V001] >= '13' THEN 'PASS' ELSE 'FAIL' END END AS [Chemistry 9 12 V001]
	,CASE WHEN [Chemistry 9 12 V002] IS NULL THEN '' ELSE CASE WHEN [Chemistry 9 12 V002] >= '13' THEN 'PASS' ELSE 'FAIL' END END AS [Chemistry 9 12 V002]
	,CASE WHEN [Chemistry 9 12 V003] IS NULL THEN '' ELSE CASE WHEN [Chemistry 9 12 V003] >= '24' THEN 'PASS' ELSE 'FAIL' END END AS [Chemistry 9 12 V003]
	,CASE WHEN [Chemistry 9 12 V008] IS NULL THEN '' ELSE CASE WHEN [Chemistry 9 12 V008] >= '18' THEN 'PASS' ELSE 'FAIL' END END AS [Chemistry 9 12 V008]
	,CASE WHEN [Economics 9 12 V001] IS NULL THEN '' ELSE CASE WHEN [Economics 9 12 V001] >= '23' THEN 'PASS' ELSE 'FAIL' END END AS [Economics 9 12 V001]
	,CASE WHEN [Economics 9 12 V004] IS NULL THEN '' ELSE CASE WHEN [Economics 9 12 V004] >= '23' THEN 'PASS' ELSE 'FAIL' END END AS [Economics 9 12 V004]
	,CASE WHEN [English Language Arts III Reading 11 11 V001] IS NULL THEN '' ELSE CASE WHEN [English Language Arts III Reading 11 11 V001] >= '25' THEN 'PASS' ELSE 'FAIL' END END AS [English Language Arts III Reading 11 11 V001]
	,CASE WHEN [English Language Arts III Reading 11 11 V002] IS NULL THEN '' ELSE CASE WHEN [English Language Arts III Reading 11 11 V002] >= '14' THEN 'PASS' ELSE 'FAIL' END END AS [English Language Arts III Reading 11 11 V002]
	,CASE WHEN [English Language Arts III Reading 11 11 V006] IS NULL THEN '' ELSE CASE WHEN [English Language Arts III Reading 11 11 V006] >= '14' THEN 'PASS' ELSE 'FAIL' END END AS [English Language Arts III Reading 11 11 V006]
	,CASE WHEN [English Language Arts III Writing 11 11 V001] IS NULL THEN '' ELSE CASE WHEN [English Language Arts III Writing 11 11 V001] >= '15' THEN 'PASS' ELSE 'FAIL' END END AS [English Language Arts III Writing 11 11 V001]
	,CASE WHEN [English Language Arts III Writing 11 11 V002] IS NULL THEN '' ELSE CASE WHEN [English Language Arts III Writing 11 11 V002] >= '24' THEN 'PASS' ELSE 'FAIL' END END AS [English Language Arts III Writing 11 11 V002]
	,CASE WHEN [English Language Arts III Writing 11 11 V006] IS NULL THEN '' ELSE CASE WHEN [English Language Arts III Writing 11 11 V006] >= '24' THEN 'PASS' ELSE 'FAIL' END END AS [English Language Arts III Writing 11 11 V006]
	,CASE WHEN [English Language Arts IV Reading 11 11 V003] IS NULL THEN '' ELSE CASE WHEN [English Language Arts IV Reading 11 11 V003] >= '15' THEN 'PASS' ELSE 'FAIL' END END AS [English Language Arts IV Reading 11 11 V003]
	,CASE WHEN [English Language Arts IV Reading 12 12 V001] IS NULL THEN '' ELSE CASE WHEN [English Language Arts IV Reading 12 12 V001] >= '15' THEN 'PASS' ELSE 'FAIL' END END AS [English Language Arts IV Reading 12 12 V001]
	,CASE WHEN [English Language Arts IV Writing 12 12 V001] IS NULL THEN '' ELSE CASE WHEN [English Language Arts IV Writing 12 12 V001] >= '26' THEN 'PASS' ELSE 'FAIL' END END AS [English Language Arts IV Writing 12 12 V001]
	,CASE WHEN [English Language Arts IV Writing 12 12 V003] IS NULL THEN '' ELSE CASE WHEN [English Language Arts IV Writing 12 12 V003] >= '26' THEN 'PASS' ELSE 'FAIL' END END AS [English Language Arts IV Writing 12 12 V003]
	,CASE WHEN [Geometry 9 12 V003] IS NULL THEN '' ELSE CASE WHEN [Geometry 9 12 V003] >= '18' THEN 'PASS' ELSE 'FAIL' END END AS [Geometry 9 12 V003]
	,CASE WHEN [New Mexico History 7 12 V001] IS NULL THEN '' ELSE CASE WHEN [New Mexico History 7 12 V001] >= '18' THEN 'PASS' ELSE 'FAIL' END END AS [New Mexico History 7 12 V001]
	,CASE WHEN [New Mexico 7 12 History V004] IS NULL THEN '' ELSE CASE WHEN [New Mexico 7 12 History V004] >= '18' THEN 'PASS' ELSE 'FAIL' END END AS [New Mexico 7 12 History V004]
	,CASE WHEN [New Mexico 7 12 History V001] IS NULL THEN '' ELSE CASE WHEN [New Mexico 7 12 History V001] >= '18' THEN 'PASS' ELSE 'FAIL' END END AS [New Mexico 7 12 History V001]
	,CASE WHEN [Physics 9 12 V003] IS NULL THEN '' ELSE CASE WHEN [Physics 9 12 V003] >= '24' THEN 'PASS' ELSE 'FAIL' END END AS [Physics 9 12 V003]
	,CASE WHEN [Pre-Calculus 9 12 V004] IS NULL THEN '' ELSE CASE WHEN [Pre-Calculus 9 12 V004] >= '16' THEN 'PASS' ELSE 'FAIL' END END AS [Pre-Calculus 9 12 V004]
	,CASE WHEN [Spanish Language Arts III Reading 11 11 V001] IS NULL THEN '' ELSE CASE WHEN [Spanish Language Arts III Reading 11 11 V001] >= '14' THEN 'PASS' ELSE 'FAIL' END END AS [Spanish Language Arts III Reading 11 11 V001]
	,CASE WHEN [Spanish Language Arts III Writing 11 11 V001] IS NULL THEN '' ELSE CASE WHEN [Spanish Language Arts III Writing 11 11 V001] >= '15' THEN 'PASS' ELSE 'FAIL' END END AS [Spanish Language Arts III Writing 11 11 V001]
	,CASE WHEN [US Government Comprehensive 9 12 V001] IS NULL THEN '' ELSE CASE WHEN [US Government Comprehensive 9 12 V001] >= '24' THEN 'PASS' ELSE 'FAIL' END END AS [US Government Comprehensive 9 12 V001]
	,CASE WHEN [US Government Comprehensive 9 12 V002] IS NULL THEN '' ELSE CASE WHEN [US Government Comprehensive 9 12 V002] >= '24' THEN 'PASS' ELSE 'FAIL' END END AS [US Government Comprehensive 9 12 V002]
	,CASE WHEN [US Government Comprehensive 9 12 V005] IS NULL THEN '' ELSE CASE WHEN [US Government Comprehensive 9 12 V005] >= '24' THEN 'PASS' ELSE 'FAIL' END END AS [US Government Comprehensive 9 12 V005]
	,CASE WHEN [US History 9 12 V001] IS NULL THEN '' ELSE CASE WHEN [US History 9 12 V001] >= '26' THEN 'PASS' ELSE 'FAIL' END END AS [US History 9 12 V001]
	,CASE WHEN [US History 9 12 V002] IS NULL THEN '' ELSE CASE WHEN [US History 9 12 V002] >= '31' THEN 'PASS' ELSE 'FAIL' END END AS [US History 9 12 V002]
	,CASE WHEN [US History 9 12 V007] IS NULL THEN '' ELSE CASE WHEN [US History 9 12 V007] >= '31' THEN 'PASS' ELSE 'FAIL' END END AS [US History 9 12 V007]
	,CASE WHEN [World History And Geography 9 12 V001] IS NULL THEN '' ELSE CASE WHEN [World History And Geography 9 12 V001] >= '25' THEN 'PASS' ELSE 'FAIL' END END AS[World History And Geography 9 12 V001]
	,CASE WHEN [World History And Geography 9 12 V003] IS NULL THEN '' ELSE CASE WHEN [World History And Geography 9 12 V003] >= '25' THEN 'PASS' ELSE 'FAIL' END END AS [World History And Geography 9 12 V003]
	,CASE WHEN [Environmental Science 10 12 V001] IS NULL THEN '' ELSE CASE WHEN [Environmental Science 10 12 V001] >= '26' THEN 'PASS' ELSE 'FAIL' END END AS[Environmental Science 10 12 V001]
	,CASE WHEN [Financial Literacy 9 12 V003] IS NULL THEN '' ELSE CASE WHEN [Financial Literacy 9 12 V003] >= '12' THEN 'PASS' ELSE 'FAIL' END END AS [Financial Literacy 9 12 V003]
FROM
(
SELECT 
       CAST (SIS_NUMBER AS INT) AS SIS_NUMBER
	   ,PART.PART_DESCRIPTION
       ,SCORES.TEST_SCORE
FROM
       rev.EPC_STU_TEST AS StudentTest

       JOIN
       rev.EPC_TEST_PART AS PART
       ON StudentTest.TEST_GU = PART.TEST_GU

       JOIN
       rev.EPC_STU_TEST_PART AS STU_PART
       ON PART.TEST_PART_GU = STU_PART.TEST_PART_GU
       AND STU_PART.STUDENT_TEST_GU = StudentTest.STUDENT_TEST_GU

    INNER JOIN
    rev.EPC_STU_TEST_PART_SCORE AS SCORES
    ON
    SCORES.STU_TEST_PART_GU = STU_PART.STU_TEST_PART_GU

    LEFT JOIN
    rev.EPC_TEST_SCORE_TYPE AS SCORET
    ON
    SCORET.TEST_GU = StudentTest.TEST_GU
    AND SCORES.TEST_SCORE_TYPE_GU = SCORET.TEST_SCORE_TYPE_GU

    LEFT JOIN
    rev.EPC_TEST_DEF_SCORE AS SCORETDEF
    ON
    SCORETDEF.TEST_DEF_SCORE_GU = SCORET.TEST_DEF_SCORE_GU

       LEFT JOIN
       rev.EPC_TEST AS TEST
       ON TEST.TEST_GU = StudentTest.TEST_GU

       INNER JOIN
       rev.EPC_STU AS Student
       ON Student.STUDENT_GU = StudentTest.STUDENT_GU

       INNER JOIN
       rev.REV_PERSON AS Person
       ON Person.PERSON_GU = StudentTest.STUDENT_GU

       LEFT JOIN
       APS.PrimaryEnrollmentsAsOf(GETDATE()) AS Enroll
       ON
       StudentTest.STUDENT_GU = Enroll.STUDENT_GU

       LEFT JOIN
       rev.REV_ORGANIZATION_YEAR AS OrgYear
       ON
       Enroll.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

       LEFT JOIN
       rev.REV_ORGANIZATION AS Org
       ON
       OrgYear.ORGANIZATION_GU = Org.ORGANIZATION_GU

       LEFT JOIN
       APS.LookupTable('K12','Grade') AS GradeLevel
       ON
       Enroll.GRADE = GradeLevel.VALUE_CODE

WHERE
       TEST_NAME LIKE 'EOC%'
	   --and PART_DESCRIPTION LIKE ('%HIST%') OR PART_DESCRIPTION LIKE ('%GOVER%') OR PART_DESCRIPTION LIKE ('%ECON%')
--       AND SIS_NUMBER = '102955598'
       --AND SCORE_DESCRIPTION IN ('Scale')
--GROUP BY

) AS T1
PIVOT
	(MAX ([TEST_SCORE]) FOR PART_DESCRIPTION IN 
		(
								[Algebra I 7 12 V001]
								,[Algebra I 7 12 V003]
								,[Algebra II 10 12 V002]
								,[Algebra II 10 12 V006]
								,[Anatomy Physiology 11 12 V002]
								,[Biology 9 12 V002]
								,[Biology 9 12 V003]
								,[Biology 9 12 V007]
								,[Chemistry 9 12 V001]
								,[Chemistry 9 12 V002]
								,[Chemistry 9 12 V003]
								,[Chemistry 9 12 V008]
								,[Economics 9 12 V001]
								,[Economics 9 12 V004]
								,[English Language Arts III Reading 11 11 V001]
								,[English Language Arts III Reading 11 11 V002]
								,[English Language Arts III Reading 11 11 V006]
								,[English Language Arts III Writing 11 11 V001]
								,[English Language Arts III Writing 11 11 V002]
								,[English Language Arts III Writing 11 11 V006]
								,[English Language Arts IV Reading 11 11 V003]
								,[English Language Arts IV Reading 12 12 V001]
								,[English Language Arts IV Writing 12 12 V001]
								,[English Language Arts IV Writing 12 12 V003]
								,[Health Education 6 12 V001]
								,[Health Education 6 12 V002]
								,[Geometry 9 12 V003]
								,[New Mexico History 7 12 V001]
								,[New Mexico 7 12 History V004]
								,[New Mexico 7 12 History V001]
								,[Physics 9 12 V003]
								,[Pre-Calculus 9 12 V004]
								,[Spanish Language Arts III Reading 11 11 V001]
								,[Spanish Language Arts III Writing 11 11 V001]
								,[US Government Comprehensive 9 12 V001]
								,[US Government Comprehensive 9 12 V002]
								,[US Government Comprehensive 9 12 V005]
								,[US History 9 12 V001]
								,[US History 9 12 V002]
								,[US History 9 12 V007]
								,[World History And Geography 9 12 V001]
								,[World History And Geography 9 12 V003]
								,[Environmental Science 10 12 V001]
								,[Financial Literacy 9 12 V003]
								)) AS UP1

DECLARE @SBA_CNTS
	TABLE
		(
		SIS_NUMBER VARCHAR (50)
		,MATH VARCHAR (50)
		,SCIENCE VARCHAR (50)
		,READING VARCHAR (50)
		)
INSERT INTO @SBA_CNTS
	

SELECT 
	STUD_ID AS SIS_NUMBER
	,MATH
	,SCIENCE
	,CAST(READING AS INT) + CAST([READING(S)] AS INT) AS READING
	
FROM
(
SELECT 
       CAST (SIS_NUMBER AS INT) AS SIS_NUMBER
	   ,SIS_NUMBER AS STUD_ID
	   ,PART.PART_DESCRIPTION
       ,SCORE_DESCRIPTION
FROM
       rev.EPC_STU_TEST AS StudentTest

       JOIN
       rev.EPC_TEST_PART AS PART
       ON StudentTest.TEST_GU = PART.TEST_GU

       JOIN
       rev.EPC_STU_TEST_PART AS STU_PART
       ON PART.TEST_PART_GU = STU_PART.TEST_PART_GU
       AND STU_PART.STUDENT_TEST_GU = StudentTest.STUDENT_TEST_GU

    INNER JOIN
    rev.EPC_STU_TEST_PART_SCORE AS SCORES
    ON
    SCORES.STU_TEST_PART_GU = STU_PART.STU_TEST_PART_GU

    LEFT JOIN
    rev.EPC_TEST_SCORE_TYPE AS SCORET
    ON
    SCORET.TEST_GU = StudentTest.TEST_GU
    AND SCORES.TEST_SCORE_TYPE_GU = SCORET.TEST_SCORE_TYPE_GU

    LEFT JOIN
    rev.EPC_TEST_DEF_SCORE AS SCORETDEF
    ON
    SCORETDEF.TEST_DEF_SCORE_GU = SCORET.TEST_DEF_SCORE_GU

       LEFT JOIN
       rev.EPC_TEST AS TEST
       ON TEST.TEST_GU = StudentTest.TEST_GU

       INNER JOIN
       rev.EPC_STU AS Student
       ON Student.STUDENT_GU = StudentTest.STUDENT_GU

       INNER JOIN
       rev.REV_PERSON AS Person
       ON Person.PERSON_GU = StudentTest.STUDENT_GU

       LEFT JOIN
       APS.PrimaryEnrollmentsAsOf(GETDATE()) AS Enroll
       ON
       StudentTest.STUDENT_GU = Enroll.STUDENT_GU

       LEFT JOIN
       rev.REV_ORGANIZATION_YEAR AS OrgYear
       ON
       Enroll.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

       LEFT JOIN
       rev.REV_ORGANIZATION AS Org
       ON
       OrgYear.ORGANIZATION_GU = Org.ORGANIZATION_GU

       LEFT JOIN
       APS.LookupTable('K12','Grade') AS GradeLevel
       ON
       Enroll.GRADE = GradeLevel.VALUE_CODE


WHERE
       1 = 1
	   AND TEST_NAME = 'SBA HS 2011 Plus'
	   AND (PART_DESCRIPTION = 'READING' OR PART_DESCRIPTION = 'MATH' OR PART_DESCRIPTION = 'SCIENCE' OR PART_DESCRIPTION = 'READING(S)'  OR PART_DESCRIPTION = 'WRITING')
       AND SCORE_DESCRIPTION = 'Scale'
) AS T1
PIVOT
	(
	COUNT (SIS_NUMBER) FOR PART_DESCRIPTION IN ([MATH], [READING],[READING(S)], [SCIENCE])) AS COUNTS 
DECLARE @PARCC_CNTS
	TABLE
		(
		SIS_NUMBER VARCHAR (50)
		,MATH VARCHAR (50)
		--,SCIENCE VARCHAR (50)
		,READING VARCHAR (50)
		)
INSERT INTO @PARCC_CNTS

SELECT 
		STUD_ID AS SIS_NUMBER
	   ,CAST([PARCC HS Geometry] AS INT) + CAST([PARCC HS ALGEBRA II] AS INT) AS MATH
       ,[ELA/L English 11] AS READING
	
FROM
(
SELECT 
       CAST (SIS_NUMBER AS INT) AS SIS_NUMBER
	   ,SIS_NUMBER AS STUD_ID
	   ,PART.PART_DESCRIPTION

FROM
       rev.EPC_STU_TEST AS StudentTest

       JOIN
       rev.EPC_TEST_PART AS PART
       ON StudentTest.TEST_GU = PART.TEST_GU

       JOIN
       rev.EPC_STU_TEST_PART AS STU_PART
       ON PART.TEST_PART_GU = STU_PART.TEST_PART_GU
       AND STU_PART.STUDENT_TEST_GU = StudentTest.STUDENT_TEST_GU

		INNER JOIN
		rev.EPC_STU_TEST_PART_SCORE AS SCORES
		ON
		SCORES.STU_TEST_PART_GU = STU_PART.STU_TEST_PART_GU

		LEFT JOIN
		rev.EPC_TEST_SCORE_TYPE AS SCORET
		ON
		SCORET.TEST_GU = StudentTest.TEST_GU
		AND SCORES.TEST_SCORE_TYPE_GU = SCORET.TEST_SCORE_TYPE_GU

		LEFT JOIN
		rev.EPC_TEST_DEF_SCORE AS SCORETDEF
		ON
		SCORETDEF.TEST_DEF_SCORE_GU = SCORET.TEST_DEF_SCORE_GU

       LEFT JOIN
       rev.EPC_TEST AS TEST
       ON TEST.TEST_GU = StudentTest.TEST_GU

       INNER JOIN
       rev.EPC_STU AS Student
       ON Student.STUDENT_GU = StudentTest.STUDENT_GU

       INNER JOIN
       rev.REV_PERSON AS Person
       ON Person.PERSON_GU = StudentTest.STUDENT_GU

WHERE
       TEST_NAME IN ('PARCC HS ELA/L English 11','PARCC HS Geometry','PARCC HS ALGEBRA II')

) AS T1
PIVOT
	(COUNT (SIS_NUMBER) FOR PART_DESCRIPTION IN ([PARCC HS Geometry],[PARCC HS Algebra II],[ELA/L English 11])) AS PARCC_CNT


DECLARE @EOC_SBA_AND_EOC
	TABLE
		(
		SIS_NUMBER VARCHAR (50)
		,LAST_NAME VARCHAR (50)
		,FIRST_NAME VARCHAR (50)
		,SCHOOL VARCHAR (50)
		,GRADE VARCHAR (50)
		--- SBA SCORES ---
		,READING VARCHAR (50)
		,PASS_FAIL_READING VARCHAR (50)
		,MATH VARCHAR (50)
		,PASS_FAIL_MATH VARCHAR (50)
		,SCIENCE VARCHAR (50)
		,PASS_FAIL_SCIENCE VARCHAR (50)
		,TOTAL_SCORE_COMBO VARCHAR (50)
		,PASS_FAIL_COMBO VARCHAR (50)
		,TEST VARCHAR (50)
		,SCALE_SCORE VARCHAR (50)
		,PL VARCHAR (50)
		--- EOC PASS/FAIL --- 
	    ,[Algebra I 7 12 V001] Varchar(50)
		,[Algebra I 7 12 V003] Varchar(50)
		,[Algebra II 10 12 V002] Varchar(50)
		,[Algebra II 10 12 V006] Varchar(50)
		,[Anatomy Physiology 11 12 V002] Varchar(50)
		,[Biology 9 12 V002] Varchar(50)
		,[Biology 9 12 V003] Varchar(50)
		,[Biology 9 12 V007] Varchar(50)
		,[Chemistry 9 12 V002] Varchar(50)
		,[Chemistry 9 12 V003] Varchar(50)
		,[Chemistry 9 12 V008] Varchar(50)
		,[Economics 9 12 V001] Varchar(50)
		,[Economics 9 12 V004] Varchar(50)
		,[English Language Arts III Reading 11 11 V001] Varchar(50)
		,[English Language Arts III Reading 11 11 V002] Varchar(50)
		,[English Language Arts III Reading 11 11 V006] Varchar(50) 
		,[English Language Arts III Writing 11 11 V001] Varchar(50)
		,[English Language Arts III Writing 11 11 V002] Varchar(50)
		,[English Language Arts III Writing 11 11 V006] Varchar(50)
		,[English Language Arts IV Reading 11 11 V003] Varchar(50)
		,[English Language Arts IV Reading 12 12 V001] Varchar(50)
		,[English Language Arts IV Writing 12 12 V001] Varchar(50) 
		,[English Language Arts IV Writing 12 12 V003] Varchar(50) 
		,[Environmental Science 10 12 V001] Varchar(50) 
		,[Financial Literacy 9 12 V003] Varchar(50) 
		,[Geometry 9 12 V003] Varchar(50) 
		,[New Mexico 7 12 History V001] Varchar(50)
		,[New Mexico 7 12 History V004] Varchar(50)
		,[New Mexico History 7 12 V001] Varchar(50)
		,[Physics 9 12 V003] Varchar(50)
		,[Pre-Calculus 9 12 V004] Varchar(50)
		,[Spanish Language Arts III Reading 11 11 V001] Varchar(50)
		,[Spanish Language Arts III Writing 11 11 V001] Varchar(50)
		,[US Government Comprehensive 9 12 V001] Varchar(50)
		,[US Government Comprehensive 9 12 V002] Varchar(50)
		,[US Government Comprehensive 9 12 V005] Varchar(50)
		,[US History 9 12 V001] Varchar(50)
		,[US History 9 12 V002] Varchar(50)
		,[US History 9 12 V007] Varchar(50)
		,[World History And Geography 9 12 V001] Varchar(50)
		,[World History And Geography 9 12 V003] Varchar(50)

		--- ADD PARCC PASS/FAIL
		,[PARCC_ALG_II] Varchar(50)
		,[PASS_FAIL_PARCC_ALG_II] Varchar(50)  
		,[PARCC_GEOM] Varchar(50)
		,[PASS_FAIL_PARCC_GEOM] Varchar(50)
		,PARCC_ELA_11 VARCHAR(50)
		,PASS_FAIL_PARCC_ELA_11 VARCHAR (50)
		,[PARCC_ELA_11_READ] Varchar(50)
		,[PARCC_ELA_11_WRIT] Varchar(50)
		,SS_ATTEMPTS VARCHAR (50)
		,WRI_ATTEMPTS VARCHAR (50)
		,MATH_ATTEMPTS VARCHAR (50)
		,READING_ATTEMPTS VARCHAR (50)
		,SCIENCE_ATTEMPTS VARCHAR (50)

		)
INSERT INTO @EOC_SBA_AND_EOC
	SELECT
		SIS_NUMBER
		,LAST_NAME
		,FIRST_NAME
		,SCHOOL
		,GRADE
		--- SBA SCORES ---
		,READING
		,CASE WHEN READING IS NULL THEN ''
			ELSE
			CASE WHEN READING >= 1137 THEN 'PASS' ELSE 'FAIL'
		END END AS PASS_FAIL_READING
		,MATH
		,CASE WHEN MATH IS NULL THEN ''
			ELSE
			CASE WHEN MATH >= 1137 THEN 'PASS' ELSE 'FAIL'
		END END AS PASS_FAIL_MATH
		,SCIENCE
		,CASE WHEN SCIENCE IS NULL THEN ''
			ELSE
			CASE WHEN SCIENCE >= 1138 THEN 'PASS' ELSE 'FAIL'
		END END AS PASS_FAIL_SCIENCE
		,TOTAL_SCORE_COMBO AS TOTAL_SCORE_COMBO
		,PASS_FAIL_COMBO AS PASS_FAIL_COMBO
		,'' AS TEST
		,'' AS SCALE_SCORE
		,'' AS PL
		--- EOC PASS/FAIL --- 
	    ,[Algebra I 7 12 V001]
		,[Algebra I 7 12 V003]
		,[Algebra II 10 12 V002]
		,[Algebra II 10 12 V006]
		,[Anatomy Physiology 11 12 V002]
		,[Biology 9 12 V002]
		,[Biology 9 12 V003]
		,[Biology 9 12 V007]
		,[Chemistry 9 12 V002]
		,[Chemistry 9 12 V003]
		,[Chemistry 9 12 V008]
		,[Economics 9 12 V001]
		,[Economics 9 12 V004]
		,[English Language Arts III Reading 11 11 V001]
		,[English Language Arts III Reading 11 11 V002]
		,[English Language Arts III Reading 11 11 V006] 
		,[English Language Arts III Writing 11 11 V001]
		,[English Language Arts III Writing 11 11 V002]
		,[English Language Arts III Writing 11 11 V006]
		,[English Language Arts IV Reading 11 11 V003]
		,[English Language Arts IV Reading 12 12 V001]
		,[English Language Arts IV Writing 12 12 V001] 
		,[English Language Arts IV Writing 12 12 V003] 
		,[Environmental Science 10 12 V001] 
		,[Financial Literacy 9 12 V003] 
		,[Geometry 9 12 V003] 
		,[New Mexico 7 12 History V001]
		,[New Mexico 7 12 History V004]
		,[New Mexico History 7 12 V001]
		,[Physics 9 12 V003]
		,[Pre-Calculus 9 12 V004]
		,[Spanish Language Arts III Reading 11 11 V001]
		,[Spanish Language Arts III Writing 11 11 V001]
		,[US Government Comprehensive 9 12 V001]
		,[US Government Comprehensive 9 12 V002]
		,[US Government Comprehensive 9 12 V005]
		,[US History 9 12 V001]
		,[US History 9 12 V002]
		,[US History 9 12 V007]
		,[World History And Geography 9 12 V001]
		,[World History And Geography 9 12 V003]

		--- ADD PARCC PASS/FAIL
		,PARCC_ALG_II AS [PARCC_ALG_II] 
		,CASE WHEN PARCC_ALG_II IS NULL THEN '' ELSE CASE WHEN PARCC_ALG_II >= 725 THEN 'PASS' ELSE 'FAIL'
		END END AS PASS_FAIL_PARCC_ALG_II
		,PARCC_GEOM AS [PARCC_GEOM]
		,CASE WHEN PARCC_GEOM IS NULL THEN '' ELSE CASE WHEN PARCC_GEOM >= 725 THEN 'PASS' ELSE 'FAIL'
		END END AS PASS_FAIL_PARCC_GEOM
		,PARCC_ELA_11
		,CASE WHEN PARCC_ELA_11 IS NULL THEN '' ELSE CASE WHEN PARCC_ELA_11 >= 725 THEN 'PASS' ELSE 'FAIL'
		END END AS PASS_FAIL_PARCC_ELA_11
		,'' AS [PARCC_ELA_11_READ]
		,'' AS [PARCC_ELA_11_WRIT]
		,SS_ATTEMPTS
		,WRI_ATTEMPTS
		,MATH_ATTEMPTS
		,READING_ATTEMPTS
		,SCIENCE_ATTEMPTS
	FROM
	(
	SELECT
		STUD.SIS_NUMBER
		,STUD.LAST_NAME
		,STUD.FIRST_NAME
		,SCHOOL_CODE AS SCHOOL
		,STUD.GRADE
		--- SBA SCORES ---
		,SBA_R.SCALE_SCORE AS READING
		,'' AS PASS_FAIL_READING
		,SBA_M.SCALE_SCORE AS MATH
		,'' AS PASS_FAIL_MATH
		,SBA_S.SCALE_SCORE AS SCIENCE
		,'' AS PASS_FAIL_SCIENCE
		,CAST(SBA_R.SCALE_SCORE AS INT) + CAST(SBA_M.SCALE_SCORE AS INT) AS TOTAL_SCORE_COMBO
		,CASE WHEN SBA_R.SCALE_SCORE IS NULL OR SBA_M.SCALE_SCORE IS NULL THEN ''
				ELSE	
					CASE
					WHEN ((CAST(SBA_R.SCALE_SCORE AS INT)) + (CAST(SBA_M.SCALE_SCORE AS INT)) >= 2273
							AND (SBA_M.SCALE_SCORE) >= 1127
							AND (SBA_R.SCALE_SCORE) >= 1129) THEN 'PASS'
					ELSE ('FAIL')
				END
		END AS PASS_FAIL_COMBO
		,'' AS TEST
		,'' AS SCALE_SCORE
		,'' AS PL
		--- EOC PASS/FAIL --- 
	    ,EOC_HIST.[Algebra I 7 12 V001] [Algebra I 7 12 V001]
		,EOC_HIST.[Algebra I 7 12 V003] [Algebra I 7 12 V003]
		,EOC_HIST.[Algebra II 10 12 V002] [Algebra II 10 12 V002]
		,EOC_HIST.[Algebra II 10 12 V006] [Algebra II 10 12 V006]
		,EOC_HIST.[Anatomy Physiology 11 12 V002] [Anatomy Physiology 11 12 V002]
		,EOC_HIST.[Biology 9 12 V002] [Biology 9 12 V002]
		,EOC_HIST.[Biology 9 12 V003] [Biology 9 12 V003]
		,EOC_HIST.[Biology 9 12 V007] [Biology 9 12 V007]
		,EOC_HIST.[Chemistry 9 12 V002] [Chemistry 9 12 V002]
		,EOC_HIST.[Chemistry 9 12 V003] [Chemistry 9 12 V003]
		,EOC_HIST.[Chemistry 9 12 V008] [Chemistry 9 12 V008]
		,EOC_HIST.[Economics 9 12 V001] [Economics 9 12 V001]
		,EOC_HIST.[Economics 9 12 V001] [Economics 9 12 V004]
		,EOC_HIST.[English Language Arts III Reading 11 11 V001] [English Language Arts III Reading 11 11 V001]
		,EOC_HIST.[English Language Arts III Reading 11 11 V002] [English Language Arts III Reading 11 11 V002]
		,EOC_HIST.[English Language Arts III Reading 11 11 V006] [English Language Arts III Reading 11 11 V006] 
		,EOC_HIST.[English Language Arts III Writing 11 11 V001] [English Language Arts III Writing 11 11 V001]
		,EOC_HIST.[English Language Arts III Writing 11 11 V002] [English Language Arts III Writing 11 11 V002]
		,EOC_HIST.[English Language Arts III Writing 11 11 V006] [English Language Arts III Writing 11 11 V006]
		,EOC_HIST.[English Language Arts IV Reading 11 11 V003] [English Language Arts IV Reading 11 11 V003]
		,EOC_HIST.[English Language Arts IV Writing 12 12 V001] [English Language Arts IV Reading 12 12 V001]
		,EOC_HIST.[English Language Arts IV Writing 12 12 V001] [English Language Arts IV Writing 12 12 V001] 
		,EOC_HIST.[English Language Arts IV Writing 12 12 V003] [English Language Arts IV Writing 12 12 V003] 
		,EOC_HIST.[Environmental Science 10 12 V001] [Environmental Science 10 12 V001] 
		,EOC_HIST.[Financial Literacy 9 12 V003] [Financial Literacy 9 12 V003] 
		,EOC_HIST.[Geometry 9 12 V003] [Geometry 9 12 V003] 
		,EOC_HIST.[New Mexico 7 12 History V001] [New Mexico 7 12 History V001]
		,EOC_HIST.[New Mexico 7 12 History V004] [New Mexico 7 12 History V004]
		,EOC_HIST.[New Mexico History 7 12 V001] [New Mexico History 7 12 V001]
		,EOC_HIST.[Physics 9 12 V003]  [Physics 9 12 V003]
		,EOC_HIST.[Pre-Calculus 9 12 V004] [Pre-Calculus 9 12 V004]
		,EOC_HIST.[Spanish Language Arts III Reading 11 11 V001] [Spanish Language Arts III Reading 11 11 V001]
		,EOC_HIST.[Spanish Language Arts III Writing 11 11 V001] [Spanish Language Arts III Writing 11 11 V001]
		,EOC_HIST.[US Government Comprehensive 9 12 V001] [US Government Comprehensive 9 12 V001]
		,EOC_HIST.[US Government Comprehensive 9 12 V002] [US Government Comprehensive 9 12 V002]
		,EOC_HIST.[US Government Comprehensive 9 12 V005] [US Government Comprehensive 9 12 V005]
		,EOC_HIST.[US History 9 12 V001] [US History 9 12 V001]
		,EOC_HIST.[US History 9 12 V002] [US History 9 12 V002]
		,EOC_HIST.[US History 9 12 V007] [US History 9 12 V007]
		,EOC_HIST.[World History And Geography 9 12 V001] [World History And Geography 9 12 V001]
		,EOC_HIST.[World History And Geography 9 12 V003] [World History And Geography 9 12 V003]

		--- ADD PARCC PASS/FAIL
		,P_ALG.SCALE_SCORE [PARCC_ALG_II] 
		,'' AS PASS_FAIL_PARCC_ALG_II
		,P_GEOM.SCALE_SCORE AS [PARCC_GEOM]
		,'' AS PASS_FAIL_PARCC_GEOM
		,P_ALG.SCALE_SCORE [PARCC_ELA_11_READ]
		,P_ELA.SCALE_SCORE AS [PARCC_ELA_11]
		,'' AS PASS_FAIL_PARCC_ELA_11
		,SS_CNT.TEST AS SS_ATTEMPTS
		,CAST(WR_CNT.TEST AS INT) + CAST(PARCC_CNTS.READING AS INT) AS WRI_ATTEMPTS
		,CAST(SBA_CNTS.MATH AS INT) + CAST(PARCC_CNTS.MATH AS INT) AS MATH_ATTEMPTS
		,CAST(SBA_CNTS.READING AS INT) + CAST(PARCC_CNTS.READING AS INT) AS READING_ATTEMPTS
		,SBA_CNTS.SCIENCE AS SCIENCE_ATTEMPTS

	FROM
		@STUDENTS AS STUD
		LEFT HASH JOIN
		@SBA_MATH AS SBA_M
		ON STUD.SIS_NUMBER = SBA_M.SIS_NUMBER

		LEFT HASH JOIN
		@SBA_READING AS SBA_R
		ON STUD.SIS_NUMBER = SBA_R.SIS_NUMBER

		LEFT HASH JOIN
		@SBA_SCIENCE AS SBA_S
		ON STUD.SIS_NUMBER = SBA_S.SIS_NUMBER

		LEFT HASH JOIN
		@PARCC_ELA_11 AS P_ELA
		ON STUD.SIS_NUMBER = P_ELA.SIS_NUMBER

		LEFT HASH JOIN @PARCC_GEOM AS P_GEOM
		ON STUD.SIS_NUMBER = P_GEOM.SIS_NUMBER

		LEFT HASH JOIN @PARCC_ALG_II AS P_ALG
		ON STUD.SIS_NUMBER = P_ALG.SIS_NUMBER

		LEFT HASH JOIN @SS_COUNT AS SS_CNT
		ON STUD.SIS_NUMBER = SS_CNT.SIS_NUMBER

		LEFT HASH JOIN @WR_CNTS AS WR_CNT
		ON STUD.SIS_NUMBER = WR_CNT.SIS_NUMBER

		LEFT HASH JOIN @EOC_HIST AS EOC_HIST
		ON STUD.SIS_NUMBER = EOC_HIST.SIS_NUMBER

		LEFT HASH JOIN @SBA_CNTS AS SBA_CNTS
		ON STUD.SIS_NUMBER = SBA_CNTS.SIS_NUMBER

		LEFT HASH JOIN @PARCC_CNTS AS PARCC_CNTS
		ON STUD.SIS_NUMBER = PARCC_CNTS.SIS_NUMBER

	) AS T1

DECLARE @TOTAL_ATTEMPTS
	TABLE
		(
		SIS_NUMBER VARCHAR (50)
		,MATH VARCHAR (50)
		,READING VARCHAR (50)
		,SCIENCE VARCHAR (50)
		)
INSERT INTO @TOTAL_ATTEMPTS
SELECT
	SBA_CNTS.SIS_NUMBER
	,CAST(SBA_CNTS.MATH AS INT) + CAST(PARCC_CNTS.MATH AS INT) AS MATH
	,CAST(SBA_CNTS.READING AS INT) + CAST(PARCC_CNTS.READING AS INT) AS READING
	,SBA_CNTS.SCIENCE
FROM
	@SBA_CNTS AS SBA_CNTS
	LEFT HASH JOIN
	@PARCC_CNTS AS PARCC_CNTS
	ON SBA_CNTS.SIS_NUMBER = PARCC_CNTS.SIS_NUMBER


DECLARE @ADC_TESTS
	TABLE
		(
		SIS_NUMBER VARCHAR (50)
		,MATH VARCHAR (50)
		,[READ] VARCHAR (50)
		,SCI VARCHAR (50)
		,WRITE VARCHAR (50)
		,SOC VARCHAR (50)
		,REWR VARCHAR (50)
		)
INSERT INTO @ADC_TESTS
SELECT 
	SIS_NUMBER
	,MATH
	,[READ]
	,SCI
	,WRITE
	,SOC
	,REWR
	
FROM
(
SELECT 
       Student.SIS_NUMBER
       ,STU_PART.PERFORMANCE_LEVEL
	   ,test.TEST_COMPARE_CODE

FROM
       rev.EPC_STU_TEST AS StudentTest

       JOIN
       rev.EPC_TEST_PART AS PART
       ON StudentTest.TEST_GU = PART.TEST_GU

       JOIN
       rev.EPC_STU_TEST_PART AS STU_PART
       ON PART.TEST_PART_GU = STU_PART.TEST_PART_GU
       AND STU_PART.STUDENT_TEST_GU = StudentTest.STUDENT_TEST_GU

		INNER JOIN
		rev.EPC_STU_TEST_PART_SCORE AS SCORES
		ON
		SCORES.STU_TEST_PART_GU = STU_PART.STU_TEST_PART_GU
		AND SCORES.TEST_SCORE != '--'

		LEFT JOIN
		rev.EPC_TEST_SCORE_TYPE AS SCORET
		ON
		SCORET.TEST_GU = StudentTest.TEST_GU
		AND SCORES.TEST_SCORE_TYPE_GU = SCORET.TEST_SCORE_TYPE_GU

		LEFT JOIN
		rev.EPC_TEST_DEF_SCORE AS SCORETDEF
		ON
		SCORETDEF.TEST_DEF_SCORE_GU = SCORET.TEST_DEF_SCORE_GU

       LEFT JOIN
       rev.EPC_TEST AS TEST
       ON TEST.TEST_GU = StudentTest.TEST_GU

       INNER JOIN
       rev.EPC_STU AS Student
       ON Student.STUDENT_GU = StudentTest.STUDENT_GU

       INNER JOIN
       rev.REV_PERSON AS Person
       ON Person.PERSON_GU = StudentTest.STUDENT_GU

	   INNER HASH JOIN
	   @STUDENTS AS STUDS
	   ON Student.SIS_NUMBER = STUDS.SIS_NUMBER
	   

WHERE
       TEST_COMPARE_CODE IN ('SCI', 'MATH','READ','WRITE','REWR','SOC') 
	   AND SCORE_DESCRIPTION IN ('RAW','SCALE')
	   AND PERFORMANCE_LEVEL = 'P'

) AS T1

PIVOT
	(MAX (PERFORMANCE_LEVEL) FOR TEST_COMPARE_CODE IN ([MATH],[READ],[SCI],[WRITE],[SOC],[REWR])) AS PF
WHERE 1 = 1

DECLARE @ADC_TEST_NAME
	TABLE
		(
		SIS_NUMBER VARCHAR (50)
		,MATH_TEST VARCHAR (50)
		,[READ_TEST] VARCHAR (50)
		,SCI_TEST VARCHAR (50)
		,WRITE VARCHAR (50)
		,SS_TEST VARCHAR (50)
		,REWR_TEST VARCHAR (50)
		)

INSERT INTO @ADC_TEST_NAME
SELECT 
	SIS_NUMBER
	,MATH_TEST
	,[READ_TEST]
	,SCI_TEST
	,WRITE_TEST
	,SS_TEST
	,REWR_TEST
	
FROM
(
SELECT 
	SIS_NUMBER
	,MATH AS MATH_TEST
	,[READ] AS READ_TEST
	,SCI AS SCI_TEST
	,WRITE AS WRITE_TEST
	,SOC AS SS_TEST
	,REWR AS REWR_TEST
	
	
FROM
(
SELECT 
	    ROW_NUMBER () OVER (PARTITION BY Student.SIS_NUMBER, TEST.TEST_NAME ORDER BY TEST.TEST_NAME DESC) AS RN
       ,Student.SIS_NUMBER
       --,STU_PART.PERFORMANCE_LEVEL
	   ,test.TEST_COMPARE_CODE
	   ,TEST.TEST_NAME

FROM
       rev.EPC_STU_TEST AS StudentTest

       JOIN
       rev.EPC_TEST_PART AS PART
       ON StudentTest.TEST_GU = PART.TEST_GU

       JOIN
       rev.EPC_STU_TEST_PART AS STU_PART
       ON PART.TEST_PART_GU = STU_PART.TEST_PART_GU
       AND STU_PART.STUDENT_TEST_GU = StudentTest.STUDENT_TEST_GU

		INNER JOIN
		rev.EPC_STU_TEST_PART_SCORE AS SCORES
		ON
		SCORES.STU_TEST_PART_GU = STU_PART.STU_TEST_PART_GU
		AND SCORES.TEST_SCORE != '--'

		LEFT JOIN
		rev.EPC_TEST_SCORE_TYPE AS SCORET
		ON
		SCORET.TEST_GU = StudentTest.TEST_GU
		AND SCORES.TEST_SCORE_TYPE_GU = SCORET.TEST_SCORE_TYPE_GU

		LEFT JOIN
		rev.EPC_TEST_DEF_SCORE AS SCORETDEF
		ON
		SCORETDEF.TEST_DEF_SCORE_GU = SCORET.TEST_DEF_SCORE_GU

       LEFT JOIN
       rev.EPC_TEST AS TEST
       ON TEST.TEST_GU = StudentTest.TEST_GU

       INNER JOIN
       rev.EPC_STU AS Student
       ON Student.STUDENT_GU = StudentTest.STUDENT_GU

       INNER JOIN
       rev.REV_PERSON AS Person
       ON Person.PERSON_GU = StudentTest.STUDENT_GU

	   INNER HASH JOIN
	   @STUDENTS AS STUDS
	   ON Student.SIS_NUMBER = STUDS.SIS_NUMBER
	   

WHERE
       1 = 1
	   AND TEST_COMPARE_CODE IN ('SCI', 'MATH','READ','WRITE','REWR','SOC') 
	   AND SCORE_DESCRIPTION IN ('RAW','SCALE')
	   AND PERFORMANCE_LEVEL = 'P'

) AS T1

PIVOT
	(MAX (TEST_NAME) FOR TEST_COMPARE_CODE IN ([MATH],[READ],[SCI],[WRITE],[SOC],[REWR])) AS PF

WHERE 1 = 1
AND RN = 1
) AS T2


DECLARE @EXIT_EXAM_STATUS
	TABLE
		(
		SIS_NUMBER VARCHAR (50)
		,LAST_NAME VARCHAR (50)
		,FIRST_NAME VARCHAR (50)
		,SCHOOL VARCHAR (50)
		,GRADE VARCHAR (50)
		,SBA_READING VARCHAR (50)
		,SBA_READING_PASS_FAIL VARCHAR (50)
		,SBA_MATH VARCHAR (50)
		,SBA_MATH_PASS_FAIL VARCHAR (50)
		,SBA_SCIENCE VARCHAR (50)
		,SBA_SCIENCE_PASS_FAIL VARCHAR (50)
		,SBA_COMBO VARCHAR (50)
		,SBA_COMBO_PASS_FAIL VARCHAR (50)
		,PARCC_ELA_11 VARCHAR (50)
		,PARCC_ELA_11_PASS_FAIL VARCHAR (50)
		,PARCC_ALG_II VARCHAR (50)
		,PARCC_ALG_II_PASS_FAIL VARCHAR (50)
		,PARCC_GEOM VARCHAR (50)
		,PARCC_GEOM_PASS_FAIL VARCHAR (50)
		,[MATH REQUIREMENTS] VARCHAR (50)
		,[READING REQUIREMENTS] VARCHAR (50)
		,[WRITING REQUIREMENTS] VARCHAR (50)
		,[SCIENCE REQUIREMENTS] VARCHAR (50)
		,[SS REQUIREMENTS] VARCHAR (50)
		,MATH_ATTEMPTS VARCHAR (50)
		,READING_ATTEMPTS VARCHAR (50)
		,SCIENCE_ATTEMPTS VARCHAR (50)
		,WRI_ATTEMPTS VARCHAR (50)
		,SS_ATTEMPTS VARCHAR (50)

		)
	INSERT INTO @EXIT_EXAM_STATUS
	SELECT
		SIS_NUMBER
		,LAST_NAME
		,FIRST_NAME
		,SCHOOL
		,GRADE
		,READING AS SBA_READING
		,PASS_FAIL_READING AS SBA_READING_PASS_FAIL
		,MATH AS SBA_MATH
		,PASS_FAIL_MATH AS SBA_MATH_PASS_FAIL
		,SCIENCE AS SBA_SCIENCE
		,PASS_FAIL_SCIENCE AS SBA_SCIENCE_PASS_FAIL
		,TOTAL_SCORE_COMBO AS SBA_COMBO
		,PASS_FAIL_COMBO AS SBA_COMBO_PASS_FAIL
		,PARCC_ELA_11 AS PARCC_ELA_11
		,PASS_FAIL_PARCC_ELA_11 AS PARCC_ELA_11_PASS_FAIL
		,PARCC_ALG_II AS PARCC_ALG_II
		,PASS_FAIL_PARCC_ALG_II AS PARCC_ALG_II_PASS_FAIL
		,PARCC_GEOM AS PARCC_GEOM
		,PASS_FAIL_PARCC_GEOM AS PARCC_GEOM_PASS_FAIL
		,CASE WHEN PASS_FAIL_MATH = 'PASS' OR PASS_FAIL_COMBO = 'PASS' OR PASS_FAIL_PARCC_ALG_II = 'PASS' OR PASS_FAIL_PARCC_GEOM = 'PASS' THEN 'PASSED (SBA/PARCC)'
		END AS 'MATH REQUIREMENTS'
		,CASE WHEN PASS_FAIL_READING = 'PASS' OR PASS_FAIL_COMBO = 'PASS' OR PASS_FAIL_PARCC_ELA_11 = 'PASS' THEN 'PASSED (SBA/PARCC)'
		END AS 'READING REQUIREMENTS'
		,CASE WHEN PASS_FAIL_PARCC_ELA_11 = 'PASS' THEN 'PASSED (PARCC)'
		END AS 'WRITING REQUIREMENTS'
		,CASE WHEN PASS_FAIL_SCIENCE = 'PASS' THEN 'PASSED (SBA)'
		END AS 'SCIENCE REQUIREMENTS'
		,'' AS 'SS REQUIREMENTS'
		,MATH_ATTEMPTS
		,READING_ATTEMPTS
		,SCIENCE_ATTEMPTS
		,WRI_ATTEMPTS
		,SS_ATTEMPTS
	FROM
		@EOC_SBA_AND_EOC

DECLARE @EES_FINAL
	TABLE
		(
		SCHOOL VARCHAR (50)
		,LAST_NAME VARCHAR (50)
		,FIRST_NAME VARCHAR (50)
		,SIS_NUMBER VARCHAR (50)
		,GRADE VARCHAR (50)

		,SBA_MATH VARCHAR (50)
		,SBA_MATH_PASS_FAIL VARCHAR (50)
		,SBA_COMBO VARCHAR (50)
		,SBA_COMBO_PASS_FAIL VARCHAR (50)
		,PARCC_GEOM VARCHAR (50)
		,PARCC_GEOM_PASS_FAIL VARCHAR (50)
		,PARCC_ALG_II VARCHAR (50)
		,PARCC_ALG_II_PASS_FAIL VARCHAR (50)
		,MATH_ATTEMPTS VARCHAR (50)
		,[MATH REQUIREMENTS] VARCHAR (100)



		,SBA_READING VARCHAR (50)
		,SBA_READING_PASS_FAIL VARCHAR (50)
		,R_SBA_COMBO VARCHAR (50)
		,R_SBA_COMBO_PASS_FAIL VARCHAR (50)
		,PARCC_ELA_11 VARCHAR (50)
		,PARCC_ELA_11_PASS_FAIL VARCHAR (50)
		,READING_ATTEMPTS VARCHAR (50)
		,[READING REQUIREMENTS] VARCHAR (100)

		,WRI_ATTEMPTS VARCHAR (50)
		,[WRITING REQUIREMENTS] VARCHAR (100)

		,SBA_SCIENCE VARCHAR (50)
		,SBA_SCIENCE_PASS_FAIL VARCHAR (50)
		,SCIENCE_ATTEMPTS VARCHAR (50)
		,[SCIENCE REQUIREMENTS] VARCHAR (100)

		,SS_ATTEMPTS VARCHAR (50)
		,[SS REQUIREMENTS] VARCHAR (100)
		)
INSERT INTO @EES_FINAL
	SELECT
		SCHOOL
		,EES.LAST_NAME
		,EES.FIRST_NAME
		,EES.SIS_NUMBER
		,EES.GRADE
		,CASE WHEN SBA_MATH IS NULL THEN '' ELSE SBA_MATH
		END AS SBA_MATH
		,SBA_MATH_PASS_FAIL
		,SBA_COMBO
		,SBA_COMBO_PASS_FAIL
		,PARCC_GEOM
		,PARCC_GEOM_PASS_FAIL
		,PARCC_ALG_II
		,PARCC_ALG_II_PASS_FAIL
		,CASE WHEN EES.MATH_ATTEMPTS IS NULL THEN '0' ELSE EES.MATH_ATTEMPTS
		END AS 'MATH ATTEMPTS'
		,CASE WHEN EES.[MATH REQUIREMENTS] IS NULL AND ADC.MATH IS NULL AND EES.MATH_ATTEMPTS > 2 THEN 'TAKE ADC'
			  WHEN EES.[MATH REQUIREMENTS] IS NULL AND ADC.MATH IS NULL AND (EES.MATH_ATTEMPTS IS NULL OR EES.READING_ATTEMPTS < 3) THEN 'TAKE PARCC'
			  WHEN EES.[MATH REQUIREMENTS] IS NULL AND ADC.MATH = 'P' THEN 'PASSED '+ ATN.MATH_TEST
			  ELSE EES.[MATH REQUIREMENTS]
		END AS 'MATH REQUIREMENTS'

		,SBA_READING
		,SBA_READING_PASS_FAIL
		,SBA_COMBO
		,SBA_COMBO_PASS_FAIL
		,PARCC_ELA_11
		,PARCC_ELA_11_PASS_FAIL
		,CASE WHEN EES.READING_ATTEMPTS IS NULL THEN '0' ELSE EES.READING_ATTEMPTS
		END AS 'READING ATTEMPTS'
		,CASE WHEN EES.[READING REQUIREMENTS] IS NULL AND ADC.[READ] IS NULL AND ADC.REWR IS NULL AND EES.READING_ATTEMPTS > 2 THEN 'TAKE ADC'
			  WHEN EES.[READING REQUIREMENTS] IS NULL AND ADC.[READ] IS NULL AND ADC.REWR IS NULL AND (EES.READING_ATTEMPTS IS NULL OR EES.[READING_ATTEMPTS] < 3) THEN 'TAKE PARCC ELA 11'
		      WHEN EES.[READING REQUIREMENTS] IS NULL AND ADC.[READ] IS NULL AND ADC.REWR = 'P' THEN 'PASSED ' + '(' + ATN.REWR_TEST +')'
			  WHEN EES.[READING REQUIREMENTS] IS NULL AND ADC.[READ] = 'P' THEN 'PASSED ' + '(' + ATN.READ_TEST +')'
			  ELSE EES.[READING REQUIREMENTS]
		END AS 'READING REQUIREMENTS'

		,CASE WHEN EES.WRI_ATTEMPTS IS NULL THEN '0' ELSE EES.WRI_ATTEMPTS
		END AS'WRITING ATTEMPTS'
		,CASE WHEN EES.[WRITING REQUIREMENTS] IS NULL AND ADC.WRITE IS NULL AND ADC.REWR IS NULL AND (EES.WRI_ATTEMPTS < 1 OR EES.WRI_ATTEMPTS IS NULL) THEN 'TAKE EOC'
			  WHEN EES.[WRITING REQUIREMENTS] IS NULL AND ADC.WRITE IS NULL AND ADC.REWR IS NULL AND (EES.WRI_ATTEMPTS > 0) THEN 'TAKE ADC'
			  WHEN EES.[WRITING REQUIREMENTS] IS NULL AND ADC.WRITE IS NULL AND ADC.REWR = 'P' THEN 'PASSED ' + '(' + ATN.WRITE +')'
			  WHEN EES.[WRITING REQUIREMENTS] IS NULL AND ADC.WRITE = 'P' THEN 'PASSED ' + '(' + ATN.WRITE + ')'
			  ELSE EES.[WRITING REQUIREMENTS]
		END AS 'WRITING REQUIREMENTS'

		,SBA_SCIENCE
		,CASE WHEN EES.SCIENCE_ATTEMPTS IS NULL THEN '0' ELSE EES.SCIENCE_ATTEMPTS
		END AS 'SCIENCE ATTEMPTS'
		,SBA_SCIENCE_PASS_FAIL
		,CASE WHEN EES.[SCIENCE REQUIREMENTS] IS NULL AND (EES.SCIENCE_ATTEMPTS IS NULL OR EES.SCIENCE_ATTEMPTS < 2) THEN 'TAKE SBA'
			  WHEN EES.[SCIENCE REQUIREMENTS] IS NULL AND ADC.SCI IS NULL AND EES.SCIENCE_ATTEMPTS > 1 THEN 'TAKE ADC'
			  WHEN EES.[SCIENCE REQUIREMENTS] IS NULL AND ADC.SCI IS NULL AND (EES.SCIENCE_ATTEMPTS IS NULL OR EES.SCIENCE_ATTEMPTS < 2) THEN 'TAKE EOC'
			  WHEN EES.[SCIENCE REQUIREMENTS] IS NULL AND ADC.SCI = 'P' THEN 'PASSED ' + '(' + ATN.SCI_TEST + ')'
		      ELSE EES.[SCIENCE REQUIREMENTS]
		END AS 'SCIENCE REQUIREMENTS'

		,CASE WHEN EES.SS_ATTEMPTS IS NULL THEN '0' ELSE EES.SS_ATTEMPTS
		END AS 'SS ATTEMPTS'
		,CASE WHEN ADC.SOC IS NULL THEN 'EOC' ELSE 'PASSED ' + '(' + ATN.SS_TEST +')' 
		END AS 'SS REQUIREMENTS'
	FROM
		@EXIT_EXAM_STATUS AS EES
		LEFT HASH JOIN
		@ADC_TESTS AS ADC
		ON EES.SIS_NUMBER = ADC.SIS_NUMBER

		LEFT HASH JOIN
		@ADC_TEST_NAME AS ATN
		ON EES.SIS_NUMBER = ATN.SIS_NUMBER

		LEFT HASH JOIN
		@STUDENTS AS STUD
		ON EES.SIS_NUMBER = STUD.SIS_NUMBER

--SELECT * FROM @SBA_READING
--WHERE SIS_NUMBER = '100003771'
--SELECT * FROM @SBA_MATH
--WHERE SIS_NUMBER = '100003771'
--SELECT * FROM @SBA_SCIENCE
--WHERE SIS_NUMBER = '100003771'
--SELECT * FROM @STUDENTS
--SELECT * FROM @EOC_SBA_AND_EOC
--WHERE SIS_NUMBER = '100003771'
--SELECT * FROM @SBA_CNTS
--WHERE SIS_NUMBER = '100003771'
--SELECT * FROM @PARCC_CNTS
--WHERE SIS_NUMBER = '100003771'
--SELECT * FROM @ADC_TESTS
--WHERE SIS_NUMBER = '100011881'
--ORDER BY SIS_NUMBER
--SELECT * FROM @EXIT_EXAM_STATUS
--WHERE SIS_NUMBER = '100011881'
--ORDER BY SIS_NUMBER
--SELECT * FROM @ADC_TEST_NAME
--WHERE 1 = 1
--AND SIS_NUMBER = '100011881'
SELECT * FROM @EES_FINAL
WHERE 1 = 1
--AND SIS_NUMBER = '100011881'

--AND SIS_NUMBER = '100003771'
--AND GRADE = '12'
--AND SIS_NUMBER = '100003557'
--SELECT * FROM @EOC_HIST
--WHERE SIS_NUMBER = '100038934'
ORDER BY SIS_NUMBER