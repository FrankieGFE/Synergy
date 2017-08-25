

/***********************************************************************************************

TWO HOUR HERITAGE FOR NON EL STUDENTS


*************************************************************************************************/

--THIS SELECT THRU T7 
SELECT 
	ORGANIZATION_NAME, T6.SIS_NUMBER, COURSE_ID, COURSE_TITLE, COURSE_LEVEL, STATE_COURSE_CODE
 FROM(
----THESE TWO SELECTS GROUPS AND REMOVES TO CHOOSE STUDENTS WITH 2 HOURS
SELECT * FROM(
SELECT 
	STUDENT_GU, SIS_NUMBER, MAX(RN) AS MAXCOUNT 
FROM( 
SELECT 
	T4.*	
	,ROW_NUMBER() OVER (PARTITION BY T4.SIS_NUMBER, T4.COURSE_LEVEL ORDER BY T4.COURSE_LEVEL) AS RN
FROM
(
--THIS PULLS THRU T3
SELECT 
	*
FROM 
(
-------------------------------------------------------------------------------------------------
--FIRST PULL NON ELL STUDENTS THAT HAVE A BEP TAGGED COURSE BETWEEN 1274-1274 STATE COURSE CODES
-------------------------------------------------------------------------------------------------

SELECT 
	PRIM.STUDENT_GU, SIS_NUMBER, SCH.COURSE_ID, SCH.COURSE_TITLE, COURSE_LEVEL, STATE_COURSE_CODE
 FROM 
APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
LEFT JOIN 
APS.ELLCalculatedAsOf(GETDATE()) AS ELL
ON
PRIM.STUDENT_GU = ELL.STUDENT_GU
LEFT JOIN 
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
LST.COURSE_LEVEL = 'BEP'
AND LEFT(CRS.STATE_COURSE_CODE,4) BETWEEN '1271' AND '1274'
-- non-EL STUDENTS
AND ELL.STUDENT_GU IS NULL
) AS T1

--6,173 ROWS

---------------------------------------------------------------------------------------------------------------
-- REMOVE STUDENTS ABOVE IF THEY HAVE ANY COURSES TAGGED ESL
---------------------------------------------------------------------------------------------------------------

LEFT JOIN 
(SELECT DISTINCT RESTOFSCH.STUDENT_GU AS RESTSCHGU
FROM
APS.ScheduleDetailsAsOf(GETDATE()) AS RESTOFSCH
INNER JOIN 
rev.EPC_CRS_LEVEL_LST AS LST
ON
RESTOFSCH.COURSE_GU = LST.COURSE_GU
AND LST.COURSE_LEVEL IN ('ESL') 
INNER JOIN 
REV.EPC_CRS AS CRS2
ON
RESTOFSCH.COURSE_GU = CRS2.COURSE_GU

) AS T2

ON
T1.STUDENT_GU = T2.RESTSCHGU

WHERE
T2.RESTSCHGU IS NULL

)AS T3


-------------------------------------------------------------------------------------------------
--FOR STUDENTS ABOVE PULL ALL BEP CLASSES NOW THEN FILTER FOR STUDENTS THAT ONLY HAVE 2
-------------------------------------------------------------------------------------------------

INNER JOIN 
(
SELECT 
	STUDENT_GU, SIS_NUMBER, SCH.COURSE_ID, SCH.COURSE_TITLE, COURSE_LEVEL, STATE_COURSE_CODE
 FROM 

APS.ScheduleDetailsAsOf(GETDATE()) AS SCH
INNER JOIN 
rev.EPC_CRS_LEVEL_LST AS LST
ON
SCH.COURSE_GU = LST.COURSE_GU
INNER JOIN 
REV.EPC_CRS AS CRS
ON
SCH.COURSE_GU = CRS.COURSE_GU
WHERE
COURSE_LEVEL IN ('BEP')

) AS T4

ON
T3.STUDENT_GU = T4.STUDENT_GU

) AS T4
GROUP BY T4.STUDENT_GU, T4.SIS_NUMBER
) AS T5
WHERE 
	MAXCOUNT = 2
) AS T6

-------------------------------------------------------------------------------------------------
--FOR STUDENTS ABOVE THAT ONLY HAVE 2 BEP PULL DETAILS
-------------------------------------------------------------------------------------------------

INNER JOIN 
(
SELECT 
	SCH.ORGANIZATION_NAME,
	STUDENT_GU, SIS_NUMBER, SCH.COURSE_ID, SCH.COURSE_TITLE, COURSE_LEVEL, STATE_COURSE_CODE
 FROM 

APS.ScheduleDetailsAsOf(GETDATE()) AS SCH
INNER JOIN 
rev.EPC_CRS_LEVEL_LST AS LST
ON
SCH.COURSE_GU = LST.COURSE_GU
INNER JOIN 
REV.EPC_CRS AS CRS
ON
SCH.COURSE_GU = CRS.COURSE_GU
WHERE
COURSE_LEVEL IN ('BEP')

) AS T7

ON
T6.STUDENT_GU = T7.STUDENT_GU


ORDER BY ORGANIZATION_NAME, SIS_NUMBER, STATE_COURSE_CODE