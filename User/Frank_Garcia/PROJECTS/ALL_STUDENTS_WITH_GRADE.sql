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
                                              --and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU          = oyr.YEAR_GU
       JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
       JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
	   JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
	   LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grade ON grade.VALUE_CODE = ssy.GRADE

WHERE  ssy.ENTER_DATE is not null
AND YR.SCHOOL_YEAR = '2016'


--AND  ssy.LEAVE_DATE IS NULL
--AND STU.SIS_NUMBER = '122081'
	   --AND stu.EXPECTED_GRADUATION_YEAR IS NOT NULL



 
