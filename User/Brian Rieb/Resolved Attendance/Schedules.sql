-- This is an attempt to pull total instructional minutes for every
-- day/kid/ssy? or enorllment? It seems like overkill cuz that's something
-- like enrollments (120k/yr) * instructional days (120) * years
-- but the ulimate goal will be to ONLy run this for certain kids/days
-- probably every kid for the current day (so maybe like 130k reocrds per run)

--what about spanning multiple periods... How do we handle passing periods
-- also what about periods that have lunch built in?

SELECT
	Student.SIS_NUMBER				AS [Student Number]
	,School.SCHOOL_CODE				AS [School Code]
	,Course.COURSE_ID				AS [Course]
	,SchoolYearSection.SECTION_ID	AS [Section Number]

	,SectionMeetingDay.PERIOD_BEGIN	AS [Sched Begin Period]
	,SectionMeetingDay.PERIOD_END	AS [Sched End Period]

	,SchoolYearRotationCyclePeriodBegin.BELL_PERIOD AS [Bell Period Begin]
	,SchoolYearRotationCyclePeriodEnd.BELL_PERIOD AS [Bell Period End]

	,SchoolYearSection.EXCLUDE_ATTENDANCE
	
	,BellPeriodBegin.START_TIME
	,BellPeriodEnd.END_TIME
	,CASE
		WHEN SchoolYearSection.INSTRUCTIONAL_MINUTES IS NOT NULL THEN SchoolYearSection.INSTRUCTIONAL_MINUTES
		ELSE DATEDIFF(MINUTE, BellPeriodBegin.START_TIME, BellPeriodEnd.END_TIME) 
	END AS [Instructional Minutes]
	
	
--	,RevYear.SCHOOL_YEAR
--	,RevYear.EXTENSION
	,School.SCHOOL_CODE
		
	,AttendanceCalendar.CAL_DATE
	,StudentClass.ENTER_DATE
	,StudentClass.LEAVE_DATE
	,AttendanceCalendar.ROTATION
		
--	,SchoolYearOptions.BELL_SCHEDULE_DEFAULT
--	,BellSchedule.BELL_SCHEDULE_CODE
	
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
	Student.SIS_NUMBER = '970055890' -- (222) '970098001' -- SAndia'102974847' -- debug
--	AND Course.COURSE_ID = '9241B2'
--	AND AttendanceCalendar.CAL_DATE = '2013-08-13'