/**
 * $Revision: 1 $
 * $LastChangedBy: e104090 $
 * $LastChangedDate: 2015-05-07$
 */
 
-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[LCEStudentsNeedingTestingAsOf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.LCEStudentsNeedingTestingAsOf() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO


ALTER FUNCTION APS.LCEStudentsNeedingTestingAsOf(@AsOfDate DATE)
RETURNS TABLE
AS
RETURN	

SELECT
	Organization.ORGANIZATION_NAME AS SchoolName
	,GradeLevel.VALUE_DESCRIPTION AS Grade
	,Student.SIS_NUMBER AS [StudentNumber]
	,Person.LAST_NAME + ', ' + Person.FIRST_NAME AS Name
	,HomeLanguage.VALUE_DESCRIPTION AS HomeLanguage
	,Student.STUDENT_GU
FROM
	APS.PrimaryEnrollmentsAsOf(@AsOfDate) AS Enroll
	INNER JOIN
	rev.EPC_STU AS Student
	ON 
	Enroll.STUDENT_GU = Student.STUDENT_GU

	LEFT JOIN
	APS.LCELatestEvaluationAsOf(@AsOfDate) AS MostRecentTest
	ON
	Enroll.STUDENT_GU = MostRecentTest.STUDENT_GU

	LEFT JOIN
	APS.LCEMostRecentTestWaiverAsOf(@AsOfDate) As Waivers
	ON Enroll.STUDENT_GU = Waivers.STUDENT_GU

	-- the rest of the joins is to accomidate the formatted columns
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

	INNER JOIN
	APS.LookupTable('K12','GRADE') AS GradeLevel
	ON
	Enroll.GRADE = GradeLevel.VALUE_CODE

	INNER JOIN
	APS.LookupTable('K12','Language') AS HomeLanguage
	ON
	Student.HOME_LANGUAGE = HomeLanguage.VALUE_CODE
WHERE
	Student.HOME_LANGUAGE NOT IN ('00','54')
	AND MostRecentTest.STUDENT_GU IS NULL -- No Tests
	AND GradeLevel.VALUE_DESCRIPTION NOT IN ('P1', 'P2', 'PK', 'T1', 'T2', 'T3', 'T4', 'C1', 'C2', 'C3', 'C4')

