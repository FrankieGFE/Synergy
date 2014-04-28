/**
 * $Revision: 1 $
 * $LastChangedBy: e104090 $
 * $LastChangedDate: 2014-04-23 $
 */
 

/*
	This process updates Synergy PERSON and STAFF tables with data from Lawson that are not updated with LDAP (ex. LAST NAME, FIRST NAME, EMAIL). 
	 - Active staff only (not DISABLED in USER table in Synergy)
	 - Uses Staff Crosswalk to determine TYPE

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
	
	INNER HASH JOIN
		( 
			SELECT 
				*
			FROM
				(
				SELECT
					-------------------------------------------------------------------------------------------------------------------------------
					--FIELDS NEEDED FOR REV.PERSON IN SYNERGY
					-- APS.FormatTitleCase(Employee.LAST_NAME) AS LAW_LAST_NAME
					--,APS.FormatTitleCase(Employee.FIRST_NAME) AS LAW_FIRST_NAME
					--,APS.FormatTitleCase(Employee.MIDDLE_NAME) AS LAW_MIDDLE_NAME
					CASE WHEN Paemployee.SEX NOT IN('M', 'F') THEN '' ELSE Paemployee.SEX END AS LAW_GENDER 
					,CASE WHEN Paemployee.EEO_CLASS = 'HI' THEN 'Y' ELSE 'N' END AS LAW_HISPANIC_INDICATOR 
					
					,CASE WHEN Paemployee.EEO_CLASS = 'WH' THEN '1'
						  WHEN Paemployee.EEO_CLASS = 'AA' THEN '100'
						  WHEN Paemployee.EEO_CLASS = 'AP' THEN '299'
						  WHEN Paemployee.EEO_CLASS = 'BL' THEN '600'
						  WHEN Paemployee.EEO_CLASS = 'HI' THEN '1'
					ELSE ''	END	 AS LAW_ETHNIC_CODE 
					
					,Paemployee.BIRTHDATE AS LAW_BIRTHDATE
					--,Employee.EMAIL_ADDRESS AS LAW_EMAIL
					,LEFT(REPLACE(REPLACE(Paemployee.HM_PHONE_NBR,'.', ''),'-', ''),10) AS LAW_PHONE  
					--------------------------------------------------------------------------------------------------------------------------------					
					,ROW_NUMBER() OVER (PARTITION BY Paemppos.COMPANY, Paemppos.EMPLOYEE ORDER BY Paemppos.FTE DESC, Paemppos.EFFECT_DATE ASC) AS RN
					,'e' + RIGHT('000000'+ CONVERT (VARCHAR (6), CAST(Employee.EMPLOYEE AS VARCHAR)), 6) AS LAW_BADGE_NUMBER 
					
				FROM
					[180-SMAXODS-01].Lawson.dbo.Paemppos
					INNER JOIN
					[180-SMAXODS-01].Lawson.dbo.Employee
					ON
					Paemppos.EMPLOYEE = Employee.EMPLOYEE	
					INNER JOIN
					[180-SMAXODS-01].Lawson.dbo.Paemployee
					ON
					Paemppos.EMPLOYEE = Paemployee.EMPLOYEE	
				) AS LAW
		WHERE
			RN = 1
		) AS LAWSON

	ON
	STAFF.BADGE_NUM = LAWSON.LAW_BADGE_NUMBER

WHERE
	DISABLED = 'N'
	AND EXEMPT_FROM_LDAP = 'N'
	AND BADGE_NUM BETWEEN 'e205300' AND 'e205352'
	
	

ROLLBACK

----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

/*

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
			( 
				SELECT 
					*
				FROM
					(
					SELECT
											
						-------------------------------------------------------------------------------------------------------------------------------
						--FIELDS NEEDED FOR EPC.STAFF IN SYNERGY
						
						Employee.EMPLOYEE AS LAW_EMPLOYEE -- (STAFF IN THE STATE_ID)
						,'e' + RIGHT('000000'+ CONVERT (VARCHAR (6), CAST(Employee.EMPLOYEE AS VARCHAR)), 6) AS LAW_BADGE_NUMBER 
						,Employee.DATE_HIRED AS LAW_HIRE_DATE 
						,CASE WHEN StaffCrosswalk.SYNERGY_TYPE IS NOT NULL THEN StaffCrosswalk.SYNERGY_TYPE ELSE '' END AS LAW_TYPE
						-------------------------------------------------------------------------------------------------------------------------------
						
						,ROW_NUMBER() OVER (PARTITION BY Paemppos.COMPANY, Paemppos.EMPLOYEE ORDER BY Paemppos.FTE DESC, Paemppos.EFFECT_DATE ASC) AS RN
						
					FROM
						[180-SMAXODS-01].Lawson.dbo.Paemppos
						INNER JOIN
						[180-SMAXODS-01].Lawson.dbo.Employee
						ON
						Paemppos.EMPLOYEE = Employee.EMPLOYEE	
						INNER JOIN
						[180-SMAXODS-01].Lawson.dbo.Paemployee
						ON
						Paemppos.EMPLOYEE = Paemployee.EMPLOYEE	
						INNER JOIN
						[180-SMAXODS-01].HELPER.dbo.StaffCrosswalk AS StaffCrosswalk
						ON
						--join to crosswalk for an exact match
						SUBSTRING(Paemppos.POSITION,4,7) = StaffCrosswalk.Position_Code
						OR(
						--join to crosswalk for an exact match and if it matches, then check to see if 
						SUBSTRING(Paemppos.POSITION,4,7) LIKE StaffCrosswalk.Position_Code
						AND (SELECT StaffCrosswalk.Position_Code FROM [180-SMAXODS-01].HELPER.dbo.StaffCrosswalk AS StaffCrosswalk WHERE StaffCrosswalk.Position_Code = SUBSTRING(Paemppos.POSITION,4,7)) IS NULL
						)	
						AND StaffCrosswalk.IN_SYNERGY = 'Y'		
					) AS LAW

				WHERE
					RN = 1
			) AS LAWSON

		ON
		STAFF.BADGE_NUM = LAWSON.LAW_BADGE_NUMBER

WHERE
	DISABLED = 'N'
	AND EXEMPT_FROM_LDAP = 'N'

*/

