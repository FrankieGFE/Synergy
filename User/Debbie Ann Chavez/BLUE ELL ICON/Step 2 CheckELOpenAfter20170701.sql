

--BEGIN TRAN

--UPDATE rev.REV_PERSON_NOT 

--SET END_DATE = '20170630'

SELECT SIS_NUMBER,NOTE.* 

FROM 
rev.REV_PERSON_NOT AS NOTe
INNER JOIN 
REV.epc_stu as stu
ON 
NOTE.PERSON_GU = STU.STUDENT_GU
--INNER JOIN 
--APS.ELLCalculatedAsOf(GETDATE()) AS ELL
--ON
--STU.STUDENT_GU = ELL.STUDENT_GU

WHERE

NOT_CFG_GU = '256096C9-A40D-4654-8322-3E17FAF8EE2D'
--AND ADDED_BY_RULE = 'N'
AND BEGIN_DATE > '20170701'
--AND ELL.STUDENT_GU IS NULL

