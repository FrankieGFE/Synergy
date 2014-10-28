/**
 * $Revision$
 * $LastChangedBy$
 * $LastChangedDate$
 *
 * This query pulls participants of type offender (1) for the year
 * that are on a list in a file.  It includes incident information, as well as SOR information
 */

-- Add the next to lines to simulate running as a non-ad account
EXECUTE AS LOGIN='QueryFileUser'
GO


DECLARE @Year INT = 2014
DECLARE @YearExtension VARCHAR(1) = 'R'

DECLARE @YearGU UNIQUEIDENTIFIER
SELECT
	@YearGU = YEAR_GU
FROM
	rev.REV_YEAR
WHERE
	SCHOOL_YEAR= @Year
	AND EXTENSION = @YearExtension


SELECT
	Student.SIS_NUMBER
	,Person.LAST_NAME
	,Person.FIRST_NAME
	,Person.MIDDLE_NAME
	,KidSet.School AS SchoolInFile
	,SOROrganization.ORGANIZATION_NAME AS SchoolOfRecord
	,IncidentOrganization.ORGANIZATION_NAME AS IncidentSchool
	,Incident.INCIDENT_ID
	,Incident.INCIDENT_DATE
FROM
	rev.EPC_STU_INC_DISCIPLINE AS Participant
	INNER JOIN
	rev.EPC_SCH_INCIDENT AS Incident
	ON
	Participant.SCH_INCIDENT_GU = Incident.SCH_INCIDENT_GU

	INNER JOIN
	rev.REV_ORGANIZATION_YEAR AS OrgYear
	ON
	Incident.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

	INNER JOIN
	rev.REV_ORGANIZATION AS IncidentOrganization
	ON
	OrgYear.ORGANIZATION_GU = IncidentOrganization.ORGANIZATION_GU

	INNER JOIN
	rev.EPC_STU AS Student
	ON
	Participant.STUDENT_GU = Student.STUDENT_GU

	INNER JOIN
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
		'SELECT * from SummerProgramKids.txt'
	) AS KidSet
	ON
	Student.SIS_NUMBER = KidSet.[PermID]

	INNER JOIN
	rev.REV_PERSON AS Person
	ON
	Participant.STUDENT_GU = Person.PERSON_GU

	LEFT JOIN
	rev.EPC_STU_YR AS SOR
	ON
	Participant.STUDENT_GU = SOR.STUDENT_GU
	AND SOR.YEAR_GU = @YearGU

	LEFT JOIN
	rev.EPC_STU_SCH_YR AS SSY
	ON
	SOR.STU_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU

	LEFT JOIN
	rev.REV_ORGANIZATION_YEAR AS SOROrgYear
	ON
	SSY.ORGANIZATION_YEAR_GU = SOROrgYear.ORGANIZATION_YEAR_GU

	LEFT JOIN
	rev.REV_ORGANIZATION AS SOROrganization
	ON
	SOROrgYear.ORGANIZATION_GU = SOROrganization.ORGANIZATION_GU
WHERE
	-- Only where they are offender
	INCIDENT_ROLE = 1
	AND OrgYear.YEAR_GU = @YearGU -- only for given year

-- Always conclude your statement with these last two lines so it reverts back
-- to your user
REVERT
GO