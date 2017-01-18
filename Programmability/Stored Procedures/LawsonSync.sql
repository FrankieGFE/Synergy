/**
 * $Revision: 973 $
 * $LastChangedBy: e104090 $
 * $LastChangedDate: 2016-04-08 16:49:09 -0600 (Fri, 08 Apr 2016) $
 */
 

/*
	This process updates Synergy PERSON and STAFF tables with data from Lawson that are not updated with LDAP (ex. LAST NAME, FIRST NAME, EMAIL)
	AND Updates the User records for New Staff to Disabled, and Exempt until employees attend training.
	AND Creates records for the Staff Role Type.
	 - Active staff only (not DISABLED in USER table in Synergy)
	 - Uses Staff Crosswalk to determine TYPE
	 - This takes about 1 min 04 seconds to run
*/


USE ST_Production
GO


-- Remove Procedure if it exists
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[LawsonSync]') AND type in (N'P', N'PC'))
	EXEC ('CREATE PROCEDURE [APS].LawsonSync AS SELECT 0')
GO

/**
 * STORED PROC APS.LawsonSync
 * 
 */	
--Validation parameter must be passed, 1 to validate only, 0 to update
ALTER PROC [APS].[LawsonSync](
	@ValidateOnly INT
)

AS
BEGIN


BEGIN TRANSACTION


DECLARE @LAWSONGU VARCHAR (128) 

SELECT @LAWSONGU = USER_GU FROM rev.REV_USER WHERE LOGIN_NAME = 'APS.LAWSONSYNC'


UPDATE 
	PERSON
SET		
	GENDER = LAWSON.LAW_GENDER
	, BIRTH_DATE = LAWSON.LAW_BIRTHDATE
	, ETHNIC_CODE = LAWSON.LAW_ETHNIC_CODE
	, HISPANIC_INDICATOR = LAWSON.LAW_HISPANIC_INDICATOR
	--, PRIMARY_PHONE = LAWSON.LAW_PHONE
	, CHANGE_DATE_TIME_STAMP = GETDATE()
	--APS.LAWSONSYNC USER GU
	, CHANGE_ID_STAMP = @LAWSONGU
	,LAST_NAME = APS.FormatTitleCase(LAWSON.LAW_LAST_NAME)
FROM
	--ONLY UPDATE STAFF AND PERSON RECORDS THAT ARE NOT DISABLED IN SYNERGY (ACTIVE STAFF ONLY)
	rev.EPC_STAFF AS STAFF
	
	INNER JOIN
	rev.REV_PERSON AS PERSON
	ON 
	STAFF_GU = PERSON_GU
	
	INNER JOIN
	[180-SMAXODS-01.APS.EDU.ACTD].Lawson.APS.SynergyExtraStaffInfo AS LAWSON

	ON
	STAFF.BADGE_NUM = LAWSON.LAW_BADGE_NUMBER

WHERE
	GENDER != LAWSON.LAW_GENDER
	OR BIRTH_DATE != LAWSON.LAW_BIRTHDATE
	OR ETHNIC_CODE != LAWSON.LAW_ETHNIC_CODE
	OR HISPANIC_INDICATOR != LAWSON.LAW_HISPANIC_INDICATOR
	--OR PRIMARY_PHONE != LAWSON.LAW_PHONE
	OR LAST_NAME != LAWSON.LAW_LAST_NAME

	
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
	, ADD_DATE_TIME_STAMP = GETDATE()
	-- APS.LAWSONSYNC ON LIVE HAS THIS GU 
	, CHANGE_ID_STAMP = @LAWSONGU
	, ADD_ID_STAMP = @LAWSONGU


	FROM
		--ONLY UPDATE STAFF AND PERSON RECORDS THAT ARE NOT DISABLED IN SYNERGY (ACTIVE STAFF ONLY)
		rev.EPC_STAFF AS STAFF
		INNER JOIN
		[180-SMAXODS-01.APS.EDU.ACTD].Lawson.APS.SynergyExtraStaffInfo AS LAWSON
		ON
		STAFF.BADGE_NUM = LAWSON.LAW_BADGE_NUMBER

WHERE
	STATE_ID = LAW_EMPLOYEE
	OR BADGE_NUM = LAW_BADGE_NUMBER
	OR HIRE_DATE = LAW_HIRE_DATE
	OR TYPE = LAW_TYPE

----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

--- SET ALL NEW USERS FROM LDAP TO EXEMPT AND DISABLED, JUDE WILL GIVE ACCESS FOR TRAINING

UPDATE 
	USERS
SET
	SHOW_QUICK_LAUNCH = 'Y'
	,EXEMPT_FROM_LDAP = 'Y'
	,[DISABLED] = 'Y'
	,CHANGE_DATE_TIME_STAMP = GETDATE()
	,ADD_DATE_TIME_STAMP = GETDATE()
	-- APS.LAWSONSYNC ON LIVE HAS THIS GU 
	,CHANGE_ID_STAMP = @LAWSONGU
	,ADD_ID_STAMP = @LAWSONGU
FROM
	rev.REV_USER AS USERS

