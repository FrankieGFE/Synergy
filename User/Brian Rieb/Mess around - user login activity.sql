/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  
	Activity.*
	,SynUser.LOGIN_NAME
	,Person.FIRST_NAME
	,Person.LAST_NAME
FROM 
	[rev].[REV_USER_ACT] AS Activity

	INNER JOIN

	rev.REV_USER AS SynUser

	ON

	Activity.USER_GU = SynUser.USER_GU

	INNER JOIN

	rev.REV_PERSON AS Person

	ON

	SynUser.USER_GU = Person.PERSON_GU
WHERE
	ACCESS_DT >= CONVERT(DATE, GETDATE())