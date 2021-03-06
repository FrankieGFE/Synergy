-- Bell Schedule
SELECT
	BellSchedule.ORGANIZATION_YEAR_GU
	,BellSchedule.BELL_SCHEDULE_CODE
	,BellSchedulePeriod.BELL_PERIOD
	,DATEDIFF(MINUTE, BellSchedulePeriod.START_TIME, BellSchedulePeriod.END_TIME) AS Amount
FROM
	rev.EPC_SCH_YR_BELL_SCHED AS BellSchedule
	INNER JOIN
	rev.EPC_SCH_YR_BELL_SCHED_PER AS BellSchedulePeriod
	ON
	BellSchedule.BELL_SCHEDULE_GU = BellSchedulePeriod.BELL_SCHEDULE_GU
	