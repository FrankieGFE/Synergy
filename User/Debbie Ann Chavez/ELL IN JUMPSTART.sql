

SELECT ORGANIZATION_NAME, SIS_NUMBER, PERS.LAST_NAME, PERS.FIRST_NAME, LU.VALUE_DESCRIPTION AS GRADE  FROM 
APS.PrimaryEnrollmentsAsOf(GETDATE()) AS PRIM
INNER JOIN
APS.ELLCalculatedAsOf('2015-07-10') AS ELL
ON
PRIM.STUDENT_GU = ELL.STUDENT_GU
INNER JOIN
rev.EPC_STU AS STU
ON
PRIM.STUDENT_GU = STU.STUDENT_GU
INNER JOIN
APS.LookupTable ('K12', 'Grade') AS LU
ON
PRIM.GRADE = LU.VALUE_CODE
INNER JOIN
rev.REV_ORGANIZATION_YEAR AS ORGYR
ON
ORGYR.ORGANIZATION_YEAR_GU = PRIM.ORGANIZATION_YEAR_GU
INNER JOIN
rev.REV_ORGANIZATION AS ORG
ON
ORG.ORGANIZATION_GU = ORGYR.ORGANIZATION_GU
INNER JOIN
rev.REV_PERSON AS PERS
ON
PERS.PERSON_GU = STU.STUDENT_GU


WHERE prim.GRADE BETWEEN '110' AND '150'