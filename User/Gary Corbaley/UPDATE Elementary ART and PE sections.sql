BEGIN TRAN


UPDATE [Section]
SET
	[Section].[EXCLUDE_ATTENDANCE] = 'N'
	,[Section].[EXCLUDE_GRADING] = 'Y'
	,[Section].[GB_SPEC_USER_GROUP_GU] = 
	CASE WHEN [LIST].[PERIOD_BEGIN] IN ('12','13') THEN '9A8E00D6-6A27-4F41-A9D9-5FBE72F11D67'
		WHEN [LIST].[PERIOD_BEGIN] IN ('10','11') THEN 'AE800DAC-A5A9-4275-9D5F-12217FD58A3D'	
	END
FROM
	(
		SELECT DISTINCT
			[ENROLLMENT].[SCHOOL_NAME]
			,[SCHEDULE].[COURSE_ID]
			,[SCHEDULE].[SECTION_ID]
			,[SCHEDULE].[COURSE_TITLE]
			,[STAFF_PERSON].[FIRST_NAME]
			,[STAFF_PERSON].[LAST_NAME]
			,[SCHEDULE].[SECTION_GU]
			--,[SCHEDULE].[COURSE_GU]
			--,[ENROLLMENT].[STUDENT_GU]
			,[SCHEDULE].[PERIOD_BEGIN]
			,[SCHEDULE].[PERIOD_END]
			--,[SCHEDULE].*
			
			,[Section].[EXCLUDE_ATTENDANCE]
			,[Section].[EXCLUDE_GRADING]
			,[Section].[GB_SPEC_USER_GROUP_GU]
			
		FROM
			APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS [ENROLLMENT]
			
			INNER JOIN
			APS.ScheduleAsOf(GETDATE()) AS [SCHEDULE]
			ON
			[ENROLLMENT].[STUDENT_GU] = [SCHEDULE].[STUDENT_GU]
			AND [ENROLLMENT].[STUDENT_SCHOOL_YEAR_GU] = [SCHEDULE].[STUDENT_SCHOOL_YEAR_GU]	
			
			INNER JOIN
			rev.[EPC_SCH_YR_SECT] AS [Section]
			ON
			[SCHEDULE].[SECTION_GU] = [Section].[SECTION_GU]
			
			LEFT OUTER JOIN
			rev.EPC_STAFF AS [STAFF]
			ON
			[SCHEDULE].[STAFF_GU] = [STAFF].[STAFF_GU]
			
			LEFT OUTER JOIN
			rev.REV_PERSON AS [STAFF_PERSON]
			ON
			[SCHEDULE].[STAFF_GU] = [STAFF_PERSON].[PERSON_GU]
			
		WHERE
			[ENROLLMENT].[SCHOOL_CODE] BETWEEN '200' AND '399'
			AND [SCHEDULE].[PERIOD_BEGIN] IN ('10','11','12','13')
			
			--AND [SCHEDULE].[COURSE_ID] = '23014000'
			--AND [SCHEDULE].[SECTION_ID] = 'P020'
	) AS [LIST]
	
	INNER JOIN
	rev.[EPC_SCH_YR_SECT] AS [Section]
	ON
	[LIST].[SECTION_GU] = [Section].[SECTION_GU]
	
	
	--ART '9A8E00D6-6A27-4F41-A9D9-5FBE72F11D67'
	--PE 'AE800DAC-A5A9-4275-9D5F-12217FD58A3D'
	--ROLLBACK
	COMMIT