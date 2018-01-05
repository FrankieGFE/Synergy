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
 * English Language Learner (ELL)
 * 
	
****/

SELECT  
         stu.SIS_NUMBER                            AS [student_code]
       , yr.SCHOOL_YEAR                            AS [school_year]
       , sch.SCHOOL_CODE                           AS [school_code]
       , 'ELL'						               AS [program_code]
       , CONVERT(VARCHAR(10), ELL.ENTRY_DATE, 120) AS [date_enrolled]
       , CONVERT(VARCHAR(10), ELL.EXIT_DATE, 120)  AS [date_withdrawn]
	   , CONVERT(VARCHAR(10), NULL, 120)		   AS [date_iep]
	   , CONVERT(VARCHAR(10), NULL, 120)		   AS [date_iep_end]
FROM   rev.EPC_STU                    stu
       JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
	   join rev.EPC_STU_YR AS SOR		   ON SOR.STU_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU  
       JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                              and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU          = oyr.YEAR_GU
       JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
       JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
	   JOIN rev.EPC_STU_PGM_ELL_HIS AS ELL ON ELL.STUDENT_GU = stu.STUDENT_GU

WHERE  ssy.ENTER_DATE is not null
AND (ELL.EXIT_DATE IS NULL OR ELL.EXIT_DATE > '2014-08-15')
ORDER BY ELL.EXIT_DATE DESC
	   



 
