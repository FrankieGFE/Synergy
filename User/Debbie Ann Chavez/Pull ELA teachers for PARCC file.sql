

EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT 
PARCC.*
,STU.SIS_NUMBER
, PERS.LAST_NAME + ', ' + PERS.FIRST_NAME AS ELA_TEACHER_NAME
,SCH.COURSE_TITLE
FROM

            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                  'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
                  'SELECT * from PARCC_TAKEN.csv'
                ) AS PARCC

LEFT JOIN 
rev.EPC_STU AS STU

ON
PARCC.[Student ID] = STU.SIS_NUMBER

LEFT JOIN
APS.ScheduleDetailsAsOf(GETDATE()) AS SCH
ON
STU.STUDENT_GU = SCH.STUDENT_GU
AND SCH.DEPARTMENT = 'Eng'

LEFT JOIN
rev.REV_PERSON AS PERS
ON
PERS.PERSON_GU = SCH.STAFF_GU

ORDER BY SIS_NUMBER


      REVERT
GO