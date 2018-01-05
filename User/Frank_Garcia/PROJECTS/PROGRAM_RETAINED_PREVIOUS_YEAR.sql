USE ST_Production
GO

/****
 
 * $LastChangedBy: Frank Garcia
 * $LastChangedDate: 10/30/2014 $
 *
 * Request By: SchoolNet
 * InitialRequestDate: 
 * 
 * Initial Request:
 * RETAINED (RET)
 * 
	
****/
SELECT
	student_code								AS [student_code]
	, yr.SCHOOL_YEAR							AS [school_year]
	, sch.SCHOOL_CODE							AS [school_code]
	, 'RET'										AS [program_code]
	, CONVERT(VARCHAR(10), ssy.ENTER_DATE, 120) AS [date_enrolled]
	, CONVERT(VARCHAR(10), ssy.LEAVE_DATE, 120) AS [date_withdrawn]
	, CONVERT(VARCHAR(10), NULL, 120)		    AS [date_iep]
	, CONVERT(VARCHAR(10), NULL, 120)		    AS [date_iep_end]

	
FROM
(

SELECT
	ROW_NUMBER () OVER (PARTITION BY student_code ORDER BY school_year DESC) AS RN
	,student_code
	,school_year
	--,school_code
	,program_code
	--,date_enrolled
	--,date_withdrawn
	--,date_iep
	--,date_iep_end
FROM
	(
	SELECT  
			 stu.SIS_NUMBER                            AS [student_code]
		   , yr.SCHOOL_YEAR                            AS [school_year]
		   , sch.SCHOOL_CODE                           AS [school_code]
		   , ssy.PREVIOUS_YEAR_END_STATUS              AS [program_code]
		   , CONVERT(VARCHAR(10), ssy.ENTER_DATE, 120) AS [date_enrolled]
		   , CONVERT(VARCHAR(10), ssy.LEAVE_DATE, 120) AS [date_withdrawn]
		   , CONVERT(VARCHAR(10), NULL, 120)		   AS [date_iep]
		   , CONVERT(VARCHAR(10), NULL, 120)		   AS [date_iep_end]
	FROM   rev.EPC_STU                    stu
		   JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
		   JOIN rev.EPC_STU_YR            SOR  ON SOR.STU_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU  
		   JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
												  and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
		   JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU          = oyr.YEAR_GU
		   JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
		   JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
	WHERE  ssy.ENTER_DATE is not null
	--AND ssy.PREVIOUS_YEAR_END_STATUS = 'R'
	
UNION

	
	SELECT  
			 stu.SIS_NUMBER                            AS [student_code]
		   , yr.SCHOOL_YEAR                            AS [2013_school_year]
		   , sch.SCHOOL_CODE                           AS [2013_school_code]
		   , ssy.YEAR_END_STATUS		               AS [program_code]
		   , CONVERT(VARCHAR(10), ssy.ENTER_DATE, 120) AS [date_enrolled]
		   , CONVERT(VARCHAR(10), ssy.LEAVE_DATE, 120) AS [date_withdrawn]
		   , CONVERT(VARCHAR(10), NULL, 120)		   AS [date_iep]
		   , CONVERT(VARCHAR(10), NULL, 120)		   AS [date_iep_end]
	FROM   rev.EPC_STU                    stu
		   JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
		   JOIN rev.EPC_STU_YR            SOR  ON SOR.STU_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU  
		   JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
												  --and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
		   JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU          = oyr.YEAR_GU
		   JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
		   JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
	WHERE  ssy.ENTER_DATE is not null
	--AND ssy.YEAR_END_STATUS = 'R'
	AND yr.SCHOOL_YEAR = 2013
) AS RET3
WHERE program_code = 'R'
and date_enrolled is not null
) AS RET2
		   LEFT JOIN rev.EPC_STU          stu  ON RET2.student_code = stu.SIS_NUMBER
		   JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
		   JOIN rev.EPC_STU_YR            SOR  ON SOR.STU_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU  
		   JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
												  and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
		   JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU          = oyr.YEAR_GU
		   JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
		   JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU

WHERE RN = 1
AND ssy.ENTER_DATE is not null
--and student_code = '100031251'
ORDER BY date_enrolled


