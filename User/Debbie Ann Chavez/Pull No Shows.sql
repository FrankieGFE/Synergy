

SELECT SIS_NUMBER,NO_SHOW_STUDENT, SUMMER_WITHDRAWL_CODE, SUMMER_WITHDRAWL_DATE, ENTER_DATE, LEAVE_DATE, ORGANIZATION_GU
FROM
rev.EPC_STU_SCH_YR AS SSY
INNER JOIN
rev.EPC_STU AS STU
ON
SSY.STUDENT_GU = STU.STUDENT_GU

INNER JOIN
rev.REV_ORGANIZATION_YEAR AS ORGYR
ON
ORGYR.ORGANIZATION_YEAR_GU = SSY.ORGANIZATION_YEAR_GU
INNER JOIN
rev.REV_YEAR AS YRS
ON
ORGYR.YEAR_GU = YRS.YEAR_GU

WHERE
 SCHOOL_YEAR = '2014'
 --AND SIS_NUMBER = 104653902
 AND SUMMER_WITHDRAWL_DATE IS NOT NULL