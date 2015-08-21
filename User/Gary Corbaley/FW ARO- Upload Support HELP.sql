

/*
School	
Teacher First Name	
Teacher Last Name	
Teacher Email	
Class/Section	
Student UserID	
Student First Name	
Student Last Name	
Student Email (not required)	
Student Grade Level	
Econ. Disadvantaged	
SPED	
ELL (Eng. Language Learners)	
ALL Students	
Black	
White	
Hispanic	
Asian/ Pacific Islander	
Native American	
CCol1	
CCol2


*/


SELECT
	--[ENROLLMENTS].[SCHOOL_CODE]
	[ENROLLMENTS].[SCHOOL_NAME] AS [School]
	,[STAFF].[FIRST_NAME] AS [Teacher First Name]
	,[STAFF].[LAST_NAME] AS [Teacher Last Name]
	,[STAFF].[EMAIL] AS [Teacher Email]
	,[SCHEDULE].[COURSE_TITLE] AS [Class/Section]
	,[STUDENT].[SIS_NUMBER] AS [Student UserID]
	,[STUDENT].[FIRST_NAME] AS [Student First Name]
	,[STUDENT].[LAST_NAME] AS [Student Last Name]
	,'' AS [Student Email (not required)]
	,[ENROLLMENTS].[GRADE] AS [Student Grade Level]
	,CASE WHEN [STUDENT].[LUNCH_STATUS] IN ('F','R','2') THEN 'Y' ELSE 'N' END AS [Econ. Disadvantaged]
	,[STUDENT].[SPED_STATUS] AS [SPED]
	,[STUDENT].[ELL_STATUS] AS [ELL (Eng. Language Learners)]
	,'' AS [ALL Students]	
	,'' AS [Black]
	,'' AS [White]
	,'' AS [Hispanic]
	,'' AS [Asian/ Pacific Islander]
	,'' AS [Native American]
	,'' AS [CCol1]
	,'' AS [CCol2]
	
FROM
	APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS [ENROLLMENTS]
	
	INNER JOIN
	APS.ScheduleDetailsAsOf(GETDATE()) AS [SCHEDULE]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [SCHEDULE].[STUDENT_GU]
	AND [ENROLLMENTS].[HOMEROOM_SECTION_GU] = [SCHEDULE].[SECTION_GU]
	
	INNER JOIN
	rev.REV_PERSON AS [STAFF]
	ON
	[SCHEDULE].[STAFF_GU] = [STAFF].[PERSON_GU]
	
	INNER JOIN
	APS.BasicStudentWithMoreInfo AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
WHERE
	[ENROLLMENTS].[GRADE] = '08'