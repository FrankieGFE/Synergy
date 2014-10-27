/**
 * $Revision$
 * $LastChangedBy$
 * $LastChangedDate$
 *
 * Class counts of current sections for certain subject areas (health, econ, gov, and NM history)
 */

SELECT
	School
	,Area
	,COURSE_ID
	,COURSE_TITLE
	,TeacherLastName
	,TeacherFirstName
	,TeacherMiddleName
	,TeacherBadge
	,SECTION_ID
	,COUNT(*) AS StudentCount
FROM
	(
	SELECT
		Organization.ORGANIZATION_NAME AS School
		,CASE
			WHEN SUBJECT_AREA_1 = 'NMH' OR SUBJECT_AREA_2 = 'NMH' OR SUBJECT_AREA_3 = 'NMH' OR SUBJECT_AREA_4 = 'NMH' OR SUBJECT_AREA_5 = 'NMH' THEN 'NM History'
			WHEN SUBJECT_AREA_1 = 'Econ' OR SUBJECT_AREA_2 = 'Econ' OR SUBJECT_AREA_3 = 'Econ' OR SUBJECT_AREA_4 = 'Econ' OR SUBJECT_AREA_5 = 'Econ' THEN 'Economics'
			WHEN SUBJECT_AREA_1 = 'Gov' OR SUBJECT_AREA_2 = 'Gov' OR SUBJECT_AREA_3 = 'Gov' OR SUBJECT_AREA_4 = 'Gov' OR SUBJECT_AREA_5 = 'Gov' THEN 'Government'
			WHEN SUBJECT_AREA_1 = 'Hea' OR SUBJECT_AREA_2 = 'Hea' OR SUBJECT_AREA_3 = 'Hea' OR SUBJECT_AREA_4 = 'Hea' OR SUBJECT_AREA_5 = 'Hea' THEN 'Health'
		END AS Area
		,Course.COURSE_ID
		,Course.COURSE_TITLE
		,Schedule.SECTION_ID
		,Staff.BADGE_NUM AS TeacherBadge
		,Person.LAST_NAME AS TeacherLastName
		,Person.FIRST_NAME AS TeacherFirstName
		,Person.MIDDLE_NAME AS TeacherMiddleName
	FROM
		APS.ScheduleAsOf(GETDATE()) AS Schedule
		INNER JOIN
		rev.EPC_CRS AS Course
		ON
		Schedule.COURSE_GU = Course.COURSE_GU

		INNER JOIN
		rev.REV_ORGANIZATION AS Organization
		ON
		Schedule.ORGANIZATION_GU = Organization.ORGANIZATION_GU

		INNER JOIN
		rev.rev_PERSON AS Person
		ON
		Schedule.STAFF_GU = Person.PERSON_GU

		INNER JOIN
		rev.EPC_STAFF AS Staff
		ON
		Schedule.STAFF_GU = Staff.STAFF_GU
		
	WHERE
		SUBJECT_AREA_1 IN ('NMH', 'Econ', 'Gov', 'Hea')
		OR SUBJECT_AREA_2 IN ('NMH', 'Econ', 'Gov', 'Hea')
		OR SUBJECT_AREA_3 IN ('NMH', 'Econ', 'Gov', 'Hea')
		OR SUBJECT_AREA_4 IN ('NMH', 'Econ', 'Gov', 'Hea')
		OR SUBJECT_AREA_5 IN ('NMH', 'Econ', 'Gov', 'Hea')
	) AS Schedules
GROUP BY
	School
	,Area
	,COURSE_ID
	,COURSE_TITLE
	,TeacherLastName
	,TeacherFirstName
	,TeacherMiddleName
	,TeacherBadge
	,SECTION_ID
ORDER BY
	School
	,Area
	,COURSE_ID
	,COURSE_TITLE
	,TeacherLastName
	,TeacherFirstName
	,TeacherMiddleName
	,TeacherBadge
	,SECTION_ID
	