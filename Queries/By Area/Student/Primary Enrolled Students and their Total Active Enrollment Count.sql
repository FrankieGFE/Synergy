/* $Revision$
 * $LastChangedBy$
 * $LastChangedDate: 2014-10-03 12:55:48 -0600 (Fri, 03 Oct 2014) $
 *
 * List kids, with their primary enrollments and their total active enrollment count for a specific day
 */

DECLARE @asOfDate DATE = '10/8/2014'

SELECT
	School.SCHOOL_CODE
	,School.STATE_SCHOOL_CODE
	,Student.SIS_NUMBER
	,Student.STATE_STUDENT_NUMBER
	,Person.LAST_NAME
	,Person.FIRST_NAME
	,GradeLevel.VALUE_DESCRIPTION AS GradeLevel
	,PrimaryEnroll.ENTER_DATE
	,AllEnrollment.TotalEnrollCount
FROM
	APS.PrimaryEnrollmentsAsOf(@asOfDate) AS PrimaryEnroll
	INNER HASH JOIN
	(
		SELECT
			STUDENT_GU
			,COUNT(*) AS TotalEnrollCount
		FROM
			APS.EnrollmentsAsOf(@asOfDate)
		GROUP BY
			STUDENT_GU
	) AS AllEnrollment
	ON
	PrimaryEnroll.STUDENT_GU = AllEnrollment.STUDENT_GU

	INNER JOIN
	REV.REV_ORGANIZATION_YEAR AS OrgYear
	ON
	PrimaryEnroll.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

	INNER JOIN
	REV.EPC_SCH AS School
	ON
	OrgYear.ORGANIZATION_GU = School.ORGANIZATION_GU

	INNER JOIN
	rev.EPC_STU AS Student
	ON
	PrimaryEnroll.STUDENT_GU = Student.STUDENT_GU

	LEFT JOIN
	APS.LookupTable('K12','Grade') AS GradeLevel
	ON
	PrimaryEnroll.GRADE = GradeLevel.VALUE_CODE

	INNER JOIN
	REV.REV_PERSON AS Person
	ON
	PrimaryEnroll.STUDENT_GU = Person.PERSON_GU