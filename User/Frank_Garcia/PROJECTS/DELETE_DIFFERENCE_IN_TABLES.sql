BEGIN TRAN

DELETE

Employee_ListServe
WHERE (EMPLOYEE_ID IS NULL) 
	OR (NOT EXISTS
(
SELECT
	*
FROM
	Employee_File AS EMP
WHERE
	EMP.EMPLOYEE_ID = Employee_ListServe.EMPLOYEE_ID
))	
ROLLBACK