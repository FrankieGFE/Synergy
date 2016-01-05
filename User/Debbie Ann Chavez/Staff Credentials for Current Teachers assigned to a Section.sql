
	
	SELECT
	STAFF.BADGE_NUM
	, person.LAST_NAME + ', ' + FIRST_NAME + ' ' + ISNULL(MIDDLE_NAME,'') AS STAFF_NAME
	,StaffCredentials.DOCUMENT_NUMBER
	,StaffCredentials.DATE_EARNED
	,StaffCredentials.CREDENTIAL_TYPE + ' ' + CredType.VALUE_DESCRIPTION As CredType
	,StaffCredentials.AUTHORIZED_TCH_AREA + ' ' +  TeachingArea.VALUE_DESCRIPTION AS TeachingArea
FROM
	rev.EPC_STAFF_CRD AS StaffCredentials
	INNER JOIN
	rev.EPC_STAFF AS Staff
	ON
	StaffCredentials.STAFF_GU = Staff.STAFF_GU
	INNER JOIN 
	rev.REV_PERSON AS Person
	ON
	StaffCredentials.STAFF_GU = Person.PERSON_GU

	INNER JOIN
	(SELECT DISTINCT STAFF_GU FROM 
APS.SectionsAndAllStaffAssignedAsOf(GETDATE()) AS SECTIONS
) AS UNIQUETEACHERS
	ON
	UNIQUETEACHERS.STAFF_GU = STAFF.STAFF_GU 

	LEFT JOIN
	APS.LookupTable('k12.Staff','cred_type') AS CredType
	ON
	StaffCredentials.CREDENTIAL_TYPE = CredType.VALUE_CODE

	LEFT JOIN
	APS.LookupTable('k12.Staff','aut_teaching_area') AS TeachingArea
	ON
	StaffCredentials.AUTHORIZED_TCH_AREA = TeachingArea.VALUE_CODE

	ORDER BY BADGE_NUM