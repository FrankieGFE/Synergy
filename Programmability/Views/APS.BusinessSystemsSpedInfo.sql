
/*
	Created by Debbie Ann Chavez
	Date 6/8/2016

	*** THIS HAS A HARD-CODED SCHOOL YEAR *** CHANGE AFTER SCHOOL YEAR HAS ROLLED OVER

*/


CREATE VIEW APS.BusinessSystemsSpedInfo AS


SELECT 
	LAST_NAME, FIRST_NAME,ENR.SIS_NUMBER, ENR.GRADE, SCHOOL_CODE, SCHOOL_NAME 
	,ENTER_DATE
	,LEAVE_DATE
	,BS.PRIMARY_DISABILITY_CODE AS EXCEPTIONALITY 
	,IEP.IEP_TITLE AS PROCESS_NAME, GIFTED_STATUS
	,T1.EXIT_DATE AS IEP_EXIT_DATE
 FROM 
APS.StudentEnrollmentDetails AS ENR

INNER JOIN 
rev.EP_STUDENT_IEP AS IEP
ON 
IEP.STUDENT_GU = ENR.STUDENT_GU
AND IEP.IEP_STATUS = 'CU'

INNER JOIN 
APS.BasicStudentWithMoreInfo AS BS
ON
ENR.STUDENT_GU = BS.STUDENT_GU

LEFT JOIN 

            (
            SELECT
                        STU.SIS_NUMBER
						,SPED.STUDENT_GU
                        ,PRIMARY_DISABILITY_CODE
						,NEXT_IEP_DATE
						,CURRENT_IEP_DATE
						,EXIT_DATE
            FROM
                        REV.EP_STUDENT_SPECIAL_ED AS SPED
						INNER JOIN
						rev.EPC_STU AS STU
						ON
						SPED.STUDENT_GU = STU.STUDENT_GU
				
            WHERE
                        NEXT_IEP_DATE IS NOT NULL
                        AND (
                                    EXIT_DATE IS NULL 
                                    OR EXIT_DATE >= CONVERT(DATE, GETDATE())
                                    )
			) as T1
ON
T1.STUDENT_GU = ENR.STUDENT_GU

WHERE
SCHOOL_YEAR = 2016
AND EXTENSION = 'R'

