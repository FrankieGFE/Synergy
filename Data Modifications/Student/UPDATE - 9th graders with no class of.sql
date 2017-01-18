/**
 * $Revision: 245 $
 * $LastChangedBy: e201594 $
 * $LastChangedDate: 2014-10-16 14:53:52 -0600 (Thu, 16 Oct 2014) $
 *
 * Updates "class of" student field for applicable 9th graders
 * 
 * Initial Request: Christine Cervantes
 * All, using a newly created report we’ve identified an issue with missing Class of Year for 9th graders. 
 * Can we please enter an “Expected Graduation Year” of 2018 for all 9th graders with one or less credits earned.
 *
 */
BEGIN TRANSACTION
DECLARE @Year UNIQUEIDENTIFIER = '26F066A3-ABFC-4EDB-B397-43412EDABC8B'

--/*
UPDATE
	Student
SET
	CLASS_OF = 2018
--*/
/*
SELECT
	Organization.ORGANIZATION_NAME
	,Student.SIS_NUMBER
	,Person.LAST_NAME
	,Person.FIRST_NAME
	,Person.MIDDLE_NAME
	,COALESCE(CONVERT(VARCHAR(4),Student.CLASS_OF),'') AS CLASS_OF
	,COALESCE(GradeLevel.VALUE_DESCRIPTION,'') AS GradeLevel
	,COALESCE(CourseHistoryGrouped.EarnedCredit,0) AS EarnedCredits
*/
FROM
	rev.EPC_STU_SCH_YR AS SSY
	INNER JOIN
	rev.REV_ORGANIZATION_YEAR AS OrgYear
	ON
	SSY.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

	LEFT JOIN
	(
	SELECT 
		STUDENT_GU
		,SUM(CREDIT_COMPLETED) AS EarnedCredit
	FROM
		REV.EPC_STU_CRS_HIS AS CourseHistory
	WHERE
		COURSE_HISTORY_TYPE = 'HIGH'
		AND REPEAT_TAG_GU IS NULL
	GROUP BY 
		STUDENT_GU
	) AS CourseHistoryGrouped
	ON
	SSY.STUDENT_GU = CourseHistoryGrouped.STUDENT_GU

	--Pretty up table joins
	INNER JOIN
	rev.EPC_STU AS Student
	ON
	SSY.STUDENT_GU = Student.STUDENT_GU

	LEFT JOIN
	APS.LookupTable('K12','Grade') AS GradeLevel
	ON
	SSY.GRADE = GradeLevel.VALUE_CODE

	INNER JOIN
	rev.REV_ORGANIZATION AS Organization
	ON
	OrgYear.ORGANIZATION_GU = Organization.ORGANIZATION_GU

	INNER JOIN
	rev.REV_PERSON As Person
	ON
	SSY.STUDENT_GU = Person.PERSON_GU

WHERE
	OrgYear.YEAR_GU = @Year
	AND SSY.STATUS IS NULL --Active SSY's Only--

	AND COALESCE(EarnedCredit,0) <= 1 
	AND GradeLevel.VALUE_DESCRIPTION = '09'
	AND CLASS_OF IS NULL
	AND Organization.ORGANIZATION_NAME NOT IN ('Career Enrichment Center', 'eCADEMY Virtual', 'Juvenile Detention Center', 'Homebound',
									   'Private School', 'Home or Hospital Instruction')
ROLLBACK