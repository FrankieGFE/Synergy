USE Lawson
GO

SELECT 
	CurrentActiveEmp.EMPLOYEE
	,FIRST_NAME
	,LAST_NAME
	,EMAIL_ADDRESS
	,EFFECT_DATE
	,LOCATION
	,BIRTHDATE
	,CASE WHEN (DATEADD(year,DATEDIFF(year, BIRTHDATE  ,GETDATE()) , BIRTHDATE) > GETDATE())THEN DATEDIFF(year, BIRTHDATE  ,GETDATE()) -1
	ELSE DATEDIFF(year, BIRTHDATE  ,GETDATE()) END AS AGE
	
FROM
APS.CurrentActiveEmployees AS CurrentActiveEmp
INNER JOIN
APS.EmployeeMostRecentAssignment AS MostRecentAssignment
ON
CurrentActiveEmp.EMPLOYEE = MostRecentAssignment.Employee
INNER JOIN
Paemployee
ON
CurrentActiveEmp.EMPLOYEE = Paemployee.EMPLOYEE

WHERE
LOCATION IN ( '044', '046')
ORDER BY
AGE
