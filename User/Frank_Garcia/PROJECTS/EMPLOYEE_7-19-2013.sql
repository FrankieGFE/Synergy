SELECT
	EMPLOYEE.EMPLOYEE 
	,LAST_NAME
	,FIRST_NAME
	,EMAIL_ADDRESS
	,FICA_NBR
	,EMPLOYEE.USER_LEVEL
	,EMPLOYEE.POSITION
	
	,CASE
	WHEN PAPOSITION.DESCRIPTION LIKE '%:%' THEN
	LTRIM (SUBSTRING(PAPOSITION.DESCRIPTION,1, CHARINDEX(':',PAPOSITION.DESCRIPTION)-1))
	ELSE Paposition.DESCRIPTION
	END
    AS JOB_TITLE
    ,Paemppos.JOB_CODE
	
	
FROM
	Employee
LEFT OUTER JOIN 
	Paposition
	ON
	Paposition.POSITION = EMPLOYEE.POSITION
LEFT OUTER JOIN
	Paemployee
	ON
	Paemployee.EMPLOYEE = EMPLOYEE.EMPLOYEE
INNER JOIN
	Paemppos
	ON
	Paemppos.EMPLOYEE = EMPLOYEE.EMPLOYEE	
	AND Paemppos.USER_LEVEL = EMPLOYEE.USER_LEVEL
	AND PaemppoS.POSITION = EMPLOYEE.POSITION
	AND Paemppos.POSITION != 'INACTIVE'
	AND Paemppos.END_DATE IS NULL
		
WHERE
	TERM_DATE IS NULL	
	ORDER BY EMPLOYEE