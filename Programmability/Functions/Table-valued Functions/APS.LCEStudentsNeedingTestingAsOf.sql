/**
 * $Revision: 2 $
 * $LastChangedBy: Gary Corbaley $
 * $LastChangedDate: 04/18/2016$
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
	,Student.HOME_LANGUAGE
	,Organization.ORGANIZATION_GU
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

	LEFT JOIN
(SELECT * FROM 
(
SELECT 
STUDENT_GU
,(Q1 + Q2 + Q3 + Q4 + Q5) AS TOTALS

FROM

(
SELECT
	ALLHistory.STUDENT_GU
	,CASE WHEN Q1_LANGUAGE_SPOKEN_MOST IN ('00','054') THEN 0 ELSE 1 END AS Q1
	,CASE WHEN Q2_CHILD_FIRST_LANGUAGE IN ('00','054')  THEN 0 ELSE 1 END AS Q2
	,CASE WHEN Q3_LANGUAGES_SPOKEN IN ('00','054')  THEN 0 ELSE 1 END AS Q3
	,CASE WHEN Q4_OTHER_LANG_UNDERSTOOD IN ('00','054')  THEN 0 ELSE 1 END AS Q4
	,CASE WHEN Q5_OTHER_LANG_COMMUNICATED IN ('00','054')  THEN 0 ELSE 1 END AS Q5
FROM
	(
	SELECT
		HISTORY.*
		,ROW_NUMBER() OVER (PARTITION BY History.STUDENT_GU ORDER BY DATE_ASSIGNED DESC) AS RN
	FROM
		rev.UD_HLS_HISTORY AS History
		INNER JOIN
		APS.PrimaryEnrollmentsAsOf(@AsOfDate) AS Enroll
		ON 
		History.STUDENT_GU = Enroll.STUDENT_GU
	WHERE
		History.DATE_ASSIGNED <= @AsOfDate
	) AS ALLHistory
WHERE 
	RN=1
	) AS FILTER
) AS CALCULATEME
WHERE
	TOTALS > 0

	) AS HLSOTHERENGLISH

	ON
	HLSOTHERENGLISH.STUDENT_GU = Enroll.STUDENT_GU


WHERE
	HLSOTHERENGLISH.STUDENT_GU IS NOT NULL 
	--Student.HOME_LANGUAGE NOT IN ('00','54')
	AND MostRecentTest.STUDENT_GU IS NULL -- No Tests
	AND GradeLevel.VALUE_DESCRIPTION NOT IN ('P1', 'P2', 'PK', 'T1', 'T2', 'T3', 'T4', 'C1', 'C2', 'C3', 'C4')

