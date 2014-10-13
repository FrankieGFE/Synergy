/* $Revision: 218 $
 * $LastChangedBy: e201594 $
 * $LastChangedDate: 2014-10-09 08:10:50 -0600 (Thu, 09 Oct 2014) $
 *
 * Info needed for creating section code long for state extrcats
 * **NOTE** This is used in a report
 */
DECLARE @Year INT = 2014
DECLARE @YearExtension NVARCHAR(1)= 'R'

SELECT
	*
	--MAX(LEN(CodeLong))
FROM
	(
	SELECT
		School.SCHOOL_CODE
		,School.STATE_SCHOOL_CODE
		,Course.COURSE_ID
		,Course.COURSE_TITLE
		,Course.STATE_COURSE_CODE
		,Section.SECTION_ID
		,Section.TERM_CODE
		,Staff.BADGE_NUM
		,COALESCE(StudentCounts.KidCount,0) AS EnrollmentCount
		,Course.COURSE_ID+'-'+Section.SECTION_ID+'-'+COALESCE(REPLACE(Staff.BADGE_NUM,'e',''),'NoTeach') AS CodeLong
	FROM
		rev.EPC_SCH_YR_SECT AS Section
		INNER JOIN 
		rev.EPC_SCH_YR_CRS AS SYCourse
		ON
		Section.SCHOOL_YEAR_COURSE_GU = SYCourse.SCHOOL_YEAR_COURSE_GU

		INNER JOIN
		rev.EPC_CRS AS Course
		ON
		SYCourse.COURSE_GU = Course.COURSE_GU

		INNER JOIN
		rev.REV_ORGANIZATION_YEAR AS OrgYear
		ON
		Section.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

		INNER JOIN
		rev.REV_YEAR AS SynYear
		ON
		OrgYear.YEAR_GU = SynYear.YEAR_GU

		INNER JOIN
		REV.EPC_SCH AS School
		ON
		OrgYear.ORGANIZATION_GU = School.ORGANIZATION_GU

		LEFT JOIN
		rev.EPC_STAFF_SCH_YR AS StaffSchoolyear
		ON
		Section.STAFF_SCHOOL_YEAR_GU = StaffSchoolyear.STAFF_SCHOOL_YEAR_GU

		LEFT JOIN
		rev.EPC_STAFF AS Staff
		ON
		StaffSchoolyear.STAFF_GU = Staff.STAFF_GU

		LEFT HASH JOIN
		(
			SELECT 
				SECTION_GU
				,COUNT(*) AS KidCount
			FROM
				APS.ScheduleAsOf('10/8/2014')
			GROUP BY
				SECTION_GU
		) AS StudentCounts
		ON
		Section.SECTION_GU = StudentCounts.SECTION_GU
	WHERE
		SynYear.SCHOOL_YEAR = @Year
		AND SynYear.EXTENSION = @YearExtension
	) AS CodeCreator
