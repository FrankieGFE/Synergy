
SELECT 
STU.SIS_NUMBER
,T1.SCHOOL_NAME AS [2014_SCHOOL],T1.GRADE AS [2014_GRADE],T1.ENTER_DATE AS [2014_ENTER_DATE],T1.LEAVE_DATE AS [2014_LEAVE_DATE],T1.LEAVE_CODEDESC AS [2014_LEAVE_CODEDESC] 
,CASE WHEN T2.STUDENT_GU IS NOT NULL THEN 'FOUND IN 2015' ELSE '' END AS ENROLLED_2015 
,T2.SCHOOL_NAME AS [2015_SCHOOL],T2.GRADE AS [2015_GRADE],T2.ENTER_DATE AS [2015_ENTER_DATE],T2.LEAVE_DATE AS [2015_LEAVE_DATE],T2.LEAVE_CODEDESC AS [2015_LEAVE_CODEDESC], SUMMER_WITHDRAWL_CODE AS [2015_SUMMER_WITHDRAWL_CODE] 

,GRADUATION_DATE
,GRAD_STATUS.VALUE_DESCRIPTION AS GRAD_STATUS
,DIP_TYPE.VALUE_DESCRIPTION AS DIP_TYPE

FROM 
(
SELECT * FROM 
(
SELECT
ROW_NUMBER () OVER (PARTITION BY STUDENT_GU ORDER BY ENTER_DATE DESC, EXCLUDE_ADA_ADM) AS RN
,STUDENT_GU
,STUDENT_SCHOOL_YEAR_GU
,SCHOOL_NAME,GRADE,ENTER_DATE,LEAVE_DATE,LEAVE_CODE + '-' +LEAVE_DESCRIPTION AS LEAVE_CODEDESC
FROM
APS.StudentEnrollmentDetails AS ENROLL
WHERE
SCHOOL_YEAR = '2014'
AND EXTENSION = 'R'
AND GRADE IN ('12')
AND EXCLUDE_ADA_ADM IS NULL
AND SUMMER_WITHDRAWL_CODE IS NULL
) AS MOSTRECENT2014
WHERE
RN = 1
)AS T1

LEFT JOIN 

(
SELECT
 STUDENT_GU,SCHOOL_NAME,GRADE,ENTER_DATE, LEAVE_DATE,LEAVE_CODE + '-' +LEAVE_DESCRIPTION AS LEAVE_CODEDESC,SUMMER_WITHDRAWL_CODE
FROM
APS.StudentEnrollmentDetails AS ENROLL
WHERE
SCHOOL_YEAR = '2015'
AND ENROLL.EXTENSION = 'R'

) AS T2
ON
T1.STUDENT_GU = T2.STUDENT_GU 

LEFT JOIN
REV.EPC_STU AS STU
ON
STU.STUDENT_GU = T1.STUDENT_GU

/*************************************************************

***************************************************************/
LEFT JOIN
APS.LookupTable('K12','GRADUATION_STATUS') AS GRAD_STATUS
ON
STU.GRADUATION_STATUS = GRAD_STATUS.VALUE_CODE

LEFT JOIN
APS.LookupTable('K12','DIPLOMA_TYPE') AS DIP_TYPE
ON
STU.DIPLOMA_TYPE = DIP_TYPE.VALUE_CODE


ORDER BY ENROLLED_2015 DESC, DIP_TYPE
