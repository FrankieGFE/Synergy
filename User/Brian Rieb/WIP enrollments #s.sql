SELECT
	Grades.VALUE_DESCRIPTION AS Grade
	,
	COUNT(*) AS TheCount
FROM
	rev.EPC_SCH_ATT_CAL_OPT AS SchoolCalendar

	INNER JOIN

	rev.EPC_STU_SCH_YR AS SSY

	ON

	SchoolCalendar.ORG_YEAR_GU = SSY.ORGANIZATION_YEAR_GU

	INNER JOIN
	[rev].[SIF_22_Common_GetLookupValues]('K12','Grade') AS Grades

	ON

	SSY.GRADE = Grades.VALUE_CODE

	INNER JOIN 

	rev.REV_PERSON AS Person
	ON
	SSY.STUDENT_GU = Person.PERSON_GU

	INNER JOIN

	REV.REV_ORGANIZATION_YEAR AS OrgYear

	ON

	SSY.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

	INNER JOIN

	rev.EPC_SCH AS School

	ON 

	OrgYear.ORGANIZATION_GU = School.ORGANIZATION_GU

	INNER JOIN
	
	REV.REV_ORGANIZATION AS Organization

	ON

	OrgYear.ORGANIZATION_GU = Organization.ORGANIZATION_GU

	INNER JOIN

	rev.EPC_STU_ENROLL AS Enrollment

	ON

	SSY.STUDENT_SCHOOL_YEAR_GU = Enrollment.STUDENT_SCHOOL_YEAR_GU


WHERE
	CONVERT(DATE, GETDATE()) BETWEEN SchoolCalendar.START_DATE AND SchoolCalendar.END_DATE
	AND SSY.ENTER_DATE <= CONVERT(DATE, GETDATE()) -- they must have an enter date
	AND SSY.SUMMER_WITHDRAWL_DATE IS NULL -- remove noshows
	-- make sure not past leave dates
	AND (
		SSY.LEAVE_DATE IS NULL
		OR SSY.LEAVE_DATE >= CONVERT(DATE, GETDATE())
		)
	
	-- only show students not excluded from ADA/ADM
	AND (
		SSY.EXCLUDE_ADA_ADM IS NULL
		OR SSY.EXCLUDE_ADA_ADM = '1' -- No concurrents
		)

/*
	AND Grades.VALUE_DESCRIPTION = '01'
   AND Organization.ORGANIZATION_NAME LIKE 'Apa%'
*/
GROUP BY
	Grades.VALUE_DESCRIPTION
ORDER BY
	Grades.VALUE_DESCRIPTION

