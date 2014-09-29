/* Brian Rieb
 * 9/26/2014
 * 
 * This looks at the discepancy between ELL as of and ELL calculated as of.
 * The resulting students represent kids with a ELL qualifying test
 * that are not marked ELL.  This can be caused by one of the following reasons:
 * + Bad ELL history in SchoolMax + PHLOTE changes
 * + Kids not processed yet (today) as ELL
 * + Kids identified as PHLOTE, given a test, and then PHLOTE status changed before test results loaded
 */

SELECT
	Organization.ORGANIZATION_NAME AS School
	,Student.SIS_NUMBER AS [Student #]
	,Person.LAST_NAME AS [Last Name]
	,Person.FIRST_NAME AS [First Name]
	,GradeLevel.VALUE_DESCRIPTION AS Grade
	,CASE WHEN PHLOTE.STUDENT_GU IS NULL THEN 'N' ELSE 'Y' END AS PHLOTE

	,CalELL.ADMIN_DATE AS [Test Date]
	,CalELL.TEST_NAME AS [Test]
	,PerformanceLevel.VALUE_DESCRIPTION AS [Performance Level]

	,ELLRec.ENTRY_DATE AS [ELL Entry Date]
	,ELLRec.EXIT_DATE AS [ELL Exit Date]
	,ELLRec.EXIT_REASON AS [ELL Exit Reason Code]
FROM
	APS.ELLCalculatedAsOf(GETDATE()) AS CalELL
	INNER JOIN
	rev.EPC_STU AS Student
	ON
	CalELL.STUDENT_GU = Student.STUDENT_GU

	INNER JOIN
	rev.REV_PERSON AS Person
	ON
	CalELL.STUDENT_GU = Person.PERSON_GU

	INNER JOIN
	rev.EPC_STU_SCH_YR AS SSY
	ON
	CalELL.STUDENT_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU

	INNER JOIN
	rev.REV_ORGANIZATION_YEAR AS OrgYear
	ON
	SSY.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

	INNER JOIN
	rev.REV_ORGANIZATION AS Organization
	ON
	OrgYear.ORGANIZATION_GU = Organization.ORGANIZATION_GU

	LEFT JOIN
	APS.LookupTable('k12','Grade') AS GradeLevel
	ON
	CalELL.GRADE = GradeLevel.VALUE_CODE

	LEFT JOIN
	APS.LookupTable('K12.Testinfo','Performance_Levels') AS PerformanceLevel
	ON
	CalELL.PERFORMANCE_LEVEL = PerformanceLevel.VALUE_CODE

	LEFT JOIN
	rev.EPC_STU_PGM_ELL AS ELLRec
	ON
	CalELL.STUDENT_GU = ELLRec.STUDENT_GU

	LEFT JOIN
	APS.PHLOTEAsOf(GETDATE()) AS PHLOTE
	On
	CalELL.STUDENT_GU = PHLOTE.STUDENT_GU


	LEFT HASH JOIN
	APS.ELLAsOf(GETDATE()) AS ELL
	ON
	CalELL.STUDENT_GU = ELL.STUDENT_GU	
WHERE
	ELL.STUDENT_GU IS NULL
ORDER BY
	Organization.ORGANIZATION_NAME
	,Student.SIS_NUMBER