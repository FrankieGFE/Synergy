

/*
BEGIN TRANSACTION 

UPDATE REV.EPC_STU_ENROLL

SET GRADE = LU_GRADE

FROM 

(
*/

SELECT 
	STU.SIS_NUMBER, PRIMARIES.GRADE AS SSY_PRIMARY_GRADE
	,ENROLLS.GRADE AS ENROLL_ACTIVITY_ADAS_GRADE,
	PRIMARIES.LU_GRADE AS SSY_LU_GRADE, ENROLLS.LU_GRADE2 AS ENROLL_ACTIVITY_LU_GRADE, ENROLLS.STUDENT_SCHOOL_YEAR_GU

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
------------------------------------------------------------------------------------------------------

-- GET ENROLL ACTIVITY RECORD
INNER JOIN 

(SELECT LU2.VALUE_DESCRIPTION AS GRADE, STUDENT_SCHOOL_YEAR_GU, ACT.GRADE AS LU_GRADE2
,ENROLL.ENROLLMENT_GU, LU2.VALUE_DESCRIPTION AS ACTIVITY_GRADE 

FROM 
	REV.EPC_STU_ENROLL AS ENROLL

--	INNER JOIN 
--APS.LookupTable('K12', 'GRADE') AS LU
--ON
--ENROLL.GRADE = LU.VALUE_CODE

INNER JOIN 
rev.EPC_STU_ENROLL_ACTIVITY AS ACT
ON
ENROLL.ENROLLMENT_GU = ACT.ENROLLMENT_GU

INNER JOIN 
APS.LookupTable('K12', 'GRADE') AS LU2
ON
ACT.GRADE = LU2.VALUE_CODE
	
) AS ENROLLS

ON
ENROLLS.STUDENT_SCHOOL_YEAR_GU = SSYADAS.STUDENT_SCHOOL_YEAR_GU
----------------------------------------------------------------------------------------------------


WHERE
ENROLLS.LU_GRADE2 != PRIMARIES.LU_GRADE
AND  PRIMARIES.GRADE NOT IN ('PK', 'P1', 'P2', 'C1', 'C2', 'C3', 'C4', 'T1', 'T2', 'T3', 'T4')


/*
) AS SSYFIX

WHERE
SSYFIX.ENROLLMENT_GU= rev.EPC_STU_ENROLL_ACTIVITY.ENROLLMENT_GU
AND SSYFIX.LU_GRADE != rev.EPC_STU_ENROLL_ACTIVITY.GRADE

ROLLBACK

*/



