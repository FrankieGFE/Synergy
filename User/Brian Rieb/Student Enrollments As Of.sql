DECLARE @AsOfDate DATE = '2014-08-13'

SELECT
	SSY.STUDENT_GU
	,SSY.STUDENT_SCHOOL_YEAR_GU
	,Enrollment.ENROLLMENT_GU
FROM
	rev.EPC_SCH_ATT_CAL_OPT AS SchoolCalendar

	INNER JOIN

	rev.EPC_STU_SCH_YR AS SSY

	ON

	SchoolCalendar.ORG_YEAR_GU = SSY.ORGANIZATION_YEAR_GU

	INNER JOIN

	rev.EPC_STU_ENROLL AS Enrollment

	ON

	SSY.STUDENT_SCHOOL_YEAR_GU = Enrollment.STUDENT_SCHOOL_YEAR_GU
WHERE
	@AsOfDate BETWEEN SchoolCalendar.START_DATE AND SchoolCalendar.END_DATE
	AND Enrollment.ENTER_DATE <= @AsOfDate

	AND (
		Enrollment.LEAVE_DATE IS NULL
		OR Enrollment.LEAVE_DATE >= @AsOfDate
		)

	AND (
		Enrollment.EXCLUDE_ADA_ADM != '2' -- No concurrents
		OR Enrollment.EXCLUDE_ADA_ADM IS NULL
		)
