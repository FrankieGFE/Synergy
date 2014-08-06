DECLARE @AsOfDate DATE = '2014-08-13'


SELECT

	Grades.VALUE_DESCRIPTION
--	,Person.Gender
	,COUNT(*) AS TheCount
--*/

--COUNT(*)
FROM
	(
	SELECT
		SSY.STUDENT_GU
		,SSY.ORGANIZATION_YEAR_GU
		,SSY.STUDENT_SCHOOL_YEAR_GU
		,Enrollment.ENROLLMENT_GU
		,Enrollment.GRADE
		,SSY.GRADE AS Grade2
		,Enrollment.EXCLUDE_ADA_ADM
		,Enrollment.ENTER_DATE
		,Enrollment.LEAVE_DATE
		,SchoolCalendar.START_DATE AS SchoolYearStartDate
		,SchoolCalendar.END_DATE AS SchoolYearEndDate
		--
		,ROW_NUMBER() OVER (PARTITION BY SSY.STUDENT_GU ORDER BY Enrollment.EXCLUDE_ADA_ADM) AS RN
	FROM
		-- we start with school canendar to narrow down the org_years
		-- becasue enrollments never really have a leave date, unless they are duing the term
		rev.EPC_SCH_ATT_CAL_OPT AS SchoolCalendar

		-- SSY, because you never know what the School of Record (SOR) is in a historical context
		INNER JOIN
		rev.EPC_STU_SCH_YR AS SSY
		ON
		SchoolCalendar.ORG_YEAR_GU = SSY.ORGANIZATION_YEAR_GU

		-- Enrollment because enter and leave dates truly reside here, and not most recent as it is bubbled up to SSY
		INNER JOIN
		rev.EPC_STU_ENROLL AS Enrollment
		ON
		SSY.STUDENT_SCHOOL_YEAR_GU = Enrollment.STUDENT_SCHOOL_YEAR_GU

		INNER JOIN
		rev.REV_ORGANIZATION_YEAR AS OrgYear
		ON 
		SchoolCalendar.ORG_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

		INNER JOIN
		rev.REV_YEAR AS SynYear
		ON
		OrgYear.YEAR_GU = SynYear.YEAR_GU

	WHERE
--		@AsOfDate BETWEEN SchoolCalendar.START_DATE AND SchoolCalendar.END_DATE
--		Enrollment.ENTER_DATE >= '2014-07-15'
		SynYear.SCHOOL_YEAR = '2014' AND SynYear.EXTENSION = 'R'
		AND Enrollment.ENTER_DATE <= CONVERT(DATE, @AsOfDate) -- check for existing and applicable enrollmentdate
		--AND SSY.SUMMER_WITHDRAWL_DATE IS NULL

		-- make sure not past leave dates
		AND (
			Enrollment.LEAVE_DATE IS NULL
			OR Enrollment.LEAVE_DATE >= @AsOfDate
			)

		-- only show students not excluded from ADA/ADM
		AND (
			Enrollment.EXCLUDE_ADA_ADM IS NULL
			--OR Enrollment.EXCLUDE_ADA_ADM = '1' -- No concurrents, only null (ADA) or 1 (non-ADA/ADM)
			)
	) AS ThePull

	INNER JOIN
	rev.EPC_STU AS Student
	ON
	ThePull.STUDENT_GU = Student.STUDENT_GU

	INNER JOIN
	rev.REV_PERSON AS Person
	ON
	ThePull.STUDENT_GU = Person.PERSON_GU

	LEFT JOIN
	APS.LookupTable('K12','Grade') AS Grades
	ON
	ThePull.GRADE2 = Grades.VALUE_CODE

WHERE
	RN=1
--	Grades.VALUE_DESCRIPTION = '12'

GROUP BY
	Grades.LIST_ORDER
	,Grades.VALUE_DESCRIPTION
--	,Person.Gender
ORDER BY
	Grades.LIST_ORDER
--	,Person.Gender
		