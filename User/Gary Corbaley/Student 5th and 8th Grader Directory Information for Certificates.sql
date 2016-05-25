


SELECT DISTINCT
	[Student].[FIRST_NAME]
	,[Student].[LAST_NAME]
	,[Student].[MIDDLE_NAME]
	,[Student].[SIS_NUMBER]
	,[Student].[ELL_STATUS]
	,[Student].[SPED_STATUS]
	,[Student].[CONTACT_LANGUAGE]
	,[Enrollments].[GRADE] AS [GRADE_LEVEL]
    ,[Enrollments].[SCHOOL_NAME]
    ,[Enrollments].[SCHOOL_CODE]
	,CASE WHEN [Student].[MAIL_ADDRESS] IS NULL THEN [Student].[HOME_ADDRESS] ELSE [Student].[MAIL_ADDRESS] END AS [ADDRESS]
    ,CASE WHEN [Student].[MAIL_ADDRESS] IS NULL THEN [Student].[HOME_ADDRESS_2] ELSE [Student].[MAIL_ADDRESS_2] END AS [ADDRESS_2]
    ,CASE WHEN [Student].[MAIL_CITY] IS NULL THEN [Student].[HOME_CITY] ELSE [Student].[MAIL_CITY] END AS [CITY]
    ,CASE WHEN [Student].[MAIL_STATE] IS NULL THEN [Student].[HOME_STATE] ELSE [Student].[MAIL_STATE] END AS [STATE]
    ,CASE WHEN [Student].[MAIL_ZIP] IS NULL THEN [Student].[HOME_ZIP] ELSE [Student].[MAIL_ZIP] END AS [ZIP]
	,[Student].[PRIMARY_PHONE]
	,[Student].[Parents]
FROM
	APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS [Enrollments]
	
	INNER JOIN
	APS.BasicStudentWithMoreInfo AS [Student] 
	ON
	[Enrollments].[STUDENT_GU] = [Student].[STUDENT_GU]
	
	--LEFT JOIN
	--rev.[UD_STU] AS [STUDENT_EXCEPTIONS]
	--ON
	--[Student].[STUDENT_GU] = [STUDENT_EXCEPTIONS].[STUDENT_GU]
	
	
	
WHERE
	--[Enrollments].[ORGANIZATION_GU] LIKE @School
	[Enrollments].[SCHOOL_NAME] LIKE '%Taylor%'
	AND [Enrollments].[GRADE] IN ('05','08')
	
--	--- EXCEPTIONS
	--AND ([STUDENT_EXCEPTIONS].[EXCLUDE_BUSINESS] IS NULL OR [STUDENT_EXCEPTIONS].[EXCLUDE_BUSINESS] != @Buisness OR @Buisness = 'N')
	--AND ([STUDENT_EXCEPTIONS].[EXCLUDE_UNIVERSITY] IS NULL OR [STUDENT_EXCEPTIONS].[EXCLUDE_UNIVERSITY] != @University OR @University = 'N')
	--AND ([STUDENT_EXCEPTIONS].[EXCLUDE_MILITARY] IS NULL OR [STUDENT_EXCEPTIONS].[EXCLUDE_MILITARY] != @Military OR @Military = 'N')
	
ORDER BY
	[Enrollments].[SCHOOL_NAME]
	,[Student].[LAST_NAME]