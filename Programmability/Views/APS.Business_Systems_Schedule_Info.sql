/*
8-18-2016 FRANK GARCIA
Frank – can you please create a new extract for this request.  
Jonn has requested a new file with current SY course data and student counts to include 
School Location #, Teacher Staff ID, Course ID, Course Title, Section Number and count of students.  
We have an SSRS report MST-1411 District Master Schedules that lists most all of this data if 
you’d like to pattern the extract off this report.  
You can place the file in the same location the other Lawson job we recently created is using 
(Business Systems Sped Info), run it close to the same time and call it something similar ‘Business Systems Schedule Info’.  
Thanks- Andy
*/


ALTER VIEW APS.Business_Systems_Schedule_Info AS

SELECT
	SCH.SCHOOL_CODE
	,REPLACE([STAFF].[BADGE_NUM],'e','') AS [BADGE_NUM]
	,[COURSE].[COURSE_ID]
	,[COURSE].[COURSE_TITLE]
	,[SECTION].[SECTION_ID]
	--,[SECTION].[MAX_STUDENTS]
	,STUDENT_COUNT
	--,[SECTION].[ROOM_SIMPLE]
	--,[SECTION].[PERIOD_BEGIN]
	--,[SECTION].[PERIOD_END]
	
	--, STUFF((SELECT ','+ left(symd.MEET_DAY_CODE,1)
	--         FROM rev.EPC_SCH_YR_SECT        sec 	
	--         JOIN rev.EPC_SCH_YR_SECT_MET_DY sysmd ON sysmd.SECTION_GU      = sec.SECTION_GU
	--         JOIN rev.EPC_SCH_YR_MET_DY      symd  ON symd.SCH_YR_MET_DY_GU = sysmd.SCH_YR_MET_DY_GU
	--       WHERE sec.SECTION_GU  = [SECTION].SECTION_GU	
	--       ORDER BY symd.ORDERBY	
	--       FOR XML PATH('')
	--     ),1,1,'') AS [MEETING_DAYS]
	
	--,[PERSON].[FIRST_NAME] + ' ' + [PERSON].[LAST_NAME] AS [STAFF_NAME]	
	
	
	--,[COURSE].[STATE_COURSE_CODE]
FROM
	(
	SELECT
		[SCHEDULE].[COURSE_GU]
		,[SCHEDULE].[SECTION_GU]
		,[SCHEDULE].[ORGANIZATION_GU]
		,[SCHEDULE].[YEAR_GU]
		,[SCHEDULE].[STAFF_GU]
		,[SCHEDULE].[TERM_CODE]
		,[SCHEDULE].[PERIOD_BEGIN]
		,COUNT([SCHEDULE].[STUDENT_GU]) AS [STUDENT_COUNT]
	FROM
		--APS.ScheduleForYear((SELECT [YEAR_GU] FROM APS.YearDates WHERE @AsOfDate BETWEEN [START_DATE] AND [END_DATE])) AS [SCHEDULE]
		APS.ScheduleAsOf(getdate()) AS [SCHEDULE]
		
	GROUP BY
		[SCHEDULE].[COURSE_GU]
		,[SCHEDULE].[SECTION_GU]
		,[SCHEDULE].[ORGANIZATION_GU]
		,[SCHEDULE].[YEAR_GU]
		,[SCHEDULE].[STAFF_GU]
		,[SCHEDULE].[TERM_CODE]
		,[SCHEDULE].[PERIOD_BEGIN]
	) AS [COURSE_ENROLLMENT_COUNTS]
	
	INNER JOIN
	rev.EPC_CRS AS [COURSE]
	ON
	[COURSE_ENROLLMENT_COUNTS].[COURSE_GU] = [COURSE].[COURSE_GU]
	
	LEFT JOIN
	rev.EPC_SCH_YR_SECT AS [SECTION]
	ON
	[COURSE_ENROLLMENT_COUNTS].[SECTION_GU] = [SECTION].[SECTION_GU]
	
	LEFT JOIN
    rev.[EPC_STAFF] AS [STAFF]
    ON
    [COURSE_ENROLLMENT_COUNTS].[STAFF_GU] = [STAFF].[STAFF_GU]
    
    LEFT JOIN
    rev.[REV_PERSON] AS [PERSON]
    ON
    [STAFF].[STAFF_GU] = [PERSON].[PERSON_GU]
    
    INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[COURSE_ENROLLMENT_COUNTS].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	LEFT JOIN 
	rev.REV_YEAR AS [RevYear] -- Contains the School Year
	ON 
	[COURSE_ENROLLMENT_COUNTS].[YEAR_GU] = [RevYear].[YEAR_GU]

	INNER JOIN
	rev.EPC_SCH AS SCH
	ON SCH.ORGANIZATION_GU = Organization.ORGANIZATION_GU
	
--WHERE
--	[Organization].[ORGANIZATION_GU] LIKE @School
--	AND [SECTION].[TERM_CODE] LIKE @TermCode

--ORDER BY
--	SCH.SCHOOL_CODE
--	,[PERSON].[LAST_NAME]
--	,[COURSE].[COURSE_ID]