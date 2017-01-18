/* $Revision: 275 $
 * $LastChangedBy: e201594 $
 * $LastChangedDate: 2014-11-06 09:39:02 -0700 (Thu, 06 Nov 2014) $
 *
 * LCE Classes with Bilingual Students in them.  Includes state reporting
 * information so you can mark them appropriately in state extract.
 *
 * **NOTE** This is used in a report on SSRS (export only)
 */
DECLARE @asOfDate DATE = GETDATE()
DECLARE @School VARCHAR(128) = '%'

SELECT
	Organization.ORGANIZATION_NAME AS School
	,School.STATE_SCHOOL_CODE AS StateSchoolNumber
	,Staff.BADGE_NUM AS PrimaryTeacherBadge
	,Section.COURSE_ID AS CourseID
	,Section.SECTION_ID AS SectionID
	,Section.COURSE_TITLE AS CourseTitle
	,Course.STATE_COURSE_CODE AS StateCourseID
	,Section.BEPCount AS BilingualStudentCount
	,Section.COURSE_ID+'-'+Section.SECTION_ID+'-'+COALESCE(REPLACE(Staff.BADGE_NUM,'e',''),'NoTeach') AS SectionCodeLong
FROM
	(
	SELECT
		Schedule.ORGANIZATION_GU
		,Schedule.COURSE_GU
		,Schedule.SECTION_ID
		,Schedule.SECTION_GU
		,Schedule.COURSE_ID
		,Schedule.COURSE_TITLE
		,Schedule.STAFF_GU
		,COUNT(*) AS BEPCount
	FROM
		APS.ScheduleAsOf(@asOfDate) AS Schedule
		INNER JOIN
		APS.LCEBilingualAsOf(@asOfDate) AS BEP
		ON
		Schedule.STUDENT_GU = BEP.STUDENT_GU

		INNER JOIN
		APS.LCEClassesAsOf(@asOfDate) AS LCEClasses
		ON
		Schedule.SECTION_GU = LCEClasses.SECTION_GU
	WHERE
		Schedule.ORGANIZATION_GU LIKE @School
	GROUP BY
		Schedule.ORGANIZATION_GU
		,Schedule.COURSE_GU
		,Schedule.SECTION_GU
		,Schedule.COURSE_ID
		,Schedule.COURSE_TITLE
		,Schedule.SECTION_ID
		,Schedule.STAFF_GU
	) AS Section

	INNER JOIN
	rev.REV_ORGANIZATION AS Organization
	ON
	Section.ORGANIZATION_GU = Organization.ORGANIZATION_GU

	INNER JOIN
	rev.EPC_CRS AS Course
	ON
	Section.COURSE_GU = Course.COURSE_GU

	INNER JOIN
	rev.EPC_SCH AS School
	ON
	Section.ORGANIZATION_GU = School.ORGANIZATION_GU

	INNER JOIN
	rev.EPC_STAFF AS Staff
	ON
	Section.STAFF_GU = Staff.STAFF_GU
ORDER BY
	ORGANIZATION_NAME
	,Section.COURSE_ID
	,SECTION_ID