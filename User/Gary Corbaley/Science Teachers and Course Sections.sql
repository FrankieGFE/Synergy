

SELECT
	--[SECTION_STUDENTS].*
	[SECTION_STUDENTS].[ORGANIZATION_NAME]
	,[SECTION_STUDENTS].[COURSE_ID]
	,[SECTION_STUDENTS].[SECTION_ID]
	,[SECTION_STUDENTS].[COURSE_TITLE]
	,[SECTION_STUDENTS].[DEPARTMENT]
	,[SECTION_STUDENTS].[COURSE_HISTORY_TYPE]
	,[SECTION_STUDENTS].[SUBJECT_AREA_1]
	,[SECTION_STUDENTS].[TERM_CODE]
	,[SECTION_STUDENTS].[CREDIT]
	,[STAFF_PERSON].[FIRST_NAME] + ' ' + [STAFF_PERSON].[LAST_NAME] AS [TEACHER_NAME]
	,[STAFF].[BADGE_NUM]
	,[SECTION_STAFF].[PRIMARY_TEACHER]
	,[SECTION_STUDENTS].[STUDENT_COUNT]
FROM
	(
	SELECT
		--[STUDENT].[FIRST_NAME]
		--,[STUDENT].[LAST_NAME]
		--,[STUDENT].[MIDDLE_NAME]
		--,[STUDENT].[SIS_NUMBER]
		[SCHEDULE].[ORGANIZATION_NAME]
		,[SCHEDULE].[COURSE_ID]
		,[SCHEDULE].[COURSE_GU]
		,[SCHEDULE].[SECTION_ID]
		,[SCHEDULE].[SECTION_GU]
		,[SCHEDULE].[COURSE_TITLE]
		,[SCHEDULE].[DEPARTMENT]
		,[SCHEDULE].[COURSE_HISTORY_TYPE]
		,[SCHEDULE].[SUBJECT_AREA_1]
		,[SCHEDULE].[TERM_CODE]
		--,[STAFF_PERSON].[FIRST_NAME] + ' ' + [STAFF_PERSON].[LAST_NAME] AS [TEACHER_NAME]
		--,[SECTION_STAFF].[PRIMARY_TEACHER]
		,[SCHEDULE].[CREDIT]
		,COUNT([STUDENT].[SIS_NUMBER]) AS [STUDENT_COUNT]
		
		
	FROM
		APS.ScheduleAsOf('05/22/2016') AS [SCHEDULE]
		
		INNER JOIN
		APS.BasicStudentWithMoreInfo AS [STUDENT]
		ON
		[SCHEDULE].[STUDENT_GU] = [STUDENT].[STUDENT_GU]		
		
	WHERE
		[SCHEDULE].[DEPARTMENT] = 'Sci'
		AND [SCHEDULE].[COURSE_HISTORY_TYPE] = 'HIGH'
		AND [SCHEDULE].[TERM_CODE] IN ('S2','FY','YR','Q3','Q4')
		
	GROUP BY
		[SCHEDULE].[ORGANIZATION_NAME]
		,[SCHEDULE].[COURSE_ID]
		,[SCHEDULE].[COURSE_GU]
		,[SCHEDULE].[SECTION_ID]
		,[SCHEDULE].[SECTION_GU]
		,[SCHEDULE].[COURSE_TITLE]
		,[SCHEDULE].[DEPARTMENT]
		,[SCHEDULE].[COURSE_HISTORY_TYPE]
		,[SCHEDULE].[SUBJECT_AREA_1]
		,[SCHEDULE].[TERM_CODE]
		--,[STAFF_PERSON].[FIRST_NAME] + ' ' + [STAFF_PERSON].[LAST_NAME] AS [TEACHER_NAME]
		--,[SECTION_STAFF].[PRIMARY_TEACHER]
		,[SCHEDULE].[CREDIT]
	) AS [SECTION_STUDENTS]
	
	LEFT OUTER JOIN
	APS.SectionsAndAllStaffAssigned AS [SECTION_STAFF]
	ON
	[SECTION_STUDENTS].[SECTION_GU] = [SECTION_STAFF].[SECTION_GU]
	
	LEFT OUTER JOIN
	rev.[REV_PERSON] AS [STAFF_PERSON]
	ON
	[SECTION_STAFF].[STAFF_GU] = [STAFF_PERSON].[PERSON_GU]
	
	LEFT OUTER JOIN
	rev.[EPC_STAFF] AS [STAFF]
	ON
	[SECTION_STAFF].[STAFF_GU] = [STAFF].[STAFF_GU]
	
ORDER BY
	[SECTION_STUDENTS].[ORGANIZATION_NAME]
	,[SECTION_STUDENTS].[SECTION_ID]