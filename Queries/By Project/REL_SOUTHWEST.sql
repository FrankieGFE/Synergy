/**
 * 
 * $CreatedBy: Frank Garcia
 * $Date: 10/10/2016 $
 * Requested by Andy Gutierez
   Frank - since Shayne is handling the YDI request, can you please work on this one to try to complete by 10/14 also.  
   Please look through the attachments indicating the SY's and data being requested and let me know if you'd like to meet with Deb and I to go over.  
   The sample file layout shows one row per student for all years, don't know if we can possibly handle this with a pivot, but we can discuss.  
   Thanks - Andy
 */

/**/

WITH ACCESS AS
(
SELECT 
	STUDENT_ID
	,[2009] AS 'English Proficiancy Code 2009-2010'
	,[2010] AS 'English Proficiancy Code 2010-2011'
	,[2011] AS 'English Proficiancy Code 2011-2012'
	,[2012] AS 'English Proficiancy Code 2012-2013'
	,[2013] AS 'English Proficiancy Code 2013-2014'
	,[2014] AS 'English Proficiancy Code 2014-2015'
FROM
(
SELECT 
       CAST (SIS_NUMBER AS INT) AS STUDENT_ID
	   ,CAST(LEFT(CONVERT(VARCHAR ,ADMIN_DATE,121),4) AS INT)-1  AS SY
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
WHERE
1 = 1
	   AND PART_DESCRIPTION = 'ACCESS'
       AND SCORE_DESCRIPTION IN ('Overall LP')
) AS ACCESS
PIVOT
	(MAX([TEST_SCORE]) FOR SY IN ([2009],[2010],[2011],[2012],[2013],[2014])) AS UP1
WHERE 1 = 1

) 
,STU_GRADE AS
(
SELECT
	student_id
	,CASE WHEN [2009] IS NULL THEN 'Missing' ELSE [2009] END AS 'Current Grade 2009-2010'
	,CASE WHEN [2010] IS NULL THEN 'Missing' ELSE [2010] END AS 'Current Grade 2010-2011'
	,CASE WHEN [2011] IS NULL THEN 'Missing' ELSE [2011] END AS 'Current Grade 2011-2012'
	,CASE WHEN [2012] IS NULL THEN 'Missing' ELSE [2012] END AS 'Current Grade 2012-2013'
	,CASE WHEN [2013] IS NULL THEN 'Missing' ELSE [2013] END AS 'Current Grade 2013-2014'
	,CASE WHEN [2014] IS NULL THEN 'Missing' ELSE [2014] END AS 'Current Grade 2014-2015'
FROM
(
SELECT 
	ENR.SIS_NUMBER AS student_id
	,GRADE AS grade
	,ENR.SCHOOL_YEAR

FROM
	APS.StudentEnrollmentDetails AS ENR WITH (NOLOCK)
	LEFT JOIN
	rev.EPC_STU AS STU WITH (NOLOCK)
	ON ENR.SIS_NUMBER = STU.SIS_NUMBER

	LEFT JOIN
	rev.REV_PERSON AS PER WITH (NOLOCK)
	ON PER.PERSON_GU = STU.STUDENT_GU

	LEFT JOIN
	APS.BasicStudentWithMoreInfo AS BS WITH (NOLOCK)
	ON BS.SIS_NUMBER = ENR.SIS_NUMBER
WHERE 
	1 = 1
	AND EXTENSION = 'R'
	AND SCHOOL_YEAR IN ('2009','2010','2011','2012','2013','2014')
	AND ENR.LEAVE_DATE IS NULL
	AND ENR.EXCLUDE_ADA_ADM IS NULL
	AND ENR.ENTER_DATE IS NOT NULL
) AS SG

PIVOT
	(MAX([grade]) FOR school_year IN ([2009],[2010],[2011],[2012],[2013],[2014])) AS UP1
) 
,WMLS AS
(
SELECT 
	STUDENT_ID
	,[2009] AS 'WMLS 2009-2010'
	,[2010] AS 'WMLS 2010-2011'
	,[2011] AS 'WMLS 2011-2012'
	,[2012] AS 'WMLS 2012-2013'
	,[2013] AS 'WMLS 2013-2014'
	,[2014] AS 'WMLS 2014-2015'
FROM
(
SELECT 
       CAST (SIS_NUMBER AS INT) AS STUDENT_ID
	   ,CASE WHEN DATENAME(month, admin_date) IN ('AUGUST','SEPTEMBER','OCTOBER','NOVEMBER','DECEMBER') THEN CAST(LEFT(CONVERT(VARCHAR ,ADMIN_DATE,121),4) AS INT) ELSE CAST(LEFT(CONVERT(VARCHAR ,ADMIN_DATE,121),4) AS INT)-1 END  AS SY
       ,SCORES.TEST_SCORE
	   ,TEST_NAME
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
1 = 1
	   AND TEST_NAME = 'WAPT'
) AS WMLS
PIVOT
	(MAX([TEST_SCORE]) FOR SY IN ([2009],[2010],[2011],[2012],[2013],[2014])) AS UP1
WHERE 1 = 1
)

