/**
 * $Revision: 1 $
 * $LastChangedBy: e104090 $
 * $LastChangedDate: 2014-04-23 $
 */
 

/*
	This process updates Synergy PERSON and STAFF tables with data from Lawson that are not updated with LDAP (ex. LAST NAME, FIRST NAME, EMAIL)
	AND Updates the User records for New Staff to Disabled, and Exempt until employees attend training.
	AND Creates records for the Staff Role Type.
	 - Active staff only (not DISABLED in USER table in Synergy)
	 - Uses Staff Crosswalk to determine TYPE
	 - This takes about 1 min 04 seconds to run
*/


USE ST_Stars
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


UPDATE 
	PERSON
SET		
	GENDER = LAWSON.LAW_GENDER
	, BIRTH_DATE = LAWSON.LAW_BIRTHDATE
	, ETHNIC_CODE = LAWSON.LAW_ETHNIC_CODE
	, HISPANIC_INDICATOR = LAWSON.LAW_HISPANIC_INDICATOR
	, PRIMARY_PHONE = LAWSON.LAW_PHONE
	, CHANGE_DATE_TIME_STAMP = GETDATE()
	--APS.LAWSONSYNC USER GU
	, CHANGE_ID_STAMP = '030A3C96-5DE3-4CA3-A8E6-3CFC451798EA'
	
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
	OR PRIMARY_PHONE != LAWSON.LAW_PHONE

	
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
	, CHANGE_ID_STAMP = '030A3C96-5DE3-4CA3-A8E6-3CFC451798EA'
	, ADD_ID_STAMP = '030A3C96-5DE3-4CA3-A8E6-3CFC451798EA'


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
	,CHANGE_ID_STAMP = '030A3C96-5DE3-4CA3-A8E6-3CFC451798EA'
	,ADD_ID_STAMP = '030A3C96-5DE3-4CA3-A8E6-3CFC451798EA'
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
	,STAFF.STAFF_GU  AS STAFF_GU
	,LAWSON.AUDIOLOGY AS ROLE_TYPE
	,GETDATE() AS ADD_DATE_TIME_STAMP
	-- APS.LAWSONSYNC ON LIVE HAS THIS GU 
	,'030A3C96-5DE3-4CA3-A8E6-3CFC451798EA' AS ADD_ID_STAMP

FROM
	rev.EPC_STAFF AS STAFF
	LEFT JOIN
	rev.EPC_STAFF_ROLE AS ROLES
	ON
	STAFF.STAFF_GU = ROLES.STAFF_GU
	INNER JOIN
	[180-SMAXODS-01.APS.EDU.ACTD].Lawson.APS.SynergyExtraStaffInfo AS LAWSON
	ON
	STAFF.BADGE_NUM = LAWSON.LAW_BADGE_NUMBER	
	AND LAWSON.AUDIOLOGY = 'A'
WHERE
	ROLES.STAFF_GU IS NULL
-------------------------------------------------------------------------------------------------	

--CONFERENCE
INSERT INTO rev.EPC_STAFF_ROLE (STAFF_ROLE_GU, STAFF_GU, ROLE_TYPE, ADD_DATE_TIME_STAMP, ADD_ID_STAMP)

SELECT 
	NEWID() AS STAFF_ROLE_GU
	,STAFF.STAFF_GU  AS STAFF_GU
	,LAWSON.CONFERENCE AS ROLE_TYPE
	,GETDATE() AS ADD_DATE_TIME_STAMP
	-- APS.LAWSONSYNC ON LIVE HAS THIS GU 
	,'030A3C96-5DE3-4CA3-A8E6-3CFC451798EA' AS ADD_ID_STAMP

FROM
	rev.EPC_STAFF AS STAFF
	LEFT JOIN
	rev.EPC_STAFF_ROLE AS ROLES
	ON
	STAFF.STAFF_GU = ROLES.STAFF_GU
	INNER JOIN
	[180-SMAXODS-01.APS.EDU.ACTD].Lawson.APS.SynergyExtraStaffInfo AS LAWSON
	ON
	STAFF.BADGE_NUM = LAWSON.LAW_BADGE_NUMBER	
	AND LAWSON.CONFERENCE = 'C'
