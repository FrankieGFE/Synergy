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
 * SPED
 * 
	
****/

SELECT  
         stu.SIS_NUMBER                               AS [student_code]
	   , stu.STATE_STUDENT_NUMBER					  AS [state_id]
       , yr.SCHOOL_YEAR                               AS [school_year]
       , sch.SCHOOL_CODE                              AS [school_code]
       , CS.PRIMARY_DISABILITY_CODE                   AS [program_code]
	   ,RIGHT(LI.LEVEL_INTEGRATION ,3) AS LOI
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
	   LEFT JOIN 
		(
		SELECT 
			SIS_NUMBER
			,LEVELS.VALUE_DESCRIPTION AS LEVEL_INTEGRATION
			,LEVEL_INTEGRATION AS LI_CODE
			,LEVELS.VALUE_CODE
		FROM rev.UD_SPED_SERVICE_LEVEL AS SPED
		INNER JOIN
		rev.EPC_STU AS STU
		ON
		SPED.STUDENT_GU = STU.STUDENT_GU
		INNER JOIN 
		APS.LookupTable ('K12.SpecialEd.IEP', 'LEVEL_INTEGRATION') AS LEVELS
		ON
		LEVELS.VALUE_CODE = SPED.LEVEL_INTEGRATION
		) AS LI
		ON stu.SIS_NUMBER = LI.SIS_NUMBER
	   LEFT JOIN
            (
            SELECT
                        SPED.STUDENT_GU
                        ,PRIMARY_DISABILITY_CODE
						,NEXT_IEP_DATE
            FROM
                        REV.EP_STUDENT_SPECIAL_ED AS SPED
						INNER JOIN
						APS.PRIMARYENROLLMENTSASOF (GETDATE()) AS ENR
						ON ENR.STUDENT_GU = SPED.STUDENT_GU
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
	   --AND ssy.LEAVE_DATE IS NULL
	   --AND RIGHT(LI.LEVEL_INTEGRATION,3) NOT IN ('(A)','(B)')
	   --AND CS.PRIMARY_DISABILITY_CODE != 'GI'
	   --and stu.SIS_NUMBER = '103398962'
	   ORDER BY LOI
	   



 
