
/*
	Created By:  Debbie Ann Chavez
	Date:	4/17/2015

	This pulls any students had a no show record, NYR skips these kids.  
	Give these to functional team so the enrollments can be created manually before running Part 3.  

*/



SELECT SIS_NUMBER, SUMMER_WITHDRAWL_CODE, SUMMER_WITHDRAWL_DATE FROM
rev.EPC_STU_SCH_YR AS SSY
INNER JOIN
rev.REV_ORGANIZATION_YEAR AS ORGYR
ON
SSY.ORGANIZATION_YEAR_GU = ORGYR.ORGANIZATION_YEAR_GU
INNER JOIN
rev.REV_YEAR AS YRS
ON
YRS.YEAR_GU = ORGYR.YEAR_GU
INNER JOIN
rev.EPC_STU AS STU
ON
SSY.STUDENT_GU = STU.STUDENT_GU

INNER JOIN

(SELECT SIS_NUMBER AS IDNBR FROM 
rev.EPC_STU_SCH_YR AS SSY
INNER JOIN
rev.REV_ORGANIZATION_YEAR AS ORGYR
ON
SSY.ORGANIZATION_YEAR_GU = ORGYR.ORGANIZATION_YEAR_GU
INNER JOIN
rev.REV_YEAR AS YRS
ON
YRS.YEAR_GU = ORGYR.YEAR_GU
INNER JOIN
rev.EPC_STU AS STU
ON
SSY.STUDENT_GU = STU.STUDENT_GU
WHERE
YRS.SCHOOL_YEAR = 2014
AND SSY.CHANGE_ID_STAMP = '27CDCD0E-BF93-4071-94B2-5DB792BB735F'
) AS MINE
ON
MINE.IDNBR = STU.SIS_NUMBER

WHERE
YRS.SCHOOL_YEAR = 2015
AND SUMMER_WITHDRAWL_CODE IS NOT NULL

ORDER BY SUMMER_WITHDRAWL_CODE DESC
