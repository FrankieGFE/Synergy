/**
 * $Revision: 268 $
 * $LastChangedBy: e201594 $
 * $LastChangedDate: 2014-11-03 14:27:18 -0700 (Mon, 03 Nov 2014) $
 *
 * Teacher assigned classes by school.  This query is used in the credentials report.
 */
DECLARE @YearGu UNIQUEIDENTIFIER
		,@School VARCHAR(128) = '%'
		,@asOfDate DATE = GETDATE()
SELECT 
	@YearGu = YEAR_GU
FROM
	Rev.REV_YEAR AS SynYear
WHERE
	SynYear.SCHOOL_YEAR = 2014
	AND SynYear.EXTENSION = 'R'

SELECT
	Organization.ORGANIZATION_NAME AS School
	,Staff.BADGE_NUM
	,Person.LAST_NAME
	,Person.FIRST_NAME
	,Person.MIDDLE_NAME
	,Course.COURSE_ID
	,Course.STATE_COURSE_CODE
	,Course.COURSE_TITLE
	,Section.SECTION_ID
	,SectionAndStaff.PRIMARY_TEACHER
FROM
	APS.SectionsAndAllStaffAssignedAsOf(@asOfDate) AS SectionAndStaff
	INNER JOIN
	rev.EPC_SCH_YR_SECT AS Section
	ON
	SectionAndStaff.SECTION_GU = Section.SECTION_GU

	INNER JOIN
	rev.REV_ORGANIZATION_YEAR AS OrgYear
	ON
	Section.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

	INNER JOIN
	rev.REV_ORGANIZATION AS Organization
	ON
	OrgYear.ORGANIZATION_GU = Organization.ORGANIZATION_GU

	INNER JOIN
	rev.EPC_SCH_YR_CRS AS SchoolYearCourse
	ON
	Section.SCHOOL_YEAR_COURSE_GU = SchoolYearCourse.SCHOOL_YEAR_COURSE_GU

	INNER JOIN
	rev.EPC_CRS AS Course
	ON
	SchoolYearCourse.COURSE_GU = Course.COURSE_GU

	INNER JOIN
	rev.EPC_STAFF AS Staff
	ON
	SectionAndStaff.STAFF_GU = Staff.STAFF_GU

	INNER JOIN
	rev.REV_PERSON As Person
	ON
	SectionAndStaff.STAFF_GU = Person.PERSON_GU
WHERE
	OrgYear.YEAR_GU = @YearGu
	AND OrgYear.ORGANIZATION_GU LIKE @School
ORDER BY
	Organization.ORGANIZATION_NAME
	,Person.LAST_NAME
	,Person.FIRST_NAME
	,Person.MIDDLE_NAME
	,Staff.BADGE_NUM
	,Course.COURSE_ID
	,Section.SECTION_ID