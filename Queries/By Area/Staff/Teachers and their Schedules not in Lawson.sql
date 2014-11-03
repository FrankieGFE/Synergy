/**
 * $Revision$
 * $LastChangedBy$
 * $LastChangedDate$
 *
 * Teacher assigned classes by school that are not in Lawson.  This query is used in the credentials report.
 */

-- ****************************************************
-- CUT OUT HERE FOR REPORT
-- These variables are report passers
DECLARE @asOfDate DATE = GETDATE()
DECLARE @YearGu UNIQUEIDENTIFIER
		,@School VARCHAR(128) = '%'
		,@RemoveKnownDummyNumbers VARCHAR(1) = 'Y'
SELECT 
	@YearGu = YEAR_GU
FROM
	Rev.REV_YEAR AS SynYear
WHERE
	SynYear.SCHOOL_YEAR = 2014
	AND SynYear.EXTENSION = 'R'
-- END CUT OUT HERE FOR REPORT
-- ****************************************************


-- ---------------------------------------------------------------------------------
-- These variables are needed for openquery
DECLARE @SQL VARCHAR(MAX)
DECLARE @LawsonBadge TABLE(BADGE_NUMBER VARCHAR(32))

-- openquery does not take passed parameters, so we load it into a temp table
SET @SQL = '
SELECT
	''e'' + RIGHT(''000000''+ CONVERT (VARCHAR (6), CAST(EMPLOYEE AS VARCHAR)), 6) AS BADGE_NUMBER
FROM
	OPENQUERY([180-SMAXODS-01.APS.EDU.ACTD], ''SELECT * FROM Lawson.APS.ActiveEmployeesAsOf(' + CONVERT(VARCHAR, @asOfDate,101) + ')'')
'
INSERT INTO
	@LawsonBadge
EXEC(@SQL)

-- ---------------------------------------------------------------------------------
-- Main Query
SELECT
	Organization.ORGANIZATION_NAME AS School
	,Staff.BADGE_NUM
	,Person.LAST_NAME
	,Person.FIRST_NAME
	,Person.MIDDLE_NAME
	,Course.COURSE_ID
	,Course.COURSE_TITLE
	,Section.SECTION_ID
	,SectionAndStaff.PRIMARY_TEACHER
	,Section.EXCLUDE_FROM_STATE_RPT
	,COALESCE(Schedules.TheCount,0) AS StudentCount
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

	LEFT JOIN
	@LawsonBadge AS LawsonBadge
	ON Staff.BADGE_NUM = LawsonBadge.BADGE_NUMBER

	LEFT JOIN
	(
	SELECT	
		SECTION_GU
		,COUNT(*) AS TheCount
	FROM
		APS.ScheduleAsOf(@asOfDate) 
	GROUP BY
		SECTION_GU
	)AS Schedules
	ON
	SectionAndStaff.SECTION_GU = Schedules.SECTION_GU
WHERE
	LawsonBadge.BADGE_NUMBER IS NULL
	AND OrgYear.YEAR_GU = @YearGu
	AND OrgYear.ORGANIZATION_GU LIKE @School
	AND (
		@RemoveKnownDummyNumbers = 'N'
		OR
		(
		@RemoveKnownDummyNumbers = 'Y'
		AND Staff.BADGE_NUM NOT IN
			(
			'e999999'
			,'777777777'
			,'e222222222'
			,'666666666'
			)
		)
	)
ORDER BY
	Organization.ORGANIZATION_NAME
	,Person.LAST_NAME
	,Person.FIRST_NAME
	,Person.MIDDLE_NAME
	,Staff.BADGE_NUM
	,Course.COURSE_ID
	,Section.SECTION_ID
	
