

/***********************************************************************************************

ONE HOUR HERITAGE FOR NON EL STUDENTS


*************************************************************************************************/

-------------------------------------------------------------------------------------------------
--FIRST PULL NON-ELL STUDENTS THAT HAVE A BEP TAGGED COURSE BETWEEN 1274-1274 STATE COURSE CODES

-------------------------------------------------------------------------------------------------



SELECT 
	T1.*, PERS.LAST_NAME, PERS.FIRST_NAME, 1 AS [HOUR], 'Heritage' AS MODEL	
	
	, CASE 
			WHEN GRADE IN ('K', '01', '02', '03', '04', '05') AND [67] = '67' AND ELEM = 'Y' THEN 'Y'
			WHEN GRADE IN ('06', '07', '08') AND [67] = '67' AND [60] = '60' AND MID = 'Y' THEN 'Y' 
			WHEN GRADE IN ('09', '10', '11', '12') AND [67] = '67' AND [60] = '60' AND HIGH = 'Y' THEN 'Y' 
			ELSE 'N' END AS QUALIFIED
		
FROM 
(
SELECT 
	PRIM.SCHOOL_CODE, SCHOOL_NAME,
	PRIM.STUDENT_GU, SIS_NUMBER, SCH.COURSE_ID, SCH.COURSE_TITLE, COURSE_LEVEL, STATE_COURSE_CODE
	,CASE WHEN ADMIN_DATE IS NOT NULL THEN 'Y' ELSE 'N' END AS EL
	,PRIM.GRADE
	,[01]
      ,[03]
      ,[04]
      ,[05]
      ,[10]
      ,[20]
      ,[27]
      ,[32]
      ,[45]
      ,[47]
      ,[51]
      ,[60]
      ,[67]
      ,[ELEM]
      ,[MID]
      ,[HIGH]
	  ,SCH.[TEACHER NAME]
	  ,BADGE_NUM
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

LEFT JOIN 
APS.LCETeacherEndorsements AS CRED
ON
SCH.STAFF_GU = CRED.STAFF_GU

LEFT JOIN 
rev.EPC_STAFF AS STF
ON
CRED.STAFF_GU = STF.STAFF_GU

WHERE
LST.COURSE_LEVEL = 'BEP'
AND LEFT(CRS.STATE_COURSE_CODE,4) BETWEEN '1271' AND '1274'
-- non-EL STUDENTS
AND ELL.STUDENT_GU IS NULL
) AS T1

---------------------------------------------------------------------------------------------------------------
-- REMOVE STUDENTS ABOVE IF THEY HAVE ANY OTHER COURSES TAGGED BEP AND/OR ESL THAT IS NOT IN THE COURSE CODE RANGE
---------------------------------------------------------------------------------------------------------------

LEFT JOIN 
(SELECT DISTINCT RESTOFSCH.STUDENT_GU 
FROM
APS.ScheduleDetailsAsOf(GETDATE()) AS RESTOFSCH
INNER JOIN 
rev.EPC_CRS_LEVEL_LST AS LST
ON
RESTOFSCH.COURSE_GU = LST.COURSE_GU
AND LST.COURSE_LEVEL IN ('BEP', 'ESL') 
INNER JOIN 
REV.EPC_CRS AS CRS2
ON
RESTOFSCH.COURSE_GU = CRS2.COURSE_GU
AND LEFT(CRS2.STATE_COURSE_CODE,4) NOT BETWEEN '1271' AND '1274'
) AS T2

ON
T1.STUDENT_GU = T2.STUDENT_GU
INNER JOIN 
REV.REV_PERSON AS PERS
ON
T1.STUDENT_GU = PERS.PERSON_GU


WHERE
T2.STUDENT_GU IS NULL





ORDER BY SCHOOL_NAME, SIS_NUMBER




