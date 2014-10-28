/**
 * $Revision$
 * $LastChangedBy$
 * $LastChangedDate$
 *
 * A series of update and delete statement wiping data from staff.
 * For the record, I believe the idea of "wipe everything EXCEPT x"
 * is a very very bad idea.  It would have been better to identify
 * what you want to wipe instead of what you want to keep.
 *
 * Furthermore, Even though I sent off a list of what would be wiped
 * and we are first going to load this on a non-live environment,
 * I believe little screening/testing will be done to confirm that
 * what this does not cause harm to the system.
 *
 * This only wipes "easy" information, and does not addresses or phone numbers.
 */
BEGIN TRANSACTION

UPDATE
	Staff
SET
	DEFAULT_JOB_CLASS = NULL
	,HIRE_DATE = NULL
	,EXIT_CODE = NULL
	,EXIT_DATE = NULL
	,FTE = NULL
	,DISTRICT_PERSONNEL = 'N'
	,ABBREV_NAME = NULL
	,YEARS_IN_DIST = NULL
	,YEARS_OF_ED_SRVC = NULL
	,EXCLUDE_FROM_STATE_RPT = 'N'
	,EXCLUDE_PARENTVUE = 'N'
FROM
	rev.EPC_STAFF AS Staff
	INNER JOIN
	rev.REV_PERSON AS Person
	ON
	Staff.STAFF_GU = Person.PERSON_GU

UPDATE
	Person
SET
	SOCIAL_SECURITY_NUMBER = NULL
	,BIRTH_DATE = NULL
	,ETHNIC_CODE = NULL
	,US_CITIZEN = 'Y'
	,JOB_TITLE = NULL
	,AKA_LAST_NAME = NULL
	,AKA_FIRST_NAME = NULL
	,AKA_MIDDLE_NAME = NULL
	,AKA_SUFFIX = NULL
	,HISPANIC_INDICATOR	= NULL
	,RESOLVED_ETHNICITY_RACE	= NULL	--(Will also require removing RACE indicators from person-to-race many-to-many table
FROM
	rev.EPC_STAFF AS Staff
	INNER JOIN
	rev.REV_PERSON AS Person
	ON
	Staff.STAFF_GU = Person.PERSON_GU

DELETE
	Race
FROM
	rev.EPC_STAFF AS Staff
	INNER JOIN
	rev.REV_PERSON_SECONDRY_ETH_LST AS Race
	ON
	Staff.STAFF_GU = Race.PERSON_GU

ROLLBACK