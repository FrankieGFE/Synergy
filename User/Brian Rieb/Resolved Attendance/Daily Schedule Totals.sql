-- This qurey should return 1 record per student per school per day enrolled. 
-- we are missing a lot of kids, which may be because:
-- * Rotation Periods are not setup? (how to handle??? - non cycle days?)
-- * Bell schedules not setup?

SELECT
	StudentSchoolYear.STUDENT_SCHOOL_YEAR_GU
	,OrganziationYear.ORGANIZATION_YEAR_GU
	,OrganziationYear.ORGANIZATION_GU
	,AttendanceCalendar.CAL_DATE	AS [Calendar Date]
	
	--Plain Terms Information (terms we can read)
	,Student.SIS_NUMBER				AS [Student Number]
	,School.SCHOOL_CODE				AS [School Code]

	--Statistics	
	,COUNT(*)						AS [Number Of Classes]
	,SUM(CASE 
		WHEN SchoolYearSection.EXCLUDE_ATTENDANCE = 'Y' THEN 1 
		ELSE 0 
	END)							AS [Number of Attendance Classes] --not sure... but this means include only those taking attendance
	,SUM(CASE
		WHEN SchoolYearSection.EXCLUDE_ATTENDANCE != 'Y' THEN 0 -- exclude non-attendance classes
		WHEN SchoolYearSection.INSTRUCTIONAL_MINUTES IS NOT NULL THEN SchoolYearSection.INSTRUCTIONAL_MINUTES
		ELSE DATEDIFF(MINUTE, BellPeriodBegin.START_TIME, BellPeriodEnd.END_TIME) 
	END) AS [Instructional Attendance Minutes]	
	,SUM(CASE
		WHEN SchoolYearSection.INSTRUCTIONAL_MINUTES IS NOT NULL THEN SchoolYearSection.INSTRUCTIONAL_MINUTES
		ELSE DATEDIFF(MINUTE, BellPeriodBegin.START_TIME, BellPeriodEnd.END_TIME) 
	END) AS [Instructional Minutes]	
