-- Trying to put together a unifying query for attendance


-- Just realized you have to pull all periods for a given day if ANY period has been changed since
-- last run time. It might be a good idea to to this with a table variable (indexed)that gets the DAILY_ATTEND_GU
-- based off any changed period, and then the main select uses that DAILY ATTEND_GU to get records.
-- The table variable could also be used to hook to calendar for the total scheduled mintues (assuming that will be a separate pull)

-- hard part is going to be separatley? or somehow together calculating total scheduled minutes.
-- Also, Need to find out about the types
-- will probably want to group by student/day/type adding minutes
-- keep in mind we will do something similar but mutch easier for daily attendance.

-- Lastly once, we have the data inserted, we will need to develop queries/views on how to pull the data. 
-- (calulating percentages per day- then thresholding, then adding up?)

SELECT
	DailyAttendance.DAILY_ATTEND_GU
	,DailyAttendance.ABS_DATE
	,PeriodAttendance.BELL_PERIOD
	,ReasonCode.TYPE
	,DATEDIFF(MINUTE, BellSchedulePeriod.START_TIME, BellSchedulePeriod.END_TIME) AS Amount
	
	-- informational purposes only.
	,PeriodAttendance.ADD_DATE_TIME_STAMP
	,PeriodAttendance.CHANGE_DATE_TIME_STAMP
		
FROM
	rev.EPC_STU_ATT_PERIOD AS PeriodAttendance
	
	INNER JOIN
	rev.EPC_STU_ATT_DAILY AS DailyAttendance
	ON
	PeriodAttendance.DAILY_ATTEND_GU = DailyAttendance.DAILY_ATTEND_GU
	
	-- Not sure we need this next join for idenifying as we will be createing/updating (replace)
	-- these records
	/*
	LEFT JOIN
	
	rev.UD_STU_ATT_DAILY AS UDDaily	
	ON	
	DailyAttendance.DAILY_ATTEND_GU = UDDaily.DAILY_ATTEND_GU
	*/
	
	INNER JOIN
	rev.EPC_CODE_ABS_REAS_SCH_YR AS ReasonCodeSchoolYear	
	ON	
	PeriodAttendance.CODE_ABS_REAS_GU = ReasonCodeSchoolYear.CODE_ABS_REAS_SCH_YEAR_GU
	
	INNER JOIN 
	rev.EPC_CODE_ABS_REAS AS ReasonCode	
	ON
	ReasonCodeSchoolYear.CODE_ABS_REAS_GU = ReasonCode.CODE_ABS_REAS_GU
	
	-- Grabbing Minutes involves bell schedules, and calendars
	INNER JOIN
	rev.EPC_SCH_YR_BELL_SCHED AS BellSchedule
	ON
	BellSchedule.ORGANIZATION_YEAR_GU = ReasonCodeSchoolYear.ORGANIZATION_YEAR_GU
	
	INNER JOIN
	rev.EPC_SCH_YR_BELL_SCHED_PER AS BellSchedulePeriod
	ON
	BellSchedule.BELL_SCHEDULE_GU = BellSchedulePeriod.BELL_SCHEDULE_GU	
	AND BellSchedulePeriod.BELL_PERIOD = PeriodAttendance.BELL_PERIOD

	--need School year options for default bell schedule
	INNER JOIN
	rev.EPC_SCH_YR_OPT AS SchoolYearOptions
	ON
	ReasonCodeSchoolYear.ORGANIZATION_YEAR_GU = SchoolYearOptions.ORGANIZATION_YEAR_GU

	-- need calendar to determine which bell schedule to get	
	INNER JOIN
	rev.EPC_SCH_ATT_CAL AS AttendanceCalendar
	ON
	BellSchedule.ORGANIZATION_YEAR_GU = AttendanceCalendar.SCHOOL_YEAR_GU
	AND DailyAttendance.ABS_DATE = AttendanceCalendar.CAL_DATE
	AND 
		(
		BellSchedule.BELL_SCHEDULE_CODE = AttendanceCalendar.BELL_SCHEDULE
		OR
			-- using default
			(
			AttendanceCalendar.BELL_SCHEDULE IS NULL
			AND
			BellSchedule.BELL_SCHEDULE_CODE = SchoolYearOptions.BELL_SCHEDULE_DEFAULT
			)
		)
	
	-- This **may only be needed for info purposes** or needed to grab school
	-- to get to bell peirods
	INNER JOIN
	
	rev.EPC_STU_ENROLL AS Enrollment	
	ON	
	DailyAttendance.ENROLLMENT_GU = Enrollment.ENROLLMENT_GU
	
WHERE
	-- don't worry about tardies or positives
	ReasonCode.TYPE NOT IN ('TDY', 'TAR', 'POS')
	
	-- add constraints for only recent runs (it might be nice to store somewhere when the last time it was completed successfully... and then adjust
	-- sproc to check for anything since the last run time?
	