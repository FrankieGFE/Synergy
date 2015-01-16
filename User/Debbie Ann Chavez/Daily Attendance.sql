
--TAKES 2 MINUTES TO RUN


SELECT COUNT (*)

FROM (
SELECT DISTINCT SIS_NUMBER

--SIS_NUMBER, ECAR.ABBREVIATION , ESAD.ABS_DATE 

 FROM
 rev.EPC_STU_ATT_DAILY        AS ESAD 


JOIN rev.EPC_STU_ENROLL      AS ESE    ON ESE.ENROLLMENT_GU                   = ESAD.ENROLLMENT_GU 



JOIN rev.EPC_STU_SCH_YR           AS SSY    ON SSY.STUDENT_SCHOOL_YEAR_GU          = ESE.STUDENT_SCHOOL_YEAR_GU 
                                               AND SSY.LEAVE_DATE IS NULL
                                               AND SSY.NO_SHOW_STUDENT = 'N'
                                               AND SSY.STATUS IS NULL


JOIN rev.REV_ORGANIZATION_YEAR    AS OY     ON OY.ORGANIZATION_YEAR_GU             = SSY.ORGANIZATION_YEAR_GU 
/*
JOIN rev.REV_YEAR                 AS Y      ON Y.YEAR_GU                           = OY.YEAR_GU 
                                               AND Y.SCHOOL_YEAR                   = (SELECT SCHOOL_YEAR FROM rev.SIF_22_Common_CurrentYear)
                                               AND Y.EXTENSION   = 'R' -- Comment if Summer scools are also required
											   AND SCHOOL_YEAR = '2014'
*/

JOIN rev.EPC_STU                  AS S      ON S.STUDENT_GU                        = SSY.STUDENT_GU 


JOIN rev.EPC_CODE_ABS_REAS_SCH_YR AS ECARSY 

ON ECARSY.CODE_ABS_REAS_SCH_YEAR_GU    = ESAD.CODE_ABS_REAS1_GU 
 OR ECARSY.CODE_ABS_REAS_SCH_YEAR_GU = ESAD.CODE_ABS_REAS2_GU
  AND ECARSY.ORGANIZATION_YEAR_GU     = OY.ORGANIZATION_YEAR_GU 

JOIN rev.EPC_CODE_ABS_REAS        AS ECAR   
ON ECARSY.CODE_ABS_REAS_GU             = ECAR.CODE_ABS_REAS_GU AND ECAR.ABBREVIATION = 'IL'

WHERE
ABS_DATE BETWEEN '2015-01-05' AND '2015-01-09'
AND ABBREVIATION = 'IL'
--AND Y.SCHOOL_YEAR = '2014'

) AS T1
--ORDER BY SIS_NUMBER
