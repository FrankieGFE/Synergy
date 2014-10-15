/**
 * $Revision$
 * $LastChangedBy$
 * $LastChangedDate$
 *
 * Used on a report, this pulls total credits earned, total waiver amount and sped status
 * for kids at a school (high school only)
 */
DECLARE @Year UNIQUEIDENTIFIER = '26F066A3-ABFC-4EDB-B397-43412EDABC8B'
DECLARE @School VARCHAR(128) = 'BD274E29-030C-401A-B9EE-4B1DF8C4A559' --Valley
DECLARE @ClassOf VARCHAR(4) = '%'
DECLARE @Grade VARCHAR(4) = '%'
DECLARE @CourseHistoryType VARCHAR(4) = 'HIGH' -- HIGH or MID

SELECT
	Organization.ORGANIZATION_NAME
	,Student.SIS_NUMBER
	,Person.LAST_NAME
	,Person.FIRST_NAME
	,Person.MIDDLE_NAME
	,Student.CLASS_OF
	,GradeLevel.VALUE_DESCRIPTION AS GradeLevel
	,COALESCE(CourseHistoryGrouped.EarnedCredit,0) AS EarnedCredits
	,Waivers.TotalWaiver
	,CASE WHEN SPEDStudent.STUDENT_GU IS NOT NULL THEN 'Y' ELSE '' END AS SPED
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
		COURSE_HISTORY_TYPE = @CourseHistoryType
		AND REPEAT_TAG_GU IS NULL
	GROUP BY 
		STUDENT_GU
	) AS CourseHistoryGrouped
	ON
	SSY.STUDENT_GU = CourseHistoryGrouped.STUDENT_GU

	-- SPED STATUS
	LEFT JOIN
	REV.EP_STUDENT_SPECIAL_ED AS SPEDStudent
	ON
	SSY.STUDENT_GU = SPEDStudent.STUDENT_GU
	AND SPEDStudent.NEXT_IEP_DATE IS NOT NULL
	AND (
		SPEDStudent.EXIT_DATE IS NULL 
		OR SPEDStudent.EXIT_DATE >= CONVERT(DATE, GETDATE())
		)
	LEFT JOIN
	(
	SELECT
		STUDENT_GU
		,SUM(CREDITS_WAIVED) AS TotalWaiver
	FROM
		rev.EPC_STU_CRS_HIS_WAIVR_AREA AS Waivers
	GROUP BY
		STUDENT_GU
	) AS Waivers
	ON
	SSY.STUDENT_GU = Waivers.STUDENT_GU

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
	AND OrgYear.ORGANIZATION_GU LIKE @School
	AND SSY.STATUS IS NULL --Active SSY's Only--
	AND SSY.GRADE LIKE @Grade
	AND Student.CLASS_OF LIKE @ClassOf