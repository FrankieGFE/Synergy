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
 * ELS SERVICES REFUSED (GSY)
 * 
	
****/

SELECT  
         stu.SIS_NUMBER                            AS [student_code]
       , yr.SCHOOL_YEAR                            AS [school_year]
       , sch.SCHOOL_CODE                           AS [school_code]
       , 'ESL-R'					               AS [program_code]
       , CONVERT(VARCHAR(10), ssy.ENTER_DATE, 120) AS [date_enrolled]
       , CONVERT(VARCHAR(10), ssy.LEAVE_DATE, 120) AS [date_withdrawn]
	   , ''									   AS [date_iep]
	   , ''									   AS [date_iep_end]
FROM   rev.EPC_STU                    stu
       JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
	   join rev.EPC_STU_YR AS SOR		   ON SOR.STU_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU  
       JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                              and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU          = oyr.YEAR_GU
       JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
       JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
	   JOIN rev.EPC_STU_PGM_ELL_WAV  rell  ON rell.STUDENT_GU = stu.STUDENT_GU AND rell.WAIVER_TYPE = 'RALS'

WHERE  ssy.ENTER_DATE is not null
	   



 