WHERE
	ROLES.STAFF_GU IS NULL
-------------------------------------------------------------------------------------------------	

--DISCIPLINE
INSERT INTO rev.EPC_STAFF_ROLE (STAFF_ROLE_GU, STAFF_GU, ROLE_TYPE, ADD_DATE_TIME_STAMP, ADD_ID_STAMP)

SELECT 
	NEWID() AS STAFF_ROLE_GU
	,STAFF.STAFF_GU  AS STAFF_GU
	,LAWSON.DISCIPLINE AS ROLE_TYPE
	,GETDATE() AS ADD_DATE_TIME_STAMP
	-- APS.LAWSONSYNC ON LIVE HAS THIS GU 
	,'030A3C96-5DE3-4CA3-A8E6-3CFC451798EA' AS ADD_ID_STAMP

FROM
	rev.EPC_STAFF AS STAFF
	LEFT JOIN
	rev.EPC_STAFF_ROLE AS ROLES
	ON
	STAFF.STAFF_GU = ROLES.STAFF_GU
	INNER JOIN
	[180-SMAXODS-01.APS.EDU.ACTD].Lawson.APS.SynergyExtraStaffInfo AS LAWSON
	ON
	STAFF.BADGE_NUM = LAWSON.LAW_BADGE_NUMBER	
	AND LAWSON.DISCIPLINE = 'D'
WHERE
	ROLES.STAFF_GU IS NULL	
-----------------------------------------------------------------------------------------------------------

--HEALTH
INSERT INTO rev.EPC_STAFF_ROLE (STAFF_ROLE_GU, STAFF_GU, ROLE_TYPE, ADD_DATE_TIME_STAMP, ADD_ID_STAMP)

SELECT 
	NEWID() AS STAFF_ROLE_GU
	,STAFF.STAFF_GU  AS STAFF_GU
	,LAWSON.HEALTH AS ROLE_TYPE
	,GETDATE() AS ADD_DATE_TIME_STAMP
	-- APS.LAWSONSYNC ON LIVE HAS THIS GU 
	,'030A3C96-5DE3-4CA3-A8E6-3CFC451798EA' AS ADD_ID_STAMP

FROM
	rev.EPC_STAFF AS STAFF
	LEFT JOIN
	rev.EPC_STAFF_ROLE AS ROLES
	ON
	STAFF.STAFF_GU = ROLES.STAFF_GU
	INNER JOIN
	[180-SMAXODS-01.APS.EDU.ACTD].Lawson.APS.SynergyExtraStaffInfo AS LAWSON
	ON
	STAFF.BADGE_NUM = LAWSON.LAW_BADGE_NUMBER	
	AND LAWSON.HEALTH = 'H'
WHERE
	ROLES.STAFF_GU IS NULL
	
--------------------------------------------------------------------------------------------------------------

--RATER
INSERT INTO rev.EPC_STAFF_ROLE (STAFF_ROLE_GU, STAFF_GU, ROLE_TYPE, ADD_DATE_TIME_STAMP, ADD_ID_STAMP)

SELECT 
	NEWID() AS STAFF_ROLE_GU
	,STAFF.STAFF_GU  AS STAFF_GU
	,LAWSON.RATER AS ROLE_TYPE
	,GETDATE() AS ADD_DATE_TIME_STAMP
	-- APS.LAWSONSYNC ON LIVE HAS THIS GU 
	,'030A3C96-5DE3-4CA3-A8E6-3CFC451798EA'AS ADD_ID_STAMP

FROM
	rev.EPC_STAFF AS STAFF
	LEFT JOIN
	rev.EPC_STAFF_ROLE AS ROLES
	ON
	STAFF.STAFF_GU = ROLES.STAFF_GU
	INNER JOIN
	[180-SMAXODS-01.APS.EDU.ACTD].Lawson.APS.SynergyExtraStaffInfo AS LAWSON
	ON
	STAFF.BADGE_NUM = LAWSON.LAW_BADGE_NUMBER	
	AND LAWSON.RATER = 'R'
WHERE
	ROLES.STAFF_GU IS NULL	
	
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