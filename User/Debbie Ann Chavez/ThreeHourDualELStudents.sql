



/***********************************************************************************************

THREE HOUR DUAL FOR EL STUDENTS

--HERITAGE 3 HOUR IS ONLY FOR THE FOLLOWING SCHOOLS	('206', '210', '213', '215', '216', '225', '339', '243', '244', '249', '252', '262', '255',
 '496', '285', '291', '300', '250', '327', '275', '333', '330', '392', '280', '370', '376', '379', '385', 
 '405', '450', '415', '416', '475', '465', '470', '590', '576' )

*************************************************************************************************/

SELECT T7.*, PERS.LAST_NAME, PERS.FIRST_NAME  FROM (
SELECT 
	DISTINCT STUDENT_GU
FROM( 
SELECT 
	T4.*
	,ROW_NUMBER() OVER (PARTITION BY SIS_NUMBER, COURSE_LEVEL ORDER BY COURSE_LEVEL, STATE_COURSE_CODE) AS RN
 FROM
(

-------------------------------------------------------------------------------------------------
--FIRST PULL ELL STUDENTS THAT HAVE A BEP TAGGED COURSE BETWEEN 1274-1274 STATE COURSE CODES
-------------------------------------------------------------------------------------------------

SELECT DISTINCT PRIM.STUDENT_GU
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
(LST.COURSE_LEVEL = 'BEP'
AND LEFT(CRS.STATE_COURSE_CODE,4) BETWEEN '1271' AND '1274')
--DUAL 3 HOUR IS ONLY FOR THE FOLLOWING SCHOOLS
AND PRIM.SCHOOL_CODE IN ('206', '210', '213', '215', '216', '225', '339', '243', '244', '249', '252', '262', '255',
 '496', '285', '291', '300', '250', '327', '275', '333', '330', '392', '280', '370', '376', '379', '385', 
 '405', '450', '415', '416', '475', '465', '470', '590', '576' )
) AS T1

---------------------------------------------------------------------------------------------------------------
-- AND STUDENTS HAVE TO HAVE A COURSE TAGGED ESL
---------------------------------------------------------------------------------------------------------------

INNER JOIN 
(SELECT DISTINCT RESTOFSCH.STUDENT_GU AS ESLGU
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
T1.STUDENT_GU = T2.ESLGU

---------------------------------------------------------------------------------------------------------------
-- AND STUDENTS HAVE TO HAVE ONE *OTHER* BEP COURSE TAGGED
---------------------------------------------------------------------------------------------------------------

INNER JOIN 
(SELECT DISTINCT RESTOFSCH.STUDENT_GU AS BEPGU
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
) AS T3

ON
T2.ESLGU = T3.BEPGU


---------------------------------------------------------------------------------------------------
----FOR STUDENTS ABOVE THAT HAVE ALL 3 CONDITIONS PULL ALL THEIR BEP AND ESL CLASSES AND COUNT THEM
---------------------------------------------------------------------------------------------------

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
COURSE_LEVEL IN ('BEP', 'ESL')

) AS T4

ON
T3.BEPGU = T4.STUDENT_GU
) AS T5
--STUDENTS ALL HAVE ESL SO CHOOSE STUDENTS THAT HAVE MORE THAN ONE BEP ROW
WHERE
	COURSE_LEVEL = 'BEP' AND RN >2

) AS T6

---------------------------------------------------------------------------------------------------
----FOR STUDENTS ABOVE THAT HAVE ALL 3 CONDITIONS AND MORE THAN 2 BEP CLASSES PULL DETAILS
---------------------------------------------------------------------------------------------------

INNER JOIN 
(
SELECT 
	ORGANIZATION_NAME,
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
COURSE_LEVEL IN ('BEP', 'ESL')

) AS T7

ON T6.STUDENT_GU = T7.STUDENT_GU 

INNER JOIN 
REV.REV_PERSON AS PERS
ON
T7.STUDENT_GU = PERS.PERSON_GU

ORDER BY ORGANIZATION_NAME, SIS_NUMBER, COURSE_LEVEL, STATE_COURSE_CODE
