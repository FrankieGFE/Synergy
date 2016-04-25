





SELECT DISTINCT
	[Enrollments].[SCHOOL_CODE] AS [school_id]
	,[STUDENT].[SIS_NUMBER] AS [student_id]
	,[STUDENT].[STATE_STUDENT_NUMBER] AS [student_number]
	,'' AS [State_id]
	,[STUDENT].[LAST_NAME] AS [Last_name]
	,[STUDENT].[FIRST_NAME] AS [First_name]
	,[STUDENT].[MIDDLE_NAME] AS [Middle_name]
	,[STUDENT].[GENDER] AS [Gender]
	,CASE 
		WHEN [Enrollments].[GRADE] BETWEEN '01' AND '12' THEN [Enrollments].[GRADE]
		WHEN [Enrollments].[GRADE] = 'K' THEN 'Kindergarten'
		WHEN [Enrollments].[GRADE]= 'PK' THEN 'PreKindergarten'
	END AS [Grade]
	,CONVERT(DATE,[STUDENT].[BIRTH_DATE]) AS [DOB]
	,'' AS [Race]
	,'' AS [Hispanic_Latino]
	,'' AS [Ell_status]
	,'' AS [Frl_status]
	,'' AS [lep_status]
	,'' AS [Student_zip]
	,[PERSON].[EMAIL] AS [Student_email]
	,'' AS [Contact_relationship]
	,'' AS [Contact_type]
	,'' AS [Contact_name]
	,'' AS [Contact_phone]
	,'' AS [Contact_email]
	,'' AS [User_name]
	,'' AS [Password]
	
	
	
FROM
	APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS [Enrollments]
	
	INNER JOIN
	APS.BasicStudentWithMoreInfo AS [STUDENT]
	ON
	[Enrollments].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	INNER JOIN
	rev.REV_PERSON AS [PERSON]
	ON
	[Enrollments].[STUDENT_GU] = [PERSON].[PERSON_GU]
	
WHERE
	[Enrollments].[SCHOOL_CODE] BETWEEN '500' AND '599'