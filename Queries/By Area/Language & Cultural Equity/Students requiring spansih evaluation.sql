/* $Revision$
 * $LastChangedBy$
 * $LastChangedDate$
 *
 * List of current students in a bilingual program that are missing a spanish evaluation
 * or did not score proficient in a spansih evaluation.
 */
DECLARE @AsOfDate DATE = GETDATE()
DECLARE @School VARCHAR(128) = '%'

SELECT
	Organization.ORGANIZATION_NAME
	,GradeLevel.VALUE_DESCRIPTION AS GradeLevel
	,GradeLevel.LIST_ORDER AS GradeOrder
	,Student.SIS_NUMBER
	,Person.LAST_NAME
	,Person.FIRST_NAME
	,Person.MIDDLE_NAME
	,BEP.PROGRAM_CODE
	,BEP.PROGRAM_INTENSITY
	,SpanishEval.ADMIN_DATE
	,SpanishEval.TEST_NAME
	,SpanishEval.PERFORMANCE_LEVEL
FROM
	APS.PrimaryEnrollmentsAsOf(@AsOfDate) AS Enroll
	INNER JOIN
	APS.LCEBilingualAsOf(@AsOfDate) AS BEP
	ON
	Enroll.STUDENT_GU = BEP.STUDENT_GU

	LEFT JOIN
	APS.LCELatestSpanishEvaluationAsOf(@AsOfDate) AS SpanishEval
	ON
	Enroll.STUDENT_GU = SpanishEval.STUDENT_GU


	-- Make pretty table joins
	INNER JOIN
	rev.EPC_STU as STUDENT
	ON
	Enroll.STUDENT_GU = Student.STUDENT_GU

	INNER JOIN
	rev.REV_PERSON AS Person
	ON
	Enroll.STUDENT_GU = Person.PERSON_GU	

	INNER JOIN
	rev.REV_ORGANIZATION_YEAR AS OrgYear
	ON
	Enroll.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

	INNER JOIN
	rev.REV_ORGANIZATION AS Organization
	ON
	OrgYear.ORGANIZATION_GU = Organization.ORGANIZATION_GU

	LEFT JOIN
	APS.LookupTable('k12','Grade') AS GradeLevel
	ON
	Enroll.GRADE = GradeLevel.VALUE_CODE
WHERE
	OrgYear.ORGANIZATION_GU LIKE @School
	AND
	(
		SpanishEval.PERFORMANCE_LEVEL IS NULL
		OR SpanishEval.PERFORMANCE_LEVEL NOT IN ('FSP', 'C-PRO', 'ABVPR')
	)
	AND
	Organization.ORGANIZATION_NAME LIKE 'Rio%'
ORDER BY
	Organization.ORGANIZATION_NAME
	,GradeLevel.LIST_ORDER
	,Person.LAST_NAME
	,Person.FIRST_NAME
	,Person.MIDDLE_NAME