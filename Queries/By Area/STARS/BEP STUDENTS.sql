/*
Created By Debbie Ann Chavez
- Just change reporting date

--This pulls all BEP students for STARS 
*/

SELECT SIS_NUMBER, STATE_STUDENT_NUMBER, PROGRAM_CODE, PROGRAM_INTENSITY FROM 
APS.LCEBilingualAsOf('2016-02-10') AS BIL
INNER JOIN
rev.EPC_STU AS STU
ON
BIL.STUDENT_GU = STU.STUDENT_GU