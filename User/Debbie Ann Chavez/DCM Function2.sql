USE [ST_Production]
GO

/****** Object:  UserDefinedFunction [APS].[DistrictMasterScheduleAsOf]    Script Date: 7/24/2017 10:07:46 AM ******/



/*****************************************************************************************

Created by Debbie Ann Chavez
Date - 7/13/2017

This function is used for synergy report MST-1411 - District Master Schedules As Of

*******************************************************************************************/


ALTER FUNCTION [APS].[DistrictMasterScheduleAsOf_2](@AsOfDate DATE)
RETURNS TABLE
AS
RETURN	

SELECT
	[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	,[RevYear].[SCHOOL_YEAR]
	,[SECTION].[TERM_CODE]
	
	,[COURSE_ENROLLMENT_COUNTS].[STUDENT_COUNT]
	,[SECTION].[MAX_STUDENTS]
	,[COURSE].[COURSE_TITLE]
	,[COURSE].[COURSE_ID]
	
	,[SECTION].[SECTION_ID]
	,ROOM.ROOM_NAME
	,[SECTION].[PERIOD_BEGIN]
	,[SECTION].[PERIOD_END]
	
	, STUFF((SELECT ','+ left(symd.MEET_DAY_CODE,1)
	         FROM rev.EPC_SCH_YR_SECT        sec 	
	         JOIN rev.EPC_SCH_YR_SECT_MET_DY sysmd ON sysmd.SECTION_GU      = sec.SECTION_GU
	         JOIN rev.EPC_SCH_YR_MET_DY      symd  ON symd.SCH_YR_MET_DY_GU = sysmd.SCH_YR_MET_DY_GU
	       WHERE sec.SECTION_GU  = [SECTION].SECTION_GU	
	       ORDER BY symd.ORDERBY	
	       FOR XML PATH('')
	     ),1,1,'') AS [MEETING_DAYS]
	
	,[PERSON].[FIRST_NAME] + ' ' + [PERSON].[LAST_NAME] AS [STAFF_NAME]	
	,REPLACE([STAFF].[BADGE_NUM],'e','') AS [BADGE_NUM]
	
	,[COURSE].[STATE_COURSE_CODE]
	,[Organization].ORGANIZATION_GU
	,SCH.VALUE_DESCRIPTION AS Staff_Responsibility
	,ADDSTAFF.[FIRST_NAME] + ' ' + ADDSTAFF.[LAST_NAME] AS [ADD_STAFF_NAME]
	,REPLACE(STAFF2.[BADGE_NUM],'e','') AS [BADGE_NUM2]
	

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
		APS.ScheduleForYear((SELECT [YEAR_GU] FROM APS.YearDates WHERE @AsOfDate BETWEEN [START_DATE] AND [END_DATE] AND EXTENSION = 'R')) AS [SCHEDULE]
		--APS.ScheduleAsOf('2017-05-25') AS [SCHEDULE]
		
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

	LEFT JOIN 
	rev.EPC_SCH_ROOM AS ROOM
	ON
	ROOM.ROOM_GU = SECTION.ROOM_GU

			
			LEFT JOIN	
			rev.EPC_SCH_YR_SECT_STF AS AdditionalStaff
			ON
			[SECTION].SECTION_GU = AdditionalStaff.SECTION_GU

			LEFT JOIN
			rev.EPC_STAFF_SCH_YR AS StaffSchoolYear
			ON
			AdditionalStaff.STAFF_SCHOOL_YEAR_GU = StaffSchoolYear.STAFF_SCHOOL_YEAR_GU

			LEFT JOIN 
			REV.EPC_STAFF AS STAFF2
			ON
			StaffSchoolYear.STAFF_GU = STAFF2.STAFF_GU

			LEFT JOIN 
			REV.REV_PERSON AS ADDSTAFF
			ON
			ADDSTAFF.PERSON_GU = StaffSchoolYear.STAFF_GU

			LEFT JOIN 
			APS.LookupTable('K12.ScheduleInfo','Staff_Responsibility') AS SCH
			ON
			AdditionalStaFF.STAF_CONTR_RESPON = SCH.VALUE_CODE


-- THIS BELOW IS NEEDED IN THE SSRS REPORT
	
--WHERE
--	[Organization].[ORGANIZATION_GU] LIKE @School
	--AND [SECTION].[TERM_CODE] LIKE @TermCode


--ORDER BY
--	[Organization].[ORGANIZATION_NAME]
--	,[PERSON].[LAST_NAME]
--	,[COURSE].[COURSE_ID]
GO


