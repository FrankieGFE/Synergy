/**
 * $Revision: 1 $
 * $LastChangedBy: e104090 $
 * $LastChangedDate: 2014-04-23 $
 */
 

/*
	This process updates Synergy PERSON and STAFF tables with data from Lawson that are not updated with LDAP (ex. LAST NAME, FIRST NAME, EMAIL). 
	 - Active staff only (not DISABLED in USER table in Synergy)
	 - Uses Staff Crosswalk to determine TYPE
	 - This takes about 1 min 04 seconds to run
*/


USE ST_Stars
GO


BEGIN TRANSACTION

UPDATE 
	PERSON
SET		
	GENDER = LAWSON.LAW_GENDER
	, BIRTH_DATE = LAWSON.LAW_BIRTHDATE
	, ETHNIC_CODE = LAWSON.LAW_ETHNIC_CODE
	, HISPANIC_INDICATOR = LAWSON.LAW_HISPANIC_INDICATOR
	, PRIMARY_PHONE = LAWSON.LAW_PHONE
	, CHANGE_DATE_TIME_STAMP = GETDATE()
	, CHANGE_ID_STAMP = '27CDCD0E-BF93-4071-94B2-5DB792BB735F'

FROM
	--ONLY UPDATE STAFF AND PERSON RECORDS THAT ARE NOT DISABLED IN SYNERGY (ACTIVE STAFF ONLY)
	rev.EPC_STAFF AS STAFF
	INNER JOIN
	rev.REV_USER AS USERS
	ON 
	USERS.USER_GU = STAFF.STAFF_GU
	INNER JOIN
	rev.REV_PERSON AS PERSON
	ON 
	STAFF_GU = PERSON_GU
	
	INNER JOIN
	[180-SMAXODS-01.APS.EDU.ACTD].Lawson.APS.SynergyExtraStaffInfo AS LAWSON

	ON
	STAFF.BADGE_NUM = LAWSON.LAW_BADGE_NUMBER

WHERE
	DISABLED = 'N'
	AND EXEMPT_FROM_LDAP = 'N'

	
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

UPDATE 
	STAFF
SET		
	STATE_ID = LAW_EMPLOYEE
	, BADGE_NUM = LAW_BADGE_NUMBER
	, HIRE_DATE = LAW_HIRE_DATE
	, TYPE = LAW_TYPE
	, CHANGE_DATE_TIME_STAMP = GETDATE()
	, CHANGE_ID_STAMP = '27CDCD0E-BF93-4071-94B2-5DB792BB735F'


	FROM
		--ONLY UPDATE STAFF AND PERSON RECORDS THAT ARE NOT DISABLED IN SYNERGY (ACTIVE STAFF ONLY)
		rev.EPC_STAFF AS STAFF
		INNER JOIN
		rev.REV_USER AS USERS
		ON 
		USERS.USER_GU = STAFF.STAFF_GU
	
		INNER JOIN
		[180-SMAXODS-01.APS.EDU.ACTD].Lawson.APS.SynergyExtraStaffInfo AS LAWSON
		ON
		STAFF.BADGE_NUM = LAWSON.LAW_BADGE_NUMBER

WHERE
	DISABLED = 'N'
	AND EXEMPT_FROM_LDAP = 'N'

COMMIT