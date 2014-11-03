/**
 * $Revision: 221 $
 * $LastChangedBy: e201594 $
 * $LastChangedDate: 2014-10-09 17:00:25 -0600 (Thu, 09 Oct 2014) $
 *
 * For students enrolled and scheduled as of a certian date, grab their math and ela schedule courses (or homeroom - Period 1 if they are 3-5)
 * for 3-8th graders.
 */

DECLARE @AsOfDate DATE = GETDATE()

SELECT
	Student.SIS_NUMBER
	,StudentPerson.LAST_NAME AS StudentLastName
	,StudentPerson.FIRST_NAME AS StudentFirstName
	,COALESCE(StudentPerson.MIDDLE_NAME,'') AS StudentMiddleName
	,GradeLevel.VALUE_DESCRIPTION As GradeLevel
	,Organization.ORGANIZATION_NAME
	,Schedule.COURSE_TITLE
	,Schedule.COURSE_ID
	,Schedule.SECTION_ID
	,Staff.BADGE_NUM
	,StaffPerson.LAST_NAME AS StaffLastName
	,StaffPerson.FIRST_NAME AS StaffFirstName
	,COALESCE(StaffPerson.MIDDLE_NAME,'') AS StaffMiddleName
FROM
	APS.PrimaryEnrollmentsAsOf(@AsOfDate) AS Enroll
	INNER JOIN
	APS.ScheduleAsOf(@AsOfDate) AS Schedule
	ON
	Enroll.STUDENT_GU = Schedule.STUDENT_GU

	INNER JOIN
	rev.EPC_STU AS Student
	ON
	Enroll.STUDENT_GU = Student.STUDENT_GU

	INNER JOIN
	rev.rev_person as StudentPerson
	ON
	Enroll.STUDENT_GU = StudentPerson.PERSON_GU

	INNER JOIN
	APS.LookupTable('K12','Grade') AS GradeLevel
	ON
	Enroll.GRADE = GradeLevel.VALUE_CODE

	INNER JOIN
	rev.EPC_STAFF AS Staff
	ON
	Schedule.STAFF_GU = Staff.STAFF_GU

	INNER JOIN
	rev.REV_PERSON AS StaffPerson
	ON
	Schedule.STAFF_GU = StaffPerson.PERSON_GU
	
	INNER JOIN
	rev.REV_ORGANIZATION AS Organization
	ON
	Schedule.ORGANIZATION_GU = Organization.ORGANIZATION_GU	
WHERE
	Enroll.GRADE BETWEEN 130 AND 180
	AND
	(
		(
		Enroll.GRADE BETWEEN 130 AND 150
		AND Schedule.PERIOD_BEGIN = 1
		)
	OR
		(
		Enroll.GRADE > 150
		AND Schedule.DEPARTMENT IN ('MATH','ENG')
		)
	)