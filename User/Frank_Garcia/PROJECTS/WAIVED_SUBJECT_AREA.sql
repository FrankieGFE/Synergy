--SELECT 
--	STU.SIS_NUMBER
--	,WAIVR.WAIVED_SUBJECT_AREA
--	,WAIVR.*
--FROM
--	REV.EPC_STU_CRS_HIS_WAIVR_AREA AS WAIVR

--JOIN
--REV.EPC_STU AS STU
--ON STU.STUDENT_GU = WAIVR.STUDENT_GU
--WHERE WAIVED_SUBJECT_AREA IS NOT NULL

SELECT  
	     stu.SIS_NUMBER                            AS [student_code]
	   , stu.STATE_STUDENT_NUMBER				   AS [state_id]
       , yr.SCHOOL_YEAR                            AS [school_year]
       , sch.SCHOOL_CODE                           AS [school_code]
	   , REPLACE (PER.FIRST_NAME, '''','')							   AS [FIRST_NAME]
	   , REPLACE (per.LAST_NAME,'''','')			   AS [LAST_NAME]
	   , CONVERT(VARCHAR(10), per.BIRTH_DATE, 120) AS [dob]
	   , grade.VALUE_DESCRIPTION 				   AS GRADE
	   ,WAIVR.WAIVED_SUBJECT_AREA
	   ,WAIVR.WAIVED_SUBJECT_AREA
	   ,WAIVR.COMMENTS
FROM   rev.EPC_STU                    stu
       JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
	   join rev.EPC_STU_YR            SOR  ON SOR.STU_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU  
       JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                              --and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU          = oyr.YEAR_GU
       JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
       JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
	   JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
	   JOIN REV.EPC_STU_CRS_HIS_WAIVR_AREA AS WAIVR ON WAIVR.STUDENT_GU = STU.STUDENT_GU
	   LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grade ON grade.VALUE_CODE = ssy.GRADE


WHERE  ssy.ENTER_DATE is not null
AND YR.SCHOOL_YEAR = '2016'