FROM
	rev.EPC_STU_SCH_YR			StudentSchoolYear
	
	INNER JOIN
	rev.REV_ORGANIZATION_YEAR	OrganziationYear
	ON OrganziationYear.ORGANIZATION_YEAR_GU = StudentSchoolYear.ORGANIZATION_YEAR_GU
	AND OrganziationYear.YEAR_GU             = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
	
	INNER JOIN 
	rev.EPC_STU							Student
	ON Student.STUDENT_GU              = StudentSchoolYear.STUDENT_GU
	
	INNER JOIN
	rev.EPC_SCH							School
	ON School.ORGANIZATION_GU         = OrganziationYear.ORGANIZATION_GU  

	INNER JOIN 
	rev.EPC_STU_CLASS					StudentClass
	ON StudentClass.STUDENT_SCHOOL_YEAR_GU  = StudentSchoolYear.STUDENT_SCHOOL_YEAR_GU
	
	INNER JOIN rev.EPC_SCH_YR_SECT      SchoolYearSection
	ON StudentClass.SECTION_GU              = SchoolYearSection.SECTION_GU
	
	INNER JOIN rev.EPC_SCH_YR_CRS       SchoolYearCourse  
	ON SchoolYearCourse.SCHOOL_YEAR_COURSE_GU = SchoolYearSection.SCHOOL_YEAR_COURSE_GU
	
	INNER JOIN rev.EPC_CRS				Course
	ON Course.COURSE_GU               = SchoolYearCourse.COURSE_GU
	
	-- X Number of Days it meets
	INNER JOIN 
	rev.EPC_SCH_YR_SECT_MET_DY			SectionMeetingDay	
	ON SectionMeetingDay.SECTION_GU = SchoolYearSection.SECTION_GU
	
	INNER JOIN
	rev.EPC_SCH_YR_MET_DY				SchoolYearMeetingDay
	ON
	SectionMeetingDay.SCH_YR_MET_DY_GU = SchoolYearMeetingDay.SCH_YR_MET_DY_GU

	--need School year options for default bell schedule and # meeting days
	INNER JOIN
	rev.EPC_SCH_YR_OPT					SchoolYearOptions
	ON OrganziationYear.ORGANIZATION_YEAR_GU = SchoolYearOptions.ORGANIZATION_YEAR_GU
	
	-- x Calendar Possible Days
	INNER JOIN
	rev.EPC_SCH_ATT_CAL					AttendanceCalendar
	ON AttendanceCalendar.SCHOOL_YEAR_GU = OrganziationYear.ORGANIZATION_YEAR_GU
	AND (AttendanceCalendar.ROTATION = SchoolYearMeetingDay.MEET_DAY_CODE 
		OR SchoolYearOptions.MEETING_DAY_NUMBER = 0
		OR SchoolYearOptions.MEETING_DAY_NUMBER IS NULL
		)
	-- Make sure calendar date falls within scheduled section?
	
	AND (
		AttendanceCalendar.CAL_DATE BETWEEN StudentClass.ENTER_DATE AND StudentClass.LEAVE_DATE
		OR
			(
			AttendanceCalendar.CAL_DATE >= StudentClass.ENTER_DATE AND StudentClass.LEAVE_DATE IS NULL
			)
		)

	-- Need To relate Bell Period to Schedule Period (but not all schools may have rotation cycles
	-- in which case.. we have to join to bell schedules differently)
	LEFT JOIN
	rev.EPC_SCH_YR_ROT_CYCLE				SchoolYearRotationCycle
	ON
	SchoolYearRotationCycle.ORGANIZATION_YEAR_GU = OrganziationYear.ORGANIZATION_YEAR_GU
	AND SchoolYearRotationCycle.ROTATION_CYCLE_CODE = AttendanceCalendar.ROTATION

	LEFT JOIN
	
	rev.EPC_SCH_YR_ROT_CYCLE_PER			SchoolYearRotationCyclePeriodBegin
	ON
	SchoolYearRotationCyclePeriodBegin.SCH_YR_ROT_CYCLE_GU = SchoolYearRotationCycle.SCH_YR_ROT_CYCLE_GU
	AND SchoolYearRotationCyclePeriodBegin.SCHEDULE_PERIOD = SectionMeetingDay.PERIOD_BEGIN

	LEFT JOIN
	
	rev.EPC_SCH_YR_ROT_CYCLE_PER			SchoolYearRotationCyclePeriodEnd
	ON
	SchoolYearRotationCyclePeriodEnd.SCH_YR_ROT_CYCLE_GU = SchoolYearRotationCycle.SCH_YR_ROT_CYCLE_GU
	AND SchoolYearRotationCyclePeriodEnd.SCHEDULE_PERIOD = SectionMeetingDay.PERIOD_END
	


	INNER JOIN
	rev.EPC_SCH_YR_BELL_SCHED			BellSchedule
	ON
	BellSchedule.ORGANIZATION_YEAR_GU = OrganziationYear.ORGANIZATION_YEAR_GU
	AND (
		BellSchedule.BELL_SCHEDULE_CODE	= AttendanceCalendar.BELL_SCHEDULE
		OR
			(
			AttendanceCalendar.BELL_SCHEDULE IS NULL
			AND
			BellSchedule.BELL_SCHEDULE_CODE = SchoolYearOptions.BELL_SCHEDULE_DEFAULT
			)
		)
	


	INNER JOIN
	rev.EPC_SCH_YR_BELL_SCHED_PER		BellPeriodBegin
	ON
	BellPeriodBegin.BELL_SCHEDULE_GU = BellSchedule.BELL_SCHEDULE_GU
	AND BellPeriodBegin.BELL_PERIOD = CASE WHEN SchoolYearRotationCyclePeriodBegin.BELL_PERIOD IS NOT NULL THEN SchoolYearRotationCyclePeriodBegin.BELL_PERIOD ELSE SectionMeetingDay.PERIOD_BEGIN END
	
	INNER JOIN
	rev.EPC_SCH_YR_BELL_SCHED_PER		BellPeriodEnd
	ON
	BellPeriodEnd.BELL_SCHEDULE_GU = BellSchedule.BELL_SCHEDULE_GU
	AND BellPeriodEnd.BELL_PERIOD = CASE WHEN SchoolYearRotationCyclePeriodEnd.BELL_PERIOD IS NOT NULL THEN SchoolYearRotationCyclePeriodEnd.BELL_PERIOD ELSE SectionMeetingDay.PERIOD_END END


	--debug purposes
	INNER JOIN 
	rev.REV_YEAR						RevYear	
	ON
	RevYear.YEAR_GU	= OrganziationYear.YEAR_GU
WHERE
	SchoolYearSection.EXCLUDE_ATTENDANCE = 'Y' --not sure... but this means include only those taking attendance

	AND Student.SIS_NUMBER = '102974847' -- debug
--	AND Course.COURSE_ID = '9241B2'
--	AND AttendanceCalendar.CAL_DATE = '2013-08-13'	
GROUP BY
	StudentSchoolYear.STUDENT_SCHOOL_YEAR_GU
	,OrganziationYear.ORGANIZATION_YEAR_GU
	,OrganziationYear.ORGANIZATION_GU
	,AttendanceCalendar.CAL_DATE	
	,Student.SIS_NUMBER				
	,School.SCHOOL_CODE
ORDER BY
	AttendanceCalendar.CAL_DATE	
	,School.SCHOOL_CODE	
	,Student.SIS_NUMBER				
