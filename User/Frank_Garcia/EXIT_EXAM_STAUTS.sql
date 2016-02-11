USE
ST_Production
GO

DECLARE @STUDENTS
	TABLE
		(
		SIS_NUMBER VARCHAR (50)
		,STATE_ID VARCHAR (50)
		,SCHOOL_CODE VARCHAR (50)
		,FIRST_NAME VARCHAR (50)
		,LAST_NAME VARCHAR (50)
		,DOB VARCHAR (50)
		,GRADE VARCHAR (50)
		)
INSERT INTO @STUDENTS
	SELECT  
		SIS_NUMBER
		,STATE_ID
		,SCHOOL_CODE
		,FIRST_NAME
		,LAST_NAME
		,DOB
		,GRADE
	FROM
	(
		SELECT
			 stu.SIS_NUMBER                            AS SIS_NUMBER
		   , stu.STATE_STUDENT_NUMBER				   AS [state_id]
		   , yr.SCHOOL_YEAR                            AS [school_year]
		   , sch.SCHOOL_CODE                           AS [school_code]
		   , REPLACE (PER.FIRST_NAME, '''','')							   AS [FIRST_NAME]
		   , REPLACE (per.LAST_NAME,'''','')			   AS [LAST_NAME]
		   , CONVERT(VARCHAR(10), per.BIRTH_DATE, 120) AS [dob]
		   , grade.VALUE_DESCRIPTION 				   AS GRADE
		   , CASE WHEN stu.EXPECTED_GRADUATION_YEAR
			 IS NULL THEN ''
			 ELSE 'GSY'+ CAST(stu.EXPECTED_GRADUATION_YEAR  AS VARCHAR (4))  
			 END						               AS [program_code]
		   , CONVERT(VARCHAR(10), ssy.ENTER_DATE, 120) AS [date_enrolled]
		   , CASE WHEN ssy.LEAVE_DATE IS NULL THEN ''
			 ELSE CONVERT(VARCHAR(10), ssy.LEAVE_DATE, 120)
			 END									   AS [date_withdrawn]
		   , ''									       AS [date_iep]
		   , ''									       AS [date_iep_end]
	FROM   rev.EPC_STU                    stu
		   JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
		   join rev.EPC_STU_YR            SOR  ON SOR.STU_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU  
		   JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
												  and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
		   JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU          = oyr.YEAR_GU
		   JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
		   JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
		   JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
		   LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grade ON grade.VALUE_CODE = ssy.GRADE

	WHERE  ssy.ENTER_DATE is not null
	AND grade.VALUE_DESCRIPTION IN ( '09', '10', '11', '12','C1', 'C2', 'C3', 'C4', 'T1', 'T2', 'T3', 'T4','H0','H1','H2','H3','H4','H5','H6','H7','H8','H9') 
	)AS T1


DECLARE @SBA_READING
	TABLE
		(
		SIS_NUMBER VARCHAR (50)
		,LAST_NAME VARCHAR (50)
		,FIRST_NAME VARCHAR (50)
		,GRADE VARCHAR (50)
		,TEST_NAME VARCHAR (50)
		,TEST VARCHAR (50)
		,SCALE_SCORE VARCHAR (50)
		,PL VARCHAR (50)
		
		)
INSERT INTO @SBA_READING
	

SELECT 
	SIS_NUMBER
	,LAST_NAME
	,FIRST_NAME
	,ALT_CODE_2 AS GRADE
	,TEST_NAME
	,PART_DESCRIPTION AS TEST
	,TEST_SCORE AS SCALE_SCORE
	,PERFORMANCE_LEVEL AS PL
	
FROM
(
SELECT 
	   row_number() over (partition by SIS_NUMBER order by CAST(test_score AS INT) desc) as high
	   ,PERSON.FIRST_NAME
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
       TEST_NAME = 'SBA HS 2011 Plus'
	   and PART_DESCRIPTION = 'READING'
--       AND SIS_NUMBER = '102955598'
       AND SCORE_DESCRIPTION IN ('Scale')
) AS T1
WHERE high = 1

DECLARE @SBA_MATH
	TABLE
		(
		SIS_NUMBER VARCHAR (50)
		,LAST_NAME VARCHAR (50)
		,FIRST_NAME VARCHAR (50)
		,GRADE VARCHAR (50)
		,TEST_NAME VARCHAR (50)
		,TEST VARCHAR (50)
		,SCALE_SCORE VARCHAR (50)
		,PL VARCHAR (50)
		
		)
INSERT INTO @SBA_MATH
	

SELECT 
	SIS_NUMBER
	,LAST_NAME
	,FIRST_NAME
	,ALT_CODE_2 AS GRADE
	,TEST_NAME
	,PART_DESCRIPTION AS TEST
	,TEST_SCORE AS SCALE_SCORE
	,PERFORMANCE_LEVEL AS PL
	
FROM
(
SELECT 
	   row_number() over (partition by SIS_NUMBER order by CAST(test_score AS INT) desc) as high
	   ,PERSON.FIRST_NAME
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
       TEST_NAME = 'SBA HS 2011 Plus'
	   and PART_DESCRIPTION = 'MATH'
--       AND SIS_NUMBER = '102955598'
       AND SCORE_DESCRIPTION IN ('Scale')
) AS T1
WHERE high = 1

DECLARE @SBA_SCIENCE
	TABLE
		(
		SIS_NUMBER VARCHAR (50)
		,LAST_NAME VARCHAR (50)
		,FIRST_NAME VARCHAR (50)
		,GRADE VARCHAR (50)
		,TEST_NAME VARCHAR (50)
		,TEST VARCHAR (50)
		,SCALE_SCORE VARCHAR (50)
		,PL VARCHAR (50)
		
		)
INSERT INTO @SBA_SCIENCE
	

SELECT 
	SIS_NUMBER
	,LAST_NAME
	,FIRST_NAME
	,ALT_CODE_2 AS GRADE
	,TEST_NAME
	,PART_DESCRIPTION AS TEST
	,TEST_SCORE AS SCALE_SCORE
	,PERFORMANCE_LEVEL AS PL
	
FROM
(
SELECT 
	   row_number() over (partition by SIS_NUMBER order by CAST(test_score AS INT) desc) as high
	   ,PERSON.FIRST_NAME
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
       TEST_NAME = 'SBA HS 2011 Plus'
	   and PART_DESCRIPTION = 'SCIENCE'
--       AND SIS_NUMBER = '102955598'
       AND SCORE_DESCRIPTION IN ('Scale')
) AS T1
WHERE high = 1

DECLARE @PARCC_ELA_11
	TABLE
		(
		SIS_NUMBER VARCHAR (50)
		,LAST_NAME VARCHAR (50)
		,FIRST_NAME VARCHAR (50)
		,GRADE VARCHAR (50)
		,TEST_NAME VARCHAR (50)
		,TEST VARCHAR (50)
		,SCALE_SCORE VARCHAR (50)
		,PL VARCHAR (50)
		
		)
INSERT INTO @PARCC_ELA_11
	

SELECT 
	SIS_NUMBER
	,LAST_NAME
	,FIRST_NAME
	,ALT_CODE_2 AS GRADE
	,TEST_NAME
	,PART_DESCRIPTION AS TEST
	,TEST_SCORE AS SCALE_SCORE
	,PERFORMANCE_LEVEL AS PL
	
FROM
(
SELECT 
	   row_number() over (partition by SIS_NUMBER order by CAST(test_score AS INT) desc) as high
	   ,PERSON.FIRST_NAME
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
       TEST_NAME = 'PARCC HS ELA/L English 11'
--	   and PART_DESCRIPTION = 'READING'
----       AND SIS_NUMBER = '102955598'
--       AND SCORE_DESCRIPTION IN ('Scale')
) AS T1
WHERE high = 1

DECLARE @PARCC_GEOM
	TABLE
		(
		SIS_NUMBER VARCHAR (50)
		,LAST_NAME VARCHAR (50)
		,FIRST_NAME VARCHAR (50)
		,GRADE VARCHAR (50)
		,TEST_NAME VARCHAR (50)
		,TEST VARCHAR (50)
		,SCALE_SCORE VARCHAR (50)
		,PL VARCHAR (50)
		
		)
INSERT INTO @PARCC_GEOM
	

SELECT 
	SIS_NUMBER
	,LAST_NAME
	,FIRST_NAME
	,ALT_CODE_2 AS GRADE
	,TEST_NAME
	,PART_DESCRIPTION AS TEST
	,TEST_SCORE AS SCALE_SCORE
	,PERFORMANCE_LEVEL AS PL
	
FROM
(
SELECT 
	   row_number() over (partition by SIS_NUMBER order by CAST(test_score AS INT) desc) as high
	   ,PERSON.FIRST_NAME
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
       TEST_NAME = 'PARCC HS Geometry'
--	   and PART_DESCRIPTION = 'READING'
----       AND SIS_NUMBER = '102955598'
--       AND SCORE_DESCRIPTION IN ('Scale')
) AS T1
WHERE high = 1

DECLARE @PARCC_ALG_II
	TABLE
		(
		SIS_NUMBER VARCHAR (50)
		,LAST_NAME VARCHAR (50)
		,FIRST_NAME VARCHAR (50)
		,GRADE VARCHAR (50)
		,TEST_NAME VARCHAR (50)
		,TEST VARCHAR (50)
		,SCALE_SCORE VARCHAR (50)
		,PL VARCHAR (50)
		
		)
INSERT INTO @PARCC_ALG_II
	

SELECT 
	SIS_NUMBER
	,LAST_NAME
	,FIRST_NAME
	,ALT_CODE_2 AS GRADE
	,TEST_NAME
	,PART_DESCRIPTION AS TEST
	,CAST(TEST_SCORE AS INT) AS SCALE_SCORE
	,PERFORMANCE_LEVEL AS PL
	
FROM
(
SELECT 
	   row_number() over (partition by SIS_NUMBER order by CAST(test_score AS INT) desc) as high
	   ,PERSON.FIRST_NAME
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

	   --SELECT *
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
       TEST_NAME = 'PARCC HS Algebra II'
--	   and PART_DESCRIPTION = 'READING'
----       AND SIS_NUMBER = '102955598'
--       AND SCORE_DESCRIPTION IN ('Scale')
) AS T1
WHERE high = 1

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
	,READING
	,SCIENCE
	
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
	COUNT (SIS_NUMBER) FOR PART_DESCRIPTION IN ([MATH], [READING], [SCIENCE])) AS COUNTS 
		

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
		,SBA_MATH_ATTEMPTS VARCHAR (50)
		,SBA_READING_ATTEMPTS VARCHAR (50)
		,SBA_SCIENCE_ATTEMPTS VARCHAR (50)

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
		,SBA_MATH_ATTEMPTS
		,SBA_READING_ATTEMPTS
		,SBA_SCIENCE_ATTEMPTS
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
		,WR_CNT.TEST AS WRI_ATTEMPTS
		,SBA_CNTS.MATH AS SBA_MATH_ATTEMPTS
		,SBA_CNTS.READING AS SBA_READING_ATTEMPTS
		,SBA_CNTS.SCIENCE AS SBA_SCIENCE_ATTEMPTS

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

	) AS T1

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
		,SBA_MATH_ATTEMPTS VARCHAR (50)
		,SBA_READING_ATTEMPTS VARCHAR (50)
		,SBA_SCIENCE_ATTEMPTS VARCHAR (50)
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
		,CASE WHEN PASS_FAIL_MATH = 'PASS' OR PASS_FAIL_COMBO = 'PASS' OR PASS_FAIL_PARCC_ALG_II = 'PASS' OR PASS_FAIL_PARCC_GEOM = 'PASS' THEN 'PASSED'
		END AS 'MATH REQUIREMENTS'
		,CASE WHEN PASS_FAIL_READING = 'PASS' OR PASS_FAIL_COMBO = 'PASS' OR PASS_FAIL_PARCC_ELA_11 = 'PASS' THEN 'PASSED'
		END AS 'READING REQUIREMENTS'
		,CASE WHEN PASS_FAIL_PARCC_ELA_11 = 'PASS' THEN 'PASSED'
		END AS 'WRITING REQUIREMENTS'
		,CASE WHEN PASS_FAIL_SCIENCE = 'PASS' THEN 'PASSED'
		END AS 'SCIENCE REQUIREMENTS'
		,SBA_MATH_ATTEMPTS
		,SBA_READING_ATTEMPTS
		,SBA_SCIENCE_ATTEMPTS
		,WRI_ATTEMPTS
		,SS_ATTEMPTS
	FROM
		@EOC_SBA_AND_EOC

--SELECT * FROM @SBA_READING
--SELECT * FROM @SBA_MATH
--SELECT * FROM @SBA_SCIENCE
--SELECT * FROM @STUDENTS
--SELECT * FROM @EOC_SBA_AND_EOC
--SELECT * FROM @SBA_CNTS
--SELECT * FROM @EOC_HIST
SELECT * FROM @EXIT_EXAM_STATUS
WHERE GRADE = '12'
--WHERE SIS_NUMBER = '100038934'
ORDER BY SIS_NUMBER