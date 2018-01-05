USE ST_Production
GO

/****
 
 * $LastChangedBy: Frank Garcia
 * $LastChangedDate: 9/18/2014 $
 *
 * Request By: SchoolNet
 * InitialRequestDate: 
 * 
 * Initial Request:
 * FEEDS_TO (Feed)
 * 
	
****/

SELECT  
         stu.SIS_NUMBER                             AS [student_code]
	   , PER.LAST_NAME
	   , PER.FIRST_NAME
       , yr.SCHOOL_YEAR                       AS [school_year]
       , sch.SCHOOL_CODE                            AS [school_code]
       --, 'Feed'+ sch.SCHOOL_CODE	 			    AS [program_code]
       --, '2015-02-01'							    AS [date_enrolled]
	   , CASE WHEN ELL.PROGRAM_CODE = '1'
		     THEN 'ELL' ELSE ''
		END	AS 'ELL'
       --, CONVERT(VARCHAR(10), ssy.ENTER_DATE, 120)  AS [date_enrolled]
    --   , CONVERT(VARCHAR(10), ssy.LEAVE_DATE, 120)  AS [date_withdrawn]
	   --, CONVERT(VARCHAR(10), NULL, 120)		    AS [date_iep]
	   --, CONVERT(VARCHAR(10), NULL, 120)		    AS [date_iep_end]
	   , grade.VALUE_DESCRIPTION                    AS [grade_code]
FROM   rev.EPC_STU                    stu
       JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
	   join rev.EPC_STU_YR AS SOR		   ON SOR.STU_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU  
       JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                              and oyr.YEAR_GU = 'BCFE2270-A461-4260-BA2B-0087CB8EC26A'
       JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU          = oyr.YEAR_GU
       JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
       JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
	   LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grade ON grade.VALUE_CODE = ssy.GRADE
	   LEFT JOIN rev.EPC_STU_PGM_ELL_HIS AS ELL ON ELL.STUDENT_GU = stu.STUDENT_GU
	   LEFT JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU

WHERE  ssy.ENTER_DATE is not null
AND (ELL.EXIT_DATE IS NULL OR ELL.EXIT_DATE > '2015-05-21')
AND sch.SCHOOL_CODE = '452'
--AND sch.SCHOOL_CODE = '520'
--AND grade.VALUE_DESCRIPTION = '09'
--AND stu.SIS_NUMBER = '970092962'
ORDER BY ELL.PROGRAM_CODE

	   



 
