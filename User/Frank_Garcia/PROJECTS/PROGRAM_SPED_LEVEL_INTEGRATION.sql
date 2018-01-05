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
 * SPED LEVEL OF INTEGRATION
 * 
	
****/
SELECT
	student_code
	,school_year
	,school_code
	,program_code
	,date_enrolled
	,date_withdrawn
	,date_iep
	,date_iep_end
FROM
(
SELECT  
       ROW_NUMBER () OVER (PARTITION BY stu.SIS_NUMBER  ORDER BY rpt.ADD_DATE_TIME_STAMP ) AS RN,
	    stu.SIS_NUMBER                                AS [student_code]
       , yr.SCHOOL_YEAR                               AS [school_year]
       , sch.SCHOOL_CODE                              AS [school_code]
       , LI.VALUE_DESCRIPTION                         AS [program_code]
       , CONVERT(VARCHAR(10), ssy.ENTER_DATE, 120)    AS [date_enrolled]
       , CONVERT(VARCHAR(10), ssy.LEAVE_DATE, 120)    AS [date_withdrawn]
	   , CONVERT(VARCHAR(10), ssy.ENTER_DATE, 120)    AS [date_iep]
	   , CONVERT(VARCHAR(10), CS.NEXT_IEP_DATE, 120)  AS [date_iep_end]
FROM   rev.EPC_STU                    stu
       JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
	   join rev.EPC_STU_YR AS SOR		   ON SOR.STU_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU  
       JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                              and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU          = oyr.YEAR_GU
       JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
       JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
	   LEFT JOIN rev.EPC_NM_STU_SPED_RPT rpt ON rpt.STUDENT_GU = stu.STUDENT_GU
	   LEFT JOIN APS.LookupTable ('K12.SpecialEd.IEP', 'LEVEL_INTEGRATION') AS LI
	   ON LI.VALUE_CODE = rpt.LEVEL_INTEGRATION
	   AND rpt.SCHOOL_YEAR = YR.SCHOOL_YEAR
	   LEFT JOIN
            (
            SELECT
                        STUDENT_GU
                        ,PRIMARY_DISABILITY_CODE
						,NEXT_IEP_DATE
            FROM
                        REV.EP_STUDENT_SPECIAL_ED AS SPED
            WHERE
                        NEXT_IEP_DATE IS NOT NULL
                        AND (
                              EXIT_DATE IS NULL 
                              OR EXIT_DATE >= CONVERT(DATE, GETDATE())
                             )
            ) AS CS
        ON stu.STUDENT_GU = CS.STUDENT_GU


WHERE  ssy.ENTER_DATE is not null
	   AND CS.PRIMARY_DISABILITY_CODE IS NOT NULL
	   AND LI.VALUE_DESCRIPTION IS NOT NULL

	   
) AS T1
WHERE RN = 1	   
ORDER BY student_code


 
