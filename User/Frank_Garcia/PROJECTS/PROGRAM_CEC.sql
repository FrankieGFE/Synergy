USE ST_Production
GO

/****
 
 * $LastChangedBy: Frank Garcia
 * $LastChangedDate: 10/16/2015 $
 *
 * Request By: SchoolNet
 * InitialRequestDate: 10/15/2015
 * 
 * Initial Request:
 * CEC
 * 
	
****/
SELECT  
        [student_code]
       , [school_year]
       , [school_code]
	   , [program_code]
       , [date_enrolled]
       , [date_withdrawn]
	   , [date_iep]
	   , [date_iep_end]
	   --,school
FROM
(
SELECT  row_number() over(partition by stu.SIS_NUMBER order by SSY.ENTER_DATE) rn
       , stu.SIS_NUMBER                           AS [student_code]
       , yr.SCHOOL_YEAR                           AS [school_year]
       , SOR.SOR		                          AS [school_code]
	   , sch.SIS_SCHOOL_CODE as school
	   , 'CEC'									  AS [program_code]
       , CONVERT(VARCHAR(10),ssy.ENTER_DATE,120)  AS [date_enrolled]
       , CONVERT(VARCHAR(10),ssy.LEAVE_DATE,120)  AS [date_withdrawn]
	   , CONVERT(VARCHAR(10), NULL, 120)		  AS [date_iep]
	   , CONVERT(VARCHAR(10), NULL, 120)		  AS [date_iep_end]
	   --, SOR.SOR
FROM   rev.EPC_STU                             stu
       JOIN rev.EPC_STU_SCH_YR                 ssy  ON ssy.STUDENT_GU                    = stu.STUDENT_GU
       JOIN rev.REV_ORGANIZATION_YEAR          oyr  ON oyr.ORGANIZATION_YEAR_GU          = ssy.ORGANIZATION_YEAR_GU
                                                       and oyr.YEAR_GU                   = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       JOIN rev.REV_YEAR                       yr   ON yr.YEAR_GU                        = oyr.YEAR_GU
	   JOIN rev.EPC_SCH                        sch  ON sch.ORGANIZATION_GU               = oyr.ORGANIZATION_GU
	   LEFT JOIN
			(
			SELECT	
				sch.SCHOOL_CODE AS SOR
				,stu.STUDENT_GU
			FROM   rev.EPC_STU                    stu
			   JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
			   join rev.EPC_STU_YR AS SOR		   ON SOR.STU_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU  
			   JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
													  and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
			   JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU          = oyr.YEAR_GU
			   JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
			   JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
			WHERE  ssy.ENTER_DATE is not null
			) AS SOR
		ON stu.STUDENT_GU = SOR.STUDENT_GU

				
WHERE sch.SCHOOL_CODE = '592'
AND SSY.ENTER_DATE IS NOT NULL
) AS DC
WHERE rn = 1
--AND student_code = '100047463'
ORDER BY date_enrolled