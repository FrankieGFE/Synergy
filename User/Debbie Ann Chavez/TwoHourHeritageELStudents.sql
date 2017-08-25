
/***********************************************************************************************

TWO HOUR HERITAGE FOR EL STUDENTS


*************************************************************************************************/


SELECT 
	*
FROM
(
--THIS PULLS THRU T5
SELECT 
	DISTINCT STUDENT_GU
FROM 
(
-------------------------------------------------------------------------------------------------
--FIRST PULL ELL STUDENTS THAT HAVE A BEP TAGGED COURSE BETWEEN 1274-1274 STATE COURSE CODES
-------------------------------------------------------------------------------------------------

SELECT 
	STUDENT_GU, SIS_NUMBER, COURSE_ID, COURSE_TITLE, COURSE_LEVEL, STATE_COURSE_CODE

 FROM(
SELECT 
	PRIM.STUDENT_GU, SIS_NUMBER, SCH.COURSE_ID, SCH.COURSE_TITLE, COURSE_LEVEL, STATE_COURSE_CODE
 FROM 
APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
INNER JOIN 
APS.ELLCalculatedAsOf(GETDATE()) AS ELL
ON
PRIM.STUDENT_GU = ELL.STUDENT_GU

INNER JOIN 
APS.ScheduleDetailsAsOf(GETDATE()) AS SCH
ON
PRIM.STUDENT_GU = SCH.STUDENT_GU
INNER JOIN 
rev.EPC_CRS_LEVEL_LST AS LST
ON
SCH.COURSE_GU = LST.COURSE_GU
INNER JOIN 
REV.EPC_CRS AS CRS
ON
SCH.COURSE_GU = CRS.COURSE_GU
WHERE
(LST.COURSE_LEVEL = 'BEP'
AND LEFT(CRS.STATE_COURSE_CODE,4) BETWEEN '1271' AND '1274')
) AS T1

---------------------------------------------------------------------------------------------------------------
-- REMOVE STUDENTS ABOVE IF THEY HAVE ANY OTHER COURSES TAGGED BEP THAT IS NOT IN THE COURSE CODE RANGE
---------------------------------------------------------------------------------------------------------------

LEFT JOIN 
(SELECT DISTINCT RESTOFSCH.STUDENT_GU AS RESTSCHGU
FROM
APS.ScheduleDetailsAsOf(GETDATE()) AS RESTOFSCH
INNER JOIN 
rev.EPC_CRS_LEVEL_LST AS LST
ON
RESTOFSCH.COURSE_GU = LST.COURSE_GU
AND LST.COURSE_LEVEL IN ('BEP') 
INNER JOIN 
REV.EPC_CRS AS CRS2
ON
RESTOFSCH.COURSE_GU = CRS2.COURSE_GU
AND LEFT(CRS2.STATE_COURSE_CODE,4) NOT BETWEEN '1271' AND '1274'
) AS T2

ON
T1.STUDENT_GU = T2.RESTSCHGU

WHERE
T2.RESTSCHGU IS NULL

)AS T3

--640 ROWS

INNER JOIN 
-------------------------------------------------------------------------------------------------
--PULL ELL STUDENTS ABOVE THAT ALSO HAVE AN ESL TAGGED COURSE
-------------------------------------------------------------------------------------------------
(
SELECT DISTINCT PRIM.STUDENT_GU AS HASESLGU
	--PRIM.STUDENT_GU, SIS_NUMBER, SCH.COURSE_ID, SCH.COURSE_TITLE, COURSE_LEVEL, STATE_COURSE_CODE
 FROM 
APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
INNER JOIN 
APS.ELLCalculatedAsOf(GETDATE()) AS ELL
ON
PRIM.STUDENT_GU = ELL.STUDENT_GU

INNER JOIN 
APS.ScheduleDetailsAsOf(GETDATE()) AS SCH
ON
PRIM.STUDENT_GU = SCH.STUDENT_GU
INNER JOIN 
rev.EPC_CRS_LEVEL_LST AS LST
ON
SCH.COURSE_GU = LST.COURSE_GU
INNER JOIN 
REV.EPC_CRS AS CRS
ON
SCH.COURSE_GU = CRS.COURSE_GU
WHERE
COURSE_LEVEL = 'ESL'

) AS T4

ON T3.STUDENT_GU = T4.HASESLGU

) AS T5

--488 ROWS

-------------------------------------------------------------------------------------------------
--FOR STUDENTS ABOVE PULL ALL BEP AND ESL CLASSES NOW
-------------------------------------------------------------------------------------------------

INNER JOIN 
(
SELECT 
	prim.SCHOOL_CODE, SCHOOL_NAME,
	PRIM.STUDENT_GU, SIS_NUMBER, SCH.COURSE_ID, SCH.COURSE_TITLE, COURSE_LEVEL, STATE_COURSE_CODE
 FROM 
APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
INNER JOIN 
APS.ELLCalculatedAsOf(GETDATE()) AS ELL
ON
PRIM.STUDENT_GU = ELL.STUDENT_GU

INNER JOIN 
APS.ScheduleDetailsAsOf(GETDATE()) AS SCH
ON
PRIM.STUDENT_GU = SCH.STUDENT_GU
INNER JOIN 
rev.EPC_CRS_LEVEL_LST AS LST
ON
SCH.COURSE_GU = LST.COURSE_GU
INNER JOIN 
REV.EPC_CRS AS CRS
ON
SCH.COURSE_GU = CRS.COURSE_GU
WHERE
COURSE_LEVEL IN ('BEP','ESL')

) AS T6

ON
T5.STUDENT_GU = T6.STUDENT_GU


ORDER BY SCHOOL_NAME, SIS_NUMBER, COURSE_LEVEL