

SELECT 
	SCHOOL_NAME, GRADE, SIS_NUMBER, LAST_NAME, FIRST_NAME, HOME_LANGUAGE, CONTACT_LANGUAGE

 FROM 
APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
INNER JOIN 
APS.BasicStudentWithMoreInfo AS BS
ON
PRIM.STUDENT_GU = BS.STUDENT_GU

WHERE
CONTACT_LANGUAGE IS NULL