WHERE
	--THIS ONLY PROCESS RECORDS CREATED BY LDAP
	ADD_DATE_TIME_STAMP IS NULL
	AND LOGIN_NAME != 'Admin'
		
	
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

--THERE ARE 5 INSERTS ONE FOR EACH STAFF ROLE TYPE

--AUDIOLOGY
INSERT INTO rev.EPC_STAFF_ROLE (STAFF_ROLE_GU, STAFF_GU, ROLE_TYPE, ADD_DATE_TIME_STAMP, ADD_ID_STAMP)

SELECT 
	NEWID() AS STAFF_ROLE_GU
	,GETONE.STAFF_GU  AS STAFF_GU
	,GETONE.AUDIOLOGY AS ROLE_TYPE
	,GETDATE() AS ADD_DATE_TIME_STAMP
	-- APS.LAWSONSYNC ON LIVE HAS THIS GU 
	,@LAWSONGU AS ADD_ID_STAMP
FROM
			(
			SELECT DISTINCT 
					STAFF.STAFF_GU
					, LAWSON.AUDIOLOGY
			FROM
				rev.EPC_STAFF AS STAFF
				INNER JOIN
				[180-SMAXODS-01.APS.EDU.ACTD].Lawson.APS.SynergyExtraStaffInfo AS LAWSON
				ON
				STAFF.BADGE_NUM = LAWSON.LAW_BADGE_NUMBER	
				AND LAWSON.AUDIOLOGY = 'A'
				LEFT JOIN
				rev.EPC_STAFF_ROLE AS ROLES
				ON
				STAFF.STAFF_GU = ROLES.STAFF_GU
				AND ROLES.ROLE_TYPE = 'A'
				 AND ROLES.ROLE_TYPE = LAWSON.AUDIOLOGY
		WHERE
			ROLES.STAFF_GU IS NULL
				) AS GETONE
-------------------------------------------------------------------------------------------------	

--CONFERENCE
INSERT INTO rev.EPC_STAFF_ROLE (STAFF_ROLE_GU, STAFF_GU, ROLE_TYPE, ADD_DATE_TIME_STAMP, ADD_ID_STAMP)

SELECT 
	NEWID() AS STAFF_ROLE_GU
	,GETTWO.STAFF_GU  AS STAFF_GU
	,GETTWO.CONFERENCE AS ROLE_TYPE
	,GETDATE() AS ADD_DATE_TIME_STAMP
	-- APS.LAWSONSYNC ON LIVE HAS THIS GU 
	,@LAWSONGU AS ADD_ID_STAMP

FROM
	(
	SELECT DISTINCT 
					STAFF.STAFF_GU
					, LAWSON.CONFERENCE
			FROM
				rev.EPC_STAFF AS STAFF
				INNER JOIN
				[180-SMAXODS-01.APS.EDU.ACTD].Lawson.APS.SynergyExtraStaffInfo AS LAWSON
				ON
				STAFF.BADGE_NUM = LAWSON.LAW_BADGE_NUMBER	
				AND LAWSON.CONFERENCE = 'C'
				LEFT JOIN
				rev.EPC_STAFF_ROLE AS ROLES
				ON
				STAFF.STAFF_GU = ROLES.STAFF_GU
				AND ROLES.ROLE_TYPE = 'C'
				 AND ROLES.ROLE_TYPE = LAWSON.CONFERENCE
		WHERE
			ROLES.STAFF_GU IS NULL
		) AS GETTWO
-------------------------------------------------------------------------------------------------	

--DISCIPLINE
INSERT INTO rev.EPC_STAFF_ROLE (STAFF_ROLE_GU, STAFF_GU, ROLE_TYPE, ADD_DATE_TIME_STAMP, ADD_ID_STAMP)

SELECT 
	NEWID() AS STAFF_ROLE_GU
	,GETTHREE.STAFF_GU  AS STAFF_GU
	,GETTHREE.DISCIPLINE AS ROLE_TYPE
	,GETDATE() AS ADD_DATE_TIME_STAMP
	-- APS.LAWSONSYNC ON LIVE HAS THIS GU 
	,@LAWSONGU AS ADD_ID_STAMP

FROM
	(
	SELECT DISTINCT 
					STAFF.STAFF_GU
					, LAWSON.DISCIPLINE
			FROM
				rev.EPC_STAFF AS STAFF
				INNER JOIN
				[180-SMAXODS-01.APS.EDU.ACTD].Lawson.APS.SynergyExtraStaffInfo AS LAWSON
				ON
				STAFF.BADGE_NUM = LAWSON.LAW_BADGE_NUMBER	
				AND LAWSON.DISCIPLINE = 'D'
				LEFT JOIN
				rev.EPC_STAFF_ROLE AS ROLES
				ON
				STAFF.STAFF_GU = ROLES.STAFF_GU
				AND ROLES.ROLE_TYPE = 'D'
				 AND ROLES.ROLE_TYPE = LAWSON.DISCIPLINE
		WHERE
			ROLES.STAFF_GU IS NULL
		) AS GETTHREE
-----------------------------------------------------------------------------------------------------------