SELECT
	STU_GRADE.student_id
	,[Current Grade 2009-2010]
	,[Current Grade 2010-2011]
	,[Current Grade 2011-2012]
	,[Current Grade 2012-2013]
	,[Current Grade 2013-2014]
	,[Current Grade 2014-2015]
	,CASE WHEN [English Proficiancy Code 2009-2010] IS NULL THEN 'Missing' ELSE [English Proficiancy Code 2009-2010] END AS 'English Proficiancy Code 2009-2010'
	,CASE WHEN [English Proficiancy Code 2010-2011] IS NULL THEN 'Missing' ELSE [English Proficiancy Code 2010-2011] END AS 'English Proficiancy Code 2010-2011'
	,CASE WHEN [English Proficiancy Code 2011-2012] IS NULL THEN 'Missing' ELSE [English Proficiancy Code 2011-2012] END AS 'English Proficiancy Code 2011-2012'
	,CASE WHEN [English Proficiancy Code 2012-2013] IS NULL THEN 'Missing' ELSE [English Proficiancy Code 2012-2013] END AS 'English Proficiancy Code 2012-2013'
	,CASE WHEN [English Proficiancy Code 2013-2014] IS NULL THEN 'Missing' ELSE [English Proficiancy Code 2013-2014] END AS 'English Proficiancy Code 2013-2014'
	,CASE WHEN [English Proficiancy Code 2014-2015] IS NULL THEN 'Missing' ELSE [English Proficiancy Code 2014-2015] END AS 'English Proficiancy Code 2014-2015'
	,CASE WHEN [WMLS 2009-2010] IS NULL THEN 'Missing' ELSE [WMLS 2009-2010] END AS [WMLS 2009-2010]
	,CASE WHEN [WMLS 2010-2011] IS NULL THEN 'Missing' ELSE [WMLS 2010-2011] END AS [WMLS 2010-2011]
	,CASE WHEN [WMLS 2011-2012] IS NULL THEN 'Missing' ELSE [WMLS 2011-2012] END AS [WMLS 2011-2012]
	,CASE WHEN [WMLS 2012-2013] IS NULL THEN 'Missing' ELSE [WMLS 2012-2013] END AS [WMLS 2012-2013]
	,CASE WHEN [WMLS 2013-2014] IS NULL THEN 'Missing' ELSE [WMLS 2013-2014] END AS [WMLS 2013-2014]
	,CASE WHEN [WMLS 2014-2015] IS NULL THEN 'Missing' ELSE [WMLS 2014-2015] END AS [WMLS 2014-2015]
FROM
	stu_grade
LEFT JOIN
	ACCESS
	ON STU_GRADE.student_id = ACCESS.STUDENT_ID
LEFT JOIN
	WMLS
	ON STU_GRADE.student_id = WMLS.STUDENT_ID
ORDER BY student_id