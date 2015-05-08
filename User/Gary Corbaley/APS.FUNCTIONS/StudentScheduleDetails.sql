/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 05/08/2015 $
 *
 * Request By: Andy Gutierrez
 * InitialRequestDate: 05/08/2015
 * 
 * This script will pull detail schedule information for all active students in the system
 * One Record Per Student Per Course
 */ 
 
 
 SELECT
		[COURSE].[COURSE_ID]
		,[COURSE].[COURSE_TITLE]		
		,[SCHEDULE].[COURSE_ENTER_DATE]
		,[SCHEDULE].[COURSE_LEAVE_DATE]
		,[SCHEDULE].[SECTION_ID]
		,[SCHEDULE].[TERM_CODE]
		,[COURSE].[DUAL_CREDIT]
		,[COURSE].[OTHER_PROVIDER_NAME]
		,[COURSE].[CREDIT]
		,[COURSE].[DEPARTMENT]
		,[COURSE].[SUBJECT_AREA_1]
		,[COURSE].[SUBJECT_AREA_2]
		,[COURSE].[SUBJECT_AREA_3]
		,[COURSE].[SUBJECT_AREA_4]
		,[COURSE].[SUBJECT_AREA_5]		
		
		,[STAFF_PERSON].[FIRST_NAME] +' '+ [STAFF_PERSON].[LAST_NAME] AS [TEACHER NAME]	
		,[ALL_STAFF_SCH_YR].[PRIMARY_STAFF]
		,[SCHEDULE].[DEFAULT_MINUTES_MEET]
		,[SCHEDULE].[PERIOD_BEGIN]
		,[SCHEDULE].[PERIOD_END]
		,[SCHEDULE].[ROOM_GU]
		,[SCHEDULE].[ROOM_SIMPLE]
		,[SCHEDULE].[ENROLLMENT_ENTER_DATE]
		,[SCHEDULE].[ENROLLMENT_LEAVE_DATE]
		,[SCHEDULE].[ENROLLMENT_GRADE_LEVEL]
		,[SCHEDULE].[TXP_ACK_ADD]
		,[SCHEDULE].[TXP_ACK_DROP]
		
		,[SCHEDULE].[STUDENT_GU]
		,[SCHEDULE].[COURSE_GU]
		,[SCHEDULE].[ORGANIZATION_GU]
		,[SCHEDULE].[ORGANIZATION_YEAR_GU]
		,[SCHEDULE].[SCHOOL_YEAR_COURSE_GU]
		,[SCHEDULE].[SECTION_GU]
		,[SCHEDULE].[STAFF_GU]
		,[SCHEDULE].[YEAR_GU]
		
	FROM
		APS.BasicSchedule AS [SCHEDULE]
		
		INNER JOIN
		rev.EPC_CRS AS [COURSE]
		ON
		[SCHEDULE].[COURSE_GU] = [COURSE].[COURSE_GU]
		
		-- Get both primary and secodary staff
		INNER JOIN
		(
		SELECT
			[STAFF_SCHOOL_YEAR_GU]
			,[STAFF_GU]
			,[ORGANIZATION_YEAR_GU]
			,1 AS [PRIMARY_STAFF]
		FROM
			rev.[EPC_STAFF_SCH_YR] AS [STAFF_SCHOOL_YEAR]
			
		UNION ALL
			
		SELECT
			[STAFF_SCHOOL_YEAR].[STAFF_SCHOOL_YEAR_GU]
			,[STAFF_SCHOOL_YEAR].[STAFF_GU]
			,[STAFF_SCHOOL_YEAR].[ORGANIZATION_YEAR_GU]
			,0 AS [PRIMARY_STAFF]
		FROM
			rev.[EPC_SCH_YR_SECT_STF] AS [SECONDARY_STAFF]
			
			INNER JOIN
			rev.[EPC_STAFF_SCH_YR] AS [STAFF_SCHOOL_YEAR]
			ON
			[SECONDARY_STAFF].[STAFF_SCHOOL_YEAR_GU] = [STAFF_SCHOOL_YEAR].[STAFF_SCHOOL_YEAR_GU]
		) AS [ALL_STAFF_SCH_YR]
		ON
	   [SCHEDULE].[STAFF_SCHOOL_YEAR_GU] = [ALL_STAFF_SCH_YR].[STAFF_SCHOOL_YEAR_GU]
	   
		INNER JOIN
		rev.[EPC_STAFF] AS [STAFF]
		ON
		[ALL_STAFF_SCH_YR].[STAFF_GU] = [STAFF].[STAFF_GU]

		INNER JOIN
		rev.[REV_PERSON] AS [STAFF_PERSON]
		ON
		[STAFF].[STAFF_GU] = [STAFF_PERSON].[PERSON_GU]