BEGIN TRAN
SELECT
	*
FROM
	SchoolNet_Students	
WHERE ([011] IS NULL) 
	OR (NOT EXISTS
(	

SELECT
	*
FROM
	Student_sis AS STUD
	WHERE
	STUD.student_code = SchoolNet_Students.[011]
))	
		

ROLLBACK

--BEGIN TRAN

--DELETE

--Employee_ListServe
--WHERE (EMPLOYEE_ID IS NULL) 
--	OR (NOT EXISTS
--(
--SELECT
--	*
--FROM
--	Employee_File AS EMP
--WHERE
--	EMP.EMPLOYEE_ID = Employee_ListServe.EMPLOYEE_ID
--))	
--ROLLBACK