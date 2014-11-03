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

-- Wiping staff information
UPDATE
	Staff
SET
	DEFAULT_JOB_CLASS = NULL
	,HIRE_DATE = NULL
	,EXIT_CODE = NULL
	,EXIT_DATE = NULL
	,FTE = NULL -- unusre if this affects anything
	--,DISTRICT_PERSONNEL = 'N'  -- Probably don't want to do this one
	,ABBREV_NAME = NULL
	,YEARS_IN_DIST = NULL
	,YEARS_OF_ED_SRVC = NULL
	--,EXCLUDE_FROM_STATE_RPT = 'N' -- This one is also suspect
	--,EXCLUDE_PARENTVUE = 'N' -- As is this one
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
	,MAIL_ADDRESS_GU = NULL -- This delinks adresses from the staff member.  It does not remove the adress, as it may be used by other persons.
	,HOME_ADDRESS_GU = NULL -- This delinks adresses from the staff member.  It does not remove the adress, as it may be used by other persons.

	-- This phone stuff may "come back" based on the LDAP sync, but we can do an initial wipe... I guess
	,PRIMARY_PHONE = NULL
	,PRIMARY_PHONE_EXTN = NULL
	,PRIMARY_PHONE_TYPE = NULL
	,PRIMARY_PHONE_LISTED = 'N'
	,PRIMARY_PHONE_CONTACT = 'N'

FROM
	rev.EPC_STAFF AS Staff
	INNER JOIN
	rev.REV_PERSON AS Person
	ON
	Staff.STAFF_GU = Person.PERSON_GU


-- Removing race flags
DELETE
	Race
FROM
	rev.EPC_STAFF AS Staff
	INNER JOIN
	rev.REV_PERSON_SECONDRY_ETH_LST AS Race
	ON
	Staff.STAFF_GU = Race.PERSON_GU

--removing employement history.
DELETE FROM
	rev.EPC_STAFF_EMP_HIS


--removing phone numbers (even thosugh many may "come back")
DELETE
	Phone
FROM
	rev.REV_PERSON_PHONE AS Phone
	INNER JOIN
	rev.EPC_STAFF AS Staff
	ON
	Phone.PERSON_GU = Staff.STAFF_GU

ROLLBACK