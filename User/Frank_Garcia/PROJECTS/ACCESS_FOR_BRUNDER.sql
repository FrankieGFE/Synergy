USE ST_Production
GO

/****
 
 * $LastChangedBy: Frank Garcia
 * $LastChangedDate: 9/9/2014 $
 *
 * Request By: SchoolNet
 * InitialRequestDate: 
 * 
 * Initial Request:
 * GRAD STANDARD YEAR (GSY)
 * 
	
****/

SELECT  
	     stu.SIS_NUMBER                            AS [student_code]
	   , stu.STATE_STUDENT_NUMBER				   AS [state_id]
       , yr.SCHOOL_YEAR                            AS [school_year]
       , sch.SCHOOL_CODE                           AS [school_code]
	   , REPLACE (PER.FIRST_NAME, '''','')							   AS [FIRST_NAME]
	   , REPLACE (per.LAST_NAME,'''','')			   AS [LAST_NAME]
	   , CONVERT(VARCHAR(10), per.BIRTH_DATE, 120) AS [dob]
	   , grade.VALUE_DESCRIPTION 				   AS GRADE
	   ,T1.TEST_NAME
	   ,T1.SCORE_DESCRIPTION
	   ,T1.PL
	   ,T1.TEST_SCORE
	   ,T1.ADMIN_DATE
   --    , CASE WHEN stu.EXPECTED_GRADUATION_YEAR
		 --IS NULL THEN ''
		 --ELSE 'GSY'+ CAST(stu.EXPECTED_GRADUATION_YEAR  AS VARCHAR (4))  
		 --END						               AS [program_code]
   --    , CONVERT(VARCHAR(10), ssy.ENTER_DATE, 120) AS [date_enrolled]
   --    , CASE WHEN ssy.LEAVE_DATE IS NULL THEN ''
	  --   ELSE CONVERT(VARCHAR(10), ssy.LEAVE_DATE, 120)
		 --END									   AS [date_withdrawn]
	  -- , ''									       AS [date_iep]
	  -- , ''									       AS [date_iep_end]
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

--WHERE  ssy.ENTER_DATE is not null
--AND  ssy.LEAVE_DATE IS NULL
--AND STU.SIS_NUMBER = '122081'
--AND sch.SCHOOL_CODE = '255'
LEFT JOIN

(
SELECT 
	   ROW_NUMBER () OVER (PARTITION BY SIS_NUMBER ORDER BY TEST_SCORE DESC) AS RN
	   ,PERSON.FIRST_NAME
       ,PERSON.LAST_NAME
       ,CAST (SIS_NUMBER AS INT) AS SIS_NUMBER
       ,TEST.TEST_NAME
	   ,PART.PART_DESCRIPTION
	   ,TEST.TEST_LEVEL
	   ,TEST.TEST_FORM
	   ,ORGANIZATION_NAME
	   ,'' AS SCHOOL_YEAR
	   ,'' AS TEST_DESCRIPTION
	   ,TEST.TEST_TYPE
	   ,TEST.TEST_GROUP
	   ,TEST.TEST_DEF_CODE
       --,PART.PART_DESCRIPTION
       ,SCORE_DESCRIPTION
       ,STU_PART.PERFORMANCE_LEVEL AS PL
       ,SCORES.TEST_SCORE
       ,STUDENTTEST.ADMIN_DATE
       ,PART.PART_NUMBER
	   ,TST_GRPYT.TEST_REQ_MIN_SCORE
	   ,TST_GRPY.TEST_GROUP_NAME
	   ,DEF_GRPYT.TEST_ATTEMPTS_MIN
	   ,GRPYT_PL.PERFORMANCE_LEVEL
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

	   LEFT JOIN
	   REV.EPC_GRAD_REQ_DEF_TST_GRPYT AS TST_GRPYT
	   ON
	   TEST.TEST_GU = TST_GRPYT.TEST_GU
	   AND PART.TEST_PART_GU = TST_GRPYT.TEST_PART_GU
	   
	   LEFT JOIN
	   REV.EPC_GRAD_REQ_DEF_TST_GRPY AS TST_GRPY
	   ON 
	   TST_GRPY.GRAD_REQ_DEF_TST_GRPY_GU = TST_GRPYT.GRAD_REQ_DEF_TST_GRPY_GU

	   LEFT JOIN
	   REV.EPC_GRAD_REQ_DEF_GRPYT_REQ AS DEF_GRPYT
	   ON
	   DEF_GRPYT.TEST_GU = TEST.TEST_GU
	   AND DEF_GRPYT.GRAD_REQ_DEF_TST_GRPTY_GU = TST_GRPYT.GRAD_REQ_DEF_TST_GRPTY_GU

	   LEFT JOIN
	   REV.EPC_GRAD_REQ_DEF_GRPYT_PL AS GRPYT_PL
	   ON GRPYT_PL.GRAD_REQ_DEF_TST_GRPTY_GU = DEF_GRPYT.GRAD_REQ_DEF_TST_GRPTY_GU



WHERE
1 = 1
       --AND TEST_NAME = 'SBA'
	   AND PART_DESCRIPTION = 'ACCESS'
       --AND SIS_NUMBER = '102955598'
       --AND SCORE_DESCRIPTION IN ('Overall LP')
	   --AND TEST_SCORE != 'NA'
       --AND TEST_NAME = 'EOC Music 9 12 V001'
) AS T1
ON T1.SIS_NUMBER = STU.SIS_NUMBER
WHERE  ssy.ENTER_DATE is not null
--AND  ssy.LEAVE_DATE IS NULL
--AND STU.SIS_NUMBER = '122081'
AND sch.SCHOOL_CODE = '255'

ORDER BY  ADMIN_DATE DESC


 
