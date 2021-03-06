

SELECT SIS_NUMBER FROM 
rev.EPC_STU AS STU
LEFT JOIN 
(SELECT *FROM (
SELECT ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY ORGANIZATION_YEAR_GU) AS RN
,STUDENT_GU 
FROM rev.EPC_STU_SCH_YR
) AS T1
WHERE RN = 1
) AS SSY
ON
STU.STUDENT_GU = SSY.STUDENT_GU 

WHERE
ssy.STUDENT_GU IS NULL
AND SIS_NUMBER < '98%'

ORDER BY SIS_NUMBER