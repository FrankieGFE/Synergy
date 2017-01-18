/* $Revision: 200 $
 * $LastChangedBy: e201594 $
 * $LastChangedDate: 2014-10-03 12:55:48 -0600 (Fri, 03 Oct 2014) $
 *
 * List of PHLOTE kids who need testing 
 * **NOTE** This looks at SchoolMax for testing data
 */

SELECT
	Organization.ORGANIZATION_NAME AS SchoolName
	,GradeLevel.VALUE_DESCRIPTION AS GradeLevel
	,Student.SIS_NUMBER
	,Person.LAST_NAME AS LastName
	,Person.FIRST_NAME AS FirstName
	,HomeLanguage.VALUE_DESCRIPTION AS HomeLanguage
FROM
	APS.PrimaryEnrollmentsAsOf(GETDATE()) AS Enroll
	INNER JOIN
	rev.EPC_STU AS Student
	ON 
	Enroll.STUDENT_GU = Student.STUDENT_GU

	LEFT JOIN
	OPENQUERY([SMAXDBPROD.APS.EDU.ACTD],'SELECT CAST(ID_NBR AS VARCHAR) AS ID_NBR FROM PR.APS.LCELatestEvaluationAsOf (GETDATE()) WHERE DST_NBR = 1') AS MostRecentTest
	ON
	Student.SIS_NUMBER = MostRecentTest.ID_NBR COLLATE DATABASE_DEFAULT

	LEFT JOIN
	OPENQUERY([SMAXDBPROD.APS.EDU.ACTD],'SELECT CAST(ID_NBR AS VARCHAR) AS ID_NBR, DECLND FROM PR.APS.LCEMostRecentTestDeclineAsOf (GETDATE()) WHERE DST_NBR = 1') AS Refusals
	ON Student.SIS_NUMBER = Refusals.ID_NBR COLLATE DATABASE_DEFAULT

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
	AND COALESCE(Refusals.DECLND,'N') != 'Y' -- No Declines
	AND MostRecentTest.ID_NBR IS NULL -- No Tests
	AND GradeLevel.VALUE_DESCRIPTION NOT IN ('P1', 'P2', 'PK')
ORDER BY
	Organization.ORGANIZATION_NAME
	,GradeLevel.LIST_ORDER