--HEALTH
INSERT INTO rev.EPC_STAFF_ROLE (STAFF_ROLE_GU, STAFF_GU, ROLE_TYPE, ADD_DATE_TIME_STAMP, ADD_ID_STAMP)

SELECT 
	NEWID() AS STAFF_ROLE_GU
	,GETFOUR.STAFF_GU  AS STAFF_GU
	,GETFOUR.HEALTH AS ROLE_TYPE
	,GETDATE() AS ADD_DATE_TIME_STAMP
	-- APS.LAWSONSYNC ON LIVE HAS THIS GU 
	,@LAWSONGU AS ADD_ID_STAMP

FROM
	(
	SELECT DISTINCT 
					STAFF.STAFF_GU
					, LAWSON.HEALTH
			FROM
				rev.EPC_STAFF AS STAFF
				INNER JOIN
				[180-SMAXODS-01.APS.EDU.ACTD].Lawson.APS.SynergyExtraStaffInfo AS LAWSON
				ON
				STAFF.BADGE_NUM = LAWSON.LAW_BADGE_NUMBER	
				AND LAWSON.HEALTH = 'H'
				LEFT JOIN
				rev.EPC_STAFF_ROLE AS ROLES
				ON
				STAFF.STAFF_GU = ROLES.STAFF_GU
				AND ROLES.ROLE_TYPE = 'H'
				 AND ROLES.ROLE_TYPE = LAWSON.HEALTH
		WHERE
			ROLES.STAFF_GU IS NULL
		) AS GETFOUR
	
--------------------------------------------------------------------------------------------------------------

--RATER
INSERT INTO rev.EPC_STAFF_ROLE (STAFF_ROLE_GU, STAFF_GU, ROLE_TYPE, ADD_DATE_TIME_STAMP, ADD_ID_STAMP)

SELECT 
	NEWID() AS STAFF_ROLE_GU
	,GETFIVE.STAFF_GU  AS STAFF_GU
	,GETFIVE.RATER AS ROLE_TYPE
	,GETDATE() AS ADD_DATE_TIME_STAMP
	-- APS.LAWSONSYNC ON LIVE HAS THIS GU 
	,@LAWSONGU AS ADD_ID_STAMP

FROM
	(
	SELECT DISTINCT 
					STAFF.STAFF_GU
					, LAWSON.RATER
			FROM
				rev.EPC_STAFF AS STAFF
				INNER JOIN
				[180-SMAXODS-01.APS.EDU.ACTD].Lawson.APS.SynergyExtraStaffInfo AS LAWSON
				ON
				STAFF.BADGE_NUM = LAWSON.LAW_BADGE_NUMBER	
				AND LAWSON.RATER = 'R'
				LEFT JOIN
				rev.EPC_STAFF_ROLE AS ROLES
				ON
				STAFF.STAFF_GU = ROLES.STAFF_GU
				AND ROLES.ROLE_TYPE = 'R'
				 AND ROLES.ROLE_TYPE = LAWSON.RATER
		WHERE
			ROLES.STAFF_GU IS NULL
	) AS GETFIVE
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------	
--THIS IS NEEDED TO WIPE OUT THE TELEPHONE NUMBER THAT IS BROUGHT IN WITH LDAP NIGHTLY


UPDATE rev.REV_PERSON
	SET
	PRIMARY_PHONE = NULL
	,PRIMARY_PHONE_EXTN = NULL
	,PRIMARY_PHONE_TYPE = NULL
	,PRIMARY_PHONE_LISTED = 'N'
	,PRIMARY_PHONE_CONTACT = 'N'

/*
SELECT 

	PRIMARY_PHONE 
	,PRIMARY_PHONE_EXTN 
	,PRIMARY_PHONE_TYPE 
	,PRIMARY_PHONE_LISTED 
	,PRIMARY_PHONE_CONTACT 
*/

FROM
	rev.EPC_STAFF AS STAFF
	INNER JOIN
	rev.REV_PERSON AS PERSON
	ON 
	STAFF_GU = PERSON_GU
	
	WHERE PRIMARY_PHONE IS NOT NULL


DELETE
	Phone
FROM
	rev.REV_PERSON_PHONE AS Phone
	INNER JOIN
	rev.EPC_STAFF AS Staff
	ON
	Phone.PERSON_GU = Staff.STAFF_GU


---------------------------------------------------------------------------------------------------------------------------------------
UPDATE 
	PERSON
SET		
	CHANGE_DATE_TIME_STAMP = GETDATE()
	,CHANGE_ID_STAMP = @LAWSONGU
	,LAST_NAME = APS.FormatTitleCase(LAST_NAME)
	,FIRST_NAME = APS.FormatTitleCase(FIRST_NAME)
	,MIDDLE_NAME = APS.FormatTitleCase(MIDDLE_NAME)

FROM
	rev.REV_PERSON AS PERSON


----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------	

--Validation Check to see how many records will be processed, 0 = INSERT AND UPDATE, 1 = ROLLBACK - WILL NOT - UPDATE/INSERT
IF @ValidateOnly = 0
	BEGIN
		COMMIT 
	END
ELSE
	BEGIN
		ROLLBACK
	END
	

END -- END SPROC

GO