/**
 * $Revision: 1 $
 * $LastChangedBy: e134728 $
 * $LastChangedDate: 2016-12-05 $
/**********************************************************************************************************************************************	
 --This script identifies classes that have the same COURSE_ENTER_DATE and COURSE_LEAVE_DATE or the COURSE_ENTER_DATE is GT Semester 
 --Start Date 
 
************************************************************************************************************************************************/
*/


SELECT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[COURSES].[COURSE_ID]
	,[COURSES].[COURSE_TITLE]
	,[COURSES].[COURSE_ENTER_DATE]
	,[COURSES].[COURSE_LEAVE_DATE]
	,[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,COURSES.TERM_CODE
	
	
FROM
	(
	SELECT DISTINCT
		[SCHEDULE].[STUDENT_GU]
		,[SCHEDULE].[ORGANIZATION_YEAR_GU]
		,[SCHEDULE].[COURSE_ID]
		,[SCHEDULE].[COURSE_TITLE]
		,[SCHEDULE].[COURSE_ENTER_DATE]
		,[SCHEDULE].[COURSE_LEAVE_DATE]
		--,SCHEDULE.TERM_CODE
	FROM
		APS.StudentScheduleDetails AS [SCHEDULE]
		
		INNER JOIN 
		rev.REV_YEAR AS [RevYear] -- Contains the School Year
		ON 
		[SCHEDULE].[YEAR_GU] = [RevYear].[YEAR_GU]
		
	WHERE
		[RevYear].[SCHOOL_YEAR] = '2016'
		AND [RevYear].[EXTENSION] = 'R'
		AND [SCHEDULE].[COURSE_LEAVE_DATE] = '01/04/2017'
		AND [SCHEDULE].[COURSE_ENTER_DATE] = '01/04/2017'
		AND TERM_CODE IN ('S2','YR')
		--AND [SCHEDULE].[COURSE_ENTER_DATE] > '01/04/2017'
		
	) AS [COURSES]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[COURSES].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	INNER JOIN
	APS.StudentEnrollmentDetails AS [ENROLLMENTS]
	ON
	[COURSES].[STUDENT_GU] = [ENROLLMENTS].[STUDENT_GU]
	AND [COURSES].[ORGANIZATION_YEAR_GU] = [ENROLLMENTS].[ORGANIZATION_YEAR_GU]
	WHERE
	[ENROLLMENTS].[SCHOOL_CODE] != '591'