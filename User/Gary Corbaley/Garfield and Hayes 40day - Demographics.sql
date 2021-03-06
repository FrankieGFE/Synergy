
/*
15-16 '10/14/2015'
14-15 '10/8/2014'
13-14 '10/9/2013'
*/

SELECT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[ENROLLMENT].[GRADE]
	,[STUDENT].[GENDER]
	--,[STUDENT].[HISPANIC_INDICATOR]
	--,[STUDENT].[RACE_1]
	,[STUDENT].[RESOLVED_RACE]
	
FROM
	APS.PrimaryEnrollmentDetailsAsOf('10/9/2013') AS [ENROLLMENT]
	
	INNER JOIN
	APS.BasicStudentWithMoreInfo AS [STUDENT]
	ON
	[ENROLLMENT].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
WHERE
	[ENROLLMENT].[SCHOOL_CODE] IN ('410','416')
	
	--410 416