/**
 * 
 * $LastChangedBy: Brian Rieb
 * $LastChangedDate: 08/29/2014 $
 *
 * Readable Student Test Information
 * One Record Per Student per test
 */

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[APS].[StudentTestHistory]'))
	EXEC ('CREATE VIEW APS.StudentTestHistory AS SELECT 0 AS DUMMY')
GO

ALTER VIEW APS.StudentTestHistory AS

SELECT
	Student.SIS_NUMBER
	,Person.LAST_NAME
	,Person.FIRST_NAME
	,Test.TEST_NAME
	,StudentTest.ADMIN_DATE
	,Org.ORGANIZATION_NAME AS CurrentYearEnrollmentSchool
	,GradeLevel.VALUE_DESCRIPTION AS CurrentYearEnrollmentGrade
	,Enroll.ENTER_DATE AS CurrentYearEnrollmentEnterDate
	,Enroll.LEAVE_DATE AS CurrentYearEnrollmentLeaveDate

	,Student.STUDENT_GU
	,Test.TEST_GU
	,StudentTest.STUDENT_TEST_GU
	,Enroll.STUDENT_SCHOOL_YEAR_GU
FROM
	rev.EPC_STU_TEST AS StudentTest
	INNER JOIN
	rev.EPC_TEST AS Test
	ON
	StudentTest.TEST_GU = Test.TEST_GU

	INNER JOIN
	rev.EPC_STU AS Student
	ON
	StudentTest.STUDENT_GU = Student.STUDENT_GU

	INNER JOIN
	rev.REV_PERSON AS Person
	ON
	StudentTest.STUDENT_GU = Person.PERSON_GU

	LEFT JOIN
	APS.PrimaryEnrollmentsAsOf(GETDATE()) AS Enroll
	ON
	StudentTest.STUDENT_GU = Enroll.STUDENT_GU

	LEFT JOIN
	rev.REV_ORGANIZATION_YEAR AS OrgYear
	ON
	Enroll.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

	LEFT JOIN
	rev.REV_ORGANIZATION AS Org
	ON
	OrgYear.ORGANIZATION_GU = Org.ORGANIZATION_GU

	LEFT JOIN
	APS.LookupTable('K12','Grade') AS GradeLevel
	ON
	Enroll.GRADE = GradeLevel.VALUE_CODE