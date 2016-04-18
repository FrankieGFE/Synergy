

/*
BEGIN TRANSACTION 

UPDATE REV.EPC_STU_SCH_YR

SET GRADE = LU_GRADE

FROM 

(
*/

SELECT 
	STU.SIS_NUMBER, PRIMARIES.GRADE AS SSY_PRIMARY_GRADE,  SSYADAS.GRADE AS SSY_ADAS_GRADE,
	PRIMARIES.LU_GRADE AS SSY_LU_GRADE, SSYADAS.LU_GRADE AS SSYADAS_LU_GRADE, SSYADAS.STUDENT_SCHOOL_YEAR_GU

 FROM 
(SELECT STUDENT_GU, LU.VALUE_DESCRIPTION AS GRADE, STUDENT_SCHOOL_YEAR_GU
,LU.VALUE_CODE AS LU_GRADE, PRIM.ENROLLMENT_GU

 FROM APS.PrimaryEnrollmentsAsOf(GETDATE()) AS PRIM
INNER JOIN 
APS.LookupTable('K12', 'GRADE') AS LU
ON
PRIM.GRADE = LU.VALUE_CODE

) AS PRIMARIES


--GET SECONDARY ENROLLMENTS
INNER JOIN 
 (SELECT * FROM  APS.OpenNonPrimaryEnrollments 
 WHERE Primary_School IS NOT NULL)
 
 AS SSYADAS

ON
SSYADAS.STUDENT_GU = PRIMARIES.STUDENT_GU

INNER JOIN 
rev.EPC_STU AS STU
ON
PRIMARIES.STUDENT_GU = STU.STUDENT_GU

WHERE
SSYADAS.LU_GRADE != PRIMARIES.LU_GRADE
AND  PRIMARIES.GRADE NOT IN ('PK', 'P1', 'P2', 'C1', 'C2', 'C3', 'C4', 'T1', 'T2', 'T3', 'T4')


/*
) AS SSYFIX

WHERE


ROLLBACK

*/



