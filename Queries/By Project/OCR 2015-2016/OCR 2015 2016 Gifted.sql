

SELECT DISTINCT SIS_NUMBER FROM (

SELECT ENR.SIS_NUMBER, GIFTED_STATUS, SCHOOL_CODE, SCHOOL_NAME, ENTER_DATE, LEAVE_DATE FROM 
APS.StudentEnrollmentDetails AS ENR
INNER HASH JOIN 
APS.BasicStudentWithMoreInfo AS BS
ON
ENR.STUDENT_GU = BS.STUDENT_GU

WHERE
ENR.SCHOOL_YEAR = 2015
AND ENR.EXTENSION = 'R'
AND BS.GIFTED_STATUS = 'Y'
) AS T1